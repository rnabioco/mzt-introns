wget ftp://ftp.ensembl.org/pub/release-84/fasta/drosophila_melanogaster/dna/Drosophila_melanogaster.BDGP6.dna.toplevel.fa.gz
gunzip Drosophila_melanogaster.BDGP6.dna.toplevel.fa.gz
samtools faidx Drosophila_melanogaster.BDGP6.dna.toplevel.fa

wget ftp://ftp.ensembl.org/pub/release-84/gtf/drosophila_melanogaster/Drosophila_melanogaster.BDGP6.84.gtf.gz
gunzip Drosophila_melanogaster.BDGP6.84.gtf.gz

samtools faidx Drosophila_melanogaster.BDGP6.dna.toplevel.fa 2L > Drosophila_melanogaster.BDGP6.dna.2L.fa
samtools faidx Drosophila_melanogaster.BDGP6.dna.2L.fa

awk '$1 == "2L"' Drosophila_melanogaster.BDGP6.84.gtf > Drosophila_melanogaster.BDGP6.84.2L.gtf 

rm -f Drosophila_melanogaster.BDGP6.84.gtf Drosophila_melanogaster.BDGP6.dna.toplevel.fa Drosophila_melanogaster.BDGP6.dna.toplevel.fa.fai
