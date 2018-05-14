# Project: Bacterial-Diatom Associations
Files and scripts used for Honors Thesis project

## __*Steps*__
### **taxonomy assignment**
#### 1. Remove multiple isoforms    
(26806 -> 21377 sequences)     
code used: brianjohnhaas/trinityrnaseq/util/misc/get_longest_isoform_seq_per_trinity_gene.pl      
mkdir DiatomIsoform #original files    
for files in $(ls /home/raungar/DiatomCopies/)     
do      
  	perl get_longest_isoform_seq_per_trinity_gene.pl "/home/raungar/DiatomCopies/$files" > "/home/raungar/DiatomIsoform/$files" #original files are in DiatomCopies   
done    

#### 2. Remove redundant rRNA sequences via usearch     
(21763 -> 21361 sequences)       
mkdir DiatomUsearch     
./usearch.sh    
#### 3. Use dada2 and BLAST to assign taxonomy
mkdir DiatomDada      
dada2.R submitted on the cluster via submit.dada2.pbs        
#### 4. Remove anything with "chloroplast"
(21361 -> 20974 sequences)      
mkdir DiatomNoChloroplast      
for files in $(ls /home/raungar/DiatomDada);        
do sed '/Chloroplast/d' /home/raungar/DiatomDada/$files > $files        
done        
#### 5. Fix file names
cd DiatomNoChloroplast/; for i in *; do mv "$i" "`echo 2$i | sed "s/-/./g"`"; done; #fixes file names, since some have "-" in them, which is a problem later                   
for files in $(ls /home/raungar/DiatomNoChloroplast/)     
do  
    newfile=`echo $files | cut -c2- `;
  	cat $files | sed "s/-/./g" > $newfile;
done ;      
rm 2* # remove your previous files     
     
cd DiatomUsearch/; for i in *; do mv "$i" "`echo 2$i | sed "s/-/./g"`"; done; #fixes file names, since some have "-" in them, which is a problem later                   
for files in $(ls /home/raungar/DiatomUsearch/)     
do  
    newfile=`echo $files | cut -c2- `;
  	cat $files | sed "s/-/./g" > $newfile;
done;       
rm 2* # remove your previous files     

#### 5. Separate Archae/Bacteria for separate analyses
./archae.sh
       

### **bacterial tree formation**
#### 1. Get all bacteria and archaea only (remove eukaryotes and NAs)
(20974 -> 17503 sequences) 
code used: cat DiatomNoChloroplast/* | grep Bacteria | sed "s/-/./g"| awk -F'\t' '{print $1}' > aja_filter_bacteria_16S.list     
cat DiatomNoChloroplast/* | grep Archaea | sed "s/-/./g" |  awk -F'\t' '{print $1}' > aja_filter_archaea_16S.list   
cat DiatomUsearch/* > all.usearch.fasta      
python3 aja_rau_filter_fasta_from_list.py all.usearch.fasta aja_filter_bacteria_16S.list > bacteria.all.fasta    
python3 aja_rau_filter_fasta_from_list.py all.usearch.fasta aja_filter_archaea_16S.list > archaea.all.fasta   
cat archaea.all.fasta bacteria.all.fasta > combined.all.fasta    
#### 2. Reduce redundancy for tree via cd-hit
cat DiatomDada/ggout* | sed "s/-/./g" > dadaoutput.txt         
python elongate.name.python > combined.all.named.fasta; #change headers to included dada2 names, takes dadaoutput.txt       
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
