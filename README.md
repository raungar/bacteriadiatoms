# Project: Bacterial-Diatom Associations
Files and scripts used for Honors Thesis project

## __*Steps*__
### **taxonomy assignment**
 
#### 1. Fix file names
mkdir DiatomRenamed; cd DiatomRenamed/; for i in *; do mv "$i" "`echo 2$i | sed "s/-/./g"`"; done; #fixes file names, since some have "-" in them, which is a problem later                   
for files in $(ls /home/raungar/DiatomRenamed/)     
do  
    newfile=`echo $files | cut -c2- `;
  	cat $files | sed "s/-/./g" > $newfile;
done ;      
rm 2* # remove your previous files     
   
#### 2. Remove multiple isoforms    
(26806 -> 21377 sequences)   
code used: brianjohnhaas/trinityrnaseq/util/misc/get_longest_isoform_seq_per_trinity_gene.pl      
mkdir DiatomIsoform #original files    
for files in $(ls /home/raungar/DiatomRenamed/);     
do      
  	perl get_longest_isoform_seq_per_trinity_gene.pl "/home/raungar/DiatomRenamed/$files" > "/home/raungar/DiatomIsoform/$files" #original files are in DiatomCopies ;  
done
       
cat DiatomRenamed/* | grep ">" | sort  > diatomcopies.txt        
cat DiatomIsoform/* | grep ">" | sort > diatomisoform.txt  
comm -23 diatomcopies.txt diatomisoform.txt > diatomcopies2isoform.removed.txt     #files removed
#### 3. Use dada2 to assign taxonomy
mkdir DiatomDada      
dada2.R submitted on the cluster via submit.dada2.pbs        
#### 4. Remove anything with "chloroplast" or "mitochondria"
(21377 -> 19347 sequences)      
mkdir DiatomNoChloroplast      
for files in $(ls /home/raungar/DiatomDada);        
do sed '/Chloroplast/d; /mitochondria/d' /home/raungar/DiatomDada/$files > $files        
done        
   
       

### **bacterial tree formation** 
#### 1. Reduce redundancy for tree via cd-hit
(19347 —> 13369 sequences)      
cat DiatomNoCM/* | sed "s/-/./g" > dadaoutput.txt     
cat DiatomIsoform/* > combine.all.fasta
python elongate.name.python > combined.all.named.fasta; #change headers to included dada2 names, takes dadaoutput.txt       
cdhit-4.6.8/cd-hit -i combined.all.named.fasta -o cdhits -c 0.99 -d 500 
python longest.in.cluster.python > cdhits.header.txt #make a headers file to record the longest name at a certain cluster     
python editheaders.cdhits.py > final.cdhits.fasta #change fasta to include longest "truest" name      
#### 2. Use ssu-align
(12416 —> XXXX sequences)      
code used: ssu-align final.cdhits.fasta ssu-cdhits   
ssu-mask ssu-cdhits    
### 3. Convert to phylip for tree
from Bio import AlignIO     
alignment = AlignIO.read("BacteriaSSU3/BacteriaSSU3.bacteria.mask.stk", "stockholm")    
print(alignment.format("fasta"))    
github.com/npchar/Phylogenomic/fasta2relaxedPhylip.pl -f infile -o outfile.phylip #convert to relaxed sequential
#### 4. Community matrix development
./archae.sh # Separate Archae/Bacteria for separate analyses          
cat ssu-cdhits.archaea.mask.fasta ssu-cdhits.bacteria.mask.fasta | grep ">" | awk -F "<" '{print $1 "<" $2}' | cut -d ">" -f 2 > ssu-cdhits_headers.txt      
python getdiatoms.py > ssu-cdhits_diatom_headers.txt      
reduce.matrix.sh    
cd ArchaeaSSU; cat archaea.reduced.txt | sort -k2 > archaea.reduced.sort.txt; mkdir Diatoms; cd Diatoms; awk -F" " '{print>>$2}' ../archaea.reduced.sort.txt;    
cd ArchaealessSSU; cat archaealess.reduced.txt | sort -k2 > archaealess.reduced.sort.txt; mkdir Diatoms; cd Diatoms; awk -F" " '{print>>$2}' ../archaealess.reduced.sort.txt;    
./make.matrix.sh    
#### 5. Analyze using NMDS
code used: community.matrices.R     
#### 6. Make tree using FastTree
head -1 test.fasta.phylip > rename.phylip; awk -v i=0 'NR>1 {print "D"i"  "$2; i=i+1}' outfile.phylip >> rename.phylip
seqboot outfile.phylip
FastTree -gtr -nt SSU2/SSU2.bacteria.mask.phylip > tree_bacteria_file    
#### 7. Plot tree and analysis
code used: picante.R    
