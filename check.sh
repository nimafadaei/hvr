#!/bin/bash
PORT="8080"
echo "━━━━━━ وضعیت mhrv-tunnel ━━━━━━"
docker ps --filter name=mhrv-tunnel --format "Status: {{.Status}}"
H=$(curl -sf http://localhost:${PORT}/health 2>/dev/null)
[ "$H" = "ok" ] && echo "Health: ✅ OK" || echo "Health: ❌ DOWN"
echo "--- آخرین لاگ ---"
docker logs --tail 20 mhrv-tunnel 2>&1
