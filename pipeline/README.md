# Snakemake pipeline for quantifying intron signal in MZT timecourse libraries

## Example usage

This pipeline is designed to be run on a server and was tested on a cluster set up with LSF. It can also be run as a standalone pipeline without using a cluster, if sufficient memory/space is available. 

1) Clone the repository

```bash
git clone git@github.com:rnabioco/mzt-introns
```

2) Download reference genome, transcriptome, and transcript annotations. If you already have these then they can be specified in the config file. If not see `dbases/drosophila/ext/dl_dbases.sh` to download references for Drosophila. 

3) Download raw data: For this example we will use a test dataset provided in the repository (`raw_data/drosophila/TESTDATA/`). See an example download script from `data/raw_data/drosophila/RISSLAND/dl_data.sh` to download the original rRNA depleted RNA-seq libraries prepared from drosophila embryos at different stages pre and post ZGA.Note requires `sra-toolkit` to download data. 

4) Prepare a config file and lib_params file containing information about the RNA-seq libraries. For these
data the config file `config-test.yaml` and params file `test_lib_params.tsv` are
for these example data. Change the `DATA` directory and path to `LIB_PARAMS` as needed.

5) Test the snakemake pipeline. This command should show all of the jobs that will be executed 

```bash
snakemake -npr --configfile config-test.yaml
```

6a) Run the pipeline (local mode, no cluster support)

```bash
snakemake --configfile your-config-file.yaml
```

6b) Run the pipeline on an LSF compatible cluster. See `snakemake.sh` for an example script to run snakemake on a cluster.

## Outputs

The end product of the pipeline will be output files from salmon, containing transcript level estimates of intronic and exonic signals. 

Here are the output files from the pipeline for the test dataset included in this repo. 

```bash
├── bigwigs  # rna-seq coverage tracks across transcripts
│   ├── drosophila
│      └── bt2
│          └── eisa
│              └── TESTDATA
├── bt2 # bam transcript and intron alignments
│   ├── drosophila
│      └── TESTDATA
│          ├── eisa  # alignments to unmasked reference from earliest pre-mzt timepoint
│          │   ├── SRR5469986.sub.bam
│          │   └── SRR5469998.sub.bam
│          └── eisa_masked  # alignments to reference with introns masked to exclude signals from earliest pre-mzt timepoints
│              ├── SRR5469986.sub.bam
│              ├── SRR5469988.sub.bam
│              ├── SRR5469990.sub.bam
│              ├── SRR5469992.sub.bam
│              ├── SRR5469994.sub.bam
│              ├── SRR5469998.sub.bam
│              ├── SRR5470000.sub.bam
│              ├── SRR5470002.sub.bam
│              ├── SRR5470004.sub.bam
│              └── SRR5470006.sub.bam
├── raw_data # raw input fastq files
│   └── drosophila
│       └── TESTDATA
│           ├── SRR5469986.sub.fastq.gz
│           ├── SRR5469988.sub.fastq.gz
│           ├── SRR5469990.sub.fastq.gz
│           ├── SRR5469992.sub.fastq.gz
│           ├── SRR5469994.sub.fastq.gz
│           ├── SRR5469998.sub.fastq.gz
│           ├── SRR5470000.sub.fastq.gz
│           ├── SRR5470002.sub.fastq.gz
│           ├── SRR5470004.sub.fastq.gz
│           └── SRR5470006.sub.fastq.gz
└── salmon_bt2_masked # salmon quantification outputs 
    ├── drosophila
       └── TESTDATA
           └── eisa_masked
               ├── SRR5469986.sub
               ├── SRR5469988.sub
               ├── SRR5469990.sub
               ├── SRR5469992.sub
               ├── SRR5469994.sub
               ├── SRR5469998.sub
               ├── SRR5470000.sub
               ├── SRR5470002.sub
               └── SRR5470004.sub
```

These can be used for differential expression testing to identify de novo transcription based on intronic signals.  We provide an example of how to use DESeq2 to examine differential expression in a vignette (`results/vignette.Rmd`).


## Requirements
  The following dependencies are used in this pipeline. These can be installed manually, or alternatively, a docker image is provided with all of the necessary dependencies (`docker/README.md`). 
  
### Command-line 

    - snakemake 
    - fastqc
    - salmon 
    - STAR
    - Bowtie2 
    - samtools 
    - bedtools
    - deeptools
    - ucsc Kent tools

### R packages

    - R (>= 4.0)
    - eisaR
    - readr
    - dplyr
    - purrr
    - stringr
    - Biostrings
    - GenomicRanges
    - Rsamtools
    - Rsubread
    - valr
    - rtracklayer
    - doParallel
    
