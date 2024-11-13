#####################################################
#Sex Mismatch and Aneuploidy Removal
#####################################################


helpFunction()
{
   echo ""
   echo "Usage: $0 -a parameterA -b parameterB -c parameterC  -d parameterD"
   echo -e "\t-a Path to File Dir"
   echo -e "\t-b Name of the Plink File to process"
   echo -e "\t-c Path Report Dir"
   echo -e "\t-d Path to file"
   exit 1 # Exit script after printing help
}

while getopts "a:b:c:" opt
do
   case "$opt" in
      a ) parameterA="$OPTARG" ;;
      b ) parameterB="$OPTARG" ;;
      c ) parameterC="$OPTARG" ;;
      d ) parameterD="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Begin script in case all parameters are correct
echo "$parameterA"
echo "$parameterB"
echo "$parameterC"
echo "$parameterD"

# Print helpFunction in case parameters are empty
if [ -z "$parameterA" ] || [ -z "$parameterB" ] || [ -z "$parameterC" ] || [ -z "$parameterD" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct

#Remove SNPs below 85% threshold

~/bin/plink_linux_x86_64_20231211/plink --bfile "$parameterA""$parameterB" --remove "$parameterC""parameterD" --allow-extra-chr --make-bed --out  "$parameterA""$parameterB"_g95_s95_sex_clean

 
