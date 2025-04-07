
#$ -S /bin/bash
#$ -l h_rt=12:00:00
#$ -l h_vmem=128G,tmem=128G
#$ -cwd
#$ -j y


#YOU MIGHT WANT TO CHANGE THE TIME REQUEST DEPENDING ON THE SIZE OF YOUR DATA

### genotyping data QC Master Script (IP - 20240828)


### VERSION 0.8b (08/11/2024)
### VERSION 1 WILL BE ASSIGNED TO WORKING SCRIPT
###CURRENTLY IT IS DRAFT
###Version 0.7d Contains Sex Check and AF binning

### VERSION 0.8c
### VERSION 0.8d


# All slave-scripts completed

# Being linked to the Master Script



# In online, proper backup they are indicating chunk IP is working on.


##########################################################################
###############MAKE A LIST OF ARGUMENTS THAT IS USED FOR QCN #############
##########################################################################

# Create an input directory for where you PED and MAP are located
# input_dir=

input_dir=



#ASSIGN THE SUFFIX THAT IS GOING TO LABEL YOUT QC DIRECTORY.
#IT IS USED TO KEEP TRACK OF THE QC PIPELINE

date=`date +%y_%m_%d-%H-%M`

# CREATE A LOCAL DIRECTORY WHERE YOU WANT YOUR QC PART TO BE PERFORMED 

# FIRST MAKE IT. 
mkdir _${date}
# ASSIGN PATH VARIABLE TO YOUR QC DIRECTORY
qc_dir=/
#ENTER IT FOR THE FURTHER QC.
cd ${qc_dir}

#CASE-CONTROL FILE TO UPDATE FAM FILE IF DATA IS MISSING
case_control=

#ENTER THE NAME OF THE INPUT_FILE IN OUR CASE "NEW". IT SHOULD BE THE NAME OF THE PED/MAP INPUT .
input_file=new

# ASSIGN PATH AS YOUR SCRIPT DIRECTORY
# SCRIPT DIRECTORY IS CONTAINED IN THE ZIP FILE. UNPACK OR DOWNLOAD FROM GITHUB.
script_dir=

# CREATE A DIRECTORY FOR YOUR REPORTS.INSIDE YOUR QC DIRECTORY.
mkdir ${qc_dir}/Reports 
# ASSIGN PATH AS YOUR REPORT DIRECTORY. INSIDE YOUR QC DIRECTORY
report_dir=${qc_dir}Reports/  

###########################################################################################
############################## END OF VARIABLE CODING  ####################################
###########################################################################################

#  _____                                _            _____  __                   _
# / ___|     __    _ __ ___    _ __   | |   ___     / ___| | |__     ___    ___  | | __ 
# \___ \   / _` | | '_ ` _ \  | '_ \  | |  / _ \   | |     | '_ \   / _ \  / __| | |/ / 
#  ___) | | (_| | | | | | | | | |_) | | | |  __/   | |___  | | | | |  __/ | (__  |   <  
# |____/   \__,_| |_| |_| |_| | .__/  |_|  \___|    \____| |_| |_|  \___|  \___| |_|\_\  
#                             |_|                                                             

###########################################################################################
############# PED and MAP file from sequencing/genotyping or other projects ###############
###########################################################################################
######################################### input_file= #####################################
###########################################################################################


               


######################################
###Convert PED file to PLINK format###
######################################
##########SLAVE SCRIPT 1 INIT#########
######################################

#Run the conversion script. It will convert PED and MAP files into plink format.

/bin/bash ${script_dir}convert_ped_to_plink.sh -a ${input_dir} -b ${input_file} -c ${qc_dir}

######################################
###### REMOVE SAMPLE DUPLICATES ######  # PLINK REALLY DOESN'T LIKE DUPLICATES
######################################

#perl -ne 'print unless $dup{$_}++;' ${qc_dir} > output_file

###############################################
#######RUN GENO and SAMPLE CALLRATE QC#########
###############################################
##########SLAVE SCRIPT 2 INIT##################
###############################################


