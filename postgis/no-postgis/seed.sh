#connect to postgres
# psql postgresql://postgres:postgres@localhost:5432/postgres -c "DROP DATABASE IF EXISTS postgis_fun"
# psql postgresql://postgres:postgres@localhost:5432/postgres -c "CREATE DATABASE postgis_fun"
# psql postgresql://postgres:postgres@localhost:5432/postgis_fun -c "CREATE EXTENSION postgis"
# psql postgresql://postgres:postgres@localhost:5432/postgis_fun -f ./scripts.sql

# psql postgresql://postgres:postgres@localhost:5432/postgis_fun -c "\copy geoname (geonameid,name,asciiname,alternatenames,latitude,longitude,fclass,fcode,country,cc2,admin1,admin2,admin3,admin4,population,elevation,gtopo30,timezone,moddate) from 'data/allCountries_no_comments.txt' null as '';"
# psql postgresql://postgres:postgres@localhost:5432/postgis_fun -c "\copy alternatename  (alternatenameid,geonameid,isolanguage,alternatename,ispreferredname,isshortname,iscolloquial,ishistoric) from 'data/alternateNames_no_comments.txt' null as '';"
# psql postgresql://postgres:postgres@localhost:5432/postgis_fun -c "\copy countryinfo (iso_alpha2,iso_alpha3,iso_numeric,fips_code,name,capital,areainsqkm,population,continent,tld,currencycode,currencyname,phone,postalcode,postalcoderegex,languages,geonameid,neighbors,equivfipscode) from 'data/countryInfo_no_comments.txt' null as '';"

psql postgresql://postgres:postgres@localhost:5432/postgis_fun -f ./alter-tables.sql
