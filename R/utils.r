#' Read in a bigwig file into a valr compatible bed tibble
#' @description This function will output a 5 column tibble with
#' zero-based chrom, start, end, score, and strand columns.
#' 
#' @param path path to bigWig file
#' @param set_strand strand to add to output (defaults to "+")
#' @export 
read_bigwig <- function(path, set_strand = "+") {
  # note that rtracklayer will produce a one-based GRanges object
  rtracklayer::import(path) %>% 
    dplyr::as_tibble(.) %>% 
    dplyr::mutate(chrom = as.character(seqnames),
                  start = start - 1L, 
                  strand = set_strand) %>% 
    dplyr::select(chrom, start, end, score, strand)
}

#' Convert GTF from rtracklayer into tidy bed format
#' @param gtf_fn path to gtf file
tidy_gtf <- function(gtf_fn, zero_based_coords = TRUE){
  gtf <- rtracklayer::import(gtf_fn)
  gtf <- as.data.frame(gtf)
  gtf <- dplyr::mutate_if(gtf, is.factor, as.character)
  res <- dplyr::rename(gtf, chrom = seqnames)
  
  if(zero_based_coords) {
    res <- dplyr::mutate(res, start = start - 1L)
  }
  
  res <- tibble::as_tibble(res)
  res
} 

#' When writing out excel workbooks using openxlsx::write.xlsx()
#' this function will set the class attributes for a column, which
#' enforces a column type in the resulting xlsx file. 
#' Useful for avoid gene names being clobbered to dates and 
#' setting scientific number formatting

set_xlsx_class <- function(df, col, xlsx_class){
  for(i in seq_along(col)){
    class(df[[col[i]]]) <- xlsx_class
  }
  df
}

#' Add transcript and gene annotations to gtf
#' 
#' 
#' 
add_tx_annotations <- function(gtf_df){
  
  if(!all(c("transcript_id", "gene_id") %in% colnames(gtf))){
    stop("gtf must contain transcript_id and gene_id")
  }
  
  gtf_df <- group_by(gtf_df, seqnames, strand, source, transcript_id, 
                     gene_id, gene_name)
  
  txs <- summarize(gtf_df, 
                   start = min(start),
                   end = max(end),
                   width = end - start + 1L,
                   type = "transcript",
                   score = NA, 
                   phase = NA,
                   exon_number = NA,
                   exon_id = NA)
  
  gtf_df <- group_by(gtf_df, seqnames, strand, source, gene_id, 
                     gene_name)
  
  genes <- summarize(gtf_df, 
                     start = min(start),
                     end = max(end),
                     width = end - start + 1L,
                     type = "gene",
                     score = NA, 
                     phase = NA,
                     transcript_id = NA,
                     exon_number = NA,
                     exon_id = NA)
  
  col_order <- quo(c("seqnames",
    "start",
    "end",
    "width",
    "strand",
    "source",
    "type",
    "score",
    "phase",
    "gene_id",
    "transcript_id",
    "exon_number",
    "exon_id",
    "gene_name"))
  
  txs <- dplyr::select(txs, !!col_order)
  genes <- dplyr::select(genes, !!col_order)
  
  res <- suppressWarnings(bind_rows(list(gtf_df,
                        txs,
                        genes)))
  
  res <- arrange(res, seqnames, start)
  
  res <- ungroup(res)
  res
 }
  

#' convert matrix to tibble with rownames
#' 
#' 
tidy_matrix <- function(df, row_ids = NULL){
  as_tibble(df, rownames = row_ids)
}


#' Exrtact utr's from a gtf file
#' 
#' 
#' 
get_3utrs <- function(gtf_file,
                      gene_ids,
                      gene_col = "gene_id",
                      transcript_col = "transcript_id") {
  
  gtf <- import(gtf_file)
  gtf <- as.data.frame(gtf)
  gtf <- mutate_if(gtf, is.factor, as.character)
  gtf <- filter(gtf, gene_id %in% gene_ids)
  gtf <- dplyr::select(gtf,
                       chrom = seqnames,
                       start, end, type, strand, 
                       exon_id, 
                       one_of(c(gene_col, transcript_col)))
  
  gtf <- dplyr::filter(gtf,
                       type %in% c("exon", "CDS"))
  
  cds_gtf <- filter(gtf, type == "CDS") %>%
    group_by(transcript_id) %>%
    summarize(cds_start = unique(ifelse(strand == "+",
                                        min(start),
                                        max(end))),
              cds_end = unique(ifelse(strand == "+",
                                      max(end),
                                      min(start)))) %>%
    ungroup() %>% 
    left_join(gtf, ., by = "transcript_id")
  
  utr3_gtf <- cds_gtf %>%
    filter(type == "exon") %>%
    group_by(transcript_id) %>%
    mutate(utr3_exon = ifelse(
      strand == "+",
      ifelse(
        start >= cds_end,
        "yes",
        ifelse(cds_end >= start &
                 cds_end <= end,
               "overlapping",
               "no")
      ),
      ifelse(
        end <= cds_end,
        "yes",
        ifelse(cds_end >= start &
                 cds_end <= end,
               "overlapping",
               "no")
      )
    )) %>%
    ungroup() %>%
    filter(utr3_exon != "no")
  
  utr3_res <- utr3_gtf %>%
    group_by(transcript_id) %>%
    mutate(
      start = ifelse(strand == "+" & utr3_exon == "overlapping",
                     cds_end,
                     start),
      end = ifelse(strand == "-" & utr3_exon == "overlapping",
                   cds_end,
                   end)
    )  %>%
    filter(start != end) %>%
    select(chrom:transcript_id)
  
  utr3_res <- mutate(utr3_res, start = start - 1)
  utr3_res <- mutate_if(utr3_res, is.factor, as.character)
  res <- group_by(utr3_res, gene_id, strand) %>%
    bed_merge() %>%
    ungroup()
  
  res
}


get_tss <- function(gtf_file,
                    gene_ids = NULL){
  
  gtf <- tidy_gtf(gtf_file, zero_based_coords = TRUE)
  
  if(!is.null(gene_ids)){
    gtf <- filter(gtf,  gene_id %in% gene_ids)
  }
  
  tss <- filter(gtf, type == "gene") %>%
    mutate(end = ifelse(strand == "+",
                        start + 1,
                        end),
           start = ifelse(strand == "-",
                          end - 1,
                          start)) %>% 
    select(chrom, start, end, gene_name, gene_id, strand)
  
  tss
  
}
#' write out bed file without mangling numeric characters.
#' 
write_bed <- function(df, path = ""){
  res <- mutate_if(df, is.numeric, as.character)
  write_tsv(res, path, col_names = F)
}


#' add pre-mrna designation
add_pre <- function(chr_vec, pattern = "pre_"){
  str_c(pattern, chr_vec)
}  

#' remove pre-mrna designation 
no_pre <- function(chr_vec, pattern = "^pre_"){
  str_remove(chr_vec, pattern)
}  
