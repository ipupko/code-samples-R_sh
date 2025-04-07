
freq_table <- read.table(file="plink_output_freeze1_final_3.frq", header=T,sep="")

sink("maf_binning.txt")

cat(c("Total number of SNPs=",nrow(freq_table)))
cat("\n")
cat("\n")
cat("MAF LESS 0.01%")
cat("\n")
freq_monomorphic<-freq_table[freq_table$MAF<=0.0001,]
cat(c("SNPs less than 0.01% =",nrow(freq_table[freq_table$MAF<=0.001,])))
cat("\n")

cat(c("Out of Total Number, less than 0.01% are ", format(nrow(freq_monomorphic)/nrow(freq_table), digits=2)))

cat("\n")
cat("\n")
cat("MAF MORE THAN 1%")
cat("\n")
freq_more_1<-freq_table[freq_table$MAF>=0.01,]
cat(c("SNPs more than 1% =",nrow(freq_table[freq_table$MAF>=0.01,])))
cat("\n")
cat(c("Out of Total Number,  more than 1% are ", format(nrow(freq_more_1)/nrow(freq_table), digits=2)))
cat("\n")


cat("\n")
cat("\n")
cat("MAF MORE THAN 5%")
cat("\n")
freq_more_5<-freq_table[freq_table$MAF>=0.05,]
cat(c("SNPs more than 5%",nrow(freq_table[freq_table$MAF>=0.05,])))
cat("\n")
cat(c("Out of Total Number, more than 5% are ", format(nrow(freq_more_5)/nrow(freq_table), digits=2)))
cat("\n")
cat("\n")


cat("MAF MORE THAN 10%")
cat("\n")
freq_more_10<-freq_table[freq_table$MAF>=0.1,]
cat(c("SNPs more than 10%",nrow(freq_table[freq_table$MAF>=0.1,])))
cat("\n")
cat(c("Out of Total Number, more than 10% are ", format(nrow(freq_more_10)/nrow(freq_table), digits=2)))
           
sink()
