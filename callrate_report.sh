#####################################################
#SNPs and Sample callrate report
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

echo "SNPs excluded" > "$parameterC"SNP_excluded.txt
echo "Geno 85%" >> "$parameterC"SNP_excluded.txt | wc -l "$parameterA""$parameterB"_g85.hh >> "$parameterC"SNP_excluded.txt
echo "Geno 90%" >> "$parameterC"SNP_excluded.txt | wc -l "$parameterA""$parameterB"_g90_s85.hh >> "$parameterC"SNP_excluded.txt
echo "Geno 95%" >> "$parameterC"SNP_excluded.txt | wc -l "$parameterA""$parameterB"_g95_s90.hh >> "$parameterC"SNP_excluded.txt

echo "Samples excluded" > "$parameterC"Samples_excluded.txt
echo "Sample 85%" >> "$parameterC"Samples_excluded.txt | wc -l "$parameterA""$parameterB"_g85_s85.irem >> "$parameterC"Samples_excluded.txt
echo "Sample 90%" >> "$parameterC"Samples_excluded.txt | wc -l "$parameterA""$parameterB"_g90_s90.irem >> "$parameterC"Samples_excluded.txt
echo "Sample 95%" >> "$parameterC"Samples_excluded.txt | wc -l "$parameterA""$parameterB"_g95_s95.irem >> "$parameterC"Samples_excluded.txt

#######################################################
############# Remove intermediate checks ##############
#######################################################

rm "$parameterA"*_s85.bed
rm "$parameterA"*_s85.bim
rm "$parameterA"*_s85.fam

rm "$parameterA"*_s90.bed
rm "$parameterA"*_s90.bim
rm "$parameterA"*_s90.fam
