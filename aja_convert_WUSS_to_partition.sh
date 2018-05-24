#!/bin/bash

if [ $# -ne 2 ]
then
echo ""
echo "Usage: convert_WUSS_to_partition.sh <Consensus_Seconday_Structure_file> <number_of_preceeding_bases> "
echo ""
echo "Convert a WUSS formatted secondary structure file to a RaxML style partition file"
echo "Set number of preceding bases different than 0 to adjust the numbering."
echo "(Useful for cases where the rRNA partition is not the first partition.)"
echo "A global search for commas and replace with space will convert to Nexus style partitions"
echo "Also, change 'DNA,' to 'CHARSET' for Nexus"
echo
echo
exit
fi

Shift=$2
#echo Off-setting by $Shift

tail -n 3 $1 | head -n 1 | awk {'print $3'} | tr "[]{}()<>" "1" | tr ":.,~_-" "2" | awk 'BEGIN {FS = ""} {for (i=1; i<=NF; i=i+1) print i "\t" "part"$i}' > TEMP

#grep "part1" TEMP | cut -f1 | awk -v var=$Shift '{print $1 + var}' | tr "\n" "," | sed 's/,$/\n/' > $1.paired-sites
#grep "part2" TEMP | cut -f1 | awk -v var=$Shift '{print $1 + var}' | tr "\n" "," | sed 's/,$/\n/' > $1.UN-paired-sites

grep "part1" TEMP | cut -f1 | awk -v var=$Shift '{print $1 + var}' | tr "\n" "," | perl -nwe 'chop; print "$_\n"' > $1.paired-sites
grep "part2" TEMP | cut -f1 | awk -v var=$Shift '{print $1 + var}' | tr "\n" "," | perl -nwe 'chop; print "$_\n"' > $1.UN-paired-sites

echo "DNA, paired = " > str1
echo "DNA, unpaired = " > str2

cat str1 $1.paired-sites str2 $1.UN-paired-sites | paste -d" " - -

rm str1 str2 TEMP