# ____   _____   _   _    ___                          _     ____       _      __  __   ____    _       _____      
#/ ___| | ____| | \ | |  / _ \      __ _   _ __     __| |   / ___|     / \    |  \/  | |  _ \  | |     | ____|   
#| |  _ |  _|   |  \| | | | | |    / _` | | '_ \   / _` |   \___ \    / _ \   | |\/| | | |_) | | |     |  _|         
#| |_| || |___  | |\  | | |_| |   | (_| | | | | | | (_| |    ___) |  / ___ \  | |  | | |  __/  | |___  | |___    
#\____| |_____| |_| \_|  \___/     \__,_| |_| |_|  \__,_|   |____/  /_/   \_\ |_|  |_| |_|     |_____| |_____|
#                                         
#  ____      _      _       _       ____       _      _____   _____      ___     ____ 
# / ___|    / \    | |     | |     |  _ \     / \    |_   _| | ____|    / _ \   / ___|
#| |       / _ \   | |     | |     | |_) |   / _ \     | |   |  _|     | | | | | |    
#| |___   / ___ \  | |___  | |___  |  _ <   / ___ \    | |   | |___    | |_| | | |___ 
# \____| /_/   \_\ |_____| |_____| |_| \_\ /_/   \_\   |_|   |_____|    \__\_\  \____|
 

/bin/bash ${script_dir}callrate_sample_variant_check.sh -a ${qc_dir} -b ${input_file} -c ${qc_dir}

R --vanilla --slave --args ${qc_dir} ${input_dir} ${input_file}_g95_s95.bim ${input_file}.map < ${script_dir}coordinates_update.R

R --vanilla --slave --args ${qc_dir} ${input_dir} ${input_file}_g95_s95.fam ${case_control} < ${script_dir}case_control_update.R	

#######################################################
###### Write TXT ABOUT NUMBER OF SNPS EXCLUDED ########
#######################################################


/bin/bash  ${script_dir}callrate_report.sh  -a ${qc_dir} -b ${input_file} -c ${report_dir}

#echo "SNPs excluded" > ${report_dir}SNP_excluded.txt
#echo "Geno 85%" >> ${report_dir}SNP_excluded.txt | wc -l ${qc_dir}${input_file}_g85.hh >> ${report_dir}SNP_excluded.txt
#echo "Geno 90%" >> ${report_dir}SNP_excluded.txt | wc -l ${qc_dir}${input_file}_g90_s85.hh >> ${report_dir}SNP_excluded.txt
#echo "Geno 95%" >> ${report_dir}SNP_excluded.txt | wc -l ${qc_dir}${input_file}_g95_s90.hh >> ${report_dir}SNP_excluded.txt
#
#echo "Samples excluded" > ${report_dir}Samples_excluded.txt
#echo "Sample 85%" >> ${report_dir}Samples_excluded.txt | wc -l ${qc_dir}${input_file}_g85_s85.irem >> ${report_dir}Samples_excluded.txt
#echo "Sample 90%" >> ${report_dir}Samples_excluded.txt | wc -l ${qc_dir}${input_file}_g90_s90.irem >> ${report_dir}Samples_excluded.txt
#echo "Sample 95%" >> ${report_dir}Samples_excluded.txt | wc -l ${qc_dir}${input_file}_g95_s95.irem >> ${report_dir}Samples_excluded.txt
#
########################################################
############## Remove intermediate checks ##############
########################################################
#
#rm ${qc_dir}*_s85.bed
#rm ${qc_dir}*_s85.bim
#rm ${qc_dir}*_s85.fam
#
#rm ${qc_dir}*_s90.bed
#rm ${qc_dir}*_s90.bim
#rm ${qc_dir}*_s90.fam

################################################################################
########### THIS PART PROCESSES AND ASSESSES DATA ##############################
################################################################################
#### IT CAN SHUFFLED, BUT YOU MAY WANT TO LOOK INTO SUBSCRIPTS BEFORE ##########
################################################################################
################# WE ARE STARTING BY LOOKING AT POOR SAMPLES####################
################################################################################
################# THIS IS NOT THE PLINK FILES WE ARE USING LATER ###############
################################################################################


################################################################################
##############################  SET MAF 0.05 ###################################
################################################################################


plink --bfile ${qc_dir}${input_file}_g95_s95 --maf 0.05 --allow-extra-chr --make-bed --out  ${qc_dir}${input_file}_g95_s95_maf005

######################################
########### SEX CHECK QC##############
######################################


# ____    _____  __  __     ____   _   _   _____    ____   _  __     ___     ____ 
#/ ___|  | ____| \ \/ /    / ___| | | | | | ____|  / ___| | |/ /    / _ \   / ___|
#\___ \  |  _|    \  /    | |     | |_| | |  _|   | |     | ' /    | | | | | |    
# ___) | | |___   /  \    | |___  |  _  | | |___  | |___  | . \    | |_| | | |___ 
#|____/  |_____| /_/\_\    \____| |_| |_| |_____|  \____| |_|\_\    \__\_\  \____|
#                                                                                  

