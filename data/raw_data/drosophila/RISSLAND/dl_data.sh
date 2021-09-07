#! /usr/bin/env bash

# download fastqs from GEO
libs=$(grep none GSE98106_run_info_geo.txt | cut -f 6)

for fq in $libs
do
    fastq-dump  --gzip $fq 
done

