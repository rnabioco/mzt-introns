library(DEXSeq)
library(tidyverse)
source("../../R/globals.r")

mdata1 <- read_tsv(file.path(data_dir,
                             "raw_data",
                             "drosophila",
                             "EICHHORN",
                             "GSE83616_run_info_geo.txt"))
mdata2 <- read_tsv(file.path(data_dir,
                             "raw_data",
                             "drosophila",
                             "RISSLAND",
                             "GSE98106_run_info_geo.txt"))

#simplify mdata
mdata1 <- dplyr::select(mdata1,
                        Run_s, 
                        developmental_stage_s,
                        genotype_s,
                        source_name_s,
                        Assay_Type_s)

#simplify mdata
mdata2 <- dplyr::select(mdata2,
                        Run_s, 
                        developmental_stage_s,
                        rip_antibody_s,
                        source_name_s,
                        strain_s)

# select relevant libs
mdata2 <- dplyr::filter(mdata2,
                        source_name_s == "Embryo",
                        strain_s %in% c("w1118", "eGFP-ME31B"),
                        rip_antibody_s == "none") %>% 
  dplyr::select(-rip_antibody_s)

mdata1 <- dplyr::filter(mdata1,
                        genotype_s == "wt",
                        Assay_Type_s == "RNA-Seq") %>% 
  dplyr::select(-Assay_Type_s) %>% 
  dplyr::rename(strain_s = genotype_s)


mdata <- list(mdata1, mdata2)
names(mdata) <- c("EICHHORN", "RISSLAND")

mdata <- bind_rows(mdata, .id = "study")
#cleanup names
mdata <- mdata %>% 
  mutate(source_name_s = ifelse(source_name_s == "embryos", 
                                "Embryo",
                                source_name_s),
         developmental_stage_s = str_replace(developmental_stage_s,
                                             " h ",
                                             " hr "))

# cleanup colnames
colnames(mdata) <- str_replace(colnames(mdata),
                               "_s$",
                               "")



fa_types <- c(
  "primary_transcripts_masked"
)

pdata <- mutate(mdata, 
                mzt = ifelse(str_detect(developmental_stage,
                                        "^[2345]-[3456] hr embryo"),
                             "zygotic",
                             "maternal"),
                strain_id = str_replace(strain, "-", "_"))

pdata_split <- split(pdata, pdata$study)

rissland_files <- map(fa_types, 
                      ~file.path(data_dir,
                                 "salmon", 
                                 "drosophila",
                                 "RISSLAND",
                                 .x,
                                 pdata_split$RISSLAND$Run,
                                 "quant.sf"))

tids <- read_tsv(rissland_files[[1]][1]) %>% 
  dplyr::select(Name)

gtf <- "~/Projects/shared_dbases/annotation/drosophila/Drosophila_melanogaster.BDGP6.84.gtf"
gtf <- import(gtf)
gtf <- as.data.frame(gtf)

tx2gene <- gtf %>% 
  filter(type == "transcript") %>% 
  dplyr::select(transcript_id, gene_id) %>% 
  tbl_df() %>% 
  unique()

tx2gene_mapping <- full_join(tids, tx2gene,
                             by = c("Name" = "transcript_id"))



txi <- tximport(rissland_files[[1]],
                type="salmon", 
                txOut=TRUE,
                countsFromAbundance="scaledTPM")
cts <- txi$counts
cts <- cts[!str_detect(rownames(cts), "^pre"), ]
cts <- cts[rowSums(cts) > 0,]

tx2gene_mapping <- left_join(tibble(Name = rownames(cts)),
                             tx2gene_mapping,
                             by = "Name")


dxd <- DEXSeqDataSet(countData=round(cts),
                     sampleData=as.data.frame(pdata_split$RISSLAND),
                     design=~sample + exon + mzt:exon,
                     featureID=tx2gene_mapping$Name,
                     groupID=tx2gene_mapping$gene_id)

dxd <- estimateSizeFactors(dxd)
dxd <- estimateDispersions(dxd, quiet=TRUE)
dxd <- testForDEU(dxd, reducedModel=~sample + exon)

dxr <- DEXSeqResults(dxd, independentFiltering=FALSE)
qval <- perGeneQValue(dxr)
dxr.g <- data.frame(gene=names(qval),qval)
