#!/bin/bash

filearray=(`ls /razor/storage/aja/rnaseq_assemblies/alverson_lab`)
filearray2=(`ls /razor/storage/aja/rnaseq_assemblies/mmetsp_16S/`)

for diatomname in "${filearray[@]}"
do

header=$diatomname
if [[ $diatomname == *_* ]]
then
        header=`echo $diatomname| cut -d '_' -f 1`
fi

file="/razor/storage/aja/rnaseq_assemblies/alverson_lab/$diatomname/"$header"_ssu_tol_rrna.fa"

cp "$file" /home/raungar/diatomdir
done

for diatomname in "${filearray2[@]}"
do

header=$diatomname

file2="/razor/storage/aja/rnaseq_assemblies/mmetsp_16S/$diatomname/"$header"_ssu_tol_rrna.fa"

cp "$file2" /home/raungar/diatomdir
done
