#!/usr/bin/env bash
mkdir -p logs

set -o nounset -o pipefail -o errexit -x

#### execute snakemake ####

snakemake \
    --snakefile Snakefile \
    --jobs 1 \
    --resources all_threads=1 \
    --latency-wait 50 \
    --printshellcmds \
    --rerun-incomplete  \
    --configfile config-test.yaml 
