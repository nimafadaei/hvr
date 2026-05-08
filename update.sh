#!/bin/bash
PORT="8080"; AUTH="c1be7329-63f5-404d-9564-3e48cdcc453d"
echo "▶ آپدیت mhrv-tunnel..."
docker pull ghcr.io/therealaleph/mhrv-tunnel-node:latest
docker rm -f mhrv-tunnel 2>/dev/null || true
docker run -d --name mhrv-tunnel --restart always \
  -p ${PORT}:${PORT} -e PORT=${PORT} \
  -e TUNNEL_AUTH_KEY="${AUTH}" \
  ghcr.io/therealaleph/mhrv-tunnel-node:latest
sleep 5
H=$(curl -sf http://localhost:${PORT}/health 2>/dev/null)
[ "$H" = "ok" ] && echo "✅ آپدیت موفق" || echo "❌ بزن: docker logs mhrv-tunnel"
