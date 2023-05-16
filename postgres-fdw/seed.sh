#CREATE FIRST INSTANCE WITH ARTISTS
psql postgresql://postgres:postgres@localhost:5432/postgres -c \
    "DROP DATABASE IF EXISTS pg_extension_fun"

psql postgresql://postgres:postgres@localhost:5432/postgres -c \
    "CREATE DATABASE pg_extension_fun"

psql postgresql://postgres:postgres@localhost:5432/pg_extension_fun -c \
    "CREATE EXTENSION postgres_fdw"

psql postgresql://postgres:postgres@localhost:5432/pg_extension_fun -c \
    "CREATE TABLE artists ( \
        id SERIAL PRIMARY KEY, \
        name VARCHAR(255) NOT NULL, \
        country VARCHAR(255) NOT NULL, \
        prominence_year INTEGER NOT NULL, \
        main_genre VARCHAR(255) NOT NULL \
    )"

psql postgresql://postgres:postgres@localhost:5432/pg_extension_fun -c \
    "\copy artists(id, name, country, prominence_year, main_genre) \
    FROM 'artists.txt' (DELIMITER('|'));"



# CREATE SECOND INSTANCE WITH VINYLS

psql postgresql://postgres:postgres@localhost:5433/postgres -c \
    "DROP DATABASE IF EXISTS pg_extension_fun"

psql postgresql://postgres:postgres@localhost:5433/postgres -c \
    "CREATE DATABASE pg_extension_fun"

psql postgresql://postgres:postgres@localhost:5433/pg_extension_fun -c \
    "CREATE EXTENSION postgres_fdw"

psql postgresql://postgres:postgres@localhost:5433/pg_extension_fun -c \
    "CREATE TABLE vinyls ( \
        id SERIAL PRIMARY KEY, \
        title VARCHAR(255) NOT NULL, \
        artist VARCHAR(255) NOT NULL, \
        year INTEGER NOT NULL, \
        duration_minutes INTERVAL NOT NULL, \
        genre VARCHAR(255) NOT NULL \
    )"

psql postgresql://postgres:postgres@localhost:5433/pg_extension_fun -c \
    "\copy vinyls(id, title, artist, year, duration_minutes, genre) \
    FROM 'vinyls.txt' (DELIMITER('|'));"
