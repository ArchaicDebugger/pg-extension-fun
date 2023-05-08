#read the --skip-download option from the command line
skip_download=false
while [ $# -gt 0 ]; do
 case "$1" in
   --skip-download) skip_download=true ;;
 esac
 shift
done

mkdir -p data
cd data

#download the world data, only if requested
if [ "$skip_download" = false ] ; then
    echo "Downloading world data..."
    wget http://download.geonames.org/export/dump/allCountries.zip
else
    echo "Skipping download of world data, using existing files..."
fi

#unzip the world data, overwriting any existing files
unzip -o allCountries.zip

#remove the comments from the world data
rm -f allCountries_no_comments.txt
grep -v '^#' allCountries.txt > allCountries_no_comments.txt