plink --bfile ${qc_dir}${input_file}_g95_s95_maf005 --check-sex 0.6 0.9 ycount --allow-extra-chr --out ${qc_dir}${input_file}_g95_s95_maf005

#Corrected from  *mismatch-2.R to *mismatch.R

R --vanilla --slave --args ${qc_dir} ${qc_dir} ${input_file}_g95_s95_maf005.sexcheck ${report_dir} < ${script_dir}sex_check_plots_aneuploidies_mismatch.R

plink --bfile ${qc_dir}${input_file}_g95_s95_maf005 --remove ${report_dir}id_list_sex_mismatch.txt --allow-extra-chr --make-bed --out ${qc_dir}${input_file}_maf005_sex_checked

plink --bfile ${qc_dir}${input_file}_maf005_sex_checked --remove ${report_dir}id_list_aneuploidies.txt --allow-extra-chr --make-bed --out ${qc_dir}${input_file}_maf005_sex_aneuploidy_checked 

# ~/bin/bash ${script_dir}sex_remove.sh -a ${report_dir} -b (id_list_sex_mismatch_and_aneuploidies.txt) -c ${qc_dir} --d ${sex_exclude}

###############################################
########### Homozygosity Check QC##############
###############################################

# _   _                                                                   _   _              
#| | | |   ___    _ __ ___     ___    ____  _   _    __ _    ___    ___  (_) | |_   _   _   
#| |_| |  / _ \  | '_ ` _ \   / _ \  |_  / | | | |  / _` |  / _ \  / __| | | | __| | | | |   
#|  _  | | (_) | | | | | | | | (_) |  / /  | |_| | | (_| | | (_) | \__ \ | | | |_  | |_| |   
#|_| |_|  \___/  |_| |_| |_|  \___/  /___|  \__, |  \__, |  \___/  |___/ |_|  \__|  \__, |    
#                                           |___/   |___/                           |___/                                        
   ____   _                     _    
# / ___| | |__     ___    ___  | | __
#| |     | '_ \   / _ \  / __| | |/ /
#| |___  | | | | |  __/ | (__  |   < 
# \____| |_| |_|  \___|  \___| |_|\_\
                                                                                                            

plink --bfile ${qc_dir}${input_file}_maf005_sex_aneuploidy_checked --het --out ${qc_dir}${input_file}_g95_s95_maf005_sac 

plink --bfile ${qc_dir}${input_file}_maf005_sex_aneuploidy_checked --homozyg-kb 1000 --out ${qc_dir}${input_file}_g95_s95_maf005_sac

#outliers_high_heterozygosity_iids.txt

#Corrected from  Homozygosity_check_ver2.R to Homozygosity_check.R

R --vanilla --slave --args ${qc_dir}${input_file}_g95_s95_maf005.sexcheck ${qc_dir}${input_file}_g95_s95_maf005_sac.het ${qc_dir}${input_file}_g95_s95_maf005_sac.hom.indiv ${report_dir}  < ${script_dir}Homozygosity_check.R

plink --bfile ${qc_dir}${input_file}_maf005_sex_aneuploidy_checked --remove ${report_dir}outliers_high_heterozygosity_iids.txt --allow-extra-chr --make-bed --out ${qc_dir}${input_file}_g95_s95_maf005_sac_h

######################################
###### RELATEDNESS CHECK QC###########
###################################### 
########### UPLOAD BY IGOR ###########
######################################

# ____           _           _                _                                 ____   _                     _    
#|  _ \    ___  | |   __ _  | |_    ___    __| |  _ __     ___   ___   ___     / ___| | |__     ___    ___  | | __
#| |_) |  / _ \ | |  / _` | | __|  / _ \  / _` | | '_ \   / _ \ / __| / __|   | |     | '_ \   / _ \  / __| | |/ /
#|  _ <  |  __/ | | | (_| | | |_  |  __/ | (_| | | | | | |  __/ \__ \ \__ \   | |___  | | | | |  __/ | (__  |   < 
#|_| \_\  \___| |_|  \__,_|  \__|  \___|  \__,_| |_| |_|  \___| |___/ |___/    \____| |_| |_|  \___|  \___| |_|\_\
# 



plink --bfile ${qc_dir}${input_file}_g95_s95_maf005_sac_h --indep-pairwise 50 5 0.05 --allow-extra-chr --out ${qc_dir}${input_file}_g95_s95_maf005_sac_h.indep.SNP

