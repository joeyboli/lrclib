#!/bin/sh
set -e

DB_PATH="/data/db.sqlite3"
DUMP_URL="https://db-dumps.lrclib.net/lrclib-db-dump-20250812T075019Z.sqlite3.gz"

if [ ! -f "$DB_PATH" ]; then
  echo "No database found, downloading initial dump..."
  curl -L --progress-bar "$DUMP_URL" | gunzip > "$DB_PATH"
  echo "Database initialized."
else
  echo "Database already exists, skipping download."
fi

# Run lrclib
exec ./lrclib serve --database "$DB_PATH"
