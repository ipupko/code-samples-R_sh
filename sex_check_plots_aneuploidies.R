#!/usr/bin/env Rscript

args <- commandArgs(TRUE)
input_dir <- args[1]
output_dir <- args[2]
file_F.stat_y_count <- args[3]

setwd(input_dir)
library(tidyverse)
library(data.table)


# Read in data
#sex_check_F.stats <- read.table("file_sex_check_F", header=T)
df <- fread(file_F.stat_y_count, header=T)

##Subset Males
df_mal <- df[df$PEDSEX ==1,]

##Subset Females
df_femal <- df[df$PEDSEX ==2,]

pdf(paste0(output_dir, "/Sex_check.pdf"))
# Whole sample
plot(df$F, df$YCOUNT, col=df$PEDSEX,xlab = "F Statistics", ylab = "Y count",main = "Overall Sex Check")

##Males
plot(df_mal$F, df_mal$YCOUNT, col= df_mal$PEDSEX, xlab = "F Statistics", ylab = "Y Count",main = "Male Sex Check")

##Females
df_femal <- df[df$PEDSEX ==2,]

plot(df_femal$F, df_femal$YCOUNT, col= df_femal$PEDSEX, xlab = "F Statistics", ylab = "Y Count",main = "Female Sex Check")

dev.off()

### opening a text file to write important results to

output_file <- paste0(output_dir, "/report_sex.mismatch_aneuploidies.txt")
#output_file <- "report_sex.mismatch_aneuploidies.txt"
sink(output_file)

#Males number
cat("The number of reported males:", nrow(df_mal),"\n\n")
#Female Number
cat("The number of reported females:", nrow(df_femal),"\n\n")

### FEMALE SEX MISMATCH ###

sex_mismatch_females <- subset(df_femal, F > 0.8 & YCOUNT > mean(df$YCOUNT))
cat("The number sex mismatches in females:",nrow(sex_mismatch_females),"\n\n")
cat("The details for the sex mismatch in the female subset of the sample are below:", "\n\n")
print(sex_mismatch_females)

### MALE SEX MISMATCH ###

# identify number of females wrongly assigned as males
sex_mismatch_males <- subset(df_mal, F < 0.8 & YCOUNT < mean(df$YCOUNT))
cat("\n\n","The number sex mismatches in males:",nrow(sex_mismatch_males),"\n\n")
cat("The details for the sex mismatch in the male subset of the sample are below:", "\n\n")
print(sex_mismatch_males)

#### TURNER SYNDROM

# identify potential X0 samples (Turner syndrome)
# F > 0.8 with high Ycounts would be considered a male. So female (PEDSEX) samples with F > 0.8 and Ycount < mean(df_femal) are most likely X0 samples

X0_Turner <- subset(df_femal, F > 0.8 & YCOUNT < mean(df$YCOUNT))
cat("\n\n","The number X0 (Turner syndrome) :",nrow(X0_Turner),"\n\n")
cat("The details for the X0 (Turner syndrome) samples are below:", "\n\n")
print(X0_Turner)

#### XXY SYNDROM
XXY_Klinefelter <- subset(df_mal, F < 0.8 & YCOUNT > mean(df$YCOUNT))
cat("\n\n","The number XXY (XXY_Klinefelter) :",nrow(XXY_Klinefelter),"\n\n")
cat("The details for the XXY (XXY_Klinefelter) samples are below:", "\n\n")
print(XXY_Klinefelter)

### Identify female samples with extreme X hetrozygosity 

# We suspect XXX syndrome samples here
# threshold -0.15 selected based on eyeballing from sex check plots

Extreme_het_X <- subset(df_femal, F < -0.15 & YCOUNT < mean(df$YCOUNT))
cat("\n\n","The number Extreme_het_X samples are :",nrow(Extreme_het_X),"\n\n")
cat("The details for the Extreme_het_X samples are below:", "\n\n")
print(Extreme_het_X)

# so samples to be excluded from analysis
df_aneuploidies <- rbind(X0_Turner,XXY_Klinefelter,Extreme_het_X)

cat("\n\n","The number of sex chr aneuploidies samples to be excluded are :",nrow(df_aneuploidies),"\n\n")
cat("The details for sex chr aneuploidies samples to be excluded are below:", "\n\n")
print(df_aneuploidies)

#close the file
sink()

# write out ID list that needs to be excluded from analysis
id_list_aneuploidies <- df_aneuploidies[,c(1,2)]
write.table(id_list_aneuploidies,paste0(output_dir,"/id_list_aneuploidies.txt"), quote=F,row.names=F,sep="\t",col.names=F)

#End
