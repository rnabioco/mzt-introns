#! /usr/bin/env bash
#BSUB -n 1
#BSUB -J dl
#BSUB -e err.txt
#BSUB -o out.txt

# download fastqs from GEO


#libs=$(grep none GSE98106_run_info_geo.txt | cut -f 6)
#
#for fq in $libs
#do
#    fastq-dump  --gzip $fq 
#done
#
#libs=$(grep "RNA-Seq" GSE83616_run_info_geo.txt | grep "wt"  | cut -f 9 )
#
#for fq in $libs
#do
#    fastq-dump  --gzip $fq 
#done


# download encode total rna-seq

# get metadata 
wget -O metadata.tsv \
    "https://www.encodeproject.org/metadata/type=Experiment&assay_term_name=RNA-seq&replicates.library.biosample.donor.organism.scientific_name=Drosophila+melanogaster&biosample_term_name=whole+organism&replicates.library.biosample.life_stage=embryonic&assay_title=total+RNA-seq&files.run_type=paired-ended&files.file_type=fastq/metadata.tsv"

libs=$(grep " [0246]-[2468] hour" metadata.tsv  | cut -f 42)
for fq in $libs
do
    echo $fq
    wget $fq
done
