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
(12416 —> 9478 bacteria and 31 archaea sequences)      
code used: cat ssu-cdhits/ssu-cdhits.archaea.ifile | grep TRINITY | awk '{print $1}' > archaea.search     
grep -A 1 -F -f archaea.search cdhits.copy | grep -v -- "^--$" > archaea.cdhits.cut    
ssu-cdhits/ssu-cdhits.bacteria.ifile | grep TRINITY | awk '{print $1}' > bacteria.search     
grep -A 1 -F -f bacteria.search cdhits.copy | grep -v -- "^--$" > bacteria.cdhits.cut 
cat archaea.cdhits.cut bacteria.cdhits.cut gg_13_8_train_set_97.fa > gg.cdhits.fasta            
awk -v x=0 '{if($0 ~ />.*/){x=x+1; print ">s"x} else {print $0}}' gg.cdhits.fasta > gg.cdhits.count.fasta       
awk -v x=0 '{if($0 ~ />.*/){x=x+1; print ">s"x"\t"$0}}' gg.cdhits.copy.fasta > record.gg.cdhits.txt
    
ssu-prep -x gg.cdhits.count.fasta gg.cdhits2.all 125       
./gg.cdhits2.all.ssu-align.sh    




### 3. Convert to phylip for tree
python stk2phy.py gg.cdhits2.all.bacteria.mask.stk > gg.cdhits2.all.bacteria.mask.phy     
python stk2phy.py gg.cdhits2.all.archaea.mask.stk > gg.cdhits2.all.archaea.mask.phy       

#### 4. Create partition file
./convert_WUSS_to_partition.sh ssu_align.bacteria.mask.stk 0 > ssu_align.bacteria.mask.charsets.raxml     
./convert_WUSS_to_partition.sh ssu_align.archaea.mask.stk 0 > ssu_align.archaea.mask.charsets.raxml      
#### 5. Make tree using RAxML
.\# Teo makes reference trees
raxmlHPC-SSE3 -m GTRCAT -f v -s gg.cdhits.all2.bacteria.mask.phy -t bacteria_ref_teo.tre -n raxml_placements_bac     
raxmlHPC-SSE3 -m GTRCAT -f v -s gg.cdhits.all2.archaea.mask.phy -t archaea_ref_teo.tre -n raxml_placements_bac     



#### 6. Community matrix development
./archae.sh # Separate Archae/Bacteria for separate analyses          
cat b.raxml/ssu-cdhits.masked.bateria.phy | grep "TRINITY" | awk -F"<" '{print $1"<"$2}' > ssu-cdhits_headers_bac.txt     
cat a.raxml/ssu-cdhits.masked.archaea.phy | grep "TRINITY" | awk -F"<" '{print $1"<"$2}' > ssu-cdhits_headers_arc.txt    
reduce.matrix.sh    
cd Archaea; cat archaea.reduced.txt | sort -k2 > archaea.reduced.sort.txt; mkdir Diatoms; cd Diatoms; awk -F" " '{print>>$2}' ../archaea.reduced.sort.txt;    
cd ArchaealessSSU; cat archaealess.reduced.txt | sort -k2 > archaealess.reduced.sort.txt; mkdir Diatoms; cd Diatoms; awk -F" " '{print>>$2}' ../archaealess.reduced.sort.txt;    
./make.matrix.sh and ./make.matrix.species.sh     
#### 7. Plot tree and analysis
code used: picante.R     
picante.phylodiversitysignal.R
