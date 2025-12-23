FROM eclipse-temurin:25-jdk

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Gradle cache
ENV GRADLE_USER_HOME=/root/.gradle

WORKDIR /workspace