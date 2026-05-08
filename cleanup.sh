docker rm -f mhrv-tunnel 2>/dev/null || true
docker rmi ghcr.io/therealaleph/mhrv-tunnel-node:latest 2>/dev/null || true
ufw --force reset && ufw --force disable
echo "✅ پاک شد"
