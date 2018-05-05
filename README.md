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
cd DadaOutputGG2/; for i in *; do mv "$i" "`echo $i | sed "s/-/./g"`"; done; cd.. ; cd diatomdir_usearch;  for i in *; do mv "$i" "`echo $i | sed "s/-/./g"`"; done; #fixes file names, since some have "-" in them, which is a problem later. I did it in DadaOutputGG3 to test . 
cat diatomdir_usearch/* | sed "s/-/./g" > all.usearch.fasta    
code used: cat DadaOutputGG2/* | grep -v Bacteria | sed "s/-/./g"| awk -F'\t' '{print $1}' > aja_filter_from_bacteria_16S.list    
cat DadaOutputGG2/* | grep -v Archaea | sed "s/-/./g" |  awk -F'\t' '{print $1}' > aja_filter_from_archaea_16S.list    
python3 aja_filter_fasta_from_list.py all.usearch.fasta aja_filter_from_bacteria_16S.list > bacteria.all.fasta    
python3 aja_filter_fasta_from_list.py all.usearch.fasta aja_filter_from_archaea_16S.list > archaea.all.fasta   
cat archaea.all.fasta bacteria.all.fasta > combined.all.fasta    
#### 2. Reduce redundancy for tree via cd-hit
cat DadaOutputGG2/ggout* | sed "s/-/./g" > dadaoutput.txt .    
./elongate.name.sh > combined.all.named.fasta; #change headers to included dada2 names, takes dadaoutput.txt .         
cdhit-4.6.8/cd-hit -i combined.all.named.fasta -o cdhits -c 0.99 -d 500 #18232  —>  12819 sequences 
python longest.in.cluster.python > cdhits.header.txt #make a headers file to record the longest name at a certain cluster     
python editheaders.cdhits.py > final.cdhits.fasta #change fasta to include longest "truest" name      
#### 3. Use ssu-align
code used: ssu-align final.cdhits.fasta ssu-cdhits   
ssu-mask ssu-cdhits    
ssu-mask --stk2afa ssu-cdhits    
ssu-draw ssu-cdhits/   
#### 4. Convert to phylip for tree
from Bio import AlignIO     
alignment = AlignIO.read("BacteriaSSU3/BacteriaSSU3.bacteria.mask.stk", "stockholm")    
print(alignment.format("fasta"))    
github.com/npchar/Phylogenomic/fasta2relaxedPhylip.pl -f infile -o outfile.phylip #convert to relaxed sequential
#### 5. Community matrix development
cat ssu-cdhits.archaea.mask.fasta ssu-cdhits.bacteria.mask.fasta | grep ">" | awk -F "<" '{print $1 "<" $2}' | cut -d ">" -f 2 > ssu-cdhits_headers.txt      
python getdiatoms.py > ssu-cdhits_diatom_headers.txt      
reduce.matrix.sh    
cd ArchaeaSSU; cat archaea.reduced.txt | sort -k2 > archaea.reduced.sort.txt; mkdir Diatoms; cd Diatoms; awk -F" " '{print>>$2}' ../archaea.reduced.sort.txt;    
cd ArchaealessSSU; cat archaealess.reduced.txt | sort -k2 > archaealess.reduced.sort.txt; mkdir Diatoms; cd Diatoms; awk -F" " '{print>>$2}' ../archaealess.reduced.sort.txt;    
./make.matrix.sh    
#### 6. Analyze using NMDS
code used: community.matrices.R     
#### 7. Make tree using FastTree
head -1 test.fasta.phylip > rename.phylip; awk -v i=0 'NR>1 {print "D"i"  "$2; i=i+1}' outfile.phylip >> rename.phylip
seqboot outfile.phylip
FastTree -gtr -nt SSU2/SSU2.bacteria.mask.phylip > tree_bacteria_file    
#### 8. Plot tree and analysis
code used: picante.R    
