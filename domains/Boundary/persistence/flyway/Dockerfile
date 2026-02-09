# Dockerfile for Flyway migration container (runs migrations on startup)
FROM flyway/flyway:10-alpine

# Copy migration scripts and config
COPY migrations/sql /flyway/sql
COPY flyway.conf /flyway/conf/flyway.conf

# Entry point runs migrations automatically
ENTRYPOINT ["flyway", "migrate"]