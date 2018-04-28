#!/bin/bash

for ArchaeType in ArchaeaSSU ArchaealessSSU
do

if [ $ArchaeType == "ArchaeaSSU" ]
then
	arc="archaea"
else
	arc="archaealess"
fi

num=5

for level in species
do
	echo "$ArchaeType - $level"
	num=`expr $num + 1`
	num1=$num
	num2=`expr $num1 + 1`
	num3=`expr $num2 + 1`
	num4=`expr $num3 + 1`

	awk -v num1="$num1" -v num2="$num2" -v num3="$num3" -v num4="$num4" '{print $num1"_"$num2"_"$num3"_"$num4}' $ArchaeType/Diatoms/* | sed '1d' | sort -u > MatrixOutputSSU/bac.cols.$ArchaeType.$level.txt
	
	printf "bacteria\t" > MatrixOutputSSU/matrix.$ArchaeType.$level.txt
	awk -vRS="\n" -vORS="\t" '1' MatrixOutputSSU/bac.cols.$ArchaeType.$level.txt >> MatrixOutputSSU/matrix.$ArchaeType.$level.txt
	printf "\n" >> MatrixOutputSSU/matrix.$ArchaeType.$level.txt



	for file in $(ls "$ArchaeType/Diatoms/")
	do
		#source for next line: https://www.unix.com/shell-programming-and-scripting/73557-awk-hash-function.html
		#this next line makes the hash and saves it in a file
		awk -v num1="$num1" -v num2="$num2" -v num3="$num3" -v num4="$num4" '{cnt[$num1"_"$num2"_"$num3"_"$num4]+=1}END{for (x in cnt){print x,cnt[x]}}' "$ArchaeType/Diatoms/$file" | sort > hash.temp.txt
		
		header=`echo $file | awk -F"_" '{print $1}'`
		printf "$header\t"

		while read cols
		do
			#count is number found from hash file
  			count=0
			while read line
        		do

			
			  	line1=$(echo $line | cut -d ' ' -f 1) #name of tax id
                                line2=$(echo $line | cut -d ' ' -f 2) #count of tax id
                                isna=$(echo $line | cut -d ' ' -f1 | cut -d '.' -f3) #species is NA

                                if [ "$isna" == "NA" ]
                                then
					line1="NA"
                                fi
                                #find corresponding name if exists in hash file, print out number found
				if [ "$line1" == "$cols" ]
                                then
                                        count=$line2
                                fi

        		done <hash.temp.txt
			#if nothing found will print out zero
        		printf  "$count\t"

		done <MatrixOutputSSU/bac.cols.$ArchaeType.$level.txt
		echo ""
		#rm hash.temp.txt


	done >> MatrixOutputSSU/matrix.$ArchaeType.$level.txt
done

done
