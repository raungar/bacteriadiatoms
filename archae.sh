#!/bin/bash
#takes reduced phylip files and reduce dada2 names to the reduced list
# 


cat b.raxml/ssu-cdhits.masked.bateria.phy | grep TRINITY | awk -F"<" '{print $1" "$2}' > bacteria.headers      
cat a.raxml/ssu-cdhits.masked.archaea.phy | grep TRINITY | awk -F"<" '{print $1" "$2}' > archaea.headers 

cat DiatomNoCM/*  > diatomnocm.txt
cat diatomnocm.txt | wc -l

rm Archae/archaea.txt
touch Archae/archaea.txt
rm Archaeless/archaealess.txt
touch Archaeless/archaealess.txt

rm removed.ssu.cdhits.txt
touch removed.ssu.cdhits.txt

while read line
do
	header=`echo $line | awk '{print $1" "$2}'`
	#echo $header
	if grep -Fxq "$header" bacteria.headers
        then
		echo "$line" >> Archaeless/archaealess.txt
	elif grep -Fxq "$header" archaea.headers
	then
		echo "$line" >> Archae/archaea.txt
	else
		echo $header >> removed.ssu.cdhits.txt
	fi

done<diatomnocm.txt
