# Project: Bacterial-Diatom Associations
Files and scripts used for Honors Thesis project

## __*Steps*__
### **matrix preparation**
#### 1. Remove multiple isoforms
code used: brianjohnhaas/trinityrnaseq/util/misc/get_longest_isoform_seq_per_trinity_gene.pl

#### 2. Use dada2 and BLAST to assign taxonomy
code used: dada2.R submitted on the cluster via submit.dada2.pbs 
           this also accesses add.blast.sh to get results that only
           were classified as "Bacteria" or less


