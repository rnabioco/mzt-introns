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
                  start = start - 1, 
                  strand = set_strand) %>% 
    dplyr::select(chrom, start, end, score, strand)
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
  
