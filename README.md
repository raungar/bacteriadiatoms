# Project: Bacterial-Diatom Associations
Files and scripts used for Honors Thesis project

## __*Steps*__
### **matrix preparation**
#### 1. Remove multiple isoforms
code used: brianjohnhaas/trinityrnaseq/util/misc/get_longest_isoform_seq_per_trinity_gene.pl
#### 2. Remove redundant rRNA sequences via usearch
code used: usearch.sh (21763 sequences -> 21745 sequences)
#### 3. Use dada2 and BLAST to assign taxonomy
code used: dada2.R submitted on the cluster via submit.dada2.pbs. 
           This also accesses add.blast.sh to get results that only
           were classified as "Bacteria" or less
#### 4. Separate Archae/Bacteria for separate analyses
code used: archae.sh

