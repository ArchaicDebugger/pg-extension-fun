#connect to postgres
psql postgresql://postgres:postgres@localhost:5432/postgres -c \
    "DROP DATABASE IF EXISTS pg_extension_fun"

psql postgresql://postgres:postgres@localhost:5432/postgres -c \
    "CREATE DATABASE pg_extension_fun"

psql postgresql://postgres:postgres@localhost:5432/pg_extension_fun -c \
    "CREATE EXTENSION postgis"

psql postgresql://postgres:postgres@localhost:5432/pg_extension_fun -c \
    "CREATE TABLE geoname ( \
        geonameid INT, \
        name VARCHAR(200), \
        asciiname VARCHAR(200), \
        alternatenames TEXT, \
        latitude FLOAT, \
        longitude FLOAT, \
        fclass CHAR(1), \
        fcode VARCHAR(10), \
        country VARCHAR(2), \
        cc2 VARCHAR(1000), \
        admin1 VARCHAR(20), \
        admin2 VARCHAR(80), \
        admin3 VARCHAR(20), \
        admin4 VARCHAR(20), \
        population BIGINT, \
        elevation INT, \
        gtopo30 INT, \
        timezone VARCHAR(40), \
        moddate DATE \
    );"

psql postgresql://postgres:postgres@localhost:5432/pg_extension_fun -c \
    "\copy geoname (geonameid, name, asciiname, alternatenames, latitude, longitude, fclass, fcode, \
        country, cc2, admin1, admin2, admin3, admin4, population, elevation, gtopo30, timezone, moddate) \
    FROM 'data/allCountries_no_comments.txt' null AS '' \
    WHERE country IN ('US', 'CA', 'GB', 'IT', 'AL', 'NZ', 'JP', 'BR');"

psql postgresql://postgres:postgres@localhost:5432/pg_extension_fun -c \
    "ALTER TABLE ONLY geoname \
    ADD CONSTRAINT pk_geonameid PRIMARY KEY (geonameid);"
