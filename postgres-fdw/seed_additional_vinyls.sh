psql postgresql://postgres:postgres@localhost:5433/vinyl_store -c \
    "\copy vinyls(id, title, artist, year, duration_minutes, genre) \
    FROM 'vinyls2.txt' (DELIMITER('|'));"
