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
	echo "$ArchaeType - $level"
	num=`expr $num + 1`
	awk -v num="$num" '{print $num}' $ArchaeType/* | sed '1d' | sort -u > bac.cols.$level.txt
	printf "bacteria\t" > matrix.$ArchaeType.$level.txt
	awk -vRS="\n" -vORS="\t" '1' bac.cols.$level.txt >> matrix.$ArchaeType.$level.txt
	printf "\n" >> matrix.$ArchaeType.$level.txt

	for file in $(ls $ArchaeType/)
	do
		header=`echo $file | rev | cut -c18- | rev | cut -d'/' -f5 | cut -d '.' -f3-`
		
		#source for next line: https://www.unix.com/shell-programming-and-scripting/73557-awk-hash-function.html
		#this next line makes the hash and saves it in a file
		awk -v num=$num '{cnt[$num]+=1}END{for (x in cnt){print x,cnt[x]}}' $ArchaeType/$file | sort > hash.temp.txt
		printf "$header\t"
		while read cols
		do
  			count=0
	
			while read line
        		do
          			line1=$(echo $line | cut -d ' ' -f 1)
                		line2=$(echo $line | cut -d ' ' -f 2)
	
        	        	if [ "$line1" == "$cols" ]
                		then
                		    	count=$line2
                		fi
        		done <hash.temp.txt

        		printf  "$count\t"

		done <bac.cols.$level.txt
		echo ""
		rm hash.temp.txt
	done >> matrix.$ArchaeType.$level.txt
done

done
