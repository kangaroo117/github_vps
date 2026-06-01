#!/bin/bash
set -e

# ==================== 【最核心的修复】 ====================
# 屏蔽 SIGHUP 信号！
# 这样当 Codespaces 脚本执行完毕并关闭时，Xvnc 就不会收到挂断信号，
# 也就不去触发那个要命的 Reset 操作了。
trap '' HUP

VNC_PASSWORD="${VNC_PASSWORD:-vscode}"
VNC_DIR="/home/vscode/.vnc"
PASSWD_FILE="$VNC_DIR/passwd"

echo "Starting environment initialization..."

# 清理旧日志，保持排障清晰
rm -f "$VNC_DIR"/*.log /tmp/novnc.log

echo "Using VNC password: ${VNC_PASSWORD}"

mkdir -p "$VNC_DIR"

# 写入 xstartup（保留死循环保活策略）
cat > "$VNC_DIR/xstartup" <<'EOF'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey

# 让 fluxbox 在后台运行
fluxbox &

# 强行挂起，永远不退出
tail -f /dev/null
EOF
chmod +x "$VNC_DIR/xstartup"

printf '%s\n%s\n' "$VNC_PASSWORD" "$VNC_PASSWORD" | vncpasswd -f > "$PASSWD_FILE"
chmod 600 "$PASSWD_FILE"

# 1. 强制清理残留锁文件
vncserver -kill :1 > /dev/null 2>&1 || true
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1

# 2. 启动底层的 VNC 桌面（加上 -noreset 做双重保险）
vncserver :1 -geometry 1920x1080 -depth 24 -noreset

# 给 VNC 留出 2 秒钟的启动缓冲时间
sleep 2

# 3. 启动 noVNC，强制使用 127.0.0.1 规避 IPv6 解析坑
nohup /opt/novnc/utils/novnc_proxy --vnc 127.0.0.1:5901 --listen 6080 > /tmp/novnc.log 2>&1 &

# 等待 noVNC 启动完成
sleep 2

echo "Initialization complete! Ready to connect via port 6080."