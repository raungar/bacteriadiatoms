# Project: Bacterial-Diatom Associations
Files and scripts used for Honors Thesis project

## __*Steps*__
### **taxonomy assignemnt**
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
       

### **bacterial tree formation**
#### 1. Get all bacteria and archaea only (remove eukaryotes)
code used: cat DadaOutputGG2/* | grep -v Bacteria |  awk -F'\t' '{print $1}' > ../aja_filter_from_bacterial_16S.list   
cat DadaOutputGG2/* | grep -v Archaea |  awk -F'\t' '{print $1}' > aja_filter_from_archaea_16S.list    
python aja_filter_fasta_from_list.py all.usearch.fasta aja_filter_from_bacteria_16S.list > bacteria.all.fasta    
python aja_filter_fasta_from_list.py all.usearch.fasta aja_filter_from_archaea_16S.list > archaea.all.fasta   
cat archaea.all.fasta bacteria.all.fasta > combined.all.fasta    
#### 2. Reduce redundancy for tree via cd-hit
./elongate.name.sh > combined.all.named.fasta; #change headers to included dada2 names     
cdhit-4.6.8/cd-hit -i combined.all.named.fixed.fasta -o cdhits -c 0.99 -d 500 #18232  —>  12819 sequences 
python longest.in.cluster.python > cdhits.header.txt #make a headers file to record the longest name at a certain cluster     
python editheaders.py > final.cdhits.fasta #change fasta to include longest "truest" name      
#### 3. Use ssu-align
code used: ssu-align combined.all.fasta BacteriaSSU   
ssu-mask BacteriaSSU   
ssu-mask --stk2afa BacteriaSSU   
ssu-draw BacteriaSSU/   
#### 4. Convert to ssu-align format
from Bio import AlignIO     
alignment = AlignIO.read("BacteriaSSU3/BacteriaSSU3.bacteria.mask.stk", "stockholm")    
print(alignment.format("phylip-relaxed"))    
#### 5. Community matrix development
cat ssu-cdhits/ssu-cdhits.*fa | grep ">" | awk -F "<" '{print $1, $2}' | cut -d ">" -f 2 > ssu-cdhits_headers.txt    
python getdiatoms.py > ssu-cdhits_diatom_headers.txt    
python getdiatoms.py > ssu-cdhits_diatom_headers.txt    
reduce.matrix.sh   
#### 6. Analyze using NMDS
code used: community.matrices.R     
#### 7. Make tree using FastTree
FastTree -gtr -nt SSU2/SSU2.bacteria.mask.phylip > tree_bacteria_file    
#### 8. Plot tree and analysis
code used: picante.R    
