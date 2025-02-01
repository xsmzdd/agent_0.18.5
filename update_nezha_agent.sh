#!/bin/sh

# 定义变量
SERVICE_SCRIPT="/etc/init.d/nezha-agent"

# 备份原始的服务脚本
cp ${SERVICE_SCRIPT} ${SERVICE_SCRIPT}.bak

# 使用 sed 命令在 command 行末尾添加 "--disable-auto-update" 参数
sed -i '/^command=/ {
    s/^$command="[^"]*$"$/\1 --disable-auto-update"/
    s/^$command="[^"]*--disable-auto-update[^"]*$"$/\1"/
}' ${SERVICE_SCRIPT}

# 重新加载服务配置并重启服务
rc-service nezha-agent restart

echo "Configuration updated and service restarted successfully."
