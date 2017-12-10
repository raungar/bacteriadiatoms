library("rentrez")
library("XML")
library("RSelenium")
library("devtools")

search<-entrez_search(db="nucleotide", term="33175[BioProject] OR 33317[BioProject]",
                      retmax=20000)
write(search$ids, "/Users/rachelungar/Documents/SeniorPt1/Lab/tax.txt")
