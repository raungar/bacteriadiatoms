library("vegan")
library("ggplot2")
library("reshape2")

a.order<-read.table("/Users/rachelungar/Documents/SeniorPt1/Lab/MatrixOutput/cut.removed.matrix.Archae.order.txt",
                 header=T,row.names = 1,stringsAsFactors = F)
treatments<-read.table("/Users/rachelungar/Documents/SeniorPt1/Lab/rachel.final.txt",
                       header = T,row.names = 1,stringsAsFactors = F,sep="\t")
treatments$No.[86]<-25.5 #you can change... but dumb dash
full<-test[!!rowSums(abs(a.order)),]
treatments.a.order<-treatments[c(rownames(full)),]
nmds.a.order<-metaMDS(full,distance="bray",k=2,trymax=5000)

a.family<-read.table("/Users/rachelungar/Documents/SeniorPt1/Lab/MatrixOutput/cut.removed.matrix.Archae.family.txt",
                    header=T,stringsAsFactors = F,row.names = 1)
full<-test[!!rowSums(abs(a.family)),]
treatments.a.family<-treatments[c(rownames(full)),]
nmds.a.family<-metaMDS(full,distance="bray",k=2,trymax=5000)

a.genus<-read.table("/Users/rachelungar/Documents/SeniorPt1/Lab/MatrixOutput/cut.removed.matrix.Archae.genus.txt",
                    header=T,row.names = 1,stringsAsFactors = F)
full<-test[!!rowSums(abs(a.genus)),]
treatments.a.genus<-treatments[c(rownames(full)),]
nmds.a.genus<-metaMDS(full,distance="bray",k=2,trymax=5000)

a.species<-read.table("/Users/rachelungar/Documents/SeniorPt1/Lab/MatrixOutput/cut.removed.matrix.Archae.species.txt",
                    header=T,row.names = 1,stringsAsFactors = F)
full<-test[!!rowSums(abs(a.species)),]
treatments.a.species<-treatments[c(rownames(full)),]
nmds.a.species<-metaMDS(full,distance="bray",k=2,trymax=5000)



aless.family<-read.table("/Users/rachelungar/Documents/SeniorPt1/Lab/MatrixOutput/cut.removed.matrix.Archaeless.family.txt",
                 header=T,row.names = 1,stringsAsFactors = F)
full<-aless.family[!!rowSums(abs(aless.family)),]
treatments.aless.family<-treatments[c(rownames(full)),]
nmds.aless.family<-metaMDS(full,distance="bray",k=3,trymax=5000)

aless.genus<-read.table("/Users/rachelungar/Documents/SeniorPt1/Lab/MatrixOutput/cut.removed.matrix.Archaeless.genus.txt",
                         header=T,row.names = 1,stringsAsFactors = F)
full<-aless.genus[!!rowSums(abs(aless.genus)),]
treatments.aless.genus<-treatments[c(rownames(full)),]
nmds.aless.genus<-metaMDS(full,distance="bray",k=3,trymax=5000)

aless.species<-read.table("/Users/rachelungar/Documents/SeniorPt1/Lab/MatrixOutput/cut.removed.matrix.Archaeless.species.txt",
                         header=T,row.names = 1,stringsAsFactors = F)
full<-aless.species[!!rowSums(abs(aless.species)),]
treatments.aless.species<-treatments[c(rownames(full)),]
nmds.aless.species<-metaMDS(full,distance="bray",k=3,trymax=5000)


stressplot(nmds_test)
ordiplot(nmds_test,type = "n")
#orditorp(nmds_test,display="species",col="red",air=0.01)
orditorp(nmds_test,display="sites",cex=.7,air=0.01, col=c("red","orange","yellow","black",
                 "blue","purple","pink","gray","turqoiuse")[unique(treatments$Salinity)])


ordiplot(nmds_test,type="n")
ordihull(nmds_test,groups=treatments$Salinity,draw="polygon",col="grey90",label=F)
orditorp(nmds_test,display="species",col="red",air=0.01)
orditorp(nmds_test,display="sites",
         air=0.01,cex=.7)

MDS_xy <- data.frame(nmds.aless.genus$points)
MDS_xy$Temp <- as.numeric(treatments.aless.genus$Temperature)
MDS_xy$Salinity <- treatments.aless.genus$Salinity
MDS_xy$Date <- treatments.aless.genus$Date.of.Isolation
MDS_xy$ReIsolated <- treatments.aless.genus$Reisolated.
ggplot(MDS_xy, aes(MDS1, MDS2,color=Temp)) + geom_point() + theme_bw() +ggtitle("BACTERIA GENUS")
