#!/usr/bin/env bash

#BSUB -J mzintrons
#BSUB -o logs/snakemake_%J.out
#BSUB -e logs/snakemake_%J.err
#BSUB -R "select[mem>4] rusage[mem=4] " 
#BSUB -q rna

set -o nounset -o pipefail -o errexit -x

args=' -q rna -o {log}.out -e {log}.err -J {params.job_name} -R
"{params.memory} span[hosts=1] " -n {threads}  ' 
    

#### load necessary programs ####

# If programs are not all in the path then modify code to load 
# the necessary programs

# load modules
. /usr/share/Modules/init/bash
module load modules modules-init modules-python

module load ucsc/v308 
module load fastqc/0.11.5
module load samtools/1.5
module load STAR/2.5.2a
module load subread/1.6.2
module load bowtie2/2.3.2

# other programs (not in modules)
# Salmon-0.8.2
# FASTX toolkit 0.0.13
# gffread
#
#### execute snakemake ####

snakemake --drmaa "$args" \
    --snakefile Snakefile \
    --jobs 150 \
    --resources all_threads=150 \
    --latency-wait 50 \
    --rerun-incomplete  \
    --configfile config.yaml  
