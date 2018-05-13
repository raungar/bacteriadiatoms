library("dada2")
packageVersion("dada2")

files<-system("ls /home/raungar/DiatomUsearch/",intern=TRUE)
#files<-files[206:278] #job wasn't long enough oops manually add rest of files

for(filename in files){
	print(filename)
	file_header<-sub(pattern = "(.*)\\..*$", replacement = "\\1", basename(filename))	
        seqs<-getSequences(paste0("/home/raungar/DiatomUsearch/", filename))

	set.seed(100) # Initialize random number generator for reproducibility
	
	#GreenGenes
	taxa.gg.R21 <- assignTaxonomy(seqs, "/home/raungar/gg_13_8_train_set_97.fa.gz", 
	                           minBoot=80,multithread = TRUE)
	unname.gg.taxa.R21<-data.frame(unname(taxa.gg.R21),"NA",stringsAsFactors = F)
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

	newfilename<-paste0("/home/raungar/DiatomDada/ggout.",file_header,".txt")
	write.table(data.frame("name"=rownames(unname.gg.taxa.R21),unname.gg.taxa.R21),
        	    newfilename,
        	    row.names=FALSE, col.names=FALSE, sep="\t",quote=FALSE)
}
