
## mzt-introns  

[![github-actions](https://github.com/rnabioco/mzt-introns/actions/workflows/github-actions.yaml/badge.svg)](https://github.com/rnabioco/mzt-introns/actions/workflows/github-actions.yaml)  

Characterizing the maternal to zygotic transition using intronic read signals to define zygotic transcription.  

This repo contains a snakemake pipeline (`pipeline`) to align and quantify intronic and exonic signals from RNA-seq data using salmon. See `pipeline/README.md` for how to use this pipeline in your own work. 

## Dependencies

The pipelines uses a mix of command line tools and R packages (listed in `pipeline/README.md`). To ease use of the pipeline, a docker image is provided with all prerequisites installed, please see the instructions (`docker/README.md`).

## Inputs
Short read RNA-Seq data from a developmental timecourse, either single or paired-end format.

## Outputs

The end product of the pipeline will be output files from salmon, containing transcript level estimates of intronic and exonic signals. 

Here are the output files from the pipeline for the test dataset included in this repo. 

```bash
├── bigwigs  # rna-seq coverage tracks across transcripts
│   └── bt2
│       └── eisa
│             
├── bt2 # bam transcript and intron alignments
│   ├── eisa  # alignments to unmasked reference from earliest pre-mzt timepoint
│   │   ├── SRR5469986.sub.bam
│   │   └── SRR5469998.sub.bam
│   └── eisa_masked  # alignments to reference with introns masked to exclude signals from earliest pre-mzt timepoints
│       ├── SRR5469986.sub.bam
│       ├── SRR5469988.sub.bam
│       ├── SRR5469990.sub.bam
│       ├── SRR5469992.sub.bam
│       ├── SRR5469994.sub.bam
│       ├── SRR5469998.sub.bam
│       ├── SRR5470000.sub.bam
│       ├── SRR5470002.sub.bam
│       ├── SRR5470004.sub.bam
│       └── SRR5470006.sub.bam
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

## More information

Please see our manuscript and associated repository https://github.com/rnabioco/mzt-introns-manuscript for additional details:  

>
Riemondy K, Henriksen JC, Rissland OS. Intron dynamics reveal principles of gene regulation during the maternal-to-zygotic transition. RNA. 2023 Feb 10:rna.079168.122. doi: 10.1261/rna.079168.122
>

