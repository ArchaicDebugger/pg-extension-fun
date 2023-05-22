psql postgresql://postgres:postgres@localhost:5432/postgres -c \
    "DROP DATABASE IF EXISTS pg_extension_fun;"

psql postgresql://postgres:postgres@localhost:5432/postgres -c \
    "CREATE DATABASE pg_extension_fun;"

psql postgresql://postgres:postgres@localhost:5432/pg_extension_fun -c \
    "CREATE EXTENSION IF NOT EXISTS timescaledb;"

psql postgresql://postgres:postgres@localhost:5432/pg_extension_fun -c \
    "CREATE TABLE hello_world_entries ( \
        time TIMESTAMPTZ NOT NULL, \
        language VARCHAR(255) NOT NULL \
    );"

psql postgresql://postgres:postgres@localhost:5432/pg_extension_fun -c \
    "SELECT create_hypertable('hello_world_entries', 'time', chunk_time_interval => interval '1 year');"

sql="INSERT INTO hello_world_entries (time, language) VALUES "
languages=("C", "C++", "C#", "Java", "COBOL", "FORTRAN", "Smalltalk", "Python", "Ruby", "Perl", "PHP", "JavaScript", "TypeScript", "Go", "Rust", "Haskell", "Scala", "Clojure", "Erlang", "Elixir", "Kotlin", "Swift", "Objective-C", "R", "Julia", "Dart", "Lua", "SQL", "PL/SQL", "T-SQL", "Pascal", "Ada", "Lisp", "Scheme", "Prolog", "BASIC", "Visual Basic", "VBScript", "ActionScript", "Delphi", "RPG", "ABAP", "F#", "Groovy", "COBOL", "D", "Forth", "Fortran", "FoxPro", "LabVIEW", "Logo", "MATLAB", "ML", "Objective-C", "OCaml", "Pascal", "Perl", "PL/1", "PostScript", "RPG", "Ruby", "SAS", "Scratch", "Simula", "Smalltalk", "SQL", "Swift", "Tcl", "Visual Basic", "Visual FoxPro", "Wolfram", "Alpha", "ZPL", "ZPL2", "Z++", "Zeno", "ZetaLisp", "ZOPL", "Zsh", "ZPL", "ZPL2", "Z++", "Zeno", "ZetaLisp", "ZOPL", "Zsh", "ZPL", "ZPL2", "Z++", "Zeno", "ZetaLisp", "ZOPL", "Zsh", "ZPL", "ZPL2", "Z++", "Zeno", "ZetaLisp", "ZOPL", "Zsh", "ZPL", "ZPL2", "Z++", "Zeno", "ZetaLisp", "ZOPL", "Zsh", "ZPL", "ZPL2", "Z++", "Zeno", "ZetaLisp", "ZOPL", "Zsh", "ZPL", "ZPL2", "Z++", "Zeno", "ZetaLisp", "ZOPL", "Zsh", "ZPL", "ZPL2", "Z++", "Zeno", "ZetaLisp", "ZOPL", "Zsh")

#randomly generate 10,000,000 rows
for iteration in {1..10000}
do
    echo $iteration
    for i in {1..1000}
    do
        language=${languages[$RANDOM % ${#languages[@]} ]}
        sql+="(timestamp '1960-01-01 00:00:00' +
                random() * (timestamp '2023-01-01 00:00:00' -
                    timestamp '1960-01-01 00:00:00'), '$language')"

        if [ $i -ne 1000 ]
        then
            sql+=","
        fi
    done


    psql postgresql://postgres:postgres@localhost:5432/pg_extension_fun -c \
        "$sql;" &

    sql="INSERT INTO hello_world_entries (time, language) VALUES "
done
