### Separate Homzygosity Check Script. (IP - 20240828)

### Script Formatted using IP "monkey tail" format. In parallel uploaded to Github.

#Monkey Tail System integrated for the local backup. In online, proper backup they are indicating chunk IP is working on.

#Arguments for the QC (Lines Added IP - 20240829)
sex_check_file <- args[1] #Input of .sexcheck File.

het_file <- args[2] # Input for .het File.

hom_indiv<-homozygosity_indiv[3] # Input for .hom.indiv File.


#Load Plink Output File for the analysis.


x_homozygosity <- read.csv(sex_check_file, sep="",header = T)

autosome_homozygosity <- read.csv(het_file, sep="",header=T)

homozygosity_run <- read.csv(hom_indiv, sep="",header = T)

sex_index<-x_homozygosity[c(2,3)] #Create separate index file for individuals for 

autosome_homozygosity<-merge.data.frame(autosome_homozygosity,sex_index,by.x = "IID", by.y="IID", all = TRUE)

# Introduce Suffixes before merger
colnames(autosome_homozygosity) <- paste(colnames(autosome_homozygosity),"auto",sep="_")
colnames(x_homozygosity) <- paste(colnames(x_homozygosity),"XChr",sep="_")

# Calculate Z-Score for X Chromosome

x_homozygosity$Z_Score_XChr<-(x_homozygosity$F_XChr - mean(x_homozygosity$F_XChr))/sd(x_homozygosity$F_XChr)

# Calculate Z-Score for Autosomes

autosome_homozygosity$Z_Score_auto<-(autosome_homozygosity$F_auto - mean(autosome_homozygosity$F_auto))/sd(autosome_homozygosity$F_auto)