plink --bfile ${qc_dir}${input_file}_g95_s95_maf005_sac_h --extract ${qc_dir}${input_file}_g95_s95_maf005_sac_h.indep.SNP.prune.in --genome --min 0.125 --out ${qc_dir}${input_file}_g95_s95_maf005_sac_h_pihat_min_0125 

#Corrected from  relatedness_removal_ver2.R to relatedness_removal.R 

R --vanilla --slave --args ${qc_dir} ${report_dir} ${input_file}_g95_s95_maf005_sac_h_pihat_min_0125.genome < ${script_dir}relatedness_removal.R 

plink --bfile ${qc_dir}${input_file}_g95_s95_maf005_sac_h --remove ${report_dir}related_samples_ids.txt --make-bed --out ${qc_dir}${input_file}_g95_s95_maf005_sac_h_unrelated

###################################### 
#########POP-STRATA CHECK QC##########
###################################### 
########### UPLOAD BY IGOR ###########
######################################

# ____           _                  _                   _      ____                                                              _      
#|  _ \   _ __  (_)  _ __     ___  (_)  _ __     __ _  | |    / ___|   ___    _ __ ___    _ __     ___    _ __     ___   _ __   | |_   
#| |_) | | '__| | | | '_ \   / __| | | | '_ \   / _` | | |   | |      / _ \  | '_ ` _ \  | '_ \   / _ \  | '_ \   / _ \ | '_ \  | __|    
#|  __/  | |    | | | | | | | (__  | | | |_) | | (_| | | |   | |___  | (_) | | | | | | | | |_) | | (_) | | | | | |  __/ | | | | | |_   
#|_|     |_|    |_| |_| |_|  \___| |_| | .__/   \__,_| |_|    \____|  \___/  |_| |_| |_| | .__/   \___/  |_| |_|  \___| |_| |_|  \__|   
#                                      |_|                                               |_|                                                                                         
#                      _                 _       
#    / \     _ __     __ _  | |  _   _   ___  (_)  ___ 
#   / _ \   | '_ \   / _` | | | | | | | / __| | | / __|
#  / ___ \  | | | | | (_| | | | | |_| | \__ \ | | \__ \
# /_/   \_\ |_| |_|  \__,_| |_|  \__, | |___/ |_| |___/
#                                |___/                 
#

plink --bfile ${qc_dir}${input_file}_g95_s95_maf005_sac_h_unrelated --indep-pairwise 50 5 0.05 --allow-extra-chr --out ${qc_dir}${input_file}_g95_s95_maf005_sac_h_unrelated.indep.SNP


plink --bfile ${qc_dir}${input_file}_g95_s95_maf005_sac_h_unrelated --allow-extra-chr --extract ${qc_dir}${input_file}_g95_s95_maf005_sac_h_unrelated.indep.SNP.prune.in --pca --make-bed --out ${qc_dir}${input_file}_g95_s95_maf005_sac_h_unrelated.pca

R --vanilla --slave --args ${input_file}_g95_s95_maf005_sac_h_unrelated.pca.eigenvec population.txt ${qc_dir} ${report_dir} ${input_dir} < ${script_dir}PCA_plot.R 

plink --bfile ${input_file}_g95_s95_maf005_sac_h_unrelated --allow-extra-chr --keep  ${report_dir}population_pca_punjab_cluster_ids.txt --make-bed --out ${input_file}_g95_s95_maf005_sac_h_unrelated_punjab

plink --bfile ${input_file}_g95_s95_maf005_sac_h_unrelated --allow-extra-chr --keep  ${report_dir}population_pca_kpp_cluster_ids.txt --make-bed --out ${input_file}_g95_s95_maf005_sac_h_unrelated_kpp

######################################
############ HWE EXACT TEST ##########
######################################
#####IN PROGRESS UMAR AND IGOR########
######################################

# _   _  __        __  _____     _____  __  __     _       ____   _____     _____   _____   ____    _____ 
#| | | | \ \      / / | ____|   | ____| \ \/ /    / \     / ___| |_   _|   |_   _| | ____| / ___|  |_   _|
#| |_| |  \ \ /\ / /  |  _|     |  _|    \  /    / _ \   | |       | |       | |   |  _|   \___ \    | |  
#|  _  |   \ V  V /   | |___    | |___   /  \   / ___ \  | |___    | |       | |   | |___   ___) |   | |  
#|_| |_|    \_/\_/    |_____|   |_____| /_/\_\ /_/   \_\  \____|   |_|       |_|   |_____| |____/    |_|  
# 

