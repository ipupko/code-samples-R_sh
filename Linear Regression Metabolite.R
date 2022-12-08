selected_vars<-colnames(CRC_COMBINED_3[,c(5:113)])
fileConn=paste0("LM_2 of CRCs.txt")
for (l in selected_vars){
     test_2<-lm(formula=paste0(l,"~Cncr_Caco_Clrt+Batch_MetBio+Sex.x+Age_Blood.x+Dataset"),data=CRC_COMBINED_3,na.action = na.exclude)
     cat("\n Effect of", l, test_2[["effects"]][["Cncr_Caco_Clrt"]],file=fileConn, sep= " ",  append = TRUE)
     summary_crc<-summary(test_2)
     cat("\n Stats-Effect_estimate", l, " :", summary_crc[["coefficients"]][2,1], file=fileConn, sep= " ",  append = TRUE)
     cat("\n Stats-Effect_Std_Error", l, " :", summary_crc[["coefficients"]][2,2], file=fileConn, sep= " ",  append = TRUE)
     cat("\n Stats-Effect_t_value", l, " :", summary_crc[["coefficients"]][2,3], file=fileConn, sep= " ",  append = TRUE)
     cat("\n Stats P-value", l, " :", summary_crc[["coefficients"]][2,4], file=fileConn, sep= " ",  append = TRUE)
}


selected_vars<-colnames(brea_1_2[,c(4:112)])
fileConn=paste0("LM_2 of BREAs.txt")
for (s in selected_vars){
  test_brea_2<-stats::lm(formula=paste0(s,"~Cncr_Caco_Brea_V2+Age_Blood+Platform"),data=brea_1_2,na.action = na.exclude) #
  cat("\n Effect of", s, test_brea_2[["effects"]][["Cncr_Caco_Brea_V2"]],file=fileConn, sep= " ",  append = TRUE)
  summary_brea<-summary(test_brea_2)
  cat("\n Stats Effect estimate", s, " :", summary_brea[["coefficients"]][2,1], file=fileConn, sep= " ",  append = TRUE)
  cat("\n Stats-Effect_Std_Error", s, " :", summary_brea[["coefficients"]][2,2], file=fileConn, sep= " ",  append = TRUE)
  cat("\n Stats-Effect_t_value", s, " :", summary_brea[["coefficients"]][2,3], file=fileConn, sep= " ",  append = TRUE)
  cat("\n Stats P-value", s, " :", summary_brea[["coefficients"]][2,4], file=fileConn, sep= " ",  append = TRUE)
}


CRC_sig<-c("Glyceroph_Pc_Ae_C36_5", "Sphingo_Sm_Oh_C22_2", "Aminoacid_Gln", "Sphingo_Sm_C26_1", "Glyceroph_Pc_Ae_C34_3", "Sphingo_Sm_C24_1", "Glyceroph_Lysopc_A_C17_0")
fileConn=paste0("Rho of CRCs.txt")
for (z in CRC_sig){
  cor_test_crc<-cor.test(CRC_COMBINED_3$Cncr_Caco_Clrt, CRC_COMBINED_3[,z],data=CRC_COMBINED_3,method="spearman")
  cat("\n Rho of", z, " :", cor_test_crc[["estimate"]][["rho"]], file=fileConn, sep= " ",  append = TRUE)
}

BREA_sig<-c("Glyceroph_Pc_Ae_C36_3","Glyceroph_Pc_Ae_C38_2","Glyceroph_Pc_Ae_C34_2", "Glyceroph_Pc_Ae_C36_2", "Aminoacid_Gln","Aminoacid_Gly","Acylcarn_C2","Sphingo_Sm_Oh_C22_1","Glyceroph_Pc_Aa_C36_3","Aminoacid_His","Acylcarn_C14_1","Sphingo_Sm_C24_0","Glyceroph_Pc_Ae_C34_3","Glyceroph_Pc_Aa_C36_1","Glyceroph_Lysopc_A_C18_2","Glyceroph_Pc_Aa_C32_2","Glyceroph_Pc_Aa_C36_2")
fileConn=paste0("Rho of BREAs.txt")
for (y in BREA_sig){
    cor_test_brea<-cor.test(brea_1_2$Cncr_Caco_Brea_V2,brea_1_2[,y],method="spearman")
    cat("\n Rho of", y, " :", cor_test_brea[["estimate"]][["rho"]], file=fileConn, sep= " ",  append = TRUE)
  }
  
