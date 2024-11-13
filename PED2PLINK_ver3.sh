

#data="plink_output_freeze1_final_3"

#path="/cluster/project2/DIVERGE/QC_dir/"

#input_dir="/cluster/project2/DIVERGE/input_dir/"

#awk '/111-002131/ {print NR}'  plink_output_freeze1_final_3.ped > search_two.txt

#~/bin/plink_linux_x86_64_20231211/plink --file ${input_dir}${data} --allow-extra-chr --make-bed --out ${path}${data}_pre


helpFunction()
{
   echo ""
   echo "Usage: $0 -a parameterA -b parameterB -c parameterC"
   echo -e "\t-a Path to File Dir"
   echo -e "\t-b Name of the File"
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

~/bin/plink_linux_x86_64_20231211/plink --file "$parameterA""$parameterB" --allow-extra-chr --make-bed --out "$parameterC""$parameterB"
