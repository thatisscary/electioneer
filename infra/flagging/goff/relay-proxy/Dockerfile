# infra/flagging/goff/relay-proxy/Dockerfile
FROM gofeatureflag/go-feature-flag:latest

# Copy provider-specific config only
COPY ../goff-proxy.yaml /app/goff-proxy.yaml
COPY ../../helm/config/_goff.tpl /app/flags.yaml

ENV GOFF_CONFIG_FILE=/app/goff-proxy.yaml

EXPOSE 1031

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q --spider http://localhost:1031/health || exit 1

ENTRYPOINT ["/go-feature-flag"]
CMD ["--config", "/app/goff-proxy.yaml"]
