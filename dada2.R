library("dada2")
library("phyloseq")
#library("seqinr")
library("Biostrings")
packageVersion("dada2")
library(assertthat)

seqs<-getSequences("/Users/rachelungar/Documents/SeniorPt1/Lab/R21_ssu_tol_rrna.fa")
set.seed(100) # Initialize random number generator for reproducibility
#RDP
taxa.rdp.R21 <- assignTaxonomy(seqs, "/Users/rachelungar/Documents/SeniorPt1/Lab/rdp_train_set_16.fa.gz", 
                       minBoot=80,multithread = TRUE)
taxa.rdp.R21.plus <- addSpecies(taxa.rdp.R21,"/Users/rachelungar/Documents/SeniorPt1/Lab/rdp_species_assignment_16.fa.gz", verbose = T)
unname.rdp.R21.taxa<-as.data.frame(unname(taxa.rdp.R21.plus))
colnames(unname.rdp.R21.taxa)<-c("kingdom", "phylum", "class",
                        "order", "family","genus","species")
rownames(unname.rdp.R21.taxa)<-names(seqs)
write.table(data.frame("name"=rownames(unname.rdp.R21.taxa),unname.rdp.R21.taxa),
            "/Users/rachelungar/Documents/SeniorPt1/Lab/R21.rdp.txt",
            row.names=FALSE, sep="\t",quote=FALSE)

#Silva #has to use RDP for species
taxa.silva.R21 <- assignTaxonomy(seqs, "/Users/rachelungar/Documents/SeniorPt1/Lab/silva_nr_v132_train_set.fa.gz", 
                           minBoot=80,multithread = TRUE)
taxa.silva.R21.plus <- addSpecies(taxa.silva.R21,"/Users/rachelungar/Documents/SeniorPt1/Lab/silva_species_assignment_v132.fa.gz", verbose = T)
unname.silva.R21.taxa<-as.data.frame(unname(taxa.silva.R21.plus))
colnames(unname.silva.R21.taxa)<-c("kingdom", "phylum", "class",
                         "order", "family","genus","species")
rownames(unname.silva.R21.taxa)<-names(seqs)
write.table(data.frame("name"=rownames(unname.silva.R21.taxa),unname.silva.R21.taxa),
            "/Users/rachelungar/Documents/SeniorPt1/Lab/R21.silva.txt",
            row.names=FALSE, sep="\t",quote=FALSE)

#GreenGenes
taxa.gg.R21 <- assignTaxonomy(seqs, "/Users/rachelungar/Documents/SeniorPt1/Lab/gg_13_8_train_set_97.fa.gz", 
                           minBoot=80,multithread = TRUE)
#taxa.rdp.plus <- addSpecies(taxa,"/Users/rachelungar/Documents/SeniorPt1/Lab/silva_species_assignment_v132.fa.gz", verbose = T)
unname.gg.taxa.R21<-data.frame(unname(taxa.gg.R21),"NA",stringsAsFactors = F)
colnames(unname.gg.taxa.R21)<-c("kingdom", "phylum", "class",
                         "order", "family","genus","species")
rownames(unname.gg.taxa.R21)<-names(seqs)
for(i in seq(1:nrow(unname.gg.taxa.R21))){
  for(j in seq(1:ncol(unname.gg.taxa.R21))){
    if(!is.na(unname.gg.taxa.R21[i,j])) {
      unname.gg.taxa.R21[i,j]<-substring(as.character(unname.gg.taxa.R21[i,j]),4)
      if(unname.gg.taxa.R21[i,j]==""){
        unname.gg.taxa.R21[i,j]<-"NA"
      }
    }
  }
}

write.table(data.frame("name"=rownames(unname.gg.taxa.R21),unname.gg.taxa.R21),
            "/Users/rachelungar/Documents/SeniorPt1/Lab/R21.gg.txt",
            row.names=FALSE, sep="\t",quote=FALSE)



#############
#############
seqs<-getSequences("/Users/rachelungar/Documents/SeniorPt1/Lab/L101_ssu_tol_rrna.fa")
set.seed(100) # Initialize random number generator for reproducibility

#RDP
taxa.rdp.L101 <- assignTaxonomy(seqs, "/Users/rachelungar/Documents/SeniorPt1/Lab/rdp_train_set_16.fa.gz", 
                           minBoot=80,multithread = TRUE)
taxa.rdp.L101.plus <- addSpecies(taxa.rdp.L101,"/Users/rachelungar/Documents/SeniorPt1/Lab/rdp_species_assignment_16.fa.gz", verbose = T)
unname.rdp.L101.taxa<-as.data.frame(unname(taxa.rdp.L101.plus))
colnames(unname.rdp.L101.taxa)<-c("kingdom", "phylum", "class",
                             "order", "family","genus","species")
rownames(unname.rdp.L101.taxa)<-names(seqs)
write.table(data.frame("name"=rownames(unname.rdp.L101.taxa),unname.rdp.L101.taxa),
            "/Users/rachelungar/Documents/SeniorPt1/Lab/L101.rdp.txt",
            row.names=FALSE, sep="\t",quote=FALSE)

