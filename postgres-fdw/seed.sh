#connect to postgres
psql postgresql://postgres:postgres@localhost:5432/postgres -c \
    "DROP DATABASE IF EXISTS hall_of_fame"

psql postgresql://postgres:postgres@localhost:5432/postgres -c \
    "CREATE DATABASE hall_of_fame"

psql postgresql://postgres:postgres@localhost:5432/hall_of_fame -c \
    "CREATE EXTENSION postgres_fdw"

psql postgresql://postgres:postgres@localhost:5432/hall_of_fame -c \
    "CREATE TABLE artists ( \
        id SERIAL PRIMARY KEY, \
        name VARCHAR(255) NOT NULL, \
        country VARCHAR(255) NOT NULL, \
        prominence_year INTEGER NOT NULL, \
        main_genre VARCHAR(255) NOT NULL \
    )"

psql postgresql://postgres:postgres@localhost:5432/hall_of_fame -c \
    "\copy artists(id, name, country, prominence_year, main_genre) \
    FROM 'artists.txt' (DELIMITER('|'));"

psql postgresql://postgres:postgres@localhost:5433/postgres -c \
    "DROP DATABASE IF EXISTS vinyl_store"

psql postgresql://postgres:postgres@localhost:5433/postgres -c \
    "CREATE DATABASE vinyl_store"

psql postgresql://postgres:postgres@localhost:5433/vinyl_store -c \
    "CREATE EXTENSION postgres_fdw"

psql postgresql://postgres:postgres@localhost:5433/vinyl_store -c \
    "CREATE TABLE vinyls ( \
        id SERIAL PRIMARY KEY, \
        title VARCHAR(255) NOT NULL, \
        artist VARCHAR(255) NOT NULL, \
        year INTEGER NOT NULL, \
        duration_minutes INTERVAL NOT NULL, \
        genre VARCHAR(255) NOT NULL \
    )"

psql postgresql://postgres:postgres@localhost:5433/vinyl_store -c \
    "\copy vinyls(id, title, artist, year, duration_minutes, genre) \
    FROM 'vinyls.txt' (DELIMITER('|'));"
