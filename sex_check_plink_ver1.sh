#####################################################
#Sex Check PLINK
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

#Run X-chromosome based sex check

~/bin/plink_linux_x86_64_20231211/plink --bfile "$parameterA""$parameterB"_g95_s95 --check-sex 0.6 0.9 --allow-extra-chr --out  "$parameterC""$parameterB"_x_based

 #Remove individuals below 85% threshold

 ~/bin/plink_linux_x86_64_20231211/plink --bfile "$parameterA""$parameterB"_g95_s95 --check-sex ycount --allow-extra-chr --out "$parameterC""$parameterB"_y_based

