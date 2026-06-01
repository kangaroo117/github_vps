#!/bin/bash
# 诊断和修复6080端口502错误的脚本

set -e

VNC_PASSWORD="${VNC_PASSWORD:-vscode}"
VNC_DIR="/home/vscode/.vnc"
PASSWD_FILE="$VNC_DIR/passwd"

echo "======================================"
echo "6080 noVNC 诊断和修复脚本"
echo "======================================"
echo ""

echo "📦 检查 numpy 依赖..."
if python3 -c "import numpy" 2>/dev/null; then
    echo "✅ numpy 已安装"
else
    echo "❌ numpy 未安装，正在安装..."
    pip3 install --user numpy
    echo "✅ numpy 安装完成"
fi
echo ""

echo "🖥️  检查 VNC 服务..."
if pgrep -f "vncserver|Xvnc|Xtigervnc" > /dev/null; then
    echo "✅ VNC 服务正在运行"
else
    echo "⚠️  VNC 服务未运行，正在启动..."
    mkdir -p "$VNC_DIR"
    printf '%s\n%s\n' "$VNC_PASSWORD" "$VNC_PASSWORD" | vncpasswd -f > "$PASSWD_FILE"
    chmod 600 "$PASSWD_FILE"
    vncserver :1 -geometry 1920x1080 -depth 24
    sleep 2
    echo "✅ VNC 服务已启动"
fi
echo ""

echo "🌐 检查 noVNC 代理..."
if pgrep -f "novnc_proxy" > /dev/null; then
    echo "✅ noVNC 代理正在运行"
else
    echo "⚠️  noVNC 代理未运行，正在启动..."
    nohup /opt/novnc/utils/novnc_proxy --vnc localhost:5901 --listen 6080 > /tmp/novnc.log 2>&1 &
    sleep 2
    echo "✅ noVNC 代理已启动"
fi
echo ""

echo "🧪 测试 6080 端口..."
if curl -s http://localhost:6080/vnc.html > /dev/null 2>&1; then
    echo "✅ 6080 端口可访问"
else
    echo "❌ 6080 端口无法访问"
    echo "📋 noVNC 日志："
    tail -20 /tmp/novnc.log
    exit 1
fi
echo ""

echo "======================================"
echo "✅ 诊断完成，所有服务正常"
echo "======================================"
echo ""
echo "📌 访问地址: http://localhost:6080/vnc.html"
echo "或使用公网IP: http://<your-ip>:6080/vnc.html"
