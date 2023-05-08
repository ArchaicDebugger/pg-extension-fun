-- Active: 1677054367051@@127.0.0.1@5432@postgis_fun
-- Make sure database is selected
/*
                                                                                                                                                                        1) Earth is not a plane but a sphere
                                                                                                                                                                        2) We don't account for the direction of the points
                                                                                                                                                                        3) Latitude and longitude are not linear units and cannot be converted to meters (or kilometers) without a projection
*/






































-- calculate distance between two points
WITH
city1 AS (VALUES ('Tirana')),
country1 AS (VALUES ('AL')),
city2 AS (VALUES ('Durrës')),
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
    ) * 104 AS distance -- Aka √((x1-x2)^2 + (y1-y2)^2) * 104
FROM cte_cities ct1
    CROSS JOIN cte_cities ct2
WHERE ct1.geonameid != ct2.geonameid
    AND ct1.name != ct2.name;





















-- calculate distance between two points using ST_DistanceSphere
WITH
city1 AS (VALUES ('Tirana')),
country1 AS (VALUES ('AL')),
city2 AS (VALUES ('Durrës')),
country2 AS (VALUES ('AL')),
cte_cities AS (
    SELECT *
    FROM geoname
    WHERE (name = (table city1) AND country = (table country1))
        OR (name = (table city2) AND country = (table country2))
)
SELECT
    ct1.name, ct2.name, ct1.country, ct2.country, SQRT(
        POWER(ct1.latitude - ct2.latitude, 2) +
        POWER(ct1.longitude - ct2.longitude, 2)
    ) * 104 AS distance,
    ST_DistanceSphere(
        ST_SetSRID(ST_MakePoint(ct1.longitude, ct1.latitude), 4326),
        ST_SetSRID(ST_MakePoint(ct2.longitude, ct2.latitude), 4326)
    ) / 1000 AS distance2
FROM cte_cities ct1
    CROSS JOIN cte_cities ct2
WHERE ct1.geonameid != ct2.geonameid
    AND ct1.name != ct2.name;

































-- select other points close to point by amount of kilometers
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
    SELECT *, ST_DistanceSphere(
        ST_SetSRID(ST_MakePoint((SELECT longitude FROM cte_first_location), (SELECT latitude FROM cte_first_location)), 4326),
        ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)
    ) / 1000 AS point_distance
    FROM geoname
    WHERE ST_DistanceSphere(
        ST_SetSRID(ST_MakePoint((SELECT longitude FROM cte_first_location), (SELECT latitude FROM cte_first_location)), 4326),
        ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)
    ) / 1000 < (table distance)
)
SELECT point_distance, *
FROM cte_close_locations
ORDER BY name;































ALTER TABLE geoname ADD COLUMN geolocation GEOGRAPHY(POINT, 4326);
UPDATE geoname SET geolocation = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326);



-- select other points close to point by amount of kilometers via geography column
WITH
city AS (VALUES('Tirana')),
country AS (VALUES('AL')),
distance AS (VALUES(10)),
srid AS (VALUES(4326)),
cte_first_location AS (
    SELECT *
    FROM geoname
    WHERE name = (table city)
        AND country = (table country)
    LIMIT 1
)
SELECT gn.name, gn.country, ST_Distance(
        (SELECT geolocation FROM cte_first_location),
        gn.geolocation
    ) / 1000 AS distance
FROM cte_first_location cfl
    INNER JOIN geoname gn ON
        ST_DWithin(
            cfl.geolocation,
            gn.geolocation,
            (table distance) * 1000
        )
WHERE gn.geonameid != cfl.geonameid;

































-- add a gist index on the geography column
CREATE INDEX idx_geoname_geolocation ON public.geoname USING gist(geolocation);

