psql postgresql://postgres:postgres@localhost:5433/pg_extension_fun -c \
    "CREATE INDEX vinyls_artist_idx ON vinyls(artist);"
