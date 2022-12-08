#Author(s): Igor  Pupko (IgP)

library(impute)
library(imputeLCMD)
#"Missing"-ness analysis 

original_dataset<-crc_big_batch_metab_for_imp
variables <- colnames(original_dataset)
original_dataset$FID<-NULL
original_dataset$Idepic_Bio<-NULL
dfname <- deparse(substitute(crc_big_batch_metab_for_imp))
variables_missingness <- apply(original_dataset, 2, function(x) sum(is.na(x)))
variables_missingness_percentage <- apply(original_dataset, 2, function(x) sum(is.na(x))/nrow(original_dataset))
variables_present <- apply(original_dataset, 2, function(x) sum(complete.cases(x)))

variables_missingness <- cbind(variables, variables_missingness, variables_missingness_percentage, variables_present)

assign(paste("variables_missingness_", dfname, sep = ""), variables_missingness)

dataset_for_imp<-as.data.frame(original_dataset[(variables_missingness_percentage) < 0.2])

fileConn=paste0("README_", dfname,"_missingness_and_imputation.txt")
cat("Metabolite batch that is processed is:", dfname,"\n",file=fileConn, sep= " ",  append = TRUE)
cat("\n Number of individuals:", dim(original_dataset)[1], "\n",file=fileConn, sep= " ",  append = TRUE)
cat("\n Number of Variables:", dim(original_dataset)[2], "\n",file=fileConn, sep= " ",  append = TRUE)
cat("\r\n Variables that are having, more than 20 %:", colnames(original_dataset[(variables_missingness_percentage) > 0.2]), "\n",file=fileConn, sep= " ",  append = TRUE)
cat("\r\n All Variables that are having, less than 20 %:", colnames(original_dataset[(variables_missingness_percentage) < 0.2]), "\n",file=fileConn, sep= " ",  append = TRUE)
variables <- colnames(dataset_for_imp)
variables_missingness <- apply(dataset_for_imp, 2, function(x) sum(is.na(x)))
variables_missingness_percentage <- apply(dataset_for_imp, 2, function(x) sum(is.na(x))/nrow(dataset_for_imp))
variables_present <- apply(dataset_for_imp, 2, function(x) sum(complete.cases(x)))

filtered_variables_missingness <- cbind(variables, variables_missingness, variables_missingness_percentage, variables_present)

cat("\r Variables that are having, only with missing, less than 20%: ", colnames(dataset_for_imp[(variables_missingness_percentage) > 0]), "\n",file=fileConn, sep= " ",  append = TRUE)
cat("\r Variables without missingness: ", colnames(dataset_for_imp[(variables_missingness_percentage) == 0]), "\n",file=fileConn, sep= " ",  append = TRUE)
assign(paste("Selected_20_variables_missingness_", dfname, sep = ""), filtered_variables_missingness)
cat("\n Number of individuals in imputation dataset:", dim(dataset_for_imp)[1], "\n",file=fileConn, sep= " ",  append = TRUE)
cat("\n Number of Variables in imputation dataset:", dim(dataset_for_imp)[2], "\n",file=fileConn, sep= " ",  append = TRUE)

#a<-as.vector(levels(as.factor(dataset_for_imp$Batch_MetBio)))

#for (i in a) {
#  dataset_for_imp[[paste("Batch_", i,sep="")]]<-0
#  dataset_for_imp[[paste("Batch_", i,sep="")]][dataset_for_imp$Batch_MetBio==i]<-1
#  #which(colnames(BREA01_metabolites_for_imp_opt_to_imp_2)[colnames(BREA01_metabolites_for_imp_opt_to_imp_2) == 'Batch_P01'])
#}



cat("\n Batch list:", as.vector(levels(as.factor(dataset_for_imp$Batch_MetBio))), file=fileConn, sep= " ",  append = TRUE)



center<-as.vector(levels(as.factor(dataset_for_imp$Center)))
#for (j in b) {
#  dataset_for_imp[[paste("Center_", j,sep="")]]<-0
#  dataset_for_imp[[paste("Center_", j,sep="")]][dataset_for_imp$Center==j]<-1
##  #which(colnames(BREA01_metabolites_for_imp_opt_to_imp_2)[colnames(BREA01_metabolites_for_imp_opt_to_imp_2) == 'Batch_P01'])
#}

cat("\r Center List: ", as.vector(levels(as.factor(dataset_for_imp$Center))), "\n",file=fileConn, sep= " ",  append = TRUE)
save(x=dataset_for_imp,file =(paste(dfname, "_ready for imputation.RData",sep = "")))
dataset_for_imp$Center<-NULL


assign(paste(dfname, "_ready for imputation",  sep = ""), dataset_for_imp)

save(x=dataset_for_imp,file =(paste(dfname, "_ready for imputation.RData",sep = "")))

###Imputation with QRILC
dataset_for_imp_complete<-dataset_for_imp[!duplicated(dataset_for_imp),]
row.names(dataset_for_imp_complete)<-dataset_for_im.p_complete[,1]
dataset_for_imp_complete[,1]<-NULL
dataset_for_imp_complete$Batch_MetBio<-NULL
dataset_for_imp_complete$Center<-NULL
dataset_for_imp_complete$Well_Position<-NULL
dataset_for_imp_complete_t<-(dataset_for_imp_complete) # QRILC works in odd fashion, so it needs to be transposed before imputation
cat("Begin QRILC Imputation",sep= " ")
imputed_dataset_output_t<-impute.QRILC(dataSet.mvs = dataset_for_imp_complete_t, tune.sigma = 1)
cat("Finish QRILC Imputation",sep= " ")
#imputed_dataset_t<-as.data.frame(imputed_dataset_output[[1]])
imputed_dataset_t<-as.data.frame(imputed_dataset_output_t[[1]])
imputed_dataset<-(imputed_dataset_t)
assign(paste(dfname, "_imputed with QRILC",  sep = ""), imputed_dataset)

save(x=imputed_dataset,file =(paste(dfname, " imputed with QRILC.RData",sep = "")))