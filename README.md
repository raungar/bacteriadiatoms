# Project: Bacterial-Diatom Associations
Files and scripts used for Honors Thesis project

## __*Steps*__
### **matrix preparation**
#### 1. Remove multiple isoforms
code used: brianjohnhaas/trinityrnaseq/util/misc/get_longest_isoform_seq_per_trinity_gene.pl (27311 -> 21763 sequences)
#### 2. Remove redundant rRNA sequences via usearch
code used: usearch.sh (21763 -> 21745 sequences)
#### 3. Use dada2 and BLAST to assign taxonomy
code used: dada2.R submitted on the cluster via submit.dada2.pbs. 
           This also accesses add.blast.sh to get results that only
           were classified as "Bacteria" or less
#### 4. Separate Archae/Bacteria for separate analyses
code used: archae.sh
#### 5. Make matrix needed for further analyses
code used: make.matrix.sh and make.matrix.species.sh (get rid of specific diatoms: for file in $(ls *); do awk '$1 != "R2" && $1 != "R37"' $file > "removed.$file"; done)
#### 5. Analyze using NMDS
code used: community.matrices.R
   
       

### **bacterial tree formation**
#### 1. Use ssu-align
code used: ssu-align bacteria.all.formatted.fasta BacteriaSSU   
ssu-mask BacteriaSSU   
ssu-mask --stk2afa BacteriaSSU   
ssu-draw BacteriaSSU/   
#### 2. Convert to fasta format
https://gist.github.com/mkuhn/553217    
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < BacteriaSSU/BacteriaSSU.bacteria.mask.fasta > BacteriaSSU/BacteriaSSU.bacteria.mask.single.fasta #convert multiple to single lines
#### 3. Make tree using FastTree
FastTree -gtr -nt SSU2/SSU2.bacteria.mask.phylip > tree_bacteria_file
