from Bio import SeqIO
import re


clstrfile = open("cdhits.header.txt", "r")

fasta_sequences = SeqIO.parse(open("cdhits"),'fasta')
#with open("editheaders.cdhits.fasta") as out_file:
for fasta in fasta_sequences:
        name, sequence = fasta.id, str(fasta.seq)
        full_header = re.split("<", name)
        header=full_header[0] + "<" + full_header[1]

        clstrfile.seek(0)

        for line in clstrfile:
                if header in line:
                        name=line.strip()
                        found="true"
                        break
        print(name)
        print(sequence,"\n",sep='')
