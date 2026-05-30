#!/bin/bash
set +e

echo "Starting environment initialization..."

# 1. 清理进程
pkill -9 -f novnc || true
pkill -9 -f websockify || true
vncserver -kill :1 > /dev/null 2>&1
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1

# 2. 启动 VNC 桌面（绑定到本地）
vncserver :1 -geometry 1920x1080 -depth 24 -localhost yes -SecurityTypes None

sleep 2

# 3. 启动 noVNC 代理（关键：不强制绑定 0.0.0.0，顺应 Codespace 网关要求）
nohup /opt/novnc/utils/novnc_proxy --vnc localhost:5901 --listen 6080 > /tmp/novnc.log 2>&1 &

echo "Initialization complete!"
