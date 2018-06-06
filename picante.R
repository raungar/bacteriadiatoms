library(picante)


community.bac<-read.table("MatrixOutputExt1/matrix.Archaealess.species.txt",
                          header=T,row.names = 1,stringsAsFactors = F)
#traits$Temperature[86]<-25.5 #you can change... but dumb dash
community.bac<-community.bac[!!rowSums(abs(community.bac)),]
colnames(community.bac)<-gsub("?\\._\\.","_",colnames(community.bac))
colnames(community.bac)<-gsub("?_\\.","_",colnames(community.bac))
colnames(community.bac)<-gsub("?\\._","_",colnames(community.bac))
colnames(community.bac)<-gsub("X\\.","",colnames(community.bac))

comm.bac<-decostand(community.bac,method = "total")
comm.bac<-comm.bac[ , -which(names(comm.bac) %in% c("NA_NA_NA_NA"))]


phy.bac<-read.tree(file="b.raxml/Bacteria.9/RAxML_bestTree.raxml.bacteria.9")
original.label<-sapply(strsplit(phy.bac$tip.label, "<"), 
                       function(x){paste( x[[1]], x[[2]], sep=" ")})
phy.bac$tip.label<-sapply(strsplit(phy.bac$tip.label,"<"), "[[", 3)


pruned.comm.bac<-community.bac[,colnames(community.bac)[colnames(community.bac) %in% unique(phy.bac$tip.label)]]

cop.phy.bac<-cophenetic(phy.bac)
write.table(cop.phy.bac,"cop.phy.bac9.txt", sep="\t")


NRI.bac<-ses.mpd(pruned.comm.bac, cop.phy.bac, null.model = "taxa.labels")
write.table(NRI.bac,"NRI.bac9.txt", sep="\t")
NTI.bac<-ses.mntd(pruned.comm.bac, cop.phy.bac,null.model="taxa.labels")
write.table(NTI.bac,"NTI.bac9.txt", sep="\t")
ses.mpd.bac<-ses.mpd((pruned.comm.bac), cop.phy.bac,null.model="taxa.labels")
write.table(ses.mpd.bac,"ses.mpd.bac9.txt", sep="\t")
ses.mntd.bac<-ses.mntd((pruned.comm.bac),cop.phy.bac,null.model="taxa.labels")
write.table(ses.mntd.bac,"ses.mntd.bac9.txt", sep="\t")

commdist.bac<-comdist(pruned.comm.bac,cop.phy.bac)
comdist.bac.clusters <- hclust(commdist.bac)	
comdist.bac.clusters$labels<-sapply(strsplit(comdist.bac.clusters$labels,"_"), "[[", 1)
write.tree(as.phylo(comdist.bac.clusters),"comdist.bac.clusters9.tree")
