#!/usr/bin/env bash
mkdir -p logs

set -o nounset -o pipefail -o errexit -x

#### execute snakemake ####

snakemake \
    --snakefile Snakefile \
    --jobs 15 \
    --resources all_threads=7 \
    --latency-wait 50 \
    --printshellcmds \
    --rerun-incomplete  \
    --configfile config-test.yaml 
