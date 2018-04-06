#! /usr/bin/env bash
#BSUB -n 1
#BSUB -J dl
#BSUB -e err.txt
#BSUB -o out.txt

# download fastqs from ENA 

# split string and remove ftp.sra.ebi.ac.uk
libs=$(awk '{OFS=FS="\t"} NR > 1 {split($10,fqs,";"); print substr(fqs[1],18), substr(fqs[2],18)} ' PRJNA81157.txt)
sshkey="/vol1/software/modules-sw/aspera/2.7.9/etc/asperaweb_id_dsa.openssh"

. /usr/share/Modules/init/bash
module load modules modules-init modules-python
 
module load aspera

for fq in $libs
do
    file_path="era-fasp@fasp.sra.ebi.ac.uk:"$fq
    echo $file_path
    ascp -QT -P33001 -l 300m -i $sshkey $file_path ./
done