#~/bin/plink_linux_x86_64_20231211/plink --bfile ${qc_dir}${input_file}_new_g95_s95_maf005_sac_h_unrelated.sexcheck --remove ${report_dir}_hwe_exclude.txt --allow-extra-chr --make-bed --out  ${qc_dir}${input_file}_g95_s95_sex_clean

R --vanilla --slave --args ${input_file}_g95_s95_maf005_sac_h_unrelated_kpp.hwe ${input_file}_g95_s95_maf005_sac_h_unrelated_punjab.hwe ${qc_dir} ${input_file}_g95_s95_maf005_sac_h_unrelated_ < ${script_dir}HWE_exact_test.R

#
#FINAL FILE						
#
#REMOVE SNPS AND SAMPLES MAF 0.005
#
#

plink --bfile ${qc_dir}${input_file}_g95_s95 --remove ${report_dir}id_list_sex_mismatch.txt --allow-extra-chr --maf 0.005 --make-bed --out ${qc_dir}${input_file}_maf0005_sex

plink --bfile ${qc_dir}${input_file}_maf0005_sex --remove ${report_dir}related_samples_ids.txt --make-bed --out ${qc_dir}${input_file}_maf0005_sex_rel

rm ${qc_dir}${input_file}_maf0005_sex.bim

rm ${qc_dir}${input_file}_maf0005_sex.bed

rm ${qc_dir}${input_file}_maf0005_sex.fam

plink --bfile ${qc_dir}${input_file}_maf0005_sex_rel --remove ${report_dir}outliers_high_heterozygosity_iids.txt --allow-extra-chr --make-bed --out ${qc_dir}${input_file}_maf0005_sex_rel_hh

rm ${qc_dir}${input_file}_maf0005_sex_rel.bim

rm ${qc_dir}${input_file}_maf0005_sex_rel.bed

rm ${qc_dir}${input_file}_maf0005_sex_rel.fam

plink --bfile ${qc_dir}${input_file}_maf0005_sex_rel_hh --remove ${report_dir}id_list_aneuploidies.txt --allow-extra-chr --make-bed --out ${qc_dir}${input_file}_maf0005_sex_rel_hh_aneup

rm ${qc_dir}${input_file}_maf0005_sex_rel_hh.bim

rm ${qc_dir}${input_file}_maf0005_sex_rel_hh.bed

rm ${qc_dir}${input_file}_maf0005_sex_rel_hh.fam

plink --bfile ${qc_dir}${input_file}_maf0005_sex_rel_hh_aneup --exclude ${report_dir}hwe_snps.txt --allow-extra-chr --make-bed --out ${qc_dir}${input_file}_final
 
######################################
###### PRE-IMPUTATION QC START #######
######################################
######################################
##### IF TOPMDED COMPLETE SCRIPT #####
######################################


# ____    ____    _____               ___   __  __   ____    _   _   _____      _      _____   ___    ___    _   _     
#|  _ \  |  _ \  | ____|             |_ _| |  \/  | |  _ \  | | | | |_   _|    / \    |_   _| |_ _|  / _ \  | \ | |   
#| |_) | | |_) | |  _|      _____     | |  | |\/| | | |_) | | | | |   | |     / _ \     | |    | |  | | | | |  \| |   
#|  __/  |  _ <  | |___    |_____|    | |  | |  | | |  __/  | |_| |   | |    / ___ \    | |    | |  | |_| | | |\  |  
#|_|     |_| \_\ |_____|             |___| |_|  |_| |_|      \___/    |_|   /_/   \_\   |_|   |___|  \___/  |_| \_|   
# 
#  ____    ____    _____   ____       _      ____       _      _____   ___    ___    _   _ 
# |  _ \  |  _ \  | ____| |  _ \     / \    |  _ \     / \    |_   _| |_ _|  / _ \  | \ | |
# | |_) | | |_) | |  _|   | |_) |   / _ \   | |_) |   / _ \     | |    | |  | | | | |  \| |
# |  __/  |  _ <  | |___  |  __/   / ___ \  |  _ <   / ___ \    | |    | |  | |_| | | |\  |
# |_|     |_| \_\ |_____| |_|     /_/   \_\ |_| \_\ /_/   \_\   |_|   |___|  \___/  |_| \_|



##########################################
##############END SCRIPT##################
##########################################
############ GOOD JOB ####################
##########################################
####THANK YOU FOR USING OUR SCRIPT########
##########################################


end
