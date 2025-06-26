{
  "inbounds": [{
    "port": ${VM_PORT},
    "protocol": "vmess",
    "settings": {
      "clients": [{
        "id": "$(uuidgen)",
        "alterId": 0
      }]
    },
    "streamSettings": {
      "network": "ws",
      "wsSettings": {
        "path": "/websocket"
      }
    }
  }],
  "outbounds": [{ "protocol": "freedom" }]
}
