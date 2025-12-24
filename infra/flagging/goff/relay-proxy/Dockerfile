# infra/flagging/goff/relay-proxy/Dockerfile
FROM gofeatureflag/go-feature-flag:latest

# Copy provider-specific config only (for build-time fallback; runtime mount overrides)
COPY ./infra/flagging/goff/goff-proxy.yaml /etc/opt/goff/goff-proxy.yaml
COPY ./infra/config/goff/flags.goff.yaml /goff/flags.goff.yaml

ENV GOFF_CONFIG_FILE=/etc/opt/goff/goff-proxy.yaml
ENV LOGLEVEL=debug

EXPOSE 8013  
#Match your docker-compose port

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q --spider http://localhost:8013/health || exit 1