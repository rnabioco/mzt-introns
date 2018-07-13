#! /usr/bin/env bash
#BSUB -n 1
#BSUB -J dl
#BSUB -e err.txt
#BSUB -o out.txt

# download fastqs from ENA

libs=$(awk '{FS="\t"} NR > 1{print $11}' PRJNA186932.txt)

for fq in $libs
do
    echo "era-fasp@"$fq

    ~/.aspera/connect/bin/ascp \
        -QT \
        -l 100m \
        -P33001 \
        -i ~/.aspera/connect/etc/asperaweb_id_dsa.openssh \
        "era-fasp@"$fq .
done

