library(CMplot)
library(GenABEL)
all<-data.frame()
filenames<-read.table("TABLE")

filenames<-as.vector(filenames$V1)

for (i in filenames)
{
chunk<-paste("/project/filepath/metabolites/", i, sep="")
rchunk<-read.table(chunk,header=T)
rchunkmod<-rchunk[rchunk$sortedModel=="CRC_CRC_Aminoacid_Gln_res+CRC_Glyceroph_Lysopc_A_C17_0_res+CRC_Glyceroph_Pc_Ae_C34_3_res+CRC_Glyceroph_Pc_Ae_C36_5_res+CRC_Glyceroph_Pc_Ae_C38_3_res+CRC_Sphingo_Sm_Oh_C22_2_res+crc_res" 
& rchunk$MAF>0.05& rchunk$HWE > 0.00001,]
all<-rbind(all, rchunkmod)
}
save(all, file="/project/filepath/all_cancer_model_2.Rdata")

all$P_calc<-pchisq(all$LikelihoodRatio, df=5, lower.tail=F)


lambda<-estlambda(all$P_calc, method="median")
#single phenotype
for_plot<-all[c("MarkerName", "Chromosome", "Position", "P_calc")]
colnames(for_plot)<-c("SNP", "Chromosome", "Position", "5_disease")
CMplot(for_plot, type="p", plot.type="m", LOG10=TRUE, threshold=NULL, file="jpg",memo="" ,dpi=300,
file.output=TRUE, verbose=TRUE, width=14, height=6)
CMplot(for_plot, plot.type="q",box=FALSE,file="jpg",memo="",dpi=300,
    conf.int=TRUE,threshold.col="red",threshold.lty=2,
    file.output=TRUE,verbose=TRUE,width=5,height=5)
dev.off()
