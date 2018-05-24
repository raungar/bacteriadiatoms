#this creates a phylogenetic tree using RAxML 
#this is specifically for archaea, you can change to bacteria
#file ssu-cdhits.archaea.mask.charsets.raxml needed from aja_convert_WUSS_to_partition.sh


#if you only want one, take out for loop
for i in `seq 1 10`
do
  	mkdir Archaea.$i
    raxmlHPC-SSE3 -s ssu-cdhits.masked.archaea.phy -f a -N 100 -x $RANDOM -n raxml.archaea.$i -m GTRCAT -p $RANDOM -w /home/raungar/a.raxml/Archaea.$i -q ssu-cdhits.archaea.mask.charsets.raxml > raxml.archaea.$i.out

done
