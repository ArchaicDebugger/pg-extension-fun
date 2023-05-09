-- Active: 1677054367051@@127.0.0.1@5432@hall_of_fame@public
-- connect via fdw
CREATE SERVER IF NOT EXISTS vinyl_store
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'postgres_fdw_2', dbname 'vinyl_store', port '5432');

CREATE USER MAPPING FOR postgres
SERVER vinyl_store
OPTIONS (user 'postgres', password 'postgres');

CREATE FOREIGN TABLE IF NOT EXISTS public.vinyls
(
    id integer NOT NULL,
    title varchar(200) NOT NULL,
    artist varchar(200) NOT NULL,
    year integer NOT NULL,
    duration_minutes INTERVAL NOT NULL,
    genre varchar(200) NOT NULL
)
SERVER vinyl_store
OPTIONS (schema_name 'public', table_name 'vinyls');

SELECT *
FROM artists
    INNER JOIN public.vinyls v ON artists.name = v.artist;

SELECT artists.name, COUNT(*) AS vinyls
FROM artists
    INNER JOIN public.vinyls v ON artists.name = v.artist
GROUP BY artists.name
ORDER BY vinyls DESC;

SELECT artists.name
FROM artists
WHERE name NOT IN (
    SELECT v.artist
    FROM public.vinyls v
);

SELECT COUNT(1)
FROM artists
WHERE name NOT IN (
    SELECT v.artist
    FROM public.vinyls v
);

INSERT INTO public.vinyls (id, title, artist, year, duration_minutes, genre)
VALUES (80, 'In Between Dreams', 'Jack Johnson', 2005, '38:43', 'Acoustic')
