#!/usr/bin/env Rscript

args <- commandArgs(TRUE)
input_dir <- args[1]
cc_file_dir <- args[2]
old_fam <- args[3]
case_control <- args[4]

setwd(input_dir)
library(tidyverse)
library(data.table)


df <- fread(paste0(input_dir,old_fam), header=F)

case_control <- fread(paste0(cc_file_dir,case_control, header=F)

fam_updated<-merge.data.frame(df,case_control,by.x = "V2", by.y="subject_id",all.x = T,sort = F)

fam_updated_final<-fam_updated[c(2,1,3,4,5,8)]

write.table(fam_updated_final,paste0(input_dir,old_fam),quote = F,col.names = F,row.names = F)