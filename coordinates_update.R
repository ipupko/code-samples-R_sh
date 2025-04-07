#!/usr/bin/env Rscript

args <- commandArgs(TRUE)
input_dir <- args[1]
coord_file_dir <- args[2]
bim <- args[3]
coord <- args[4]

setwd(input_dir)
library(tidyverse)
library(data.table)


df <- fread(paste0(input_dir,bim), header=F)

coord <- fread(paste0(coord_file_dir,coord), header=F)

bim_updated<-merge.data.frame(df, coord,by.x = "V2", by.y="V2",all.x = T,sort = F)

bim_final<-bim_updated[c(8,1,9,10,5,6)]

write.table(fam_updated_final,paste0(input_dir,bim),quote = F,col.names = F,row.names = F)