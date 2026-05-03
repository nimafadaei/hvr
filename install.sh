#!/bin/bash
IP="104.234.138.28"; PORT="8080"; SSH_PORT="22"; AUTH="c1be7329-63f5-404d-9564-3e48cdcc453d"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  mhrv-rs Tunnel Node Setup v1.9.4"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "▶ [1/5] آماده‌سازی..."
export DEBIAN_FRONTEND=noninteractive
dpkg --configure -a 2>/dev/null || true
apt-get -f install -y -q 2>/dev/null || true
apt update -y -q || true
echo "▶ [2/5] نصب Docker..."
apt install -y docker.io curl ufw || apt install -y docker.io curl ufw
systemctl enable docker --now 2>/dev/null || true
if ! command -v docker &>/dev/null; then
  echo "⚠️ Docker نصب نشد — دستور زیر رو جداگانه بزن:"
  echo "   apt install -y docker.io"
  echo "   بعد دوباره install.sh رو بزن"
else
  echo "✅ Docker آماده"
  echo "▶ [3/5] Firewall..."
  ufw --force reset 2>/dev/null || true
  ufw default deny incoming 2>/dev/null || true
  ufw default allow outgoing 2>/dev/null || true
  ufw allow ${SSH_PORT}/tcp 2>/dev/null || true
  ufw allow ${PORT}/tcp 2>/dev/null || true
  ufw --force enable 2>/dev/null || true
  echo "✅ پورت ${SSH_PORT}(SSH) و ${PORT}(Tunnel) باز شدن"
  echo "▶ [4/5] راه‌اندازی mhrv-tunnel..."
  docker rm -f mhrv-tunnel 2>/dev/null || true
  docker pull ghcr.io/therealaleph/mhrv-tunnel-node:latest
  docker run -d --name mhrv-tunnel --restart always \
    -p ${PORT}:${PORT} -e PORT=${PORT} \
    -e TUNNEL_AUTH_KEY="${AUTH}" \
    ghcr.io/therealaleph/mhrv-tunnel-node:latest
  echo "▶ [5/5] چک سلامت..."
  sleep 6
  H=$(curl -sf http://localhost:${PORT}/health 2>/dev/null)
  if [ "$H" = "ok" ]; then
    PIP=$(curl -4s ifconfig.me 2>/dev/null)
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ نصب موفق!"
    echo "URL : http://${PIP}:${PORT}"
    echo "KEY : ${AUTH}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  else
    echo "❌ خطا — بزن: docker logs mhrv-tunnel"
  fi
fi
