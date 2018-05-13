#!/bin/bash

#for loop: make sure you use directory after remove isoforms
for files in $(ls DiatomIsoform/)
do

        /share/apps/bioinformatics/usearch/10.0.240/usearch -cluster_fast /home/raungar/DiatomIsoform/$files -id 1 -centroids "DiatomUsearch/temp.$files"

        #taken from https://www.biostars.org/p/9262/
        
	awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' "DiatomUsearch/temp.$files" | sed '1d' > "DiatomUsearch/$files"
        rm "DiatomUsearch/temp.$files"
done
