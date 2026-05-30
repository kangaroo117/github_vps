#!/bin/bash
# 关闭严格模式，防止因为微小的警告导致整个脚本退出
set +e

echo "Starting environment initialization..."

# 1. 强制清理任何可能的残留锁文件
vncserver -kill :1 > /dev/null 2>&1
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1

# 2. 启动底层的 VNC 桌面
vncserver :1 -geometry 1920x1080 -depth 24 -SecurityTypes None

# 给 VNC 留出 2 秒钟的启动缓冲时间
sleep 2

# 3. 在后台启动 noVNC 网页代理，并输出日志
nohup /opt/novnc/utils/novnc_proxy --vnc localhost:5901 --listen 6080 > /tmp/novnc.log 2>&1 &

# 等待 noVNC 启动完成
sleep 2

echo "Initialization complete!"
