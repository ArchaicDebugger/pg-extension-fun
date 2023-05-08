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
    wget http://download.geonames.org/export/dump/alternateNames.zip
    wget http://download.geonames.org/export/dump/countryInfo.txt
    wget http://download.geonames.org/export/dump/iso-languagecodes.txt
else
    echo "Skipping download of world data, using existing files..."
fi

#unzip the world data, overwriting any existing files
unzip -o allCountries.zip
unzip -o alternateNames.zip

#remove the comments from the world data
rm -f allCountries_no_comments.txt
rm -f alternateNames_no_comments.txt
rm -f countryInfo_no_comments.txt
rm -f iso-languagecodes_no_comments.txt

grep -v '^#' allCountries.txt > allCountries_no_comments.txt
grep -v '^#' alternateNames.txt > alternateNames_no_comments.txt
grep -v '^#' countryInfo.txt > countryInfo_no_comments.txt
grep -v '^#' iso-languagecodes.txt > iso-languagecodes_no_comments.txt
