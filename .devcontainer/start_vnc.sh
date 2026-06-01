#!/bin/bash
set -e

VNC_PASSWORD="${VNC_PASSWORD:-vscode}"
VNC_DIR="/home/vscode/.vnc"
PASSWD_FILE="$VNC_DIR/passwd"

echo "Starting environment initialization..."

echo "Using VNC password: ${VNC_PASSWORD}"

mkdir -p "$VNC_DIR"

# ==================== 【修改点 1】 ====================
# 去掉 fluxbox 后面的 &，改用 exec 阻塞运行，并清理环境变量。
# 这样可以保证 xstartup 脚本不会提前退出，从而维持 VNC 进程。
cat > "$VNC_DIR/xstartup" <<'EOF'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey

exec fluxbox
EOF
chmod +x "$VNC_DIR/xstartup"

printf '%s\n%s\n' "$VNC_PASSWORD" "$VNC_PASSWORD" | vncpasswd -f > "$PASSWD_FILE"
chmod 600 "$PASSWD_FILE"

# 1. 强制清理任何可能的残留锁文件
vncserver -kill :1 > /dev/null 2>&1 || true
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1

# 2. 启动底层的 VNC 桌面
# ==================== 【修改点 2】 ====================
# 在末尾添加 -noreset 参数，显式告诉 Xvnc 忽略重置信号，防止意外终止进程。
vncserver :1 -geometry 1920x1080 -depth 24 -noreset

# 给 VNC 留出 2 秒钟的启动缓冲时间
sleep 2

# 3. 在后台启动 noVNC 网页代理，并输出日志
nohup /opt/novnc/utils/novnc_proxy --vnc localhost:5901 --listen 6080 > /tmp/novnc.log 2>&1 &

# 等待 noVNC 启动完成
sleep 2

echo "Initialization complete!"