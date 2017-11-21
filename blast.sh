#!/bin/bash

#file array in directory
filearray=(`ls /storage/aja/rnaseq_assemblies/alverson_lab`)
for diatomname in "${filearray[@]}"
do
	
	header=$diatomname
	if [[ $diatomname == *_* ]]
	then
    		header=`echo $diatomname| cut -d '_' -f 1`
	fi
	rdp_tax_file="/storage/aja/rnaseq_assemblies/alverson_lab/$diatomname/"$header"_ssu_tol_rrna.fa"
	perl get_longest_isoform_seq_per_trinity_gene.pl $rdp_tax_file > $header"_reduced"
	echo $rdp_tax_file

	assign_taxonomy.py -i $header"_reduced" -m blast -c 0.8 -o BLAST_Output2
done

