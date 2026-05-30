# 6080 端口 502 错误解决方案

## 问题描述

访问 `http://localhost:6080` 时出现 **502 Bad Gateway** 错误。

## 根本原因

`websockify`（noVNC 的 WebSocket 代理）缺少 `numpy` 依赖库，导致：
- WebSocket 连接处理缓慢或失败
- 代理无法正确转发连接到后端 VNC 服务（port 5901）
- 返回 502 错误

## 快速修复

### 方法 1：运行诊断脚本（推荐）

```bash
bash .devcontainer/fix_6080.sh
```

### 方法 2：手动安装 numpy

```bash
pip3 install --user numpy
```

### 方法 3：重启 VNC 服务

```bash
# 停止所有 VNC 相关进程
pkill -f vncserver
pkill -f novnc_proxy

# 重启
bash .devcontainer/start_vnc.sh
```

## 验证修复

访问以下地址，如果能加载 noVNC 界面则表示成功：

```
http://localhost:6080/vnc.html
```

## 为什么会出现这个问题？

- 环境中 Python 3.6 版本的 pip 默认没有安装 `numpy`
- `websockify` 虽然可以不用 numpy 运行，但性能会下降，在某些连接条件下可能失败
- 原始 Dockerfile 中未明确安装 numpy

## 永久解决方案

已更新 Dockerfile，新镜像构建时会自动安装 numpy：

```dockerfile
# 安装 numpy 以优化 websockify 性能
RUN pip3 install numpy
```

## 访问 noVNC

修复后访问地址：

| 环境 | 地址 |
|------|------|
| 本地 | http://localhost:6080/vnc.html |
| 远程 | http://&lt;your-ip&gt;:6080/vnc.html |

## 故障排查

如果仍然出现 502 错误：

1. **检查 VNC 服务是否运行**
   ```bash
   ps aux | grep vncserver
   ```

2. **查看 noVNC 日志**
   ```bash
   tail -f /tmp/novnc.log
   ```

3. **手动重启所有服务**
   ```bash
   bash .devcontainer/fix_6080.sh
   ```

## 相关文件

- [start_vnc.sh](.devcontainer/start_vnc.sh) - VNC 启动脚本
- [fix_6080.sh](.devcontainer/fix_6080.sh) - 诊断和修复脚本
- [Dockerfile](.devcontainer/Dockerfile) - 容器镜像定义
