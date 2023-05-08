-- Active: 1677054367051@@127.0.0.1@5432@postgis_fun

-- select distance between two points
/*

*/

WITH
city1 AS (VALUES ('Durrës')),
country1 AS (VALUES ('AL')),
city2 AS (VALUES ('Tirana')),
country2 AS (VALUES ('AL')),
cte_cities AS (
    SELECT *
    FROM geoname
    WHERE (name = (table city1) AND country = (table country1))
        OR (name = (table city2) AND country = (table country2))
)
SELECT --distance in km
    ct1.name, ct2.name, ct1.country, ct2.country, SQRT(
        POWER(ct1.latitude - ct2.latitude, 2) +
        POWER(ct1.longitude - ct2.longitude, 2)
    ) * 111.045 AS distance,
    ST_DistanceSphere(
        ST_SetSRID(ST_MakePoint(ct1.longitude, ct1.latitude), 4326),
        ST_SetSRID(ST_MakePoint(ct2.longitude, ct2.latitude), 4326)
    ) / 1000 AS distance2
FROM cte_cities ct1
    CROSS JOIN cte_cities ct2
WHERE ct1.geonameid != ct2.geonameid
    AND ct1.name != ct2.name;

-- select other points close to point by amount of kilometers (seq scan)
WITH
city AS (VALUES('Tirana')),
country AS (VALUES('AL')),
distance AS (VALUES(10)),
cte_first_location AS (
    SELECT *
    FROM geoname
    WHERE name = (table city)
        AND country = (table country)
    LIMIT 1
),
cte_close_locations AS (
    SELECT *
    FROM geoname
    WHERE ST_DistanceSphere(
        ST_SetSRID(ST_MakePoint((SELECT longitude FROM cte_first_location), (SELECT latitude FROM cte_first_location)), 4326),
        ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)
    ) / 1000 < (table distance)
)
SELECT *
FROM cte_close_locations;

--
SELECT AddGeometryColumn ('public', 'geoname', 'location', 4326, 'POINT', 2);
UPDATE geoname SET location = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326);

-- select other points close to point by amount of kilometers (parallel seq scan)
WITH
city AS (VALUES('Tirana')),
country AS (VALUES('AL')),
distance AS (VALUES(10)),
cte_first_location AS (
    SELECT *
    FROM geoname
    WHERE name = (table city)
        AND country = (table country)
    LIMIT 1
),
cte_close_locations AS (
    SELECT *
    FROM geoname
    WHERE ST_DistanceSphere(
        ST_SetSRID((SELECT the_geom FROM cte_first_location), 4326),
        ST_SetSRID(the_geom, 4326)
    ) / 1000 < (table distance)
)
SELECT *
FROM cte_close_locations;

-- select other points close to point by amount of kilometers (index scan)
WITH
city AS (VALUES('Tirana')),
country AS (VALUES('AL')),
distance AS (VALUES(1)),
srid AS (VALUES(4326)),
cte_first_location AS (
    SELECT *
    FROM geoname
    WHERE name = (table city)
        AND country = (table country)
    LIMIT 1
)
SELECT gn.name, gn.country, ST_Distance(
        (SELECT the_geom::geography FROM cte_first_location),
        gn.the_geom::geography
    ) / 1000 AS distance
FROM cte_first_location cfl
    INNER JOIN geoname gn ON
        ST_DWithin(
            cfl.the_geom::geography,
            gn.the_geom::geography,
            (table distance) * 1000
        )
WHERE gn.geonameid != cfl.geonameid
LIMIT 1000;

-- add geography column instead of geometry

ALTER TABLE geoname ADD COLUMN the_geog geography(POINT, 4326);
UPDATE geoname SET the_geog = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326);
CREATE INDEX idx_geoname_the_geog ON public.geoname USING gist(the_geog);

WITH
city AS (VALUES('Tirana')),
country AS (VALUES('AL')),
distance AS (VALUES(1)),
srid AS (VALUES(4326)),
cte_first_location AS (
    SELECT *
    FROM geoname
    WHERE name = (table city)
        AND country = (table country)
    LIMIT 1
)
SELECT gn.name, gn.country, ST_Distance(
        (SELECT the_geog FROM cte_first_location),
        gn.the_geog
    ) / 1000 AS distance
FROM cte_first_location cfl
    INNER JOIN geoname gn ON
        ST_DWithin(
            cfl.the_geog,
            gn.the_geog,
            (table distance) * 1000
        )
WHERE gn.geonameid != cfl.geonameid
LIMIT 1000;
