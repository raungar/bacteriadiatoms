#!/bin/bash

for ArchaeType in Archaealess Archaea
do

if [ $ArchaeType == "Archaea" ]
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
	#num1=$num
	#num2=`expr $num1 + 1`
	#num3=`expr $num2 + 1`
	#num4=`expr $num3 + 1`
	awk '{print $3"_"$4"_"$5"_"$6"_"$7"_"$8"_"$9"_"$10}' $ArchaeType/Diatoms/* | sed '1d' | sort -u > MatrixOutput/bac.cols.$ArchaeType.$level.txt
	printf "NA_NA_NA_NA\n" >>  MatrixOutput/bac.cols.$ArchaeType.$level.txt


	printf "bacteria\t" > MatrixOutput/matrix.$ArchaeType.$level.txt
	awk -vRS="\n" -vORS="\t" '1' MatrixOutput/bac.cols.$ArchaeType.$level.txt >> MatrixOutput/matrix.$ArchaeType.$level.txt
	printf "\n" >> MatrixOutput/matrix.$ArchaeType.$level.txt



	for file in $(ls "$ArchaeType/Diatoms/")
	do
		#source for next line: https://www.unix.com/shell-programming-and-scripting/73557-awk-hash-function.html
		#this next line makes the hash and saves it in a file
		awk '{cnt[$3"_"$4"_"$5"_"$6"_"$7"_"$8"_"$9"_"$10]+=1}END{for (x in cnt){print x,cnt[x]}}' "$ArchaeType/Diatoms/$file" | sort > hash.temp.txt
		
		header=`echo $file` # | awk -F"_" '{print $1}'`
		printf "$header\t"

		while read cols
		do
			count=0
			while read line
        		do

			
			  	line1=$(echo $line | cut -d ' ' -f 1) #name of tax id
                                line2=$(echo $line | cut -d ' ' -f 2) #count of tax id
                                
				if [ "$line1" == "$cols" ]
                                then
                                        count=$line2
                                fi

        		done <hash.temp.txt

        		printf  "$count\t"

		done <MatrixOutput/bac.cols.$ArchaeType.$level.txt
		echo ""
		#rm hash.temp.txt


	done >> MatrixOutput/matrix.$ArchaeType.$level.txt
done

done
