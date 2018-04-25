#!/bin/bash


#make sure and run archae.sh before
for ArchaeType in ArchaeaSSU ArchaealessSSU
do
num=5 #this is which column will be awk-ed for order/family/genus/species
for level in order family genus species
do
	echo "$ArchaeType - $level"
	num=`expr $num + 1` #change taxonomic level
	awk -v num="$num" '{print $num}' $ArchaeType/* | sed '1d' | sort -u > MatrixOutputSSU/bac.cols.$ArchaeType.$level.txt #get all unique tax ids in level
	printf "bacteria\t" > MatrixOutputSSU/matrix.$ArchaeType.$level.txt
	awk -vRS="\n" -vORS="\t" '1' MatrixOutputSSU/bac.cols.$ArchaeType.$level.txt >> MatrixOutputSSU/matrix.$ArchaeType.$level.txt #print uniq tax ids tab delimited
	printf "\n" >> MatrixOutputSSU/matrix.$ArchaeType.$level.txt 
	#this section creates the header of the matrix
	

	for file in $(ls $ArchaeType/)
	do
		header=`echo $file | rev | cut -c18- | rev | cut -d'/' -f5 | cut -d '.' -f3-` #grab diatom name
		
		#source for next line: https://www.unix.com/shell-programming-and-scripting/73557-awk-hash-function.html
		#this next line makes a hash and then outputs 2 columns: one with the tax id and one with the count
		awk -v num1=$num1 -v num2=$num2 -v num3=$num3 '{cnt[$num1 " " $num2 " " $num3]+=1}END{for (x in cnt){print x,cnt[x]}}' $ArchaeType/$file | sort > hash.temp.txt
		printf "$header\t"

		#read col name (tax id), then looks to see if that tax id is in hash file
		#if it is, print count, if not print zero
		while read cols
		do
  			count=0
			
			#this reads through hash file
			while read line
        		do
          			line1=$(echo $line | cut -d ' ' -f 1,2,3) #name of tax id
                		line2=$(echo $line | cut -d ' ' -f 4) #count of tax id
				isna=$($(echo $line | cut -d ' ' -f 3) #species is NA
				
				if [ $isna == "NA" ]
				then
					
				else
        	        		if [ "$line1" == "$cols" ]
                			then
                		    		count=$line2 
                			fi
				fi

        		done <hash.temp.txt

        		printf  "$count\t" #nothing found: prints zero, found: print number from file 

		done <MatrixOutputSSU/bac.cols.$ArchaeType.$level.txt
		echo ""
		rm hash.temp.txt
	done >> MatrixOutputSSU/matrix.$ArchaeType.$level.txt

done

done
