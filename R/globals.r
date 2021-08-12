# globals shared across markdown docs

library(readr)
library(valr)
library(tidyr)
library(dplyr)
library(stringr)
library(ggplot2)
library(cowplot)
library(RColorBrewer)
library(Matrix)
library(purrr)
library(R.utils)
library(viridis)
library(jsonlite)
library(rtracklayer)
library(ComplexHeatmap)
library(tximport) 
library(DESeq2)
library(tibble)
library(here)
library(ggrepel)
library(readxl)
library(eisaR)
library(doParallel)


#### Paths ####

project_dir <- here()
data_dir <- file.path(project_dir, "data")
results_dir <- file.path(project_dir, "results")
docs_dir <- file.path(project_dir, "docs")
db_dir <- file.path(project_dir, "dbases")

#### functions ####
source(file.path(project_dir, "R", "utils.r"))

ggplot2::theme_set(theme_cowplot())


#### Annotations ####

genome_dir <- "~/Projects/shared_dbases/genomes"
annot_dir <- "~/Projects/shared_dbases/annotation"

annots <- list(
  drosophila = list(
    gtf  = "drosophila/Drosophila_melanogaster.BDGP6.84.gtf",
    genome = "drosophila/Drosophila_melanogaster.BDGP6.dna.toplevel.fa",
    chroms = "drosophila/Drosophila_melanogaster.BDGP6.dna.toplevel.fa.fai"
  ),
  zebrafish = list(
    gtf = "zebrafish/danRer10/danRer10.gtf",
    genome = "zebrafish/danRer10/danRer10.fa",
    chroms = "zebrafish/danRer10/danRer10.fa.fai"
  ),
  chicken = list(
    gtf = "chicken/gallus_gallus_5/Gallus_gallus.Gallus_gallus-5.0.94.gtf",
    genome = "chicken/gallus_gallus_5/Gallus_gallus.Gallus_gallus-5.0.dna.toplevel.fa",
    chroms = "chicken/gallus_gallus_5/Gallus_gallus.Gallus_gallus-5.0.dna.toplevel.fa.fai"
  ),
  xenopus_t = list(
    gtf = "xenopus/jgi_xentrop9.1/xenTro9.gtf",
    genome = "xenopus/jgi_xentrop9.1/xenTro9.fa",
    chroms = "xenopus/jgi_xentrop9.1/xenTro9.fa.fai"
  ),
  mouse = list(
    gtf = "mouse/gencode.vM15.primary_assembly.annotation.gtf",
    genome = "mouse/GRCm38.primary_assembly.genome.fa",
    chroms = "mouse/GRCm38.primary_assembly.genome.fa.fai"
  )
)

annots <- map(annots,
              ~{.x$gtf <- file.path(annot_dir, .x$gtf)
              .x$genome <- file.path(genome_dir, .x$genome)
              .x$chroms <- file.path(genome_dir, .x$chroms)
              .x})

