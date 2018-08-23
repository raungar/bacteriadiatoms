library(picante)


files<-list.files(path="/home/raungar/MatrixOutputExt/", pattern="matrix\\.Archaealess*",all.files = F) #hard coded
for(matrix in files){

  if(matrix == "matrix.Archaealess.kingdom.txt"){
	next; #can't apply to kingdom
  }
  phy.bac<-read.tree(file="/home/raungar/b.raxml/Bacteria.9/RAxML_bestTree.raxml.bacteria.9") #hard coded
  original.label<-sapply(strsplit(phy.bac$tip.label, "<"), 
                         function(x){paste( x[[1]], x[[2]], sep=" ")})
  phy.bac$tip.label<-sapply(strsplit(phy.bac$tip.label,"<"), "[[", 3)
  
  community.bac<-read.table(paste0("/home/raungar/MatrixOutputExt/",matrix),
                            header=T,row.names = 1,stringsAsFactors = F)
  for(i in 1:length(colnames(community.bac))){if(colnames(community.bac)[i] == "NA."){colnames(community.bac)[i] ="NA"}}
  
  #naming corrections
  community.bac<-community.bac[!!rowSums(abs(community.bac)),]
  colnames(community.bac)<-gsub("?\\._\\.","_",colnames(community.bac))
  colnames(community.bac)<-gsub("?_\\.","_",colnames(community.bac))
  colnames(community.bac)<-gsub("?\\._","_",colnames(community.bac))
  colnames(community.bac)<-gsub("X\\.","",colnames(community.bac))
  
  #Allows for ses.mpd to match tree 
  length.rank<-length(strsplit(colnames(community.bac)[1],"_")[[1]])
  corrected.tip.label<-c("")
  na.string<-c("")
  #create create string "NA" string depending on rank
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
  
  #take out NA column for analysis
  community.bac<-community.bac[ , -which(names(community.bac) %in% na.string)]
  comm.bac<-decostand(community.bac,method = "total")
  pruned.comm.bac<-comm.bac[,colnames(comm.bac)[colnames(comm.bac) %in% unique(phy.bac$tip.label)]]
  
  bac_or_arc<-"Archaea" #for axis labelling
  if (strsplit(matrix,"\\.")[[1]][2] == "Archaealess"){
    bac_or_arc<-"Bacteria"
  }
  rank<-(strsplit(matrix,"\\.")[[1]][3])
  
  cop.phy.bac<-cophenetic(phy.bac) #for clustering
  write.table(cop.phy.bac,paste0("cop.phy.",bac_or_arc,".",rank,".txt"), sep="\t")
  
  #NRI, NTI, SES.MPD, SES.MNTD
  NRI.bac<-ses.mpd(pruned.comm.bac, cop.phy.bac, null.model = "taxa.labels")
  write.table(NRI.bac,paste0("NRI.",bac_or_arc,".",rank,".txt"), sep="\t")
  NTI.bac<-ses.mntd(pruned.comm.bac, cop.phy.bac,null.model="taxa.labels")
  write.table(NTI.bac,paste0("NTI.",bac_or_arc,".",rank,".txt"), sep="\t")
  ses.mpd.bac<-ses.mpd((pruned.comm.bac), cop.phy.bac,null.model="taxa.labels")
  write.table(ses.mpd.bac,paste0("ses.mpd.",bac_or_arc,".",rank,".txt"), sep="\t")
  ses.mntd.bac<-ses.mntd((pruned.comm.bac),cop.phy.bac,null.model="taxa.labels")
  write.table(ses.mntd.bac,paste0("ses.mntd",bac_or_arc,".",rank,".txt"), sep="\t")
  
  #cluster dendogram
  commdist.bac<-comdist(pruned.comm.bac,cop.phy.bac)
  comdist.bac.clusters <- hclust(commdist.bac)	
  comdist.bac.clusters$labels<-sapply(strsplit(comdist.bac.clusters$labels,"_"), "[[", 1)
  write.tree(as.phylo(comdist.bac.clusters),paste0("comdist.clusters.",bac_or_arc,".",rank,".tree"))
  
}
