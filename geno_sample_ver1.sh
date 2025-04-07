#####################################################
#SNPs and Sample
#####################################################


helpFunction()
{
   echo ""
   echo "Usage: $0 -a parameterA -b parameterB -c parameterC"
   echo -e "\t-a Path to File Dir"
   echo -e "\t-b Name of the Plink File to process"
   echo -e "\t-c Path to Output dir"
   exit 1 # Exit script after printing help
}

while getopts "a:b:c:" opt
do
   case "$opt" in
      a ) parameterA="$OPTARG" ;;
      b ) parameterB="$OPTARG" ;;
      c ) parameterC="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Begin script in case all parameters are correct
echo "$parameterA"
echo "$parameterB"
echo "$parameterC"

# Print helpFunction in case parameters are empty
if [ -z "$parameterA" ] || [ -z "$parameterB" ] || [ -z "$parameterC" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct

#Remove SNPs below 85% threshold

~/bin/plink_linux_x86_64_20231211/plink --bfile "$parameterA""$parameterB" --geno 0.15 --maf 0.0000000000001 --exclude /cluster/project2/DIVERGE/input_dir/SNP_Table_for_zeroed_SNPs_analysis.txt --allow-extra-chr --make-bed --out  "$parameterC""$parameterB"_g85

 #Remove individuals below 85% threshold

 ~/bin/plink_linux_x86_64_20231211/plink --bfile "$parameterA""$parameterB"_g85 --mind 0.15 --allow-extra-chr --make-bed --out "$parameterC""$parameterB"_g85_s85

 #Remove SNPs below 90% threshold

 ~/bin/plink_linux_x86_64_20231211/plink --bfile "$parameterA""$parameterB"_g85_s85 --geno 0.1 --allow-extra-chr --make-bed --out "$parameterC""$parameterB"_g90_s85

 #Remove individuals below 90% threshold

 ~/bin/plink_linux_x86_64_20231211/plink --bfile "$parameterA""$parameterB"_g90_s85 --mind 0.1 --allow-extra-chr --make-bed --out "$parameterC""$parameterB"_g90_s90

 #Remove SNPs below 95% threshold

 ~/bin/plink_linux_x86_64_20231211/plink --bfile "$parameterA""$parameterB"_g90_s90 --geno 0.05 --make-bed --allow-extra-chr --out "$parameterC""$parameterB"_g95_s90

 #Remove individuals below 95% threshold

 ~/bin/plink_linux_x86_64_20231211/plink --bfile "$parameterA""$parameterB"_g95_s90 --mind 0.05 --make-bed -allow-extra-chr --out "$parameterC""$parameterB"_g95_s95

