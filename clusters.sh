#!/bin/bash

while read line
do
	if [[ "$line" = *"Cluster"* ]]
	then
		if [[ $max_line != *"\*" ]] && [[ $count -gt 1 ]]
		then
      #this prints when it recognizes the next line has reached
			swap1=$(echo $max_line | awk -F "-" '{print $1}' | awk -F ">" '{print $2}')
			swap2=$(echo $max_line | awk -F "-" '{print $2}')
			echo -n "$swap1 "
			echo -n "$swap2"
			printf "\t"			
			echo $swap1"-"$swap2"-"$max_name
			
		fi

		#echo $max_name
#		echo $count
		max_len=0
		len=0
		count=0
	else
		count=$(($count+1))
		len=$(echo $line | awk -F "-" '{print $3}' | awk -F "\." '{print $1}' | wc -c) 

		if [[ max_len -eq 0 ]]
		then
			#this is for if it is the first one
			max_len=$len
		fi
		#test to see if longest tax id to figure out one to use
		if [[ $len -gt $max_len ]]
		then
			max_len=$len
			max_name=$(echo $line | awk -F "-" '{print $3}' | awk -F "\." '{print $1}') #store full tax id
			max_line="$line" #store longest tax_id output
		fi

	fi

done<"cdhitnamed.clstr"
