## Rissland project

## Goals:
  - develop methods for classifying transcripts into maternal or zygotic during the MZT 
  - use the presence of intronic read coverage to indicate `de-novo` transcription
  - apply first to well studied organisms (drosophila, zebrafish), then use as method for less well characterized systems, such as sea urchin. 

## 2018-07-13
  - Have begun using direct intron counting instead of salmon approach.
    This also allows an annotation mask to be built to exclude translated
    regions, repeat regions, or intronic sequences present pre-MZT. 
  - Also found some good datasets with rRNA depleted total RNA samples. 

## 2018-05-11
  - Zebrafish annotations are problematic for current Salmon based
    approach. Instead use a more traditional count based method with a
    curated intron annotation set. Intronic regions can be masked on
    RepeatMasker, detectable expression in egg/oocyte/1-cell stage, and 
    overlap with small RNA annotations.

  - Additionally there is a paucity of highly replicated rRNA-depleted
    datasets, which are useful because transcript quantification is not
    biased by Cytoplasmic Polyadenylation which occurs in the early
    embryo. Try to use the total-RNA-Seq datasets to exclude transcripts
    found in the well replicated poly(A) selected datasets.

  - ribosome profiling data could also be used to define intronic regions.
    For example we could combine all of the ribosome profiling data from
    zebrafish, and use this to curate introns within the CDS (which would
    be the majority). 

  - Lastly, thinking more broadly, this appraoch could help to more
    clearly resolve the evolutionary relationships between early zygotically
    transcribed genes across metazoa. Does the pattern of maternal to
    zygotic gene expression dynamics reflect the Evo-Devo ideas of
    similarity in embryogeneis, then specialization in later development?

## 2018-04-18
  - Finalize clustering for drosophila and send heatmaps and cluster Ids to Olivia
  - Compute miR-430 seed enrichment for zebrafish data (why?)
  - 
## 2018-04-17
  - Send olivia clustering information for droshopila and zebrafish
  - Overlap zygotic transcripts with SNP and other MZT datasets
  - Decide on motif searching analysis approach:
      - Try Homer for both promoters and 3'UTRs?
      - For drosophila use modEncode peaks for promoters and Homer for 3'UTRs?
      - Note that there are many genes without 3' UTRs in zebrafish, consider adding a 500bp downstream class.
  
## 2018-04-09
  - met with olivia to discuss analysis of zebrafish and sea urchin
  - Using clustering to define transcript dynamics identified some
    clusters in both zebrafish and drosophila with increased transcription
    prior to the MZT
  - focus next analysis on three goals:
      1) Motif searching for 3'UTR elements
      2) Motif or Chip-Seq data to identify regulatory transcription
      factors
      3) Overlap identified zygotic and maternal transcripts with those
      defined by others using SNP or other RNA-Seq data

## 2018-03-14
  - updated snakemake pipeline to handle paired end alignements
  - began aligning data

## 2018-03-13
  - downloaded large scale zebrafish time course from ENA

## Check intron coverage in xenopus and zebrafish 
## 2018-02-15 Make pipeline species agnostic 
  - reorganize pipeline to handle additional species
  - download zebrafish and xenopus datasets from GEO
  
## 2018-02-14 Finish drosophila characterization
  - Pick sensible cutoffs for zygotic and maternal
  - Plot as heatmaps, ordering by time to first expression for strictly zygotic
  - extract out sequences and look for zelda enrichment
  
## 2018-02-06 Reorganize results
  - current results and pipeline is mess
  - regorganize into dates and keep running log of work
  - determine if zygotic transcripts are enriched for zelda binding sites (7-mer)
  - put code on github repo
  
