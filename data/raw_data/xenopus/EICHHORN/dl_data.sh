#! /usr/bin/env bash
#BSUB -n 1
#BSUB -J dl
#BSUB -e err.txt
#BSUB -o out.txt

# download fastqs from GEO


libs=$(grep "Danio rerio" sra_info.txt | cut -f 7)

mkdir -p ../zebrafish/EICHHORN
for fq in $libs
do
    echo $fq
    fastq-dump  --gzip $fq 
    mv $fq".fastq.gz" ../zebrafish/EICHHORN
done

libs=$(grep "Xenopus" sra_info.txt | cut -f 7)

for fq in $libs
do
    echo $fq
    fastq-dump  --gzip $fq 
done


