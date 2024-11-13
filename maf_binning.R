#####################################################
#################### MAF BINNING ####################
#####################################################


args<-commandArgs(trailingOnly=TRUE)
freq_file=args[1]  # Your Plink freq file.
output_file=args[2] # Report folder . Your TXT file. 
#output_plot=args[3] # With Path, goes to report folder. Your TXT file. #Deactivated for mow

freq_table <- read.table(freq_file, header=T)

fileConn<-file("maf_binning.txt")

writeLines(c("Total number of SNPs",nrow(freq_table), fileConn)

freq_monomorphic<-freq_table[freq_table<=0.0001,]
writeLines(c("SNPs less than 0.01%",freq_table[freq_table<=0.001,]), fileConn)
writeLines(c("Out of Total Number, more than 0.1% are ", nrow(freq_monomorphic)/nrow(freq_table)), fileConn)

freq_more_1<-freq_table[freq_table>=0.01,]
writeLines(c("SNPs more than 1%",nrow(freq_table[freq_table>=0.01), fileConn)
writeLines(c("Out of Total Number,  more than 1% are ", nrow(freq_more_1)/nrow(freq_table)), fileConn)

freq_more_5<-freq_table[freq_table>=0.05,]
writeLines(c("SNPs more than 5%",nrow(freq_table[freq_table>=0.05), fileConn)
writeLines(c("Out of Total Number, more than 5% are ", nrow(freq_monomorphic)/nrow(freq_table)), fileConn)

freq_more_10<-freq_table[freq_table>=0.1,]
writeLines(c("SNPs more than 10%",nrow(freq_table[freq_table>=0.1), fileConn)
writeLines(c("Out of Total Number, more than 10% are ", nrow(freq_more_10)/nrow(freq_table)), fileConn)





q(n)