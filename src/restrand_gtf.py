#!/usr/bin/env python3
import re, sys
import argparse
import gzip
from collections import Counter      
from datetime import datetime

def flip_strands(input_gtf):
    """ 
    iterate through gtf and flip strands
    """
     
    # add header to output gtf indicating that it's been modified
    print("#! WARNING:strands were flipped by restrand_gtf.py")
    print("#! date: " + datetime.now().strftime('%Y-%m-%d')) 

    for index, record in enumerate(input_gtf):

        if record.startswith("#"):
            print(record, end = "")
            continue
        
        line = record.split("\t")
        
        strand = line[6]
        if strand == ".": 
            print(record, end = "")

        elif strand == "+":
            line[6] = "-"
            print("{}".format("\t".join(line)), end = "")

        elif strand == "-":
            line[6] = "+"
            print("{}".format("\t".join(line)), end = "")

        else:
            print("Warning! unknown character, {} found at line {}".format(strand,
                index + 1), file = sys.stderr)
            print(record, end = "")

def main():

    parser = argparse.ArgumentParser(description = """
    flip strands in a gtf file
    """)

    parser.add_argument('-i','--input_gtf', 
            help = """input gtf file""", required = True)
    
    args = parser.parse_args()
    
    # use either gzipped or plain text input
    gzopen = lambda f: gzip.open(f, 'rt') if f.endswith('.gz') else open(f) 
    
    input_gtf = gzopen(args.input_gtf)
    
    flip_strands(input_gtf)

    input_gtf.close() 

if __name__ == '__main__': main()
