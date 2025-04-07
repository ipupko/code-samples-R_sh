#####################################################
################# HOMOZYGOSITY RUNS #################
#####################################################


### Separate Homozygosity Check Script. (IP - 07/11/2024)

### Last updated 09/12/2024

### 

#####################################################
########## Write the arguments to be used ###########
#####################################################

args<-commandArgs(trailingOnly=TRUE)



#Arguments for the QC (Lines Added IP - 20240829)

sex_check_file <- args[1] #Input of file with extension .sexcheck. 

het_file <- args[2] # Input for of file with extension .het File. 

hom_indiv<-args[3] # Input for of file with extension .hom.indiv

report_dir<-ars[4] # Report Directory

########## Load ggplot and scales libs ##############
#####################################################

install.packages(ggplot)
library(ggplot)
install.packages(scales)
library(scales)


################################################
####Load Plink Output File for the analysis.####
################################################

x_homozygosity <- read.csv(sex_check_file, sep="",header = T)

autosome_homozygosity <- read.csv(het_file, sep="",header=T)

homozygosity_run <- read.csv(hom_indiv, sep="",header = T)

sex_index<-x_homozygosity[c(2,3)] #Create separate index file for individuals for 



autosome_homozygosity<-merge.data.frame(autosome_homozygosity,sex_index,by.x = "IID", by.y="IID", all = TRUE)

################################################
###### Introduce Suffixes before merger ########
################################################

colnames(autosome_homozygosity) <- paste(colnames(autosome_homozygosity),"auto",sep="_")

colnames(x_homozygosity) <- paste(colnames(x_homozygosity),"XChr",sep="_")

################################################
###### Calculate Z-Score for X Chromosome#######
################################################

x_homozygosity$Z_Score_XChr<-(x_homozygosity$F_XChr - mean(x_homozygosity$F_XChr))/sd(x_homozygosity$F_XChr)

################################################
######## Calculate Z-Score for Autosomes########
################################################

autosome_homozygosity$Z_Score_auto<-(autosome_homozygosity$F_auto - mean(autosome_homozygosity$F_auto))/sd(autosome_homozygosity$F_auto)

################################################
#### Merge X and autosome homozygosity data ####
################################################

autosome_homozygosity_KB<-merge.data.frame(autosome_homozygosity,homozygosity_run,by.x = "IID_auto", by.y="IID", all = TRUE)

##Usually it is +3 and -3. but we can be a bit more lenient. So we are using +3 anf -2. Can be adjusted for the GUIDE FILE.
autosome_homozygosity_KB$Colour = ifelse (autosome_homozygosity_KB$Z_Score_auto > 3 , "High" , ifelse(autosome_homozygosity_KB$Z_Score_auto < -2, "Outliers", "Normal"))

pdf(paste0(report_dir,"Total Homozygosity Runs Vs Homozygosity Z-score.pdf"))

ggplot(autosome_homozygosity_KB,aes(x=KB, y=Z_Score_auto,col=Colour)) + geom_point() + geom_hline(yintercept=0, linetype="dashed", color = "black") + ylab("Homozygosity Z-score") +  xlab("Total runs of homozygosity (kb)")  + scale_x_continuous(labels = label_comma()) + labs(colour="Level of Homozygosity")

dev.off()

##############################################################################
###### Create a txt file for the outliers, that PLINK is going to exclude ###
##############################################################################
outliers_high_heterozygosity<-autosome_homozygosity_KB[autosome_homozygosity_KB$Colour=="Outliers",]

outliers_high_heterozygosity_iids<-outliers_high_heterozygosity[c(2,1)]

write.table(outliers_high_heterozygosity_iids,file=paste0(report_dir,"outliers_high_heterozygosity_iids.txt"),col.names = F,row.names = F,quote = F)

q(y)