#Silva #has to use RDP for species
taxa.silva.L101 <- assignTaxonomy(seqs, "/Users/rachelungar/Documents/SeniorPt1/Lab/silva_nr_v132_train_set.fa.gz", 
                             minBoot=80,multithread = TRUE)
taxa.silva.L101.plus <- addSpecies(taxa.silva.L101,"/Users/rachelungar/Documents/SeniorPt1/Lab/silva_species_assignment_v132.fa.gz", verbose = T)
unname.silva.L101.taxa<-as.data.frame(unname(taxa.silva.L101.plus))
colnames(unname.silva.L101.taxa)<-c("kingdom", "phylum", "class",
                               "order", "family","genus","species")
rownames(unname.silva.L101.taxa)<-names(seqs)
write.table(data.frame("name"=rownames(unname.silva.L101.taxa),unname.silva.L101.taxa),
            "/Users/rachelungar/Documents/SeniorPt1/Lab/L101.silva.txt",
            row.names=FALSE, sep="\t",quote=FALSE)

#GreenGenes
taxa.gg.L101 <- assignTaxonomy(seqs, "/Users/rachelungar/Documents/SeniorPt1/Lab/gg_13_8_train_set_97.fa.gz", 
                          minBoot=80,multithread = TRUE)
#taxa.rdp.plus <- addSpecies(taxa,"/Users/rachelungar/Documents/SeniorPt1/Lab/silva_species_assignment_v132.fa.gz", verbose = T)
unname.gg.L101.taxa<-data.frame(unname(taxa.gg.L101),"NA",stringsAsFactors = F)
colnames(unname.gg.L101.taxa)<-c("kingdom", "phylum", "class",
                            "order", "family","genus","species")
rownames(unname.gg.L101.taxa)<-names(seqs)
for(i in seq(1:nrow(unname.gg.L101.taxa))){
  for(j in seq(1:ncol(unname.gg.L101.taxa))){
    if(!is.na(unname.gg.L101.taxa[i,j])) {
      unname.gg.L101.taxa[i,j]<-substring(as.character(unname.gg.L101.taxa[i,j]),4)
      if(unname.gg.L101.taxa[i,j]==""){
        unname.gg.L101.taxa[i,j]<-"NA"
      }
    }
  }
}
write.table(data.frame("name"=rownames(unname.gg.L101.taxa),unname.gg.L101.taxa),
            "/Users/rachelungar/Documents/SeniorPt1/Lab/L101.gg.txt",
            row.names=FALSE, sep="\t",quote=FALSE)





#############
#############

seqs<-getSequences("/Users/rachelungar/Documents/SeniorPt1/Lab/Thalassiosira_miniscula.CCMP1093_ssu_tol_rrna.fa")
set.seed(100) # Initialize random number generator for reproducibility

#RDP
taxa.rdp.CCMP1093 <- assignTaxonomy(seqs, "/Users/rachelungar/Documents/SeniorPt1/Lab/rdp_train_set_16.fa.gz", 
                           minBoot=80,multithread = TRUE)
taxa.rdp.CCMP1093.plus <- addSpecies(taxa.rdp.CCMP1093,"/Users/rachelungar/Documents/SeniorPt1/Lab/rdp_species_assignment_16.fa.gz", verbose = T)
unname.rdp.CCMP1093.taxa<-as.data.frame(unname(taxa.rdp.CCMP1093.plus))
colnames(unname.rdp.CCMP1093.taxa)<-c("kingdom", "phylum", "class",
                             "order", "family","genus","species")
rownames(unname.rdp.CCMP1093.taxa)<-names(seqs)
write.table(data.frame("name"=rownames(unname.rdp.CCMP1093.taxa),unname.rdp.CCMP1093.taxa),
            "/Users/rachelungar/Documents/SeniorPt1/Lab/Thalassiosira_miniscula.CCMP1093.rdp.txt",
            row.names=FALSE, sep="\t",quote=FALSE)

#Silva #has to use RDP for species
taxa.silva.CCMP1093 <- assignTaxonomy(seqs, "/Users/rachelungar/Documents/SeniorPt1/Lab/silva_nr_v132_train_set.fa.gz", 
                             minBoot=80,multithread = TRUE)
taxa.silva.CCMP1093.plus <- addSpecies(taxa.silva.CCMP1093,"/Users/rachelungar/Documents/SeniorPt1/Lab/silva_species_assignment_v132.fa.gz", verbose = T)
unname.silva.CCMP1093.taxa<-as.data.frame(unname(taxa.silva.CCMP1093.plus))
colnames(unname.silva.CCMP1093.taxa)<-c("kingdom", "phylum", "class",
                               "order", "family","genus","species")
