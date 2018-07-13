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
#library(edgeR)
library(DESeq2)
library(tibble)

#### Paths ####

project_dir <- path.expand("~/Projects/mzt-introns")
data_dir <- file.path(project_dir, "data")
results_dir <- file.path(project_dir, "results")
docs_dir <- file.path(project_dir, "docs")
db_dir <- file.path(project_dir, "dbases")

# vector of figure paths
figs_dir <-  file.path(results_dir, "Figures") %>%
  dir(pattern = "Figure_[1-4]$",
      include.dirs = TRUE,
      full.names = T)

#### functions ####
source(file.path(project_dir, "R", "utils.r"))