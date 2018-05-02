library(picante)
	#library(seqinr)
	#library(ape)
	

	community<-read.table("/Users/labuser/Documents/Diatoms/matrix.ArchaeaSSU.species.txt",
	                      header=T,row.names = 1,stringsAsFactors = F)
	#traits$Temperature[86]<-25.5 #you can change... but dumb dash
	community<-community[!!rowSums(abs(community)),]
	colnames(community)[5]<-c("WCHD3-30_NA_NA_NA")
	community["NA_NA_NA_NA"]<-0
	traits<-traits[c(rownames(traits)),]
	comm<-decostand(community,method = "total")
	phy.arc<-read.tree(file="/Users/labuser/Documents/Diatoms/Archaea.13/RAxML_bestTree.archaea")
	original.label<-sapply(strsplit(phy.arc$tip.label, "<"), 
	                       function(x){paste( x[[1]], x[[2]], sep=" ")})
  tiptemp<-sapply(strsplit(phy.arc$tip.label,"<"), "[[", 3)
	phy.arc$tip.label<-sapply(strsplit(tiptemp, "_"), 
	                          function(x){paste( x[[4]], x[[5]], x[[6]], x[[7]],  sep="_")})

	# aless.species<-phy.bac$tip.label
	for(i in 1:length(phy.arc$tip.label)){
	  temp.arc<-system(paste0("cat /Users/labuser/Documents/Diatoms/archaea.classification.txt | grep \"", 
	                              original.label[i],"\" | awk '{print $5}'") ,intern=TRUE) #change $5 , this is for family
	  #if(identical(temp.arc,character(0))){phy.arc$tip.label[i]<-c("NA.")}else{phy.arc$tip.label<-temp.arc}
	  #phy$tip.label<-substring(phy$tip.label, 4)
	}
	


	plot(phy.arc,cex=0.5)
	phy.bac$tip.label<-a.genus
	plot(phy.bac,cex=0.5)

	
	NRI.b.o<-ses.mpd(community, cophenetic(phy.arc), null.model = "taxa.labels")
	NTI.b.o<-ses.mntd(community, cophenetic(phy.arc),null.model="taxa.labels")
	ses.mpd<-ses.mpd((community), cophenetic(phy.arc),null.model="taxa.labels")
	ses.mntd<-ses.mntd((community), cophenetic(phy.arc),null.model="taxa.labels")
	
	
	commdist<-comdist(community,cophenetic(phy.arc))
	comdist.clusters <- hclust(commdist)	
	plot(comdist.clusters)

	
	#NEED TO UPLOAD TRAITS
	multiPhylosignal(traits[phy.arc$tip.label,],phy.arc)	
	
