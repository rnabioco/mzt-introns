#include <zlib.h>
#include <stdio.h>
#include <iostream>
#include <fstream>
#include <string>

extern "C" {
#include "kseq.h"
}

KSEQ_INIT(gzFile, gzread)
  
int main(int argc, char *argv[])
  {
    gzFile fp;
    kseq_t *seq;
    
    if (argc == 1) {
      fprintf(stderr, "Usage: %s <in.fastq/a.gz> \n", argv[0]);
      return 1;
    }
    
    fp = gzopen(argv[1], "r"); 
    seq = kseq_init(fp); 
    
    int l ; // error codes are < 0  
    while ((l = kseq_read(seq)) >= 0) { 
      
      unsigned int n = 0;
      for (unsigned int i = 0; i < seq->seq.l; i++){
        if(seq->seq.s[i] == 'N') {
          n += 1 ;
        }
      }
      if (n != seq->seq.l) {
        std::cout << ">" << seq->name.s << " "  << std::endl ;
        std::cout << seq->seq.s << std::endl ;
      } 
    }
    kseq_destroy(seq); 
    gzclose(fp); // STEP 6: close the file handle
    
    return 0;
  }