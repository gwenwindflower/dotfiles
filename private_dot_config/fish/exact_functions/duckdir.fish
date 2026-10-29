function duckdir -d "Open DuckDB with a directory's CSV and Parquet files as tables"
    argparse h/help -- $argv
    or return

    if set -q _flag_help
        echo 'Load CSV and Parquet files into an in-memory DuckDB session.'
        logirl help_usage 'duckdir [OPTIONS] <directory>'
        echo 'Reads the directory directly, without recursing. Table names are file stems.'
        echo 'File stems must be unique (case-insensitive) across both formats.'
        logirl help_header Options
        logirl help_flag h/help 'Show this help message'
        return 0
    end

    if test (count $argv) -ne 1
        logirl error 'Expected one directory; see duckdir --help' >&2
        return 2
    end

    if not test -d "$argv[1]"
        logirl error "Not a directory: $argv[1]" >&2
        return 1
    end

    if not command -q duckdb
        logirl error 'duckdb not found in PATH' >&2
        return 127
    end

    set -l directory (path resolve -- "$argv[1]")
    or return
    set -l files (path filter -f -- "$directory"/*)
    set -l names
    set -l sql

    for file in $files
        string match -rqi '\.(csv|parquet)$' -- "$file"
        or continue

        set -l name (path change-extension '' -- (path basename -- "$file"))
        set -l folded_name (string lower -- "$name")
        if contains -- "$folded_name" $names
            logirl error "Duplicate table name: $name. Give each file a unique stem." >&2
            return 1
        end
        set -a names "$folded_name"

        set -l identifier (string replace -a '"' '""' -- "$name")
        set -l literal (string replace -a "'" "''" -- "$file")
        set -l reader read_csv
        if string match -qi '*.parquet' -- "$file"
            set reader read_parquet
        end
        set -a sql "CREATE TABLE \"$identifier\" AS SELECT * FROM $reader('$literal');"
    end

    if not set -q sql[1]
        logirl error "No CSV or Parquet files found in $directory" >&2
        return 1
    end

    command duckdb :memory: -cmd (string join ' ' -- $sql)
end
