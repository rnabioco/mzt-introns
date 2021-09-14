#!/usr/bin/env bash
#BSUB -J mzintrons
#BSUB -o logs/snakemake_%J.out
#BSUB -e logs/snakemake_%J.err
#BSUB -R "select[mem>4] rusage[mem=4] " 
#BSUB -q rna

mkdir -p logs

set -o nounset -o pipefail -o errexit -x

args=' -q rna 
       -o {log}.out 
       -e {log}.err 
       -J {rule} 
       -R "select[mem>{resources.mem_mb}] rusage[mem={resources.mem_mb}] span[hosts=1] " 
       -n {threads}  ' 
    
#### load necessary programs ####

# If programs are not all in the path then load 
# the necessary programs or place in PATH

# load modules
. /usr/share/Modules/init/bash
module load modules modules-init modules-python

module load fastqc/0.11.7
module load samtools/1.9 
module load STAR/2.5.2a
module load salmon/1.1.0
module load R/4.0.3
module load subread/1.6.2

#### execute snakemake ####

snakemake --drmaa "$args" \
    --snakefile Snakefile \
    --jobs 150 \
    --resources all_threads=150 \
    --latency-wait 50 \
    --printshellcmds \
    --rerun-incomplete  \
    --configfile config-test.yaml 
