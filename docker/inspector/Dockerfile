# docker/inspector/Dockerfile
FROM eclipse-temurin:25-jre AS jre

FROM node:22-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    socat \
    bash \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Bring Java runtime into this image so Inspector can spawn `java ...`
COPY --from=jre /opt/java/openjdk /opt/java/openjdk
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="/opt/java/openjdk/bin:${PATH}"

ENV NPM_CONFIG_CACHE=/root/.npm

WORKDIR /workspace

COPY docker/inspector/start.sh /start.sh
RUN chmod +x /start.sh

CMD [ "bash", "/start.sh" ]