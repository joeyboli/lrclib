# ---- BUILD STAGE ----
# This stage uses a Debian Bookworm based image, which has a newer glibc
FROM rust:1.79-slim as builder
WORKDIR /app
COPY . .
# This compiles your application and links it against the newer glibc
RUN cargo build --release

# ---- FINAL STAGE ----
#
# CHANGE THIS LINE: Use 'bookworm-slim' instead of 'bullseye-slim'
# This ensures your runtime environment has the required glibc version
#
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y sqlite3 curl gzip && rm -rf /var/lib/apt/lists/*
WORKDIR /app

# This copy operation will now work because the glibc versions are compatible
COPY --from=builder /app/target/release/lrclib /app/lrclib

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

VOLUME ["/data"]
EXPOSE 3300
ENTRYPOINT ["/app/entrypoint.sh"]