rownames(unname.silva.CCMP1093.taxa)<-names(seqs)
write.table(data.frame("name"=rownames(unname.silva.CCMP1093.taxa),unname.silva.CCMP1093.taxa),
            "/Users/rachelungar/Documents/SeniorPt1/Lab/Thalassiosira_miniscula.CCMP1093.silva.txt",
            row.names=FALSE, sep="\t",quote=FALSE)

#GreenGenes
taxa.gg.CCMP1093 <- assignTaxonomy(seqs, "/Users/rachelungar/Documents/SeniorPt1/Lab/gg_13_8_train_set_97.fa.gz", 
                          minBoot=80,multithread = TRUE)
#taxa.rdp.plus <- addSpecies(taxa,"/Users/rachelungar/Documents/SeniorPt1/Lab/silva_species_assignment_v132.fa.gz", verbose = T)
unname.gg.CCMP1093.taxa<-data.frame(unname(taxa.gg.CCMP1093),"<NA>",stringsAsFactors = F)
colnames(unname.gg.CCMP1093.taxa)<-c("kingdom", "phylum", "class",
                            "order", "family","genus","species")
rownames(unname.gg.CCMP1093.taxa)<-names(seqs)
for(i in seq(1:nrow(unname.gg.CCMP1093.taxa))){
  for(j in seq(1:ncol(unname.gg.CCMP1093.taxa))){
    if(!is.na(unname.gg.CCMP1093.taxa[i,j])) {
      unname.gg.CCMP1093.taxa[i,j]<-substring(as.character(unname.gg.CCMP1093.taxa[i,j]),4)
      if(unname.gg.CCMP1093.taxa[i,j]==""){
        unname.gg.CCMP1093.taxa[i,j]<-"NA"
      }
    }
  }
}

write.table(data.frame("name"=rownames(unname.gg.CCMP1093.taxa),unname.gg.CCMP1093.taxa),
            "/Users/rachelungar/Documents/SeniorPt1/Lab/Thalassiosira_miniscula.CCMP1093.gg.txt",
            row.names=FALSE, sep="\t",quote=FALSE)






############ TESSTING SILVA vs. RDP vs. GreenGenes
databases<-list(unname.silva.L101.taxa,unname.rdp.L101.taxa,unname.gg.L101.taxa,
                unname.silva.R21.taxa,unname.rdp.R21.taxa,unname.gg.taxa.R21,
                unname.silva.CCMP1093.taxa,unname.rdp.CCMP1093.taxa,unname.gg.CCMP1093.taxa)
names.databases<-c("unname.silva.L101.taxa","unname.rdp.L101.taxa","unname.gg.L101.taxa",
                   "unname.silva.R21.taxa","unname.rdp.R21.taxa","unname.gg.R21.taxa",
                   "unname.silva.CCMP1093.taxa","unname.rdp.CCMP1093.taxa","unname.gg.CCMP1093.taxa")
count=1

for (database in databases){
  any.matches<-0
  num.phylum<-0
  num.kingdom<-0
  num.class<-0
  num.order<-0
  num.family<-0
  num.genus<-0
  num.species<-0
  for(i in seq(1:nrow(database))){
    if(!is.na(database[i,1])){
      any.matches<-any.matches + 1
    }
    if(!is.na(database[i,2])){
      num.phylum<-num.phylum + 1
    }
    if(!is.na(database[i,3])){
      num.class<-num.class + 1
    }
    if(!is.na(database[i,4])){
      num.order<-num.order + 1
    }
    if(!is.na(database[i,5])){
      num.family<-num.family + 1
    }
    if(!is.na(database[i,6])){
      num.genus<-num.genus + 1
    }
    if(!is.na(database[i,7])){
      num.species<-num.species + 1
    }
  }
  any.matches<-any.matches/nrow(database)*100
  num.phylum<-num.phylum/nrow(database)*100
  num.kingdom<-num.kingdom/nrow(database)*100
  num.class<-num.class/nrow(database)*100
  num.order<-num.order/nrow(database)*100
  num.family<-num.family/nrow(database)*100
  num.genus<-num.genus/nrow(database)*100
  num.species<-num.species/nrow(database)*100
  cat(paste0("A total of ",round(any.matches,digits=3),"% of sequences were identified in ",
               names.databases[count]))
  cat(paste0("\n Phylum: ",round(num.phylum,digits=3),"  "
  ,"Class: ",round(num.class,digits=3),"  "
  ,"Family: ",round(num.family,digits=3),"  "
  ,"Genus: ",round(num.genus,digits=3),"  "
  ,"Species: ",round(num.species,digits=3)))
  cat("\n_____________________________________________________________________________________\n")
  count=count+1
}
###########

write.table(data.frame("name"=rownames(unname.taxa),unname.taxa),
            "/Users/rachelungar/Documents/SeniorPt1/Lab/unnamed.taxa.txt",
            row.names=FALSE, sep="\t",quote=FALSE)






samdf <- read.csv(mimarks_path, header=TRUE)
ps <- phyloseq(tax_table(taxa.plus), sample_data(samdf),
               otu_table(seqs, taxa_are_rows = FALSE),phy_tree(fitGTR$tree))
