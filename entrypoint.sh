#!/bin/sh
set -e

DB_PATH="/data/db.sqlite3"
DUMP_URL="https://db-dumps.lrclib.net/lrclib-db-dump-20250914T143808Z.sqlite3.gz"

echo "[lrclib] Checking DB file: $DB_PATH"
ls -l /data || echo "[lrclib] /data directory does not exist!"

if [ ! -f "$DB_PATH" ]; then
  echo "[lrclib] No database found, downloading initial dump..."
  
  curl -L -# "$DUMP_URL" -o /tmp/dump.sqlite3.gz \
    --write-out "\n[lrclib] Downloaded %{size_download} bytes in %{time_total}s (avg %{speed_download} bytes/sec)\n"

  echo "[lrclib] Extracting database..."
  gunzip -c /tmp/dump.sqlite3.gz > "$DB_PATH"
  rm /tmp/dump.sqlite3.gz

  echo "[lrclib] Database initialized."
else
  echo "[lrclib] Database already exists, skipping download."
fi

ls -l "$DB_PATH" || echo "[lrclib] DB file was not created!"

exec ./lrclib serve --database "$DB_PATH"
