#!/usr/bin/env bash
set -euo pipefail

echo "Building Spring Boot JAR"
./gradlew --no-daemon -q bootJar

JAR_PATH="/workspace/build/libs/solr-mcp-server-0.0.1-SNAPSHOT.jar"

if [[ -z "${JAR_PATH}" ]]; then
  echo "ERROR: JAR not found"
  exit 1
fi

echo "▶ Using JAR: ${JAR_PATH}"

echo "▶ Copying JAR to shared volume for Inspector"
mkdir -p /artifacts
cp -f "${JAR_PATH}" /artifacts/solr-mcp-server.jar

echo "Starting Solr MCP Server (stdio)"
java -jar "${JAR_PATH}" --spring.profiles.active=stdio \
  >/tmp/solr-mcp-stdio.log 2>&1 &

echo "All services started"
wait