library(picante)
library(phytools)
library(methods)

files<-list.files(path="/home/raungar/MatrixOutputExt/", pattern="matrix\\.Archaealess*",all.files = F) #note: hard coded path
phy.bac<-read.tree(file="/home/raungar/b.raxml/Bacteria.9/RAxML_bestTree.raxml.bacteria.9")
first.tip.label<-phy.bac$tip.label

phy.bac$tip.label2<-sapply(strsplit(phy.bac$tip.label,"<"), "[[", 2)
phy.bac$tip.label2<-sapply(strsplit(phy.bac$tip.label2,"_"), "[[", 1)

  traits<-read.table("/home/raungar/rachel.final.txt",
                         header = T,row.names = 1,stringsAsFactors = F,sep="\t") #this is your traits data
  #this preps the traits data
  traits$Temperature[86]<-as.numeric(25.5) #you can change... but dumb dash
  traits$taxa.names<-rownames(traits)
  for(i in 1:nrow(traits)){
    if(traits$Reisolated.[i] == "yes"){
      traits$Reisolated.[i]=1
    }else{
      traits$Reisolated.[i]=0
    }
    if(is.na(traits$Date.of.Isolation[i])){
      traits$Date.of.Isolation[i]=-1
    }else{
      next;
    }
  }
  traits$Date.of.Isolation<-as.numeric(traits$Date.of.Isolation)
  traits$Temperature<-as.numeric(traits$Temperature)
  traits$Salinity<-as.numeric(traits$Salinity)
  traits$Reisolated.<-as.numeric(traits$Reisolated.)

#do this process for all levels(order/family/etc)
for(matrix in files){
  print(matrix)
  if(matrix == "matrix.Archaealess.kingdom.txt"){
	next; #skip this one because error message since only two columns
  }

  phy.bac$tip.label<-first.tip.label
  phy.bac$tip.label<-sapply(strsplit(phy.bac$tip.label,"<"), "[[", 3)
  
  community.bac<-read.table(paste0("/home/raungar/MatrixOutputExt/",matrix),
                            header=T,row.names = 1,stringsAsFactors = F)
  #just name correcting from here on
  for(i in 1:length(colnames(community.bac))){if(colnames(community.bac)[i] == "NA."){colnames(community.bac)[i] ="NA"}}
  community.bac<-community.bac[!!rowSums(abs(community.bac)),] #just name correcting from here on
  colnames(community.bac)<-gsub("?\\._\\.","_",colnames(community.bac))
  colnames(community.bac)<-gsub("?_\\.","_",colnames(community.bac))
  colnames(community.bac)<-gsub("?\\._","_",colnames(community.bac))
  colnames(community.bac)<-gsub("X\\.","",colnames(community.bac))
  
  #Allows for ses.mpd to match tree 
  length.rank<-length(strsplit(colnames(community.bac)[1],"_")[[1]])
  corrected.tip.label<-c("")
  na.string<-c("")
  
  #take out NA column (this just corrects naming depending on which level)
  for (rank.i in 1:length.rank){
    if (rank.i!=length.rank){
      corrected.tip.label<-paste0(corrected.tip.label,sapply(strsplit(phy.bac$tip.label,"_"),"[[",rank.i), "_")
      na.string<-paste0(na.string,"NA_")
    } else {
      corrected.tip.label<-paste0(corrected.tip.label,sapply(strsplit(phy.bac$tip.label,"_"),"[[",rank.i))
      na.string<-paste0(na.string,"NA")
    }
  }
  phy.bac$tip.label<-corrected.tip.label
  
  community.bac<-community.bac[ , -which(names(community.bac) %in% na.string)]
  
  #gives you psv, psc, psr, pse, sr
  psd<-psd(community.bac, phy.bac)  

  rank<-(strsplit(matrix,"\\.")[[1]][3])
  write.table(psd,paste0("/home/raungar/PhyloDiv/psd.Bacteria.",rank,".txt"), sep="\t")


  phy.bac.traits<-phy.bac
  phy.bac.traits$tip.label<-phy.bac.traits$tip.label2
  combined <- match.phylo.data(as.phylo(phy.bac.traits), traits)

  traitcolnum<-4 #reisolated #change for which one you want to know the phylosig about
  traitscol<-as.matrix(traits[,traitcolnum])
  rownames(traitscol)<-rownames(traits)
  colnames(traitscol)<-colnames(traits[,traitcolnum])
  ps<-phylosig(phy.bac.traits,traitscol,test=TRUE) #k statistic

  rank<-(strsplit(matrix,"\\.")[[1]][3])
  savefilename<-paste0("/home/raungar/PhyloDiv/ps.Bacteria.reisolated.",rank,".RData")
  save(ps,file=savefilename)
  
}
