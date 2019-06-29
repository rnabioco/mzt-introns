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
library(kentr)
library(ggrepel)

#### Paths ####

project_dir <- here()
data_dir <- file.path(project_dir, "data")
results_dir <- file.path(project_dir, "results")
docs_dir <- file.path(project_dir, "docs")
db_dir <- file.path(project_dir, "dbases")

#### functions ####
source(file.path(project_dir, "R", "utils.r"))

ggplot2::theme_set(theme_cowplot())
