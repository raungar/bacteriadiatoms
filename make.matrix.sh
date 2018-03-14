#!/bin/bash


#cat DadaOutputGG/* | wc -l
#awk '{print $6}' DadaOutputGG/* | sed '1d' | sort -u > bac.cols.order.txt
#awk '{print $7}' DadaOutputGG/* | sed '1d' | sort -u > bac.cols.family.txt
#awk '{print $8}' DadaOutputGG/* | sed '1d' | sort -u > bac.cols.genus.txt

#printf "bacteria\t"
# awk -vRS="\n" -vORS="\t" '1' bac.cols.order.txt
#tr "\n" "\t" < bac.cols.order.txt
#printf "\n"


for ArchaeType in Archae Archaeless
do

num=5
for level in order family genus
do
	num=`expr $num + 1`
	awk -v num=$num '{print $num}' ArchaeType/* | sed '1d' | sort -u > bac.cols.$level.txt
	printf "bacteria\t"
	awk -vRS="\n" -vORS="\t" '1' bac.cols.$level.txt
	printf "\n"

	for file in $(ls ArchaeType/)
	do
		header=`echo $file | rev | cut -c18- | rev | cut -d'/' -f5 | cut -d '.' -f2-`
		printf "$header\t"
		while read cols
		do
  			num=0
	
			while read line
        		do
          			line1=$(echo $line | cut -d ' ' -f 1)
                		line2=$(echo $line | cut -d ' ' -f 2)
	
        	        	if [ "$line1" == "$cols" ]
                		then
                		    	num=$line2
                		fi
        		done <test

        		printf  "$num\t"

		done <bac.cols.$line.txt
		echo ""
	done > matrix.$line.txt
done

done
