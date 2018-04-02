library(picante)
library(seqinr)
library(ape)

community<-read.table("/Users/rachelungar/Documents/SeniorPt1/Lab/MatrixOutput/cut.removed.matrix.Archaeless.genus.txt",
                      header=T,row.names = 1,stringsAsFactors = F)
traits<-read.table("/Users/rachelungar/Documents/SeniorPt1/Lab/rachel.final.txt",
                   header = T,row.names = 1,stringsAsFactors = F,sep="\t")
traits$Temperature[86]<-25.5 #you can change... but dumb dash
community<-community[!!rowSums(abs(community)),]
traits<-traits[c(rownames(full)),]
comm<-decostand(community,method = "total")
phy.bac<-read.tree(file="/Users/rachelungar/Documents/SeniorPt1/Lab/tree_bacteria_file")
phy.bac$tip.label<-sub("\\."," ",phy.bac$tip.label)
aless.order<-phy.bac$tip.label
aless.family<-phy.bac$tip.label
aless.genus<-phy.bac$tip.label
aless.species<-phy.bac$tip.label
for(i in 1:length(phy.bac$tip.label)){
  temp.aless.order<-system(paste0("cat /Users/rachelungar/Documents/SeniorPt1/Lab/archaealess.classification.txt | grep \"", 
                              phy.bac$tip.label[i],"\" | awk '{print $6}'") ,intern=TRUE) #change $5 , this is for family
  temp.aless.family<-system(paste0("cat /Users/rachelungar/Documents/SeniorPt1/Lab/archaealess.classification.txt | grep \"", 
                               phy.bac$tip.label[i],"\" | awk '{print $7}'") ,intern=TRUE) #change $5 , this is for family
  temp.aless.genus<-system(paste0("cat /Users/rachelungar/Documents/SeniorPt1/Lab/archaealess.classification.txt | grep \"", 
                              phy.bac$tip.label[i],"\" | awk '{print $8}'") ,intern=TRUE) #change $5 , this is for family
  temp.aless.species<-system(paste0("cat /Users/rachelungar/Documents/SeniorPt1/Lab/archaealess.classification.txt | grep \"", 
                                phy.bac$tip.label[i],"\" | awk '{print $9}'") ,intern=TRUE) #change $5 , this is for family
  
  if(identical(temp.aless.order,character(0))){aless.order[i]<-c("NA.")}else{aless.order[i]<-temp.aless.order}
  if(identical(temp.aless.family,character(0))){aless.family[i]<-c("NA.")}else{aless.family[i]<-temp.aless.family}
  if(identical(temp.aless.genus,character(0))){aless.genus[i]<-c("NA.")}else{aless.genus[i]<-temp.aless.genus}
  if(identical(temp.aless.species,character(0))){aless.species[i]<-c("NA.")}else{aless.species[i]<-temp.aless.species}
  #phy$tip.label<-substring(phy$tip.label, 4)
}


plot(phy.bac,cex=0.5)
phy.bac$tip.label<-a.genus
plot(phy.bac,cex=0.5)
