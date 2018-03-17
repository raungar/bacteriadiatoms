#!/bin/bash


#make sure and run archae.sh before
for ArchaeType in Archae Archaeless
do
num=5 #this is which column will be awk-ed for order/family/genus/species
for level in order family genus species
do
	echo "$ArchaeType - $level"
	num=`expr $num + 1` #change taxonomic level
	awk -v num="$num" '{print $num}' $ArchaeType/* | sed '1d' | sort -u > MatrixOutput/bac.cols.$ArchaeType.$level.txt #get all unique tax ids in level
	printf "bacteria\t" > MatrixOutput/matrix.$ArchaeType.$level.txt
	awk -vRS="\n" -vORS="\t" '1' MatrixOutput/bac.cols.$ArchaeType.$level.txt >> MatrixOutput/matrix.$ArchaeType.$level.txt #print uniq tax ids tab delimited
	printf "\n" >> MatrixOutput/matrix.$ArchaeType.$level.txt 
	#this section creates the header of the matrix
	

	for file in $(ls $ArchaeType/)
	do
		header=`echo $file | rev | cut -c18- | rev | cut -d'/' -f5 | cut -d '.' -f3-` #grab diatom name
		
		#source for next line: https://www.unix.com/shell-programming-and-scripting/73557-awk-hash-function.html
		#this next line makes a hash and then outputs 2 columns: one with the tax id and one with the count
		awk -v num=$num '{cnt[$num]+=1}END{for (x in cnt){print x,cnt[x]}}' $ArchaeType/$file | sort > hash.temp.txt
		printf "$header\t"

		#read col name (tax id), then looks to see if that tax id is in hash file
		#if it is, print count, if not print zero
		while read cols
		do
  			count=0
			
			#this reads through hash file
			while read line
        		do
          			line1=$(echo $line | cut -d ' ' -f 1) #name of tax id
                		line2=$(echo $line | cut -d ' ' -f 2) #count of tax id
	
        	        	if [ "$line1" == "$cols" ]
                		then
                		    	count=$line2 
                		fi
        		done <hash.temp.txt

        		printf  "$count\t" #nothing found: prints zero, found: print number from file 

		done <MatrixOutput/bac.cols.$ArchaeType.$level.txt
		echo ""
		rm hash.temp.txt
	done >> MatrixOutput/matrix.$ArchaeType.$level.txt

done

done
