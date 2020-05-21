import sys
import argparse
import os
from collections import Counter

def parse_metadata(mdata, log):

    fqdir = os.path.dirname(mdata)
    fqdir = os.path.abspath(fqdir)

    fq_suffix = ".fastq.gz"
    
    wfn = open(log, 'w')
    with open(mdata) as f:
      
      replicate_count = Counter()

      for idx, line in enumerate(f):
        mdata = line.split("\t")
        file_id = mdata[0]
        expt_id = mdata[0]
        expt_name = mdata[0]
        read_id = mdata[35]
        paired_lib = mdata[36]
        
        if idx == 0:
          mess = "extracting mdata from {} {} {}  {} {}".format(file_id, 
          expt_id, expt_name, read_id, paired_lib)
          print(mess)
          continue 

        if read_id == "2":
          continue
        
        expt_name = expt_name.replace(" ", "-")
        replicate_count[expt_name] += 1
        
        expt_name = expt_name + "_" + str(replicate_count[expt_name])

        #expt_file_id = [expt_name, expt_id, file_id, paired_lib]
        
        #expt_file_id = "_".join(expt_file_id[0])
        expt_file_id = expt_name
        print(expt_file_id)
        
        R1_id = os.path.join(fqdir, file_id + fq_suffix)
        R2_id = os.path.join(fqdir, paired_lib + fq_suffix)

        print(R1_id, R2_id)
        if os.path.isfile(R1_id):
            print("R1 is = " + file_id)
            R1_nid = os.path.join(fqdir, expt_file_id + "_R1" + fq_suffix)
            print("renaming to {}".format(R1_nid))
            os.symlink(R1_id, R1_nid)
        else:
            print("missing file " + R1_id, file = sys.stderr)

        if os.path.isfile(R2_id):
            print("R2 is = " + paired_lib)
            R2_nid = os.path.join(fqdir, expt_file_id + "_R2" + fq_suffix)
            print("renaming to {}".format(R2_nid))
            os.symlink(R2_id, R2_nid)
        else:
            print("missing file " + R2_id, file = sys.stderr)

        wfn.write("{}\t{}\n{}\t{}\n".format(R1_id, R1_nid, R2_id, R2_nid))
    
    wfn.close()

def main():
    parser = argparse.ArgumentParser(description="""
    rename encode fastqs""")

    parser.add_argument('-m',
                        '--metadata',
                        help ='metadata',
                        required = True)
    parser.add_argument('-l',
                        '--log',
                        help ='renaming log',
                        required = False,
                        default = "renaming_log.txt")
    args=parser.parse_args()
    
    fqdir = os.path.dirname(args.metadata)
    
    parse_metadata(args.metadata, os.path.join(fqdir, args.log))


if __name__ == '__main__': main()
