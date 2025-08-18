FROM rust:1.79-slim as builder
WORKDIR /app
COPY . .
RUN cargo build --release

FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y sqlite3 curl gzip && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=builder /app/target/release/lrclib /app/lrclib
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

VOLUME ["/data"]
EXPOSE 3300
ENTRYPOINT ["/app/entrypoint.sh"]
