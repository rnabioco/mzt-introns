# Based on dockerfile from 
# https://github.com/jianhong/genomictools/blob/master/Dockerfile 
# Set the base image to Ubuntu
FROM bioconductor/bioconductor_docker:RELEASE_3_15

# envirenment
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH $PATH:/opt/conda/bin

RUN \
  apt-get update --fix-missing && \
  apt-get install --yes rsync && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# get ucsc tools
RUN rsync -aP rsync://hgdownload.soe.ucsc.edu/genome/admin/exe/linux.x86_64/ /usr/local/bin/

## add conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc

## install cmd tools with conda
COPY environment.yaml .
RUN /opt/conda/bin/conda config --add channels default && \
    /opt/conda/bin/conda config --add channels bioconda && \
    /opt/conda/bin/conda config --add channels conda-forge && \
    /opt/conda/bin/conda env update -n base -f environment.yaml && \
    /opt/conda/bin/conda clean -afy

# Install R packages from cran
RUN R -e "install.packages(c('dplyr', 'purrr', 'BiocManager', 'readr', 'stringr', 'valr', 'purrr', 'Matrix', 'RColorBrewer', 'cowplot', 'doParallel', 'ggplot2', 'ggrepel', 'here', 'jsonlite', 'readxl', 'tibble', 'tidyr', 'viridis', 'eulerr'), repos='http://cran.rstudio.com/')"

## Install Bioconductor packages
RUN echo "BiocManager::install(c(\"Biostrings\", \"GenomicRanges\", \"GenomicAlignments\", \"GenomicFeatures\", \"Gviz\", \"eisaR\"), suppressUpdates=TRUE, ask=FALSE)" | R --vanilla
RUN echo "BiocManager::install(c(\"ComplexHeatmap\", \"DESeq2\", \"rtracklayer\", \"tximport\", \"Rsubread\", \"Rhtslib\", \"zlibbioc\"), suppressUpdates=TRUE, ask=FALSE)" | R --vanilla

# Define working directory.
WORKDIR /home/rstudio
COPY --chown=rstudio:rstudio . /home/rstudio/
