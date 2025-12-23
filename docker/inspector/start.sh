# docker/inspector/start.sh
#!/usr/bin/env bash
set -euo pipefail

echo "Starting MCP Inspector (binds to localhost inside container)"
# npx -y @modelcontextprotocol/inspector > /tmp/mcp-inspector.log 2>&1 &
npx -y @modelcontextprotocol/inspector &

echo "Exposing Inspector ports via socat"
# Expose container ports 6278/6279 (0.0.0.0) -> inspector localhost ports 6274/6277
socat TCP-LISTEN:6278,fork,reuseaddr TCP:127.0.0.1:6274 >/tmp/socat-6278.log 2>&1 &
socat TCP-LISTEN:6279,fork,reuseaddr TCP:127.0.0.1:6277 >/tmp/socat-6279.log 2>&1 &

echo "▶ Inspector is running"
wait