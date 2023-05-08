create table geoname (
	geonameid	int,
	name varchar(200),
	asciiname varchar(200),
	alternatenames text,
	latitude float,
	longitude float,
	fclass char(1),
	fcode varchar(10),
	country varchar(2),
	cc2 varchar(1000),
	admin1 varchar(20),
	admin2 varchar(80),
	admin3 varchar(20),
	admin4 varchar(20),
	population bigint,
	elevation int,
	gtopo30 int,
	timezone varchar(40),
	moddate date
 );

 create table alternatename (
	alternatenameId int,
	geonameid int,
	isoLanguage varchar(7),
	alternateName varchar(200),
	isPreferredName boolean,
	isShortName boolean,
	isColloquial boolean,
	isHistoric boolean
 );

 create table "countryinfo" (
	iso_alpha2 char(1000),
	iso_alpha3 char(1000),
	iso_numeric integer,
	fips_code varchar(3),
	name varchar(200),
	capital varchar(200),
	areainsqkm double precision,
	population integer,
	continent varchar(2),
	tld varchar(10),
	currencycode varchar(3),
	currencyname varchar(20),
	phone varchar(20),
	postalcode varchar(100),
	postalcoderegex varchar(200),
  languages varchar(200),
  geonameId int,
	neighbors varchar(50),
	equivfipscode varchar(3)
);

-- copy geoname (geonameid,name,asciiname,alternatenames,latitude,longitude,fclass,fcode,country,cc2,admin1,admin2,admin3,admin4,population,elevation,gtopo30,timezone,moddate) from 'data/allCountries.txt' null as '';
-- copy alternatename  (alternatenameid,geonameid,isolanguage,alternatename,ispreferredname,isshortname,iscolloquial,ishistoric) from 'data/alternateNames.txt' null as '';
-- copy countryinfo (iso_alpha2,iso_alpha3,iso_numeric,fips_code,name,capital,areainsqkm,population,continent,tld,currencycode,currencyname,phone,postalcode,postalcoderegex,languages,geonameid,neighbors,equivfipscode) from 'data/countryInfo.txt' null as '';

-- ALTER TABLE ONLY alternatename
--       ADD CONSTRAINT pk_alternatenameid PRIMARY KEY (alternatenameid);
-- ALTER TABLE ONLY geoname
--       ADD CONSTRAINT pk_geonameid PRIMARY KEY (geonameid);
-- ALTER TABLE ONLY countryinfo
--       ADD CONSTRAINT pk_iso_alpha2 PRIMARY KEY (iso_alpha2);

-- ALTER TABLE ONLY countryinfo
--       ADD CONSTRAINT fk_geonameid FOREIGN KEY (geonameid) REFERENCES geoname(geonameid);
-- ALTER TABLE ONLY alternatename
--       ADD CONSTRAINT fk_geonameid FOREIGN KEY (geonameid) REFERENCES geoname(geonameid);

-- SELECT AddGeometryColumn ('public','geoname','the_geom',4326,'POINT',2);

-- UPDATE geoname SET the_geom = ST_PointFromText('POINT(' || longitude || ' ' || latitude || ')', 4326);

-- CREATE INDEX idx_geoname_the_geom ON public.geoname USING gist(the_geom);
