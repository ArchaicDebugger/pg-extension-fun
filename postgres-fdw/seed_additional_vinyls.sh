psql postgresql://postgres:postgres@localhost:5433/pg_extension_fun -c \
    "\copy vinyls(id, title, artist, year, duration_minutes, genre) \
    FROM 'vinyls2.txt' (DELIMITER('|'));"
