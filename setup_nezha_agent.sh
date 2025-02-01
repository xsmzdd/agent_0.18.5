#!/bin/sh

# 定义变量
DOWNLOAD_URL="https://github.com/nezhahq/agent/releases/download/v0.18.5/nezha-agent_linux_amd64.zip"
ZIP_FILE="nezha-agent_linux_amd64.zip"
TARGET_DIR="/opt/nezha/agent/"
SERVICE_NAME="nezha-agent"
SERVICE_SCRIPT="/etc/init.d/${SERVICE_NAME}"

# 安装必要的工具
apk add --no-cache wget unzip

# 下载文件
echo "Downloading ${DOWNLOAD_URL}..."
wget -O ${ZIP_FILE} ${DOWNLOAD_URL}

# 解压缩文件
echo "Unzipping ${ZIP_FILE}..."
unzip ${ZIP_FILE}

# 删除压缩包
rm -f ${ZIP_FILE}

# 创建目标目录（如果不存在）
mkdir -p ${TARGET_DIR}

# 移动Nezha Agent到目标目录
mv nezha-agent ${TARGET_DIR}

# 检查并创建服务脚本
if [ ! -f "${SERVICE_SCRIPT}" ]; then
    echo "Creating service script..."
    cat <<EOL > ${SERVICE_SCRIPT}
#!/sbin/openrc-run
description="Nezha Agent Service"
command="${TARGET_DIR}nezha-agent"
pidfile="/var/run/${SERVICE_NAME}.pid"
depend() {
    need net
    after firewall
}
EOL
    chmod +x ${SERVICE_SCRIPT}
fi

# 添加服务到默认运行级别并启动服务
rc-update add ${SERVICE_NAME} default
rc-service ${SERVICE_NAME} restart

echo "Setup completed successfully."
