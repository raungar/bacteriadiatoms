#!/bin/bash

file=$1
fasta=$2

awk -v fasta=$fasta '{ 
   if ($4 == "NA"){
      name=$1   
      sample=$2
      printf(name)
      printf(" ")
      printf(sample)
      printf("\t")
      system("cat " fasta " | grep " name " -A 1 > blastme.fasta")      
      blast=system("blastn -db nt -query /Users/rachelungar/Documents/SeniorPt1/Lab/blastme.fasta -evalue 1e-12 -remote -outfmt 6 -max_target_seqs 1 -max_hsps 1 | cut -f2 | epost -db nucleotide | efetch -db nucleotide -format gpc | ~/edirect/xtract -pattern INSDSeq -element INSDSeq_accession-version INSDSeq_organism INSDSeq_taxonomy | cut -d$\"\t\" -f3 | sed $\"s/;/\t/g\"")

   }
   else {
      print $0
   }
}' $file > "add.blast.output.$file.txt"
