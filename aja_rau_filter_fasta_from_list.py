#! /usr/bin/env python3

# load required modules
import sys
import os
import re
import argparse
from Bio import SeqIO

# create an ArgumentParser object ('parser') that will hold all the information necessary to parse the command line
parser = argparse.ArgumentParser()

# add arguments
parser.add_argument( "fasta", help="name of FASTA file" )
parser.add_argument( "keep_list", help="name of file with list of sequences to keep" )

args = parser.parse_args()

keep_seqs = []

# open and parse file with list of sequences to exclude
keep_file = open( args.keep_list, 'r' )

for line in keep_file:
    keep_seqs.append(line.rstrip())

# close list file
keep_file.close()


# open and parse file1 (FASTA file that we're keeping sequences from)
fasta_sequences = SeqIO.parse(open(args.fasta),'fasta')

# open output file
for record in fasta_sequences:
    if record.description in keep_seqs:
    	print(record.format("fasta"))
