#$ -S /bin/bash
#$ -l h_rt=12:0:00
#$ -l h_vmem=128G,tmem=128G
#$ -cwd
#$ -j y

### DIVERGE genotyping data QC Master Script (IP - 20240828)

### PROJECT DIVERGE

### VERSION 0.6 (29/10/2024)
### VERSION 1 WILL BE ASSIGNED TO WORKING SCRIPT
###CURRENTLY IT IS DRAFT

# In online, proper backup they are indicating chunk IP is working on.



#########MAKE A LIST OF ARGUMENTS !IGOR! MAKE A LIST OF ARGUMENTS#########

input_dir=/cluster/project2/DIVERGE/input_dir/
qc_dir=/cluster/project2/DIVERGE/QC_dir/
input_file=plink_output_freeze1_final_3
script_dir=/cluster/project2/DIVERGE/geno_QC_scripts/                 

cd ${qc_dir}


######################################
###Convert PED file to PLINK format###
######################################
##########SLAVE SCRIPT 1 INIT#########
######################################

/bin/bash ${script_dir}PED2PLINK_ver3.sh -a ${input_dir} -b ${input_file} -c ${qc_dir}


######################################
#######RUN GENO and SAMPLE QC#########
######################################
##########SLAVE SCRIPT 2 INIT#########
######################################

/bin/bash ${script_dir}geno_sample_ver1.sh -a ${qc_dir} -b ${input_file} -c ${qc_dir}

#######################################################
#######Write TXT ABOUT NUMBER OF SNPS EXCLUDED#########
#######################################################
echo "SNPs excluded" > ${qc_dir}Reports/SNP_excluded.txt
echo "Geno 85%" >> ${qc_dir}Reports/SNP_excluded.txt | wc -l plink_output_freeze1_final_3_g85.hh >> ${qc_dir}Reports/SNP_excluded.txt
echo "Geno 90%" >> ${qc_dir}Reports/SNP_excluded.txt | wc -l plink_output_freeze1_final_3_g90_s85.hh >> ${qc_dir}Reports/SNP_excluded.txt
echo "Geno 95%" >> ${qc_dir}Reports/SNP_excluded.txt | wc -l plink_output_freeze1_final_3_g95_s90.hh >> ${qc_dir}Reports/SNP_excluded.txt

echo "Samples excluded" > ${qc_dir}Reports/Samples_excluded.txt
echo "Sample 85%" >> ${qc_dir}Reports/Samples_excluded.txt | wc -l plink_output_freeze1_final_3_g85_s85.irem >> ${qc_dir}Reports/Samples_excluded.txt
echo "Sample 90%" >> ${qc_dir}Reports/Samples_excluded.txt | wc -l plink_output_freeze1_final_3_g90_s90.irem >> ${qc_dir}Reports/Samples_excluded.txt
echo "Sample 95%" >> ${qc_dir}Reports/Samples_excluded.txt | wc -l plink_output_freeze1_final_3_g95_s95.irem >> ${qc_dir}Reports/Samples_excluded.txt

######################################
########### SEX CHECK QC##############
######################################
##########SLAVE SCRIPT 3 INIT#########
######################################

/bin/bash ${script_dir}sex_check_plink_ver1.sh -a ${qc_dir} -b ${input_file} -c ${qc_dir}


######################################
########### SEX CHECK QC##############
######################################
##########SLAVE SCRIPT 4 INIT#########
######################################
#####IN PROGRESS UMAR AND IGOR########
######################################


report_dir=/cluster/project2/DIVERGE/${qc_dir}/Reports/

/bin/bash ${script_dir}sex_remove.sh -a ${report_dir} -b ${input_file} -c ${qc_dir} --d ${sex_exclude}

######################################
##### HOMOZYGOSITY CHECK QC###########
######################################
##########SLAVE SCRIPT 5 INIT#########
######################################
############IN	PROGRESS IGOR######### 
######################################



######################################
########POP-STRATA CHECK QC###########
######################################
##########SLAVE SCRIPT 6 INIT#########
######################################
############IN  PROGRESS IGOR#########      
######################################


######################################
########IMPUTATION PREPARE############
######################################
##########SLAVE SCRIPT 7 INIT#########
######################################
######################################
############IN PROGRESS IGOR##########
######################################


######################################
##############END SCRIPT#############
######################################
