FROM rust:1.70 as builder
WORKDIR /app
COPY . .
RUN cargo build --release

FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y sqlite3 curl gzip
WORKDIR /app
COPY --from=builder /app/target/release/lrclib /app/lrclib
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# persistent storage for SQLite
VOLUME ["/data"]

EXPOSE 3300
ENTRYPOINT ["/app/entrypoint.sh"]
