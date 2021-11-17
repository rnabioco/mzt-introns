wget ftp://ftp.ensembl.org/pub/release-84/fasta/drosophila_melanogaster/dna/Drosophila_melanogaster.BDGP6.dna.toplevel.fa.gz
gunzip Drosophila_melanogaster.BDGP6.dna.toplevel.fa.gz
samtools faidx Drosophila_melanogaster.BDGP6.dna.toplevel.fa

wget ftp://ftp.ensembl.org/pub/release-84/gtf/drosophila_melanogaster/Drosophila_melanogaster.BDGP6.84.gtf.gz
gunzip Drosophila_melanogaster.BDGP6.84.gtf.gz

samtools faidx Drosophila_melanogaster.BDGP6.dna.toplevel.fa 4 > Drosophila_melanogaster.BDGP6.dna.chr4.fa
samtools faidx Drosophila_melanogaster.BDGP6.dna.chr4.fa

awk '$1 == "4"' Drosophila_melanogaster.BDGP6.84.gtf > Drosophila_melanogaster.BDGP6.84.chr4.gtf 

rm -f Drosophila_melanogaster.BDGP6.84.gtf Drosophila_melanogaster.BDGP6.dna.toplevel.fa Drosophila_melanogaster.BDGP6.dna.toplevel.fa.fai