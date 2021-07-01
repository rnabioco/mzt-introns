#!/usr/bin/env Rscript
# generate eisa masked intron reference for intron + exon quantification

 args = commandArgs(trailingOnly=TRUE)
 
 if(length(args) < 4){
   stop("missing args: eisa_dir species outpath fwd_bws")
 }
 
eisa_dir <- args[1]
species <- args[2]
outpath <- args[3]
fwd_bws <- args[4:length(args)]

source(here::here("R/globals.r"))

dir.create(outpath, recursive = TRUE, showWarnings = FALSE)
dir.create(file.path(outpath, "intron_mask"), recursive = TRUE, showWarnings = FALSE)


fwd_df <- map_dfr(fwd_bws,
                  ~read_bigwig(.x, set_strand = "+")) 

chunk_ivls <- function(df, n) {
  chroms <- unique(df$chrom)
  chrom_splits <- split(chroms, cut(seq_along(chroms), n, labels = FALSE))
  map(chrom_splits, 
      ~filter(df, chrom %in% .x))
}

n_cores <- 7
cl <- makeCluster(n_cores)  
registerDoParallel(cl)  

fwd_df <- foreach(i = chunk_ivls(fwd_df, n_cores),
                  .packages = c("valr"),
                  .combine = rbind
) %dopar% {
  bed_partition(i, score = sum(score))
}

stopCluster(cl)

ivl_df <- mutate(fwd_df, strand = "+") %>% 
  dplyr::select(chrom:score, strand)

masked_ivls <- filter(ivl_df, score > 0) %>% 
  group_by(strand) %>% 
  bed_merge() %>% 
  ungroup()

gtf_fn <- file.path(eisa_dir, "eisaR.gtf")
gtf_tbl <- tidy_gtf(gtf_fn)

exon_bed <- gtf_tbl %>% 
  filter(type == "exon",
         str_detect(ID, "-I[0-9]*$")) %>% 
  dplyr::select(chrom, start, end, transcript_id, gene_id, score, strand)


mask_df <- masked_ivls %>% 
  filter(strand == "+") %>% 
  group_by(strand)

# convert to tx coords
pre_mrna_bed <- exon_bed %>%
  mutate(end = end - start,
         start = 0,
         chrom = transcript_id,
         strand = "+") %>% 
  group_by(strand)

tx_coords <- bed_intersect(mask_df , pre_mrna_bed, 
                           suffix = c("", ".y")) %>% 
  mutate(name = ".",
         score = 0) %>% 
  select(chrom, start, end, name, score, strand) %>% 
  unique()

# set some basic cutoffs for introns to include for quant
to_drop <- bed_intersect(mask_df , pre_mrna_bed, 
                         suffix = c("", ".y")) %>% 
  group_by(chrom) %>% 
  summarize(masked_nts = sum(.overlap), 
            total_nts = unique(end.y - start.y),
            prop_masked = masked_nts / total_nts, 
            unmasked_nts = total_nts - masked_nts) %>% 
  filter(prop_masked > 0.80 |  unmasked_nts < 25)

db_out <- tx_coords %>% 
  dplyr::select(chrom,
                start, 
                end, 
                name,
                score,
                strand) %>% 
  bed_sort() %>% 
  mutate_if(is.numeric, format, scientific = F)  %>% 
  mutate_all(str_trim)

write_tsv(db_out,
          file.path(outpath, "intron_mask", "intron_mask_txcoords_eisa_bt2_align.bed"),
          col_names = F)

dup_tx <- read_tsv(file.path(eisa_dir, "duplicated_seqs.tsv"))

chroms <- read_tsv(file.path(eisa_dir, "eisa.fa.fai"),
                   col_names = c("chrom", "size"),
                   col_type = c("ci---"))

chroms <- chroms %>% 
  filter(!chrom %in% dup_tx$DuplicateRef,
         !chrom %in% to_drop$chrom)

write_lines(chroms$chrom, file.path(outpath, "intron_mask","eisa_unique_transcripts.tsv"))

