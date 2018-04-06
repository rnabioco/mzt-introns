import os
import sys
import argparse
import re

def parse_gff(gff):
    
    id_pattern = re.compile('ID=([^;]+);')
    parent_pattern = re.compile('Parent=([^;]+);')
    name_pattern = re.compile('Name=([^;]+)[\n;]?')
    tid_pattern = re.compile('transcript_id=([^;]+)[\n;]?')
    biotype_pattern = re.compile('gene_biotype=([^;]+)[\n;]?')

    # add header line
    print("## GTF produced by converting GFF3")
    print("## python script gff_to_gtf.py was used to generate gtf") 
    
    features = set()
    features_to_keep = ["lnc_RNA", "mRNA", "primary_transcript", "transcript", "miRNA", "snRNA"]
    #bad_transcripts = set()
    skip_gene = False 

    for line in gff:
        # ignore header lines, 
        # and blank lines which are present in transdecoder output
        if line.startswith("#"):
            continue
        if line.rstrip() == "":
            continue
       
        fields = line.split("\t")
        feature = fields[2]
        features.add(feature)
        
        attrs = fields[8].strip()

        if fields[1] == "tRNAscan-SE": 
            continue
        
        if feature in ["pseudogene"]:
            skip_gene = True
            continue

        if feature == "gene":
            biotype = biotype_pattern.search(attrs).groups()[0]
            last_gene = id_pattern.search(attrs).groups()[0]
            gene_name = name_pattern.search(attrs).groups()[0]
            skip_gene = False 
            current_transcript = ""

            new_attrs = 'gene_id "{}"; gene_name "{}"'
            new_attrs = new_attrs.format(last_gene, 
                                         gene_name)
            print("\t".join(fields[:8]), new_attrs, sep = "\t")    
        
        # mRNA field should precede child attributes
        # and be formatted as ID=;Parent=;Name=

        if feature in features_to_keep:
            if skip_gene:
                continue
            current_transcript = id_pattern.search(attrs).groups()[0]
            current_gene = parent_pattern.search(attrs).groups()[0]
            try:
                current_name = name_pattern.search(attrs).groups()[0]
            except AttributeError:
                current_name = ""

            if last_gene != current_gene:
                sys.exit("current gene {} not equal to last gene {} for transcript {}".format(current_gene, 
                    last_gene, 
                    current_transcript))   

            fields[2] = "transcript"
            new_attrs = 'gene_id "{}"; transcript_id "{}"; transcript_name "{}"'
            new_attrs = new_attrs.format(current_gene, 
                                         current_transcript,
                                         current_name)
            print("\t".join(fields[:8]), new_attrs, sep = "\t")
            continue
        
        if feature == "exon":
            if skip_gene:
                continue
            exon_id = id_pattern.search(attrs).groups()[0] 
            try:
              current_txname = tid_pattern.search(attrs).groups()[0]
            except AttributeError:
              current_txname = ""
              
            exon_transcript = parent_pattern.search(attrs).groups()[0]
            

            if current_transcript != exon_transcript:
                sys.exit("current transcript {} not equal to last transcript {} for exon {}".format(exon_transcript, 
                    current_transcript, 
                    exon_id))   
            
            new_attrs = 'gene_id "{}"; transcript_id "{}"; gene_name "{}"; exon_id "{}"'
            new_attrs = new_attrs.format(current_gene, 
                                         current_transcript,
                                         current_txname,
                                         exon_id)

            print("\t".join(fields[:8]), new_attrs, sep = "\t")
            continue

        if feature in ["rRNA", "tRNA"]:
            skip_gene = True
            continue

def main():

    parser = argparse.ArgumentParser(description="""
    convert gff3 file into GTF. Also add in gene/transcript attributes
    """)
                                      
    parser.add_argument('-i',
                          '--gff3',
                          help ='sea urchin gff3 file',
                       required = True)
    args=parser.parse_args()
   
    gff = args.gff3
    
    gff_obj = open(gff, 'r')

    
    parse_gff(gff_obj)

if __name__ == "__main__": main()

