#! /usr/bin/env bash
#BSUB -n 1
#BSUB -J dl
#BSUB -e err.txt
#BSUB -o out.txt

# download fastqs from GEO


libs=$(grep none GSE98106_run_info_geo.txt | cut -f 6)

for fq in $libs
do
    fastq-dump  --gzip $fq 
done

