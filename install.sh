#!/bin/bash
set -e
echo "🚀 开始部署 Xray + Argo"

# 加载变量
if [ -f .env ]; then source .env; else echo "❌ 缺少 .env 文件"; exit 1; fi

# 安装 Xray
bash <(curl -Ls https://raw.githubusercontent.com/XTLS/Xray-install/main/install-release.sh)

# 写入 Xray 配置
mkdir -p /usr/local/etc/xray
envsubst < config.json.tpl > /usr/local/etc/xray/config.json

# 重启服务
systemctl restart xray

# 安装 cloudflared
if ! command -v cloudflared &>/dev/null; then
  curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o /usr/local/bin/cloudflared
  chmod +x /usr/local/bin/cloudflared
fi

# 保存 Token 并启动 Argo
mkdir -p /root/.cloudflared
echo "$ARGO_TOKEN" > /root/.cloudflared/argo.json

cp argo.service /etc/systemd/system/argo.service
systemctl daemon-reexec
systemctl enable --now argo

echo "✅ 部署完成！端口：$VM_PORT 域名：$ARGO_DOMAIN"

