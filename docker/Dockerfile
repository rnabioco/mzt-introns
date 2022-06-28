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

# set libpath globally to renv library
RUN echo ".libPaths('/home/rstudio/renv/library/R-4.2/x86_64-pc-linux-gnu')" >> /root/.Rprofile

## Use renv to install specific versions specified in the renv.lock file
ENV RENV_VERSION 0.15.5
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))" && \
    R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')" 

COPY r-pkgs.R /home/rstudio/r-pkgs.R
COPY dependencies.R /home/rstudio/dependencies.R

RUN cd /home/rstudio && \
    R -e "renv::init(bare = TRUE, bioconductor = '3.15')" && \
    R -e "source('r-pkgs.R')"
RUN cd /home/rstudio && \
    R -e "renv::snapshot(type = 'implicit', prompt = FALSE)"

WORKDIR /home/rstudio