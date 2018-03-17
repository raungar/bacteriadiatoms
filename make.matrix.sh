#!/bin/bash

for ArchaeType in Archae Archaeless
do
num=5
for level in order family genus species
do
	echo "$ArchaeType - $level"
	num=`expr $num + 1`
	awk -v num="$num" '{print $num}' $ArchaeType/* | sed '1d' | sort -u > MatrixOutput/bac.cols.$ArchaeType.$level.txt
	printf "bacteria\t" > MatrixOutput/matrix.$ArchaeType.$level.txt
	awk -vRS="\n" -vORS="\t" '1' MatrixOutput/bac.cols.$ArchaeType.$level.txt >> MatrixOutput/matrix.$ArchaeType.$level.txt
	printf "\n" >> MatrixOutput/matrix.$ArchaeType.$level.txt


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

		done <MatrixOutput/bac.cols.$ArchaeType.$level.txt
		echo ""
		rm hash.temp.txt
	done >> MatrixOutput/matrix.$ArchaeType.$level.txt

done

done
