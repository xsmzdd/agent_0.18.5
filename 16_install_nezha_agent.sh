#!/bin/bash

# # 检测系统架
architecture=$(uname -m)

echo "系统架构: $architecture"

# 检查是否安装了 unzip
if ! command -v unzip &> /dev/null; then
    echo "unzip 未安装。尝试安装 unzip..."
    if [ -f /etc/debian_version ]; then
        sudo apt-get update
        sudo apt-get install -y unzip
    elif [ -f /etc/redhat-release ]; then
        sudo yum install -y unzip
    elif [ -f /etc/arch-release ]; then
        sudo pacman -Syu --noconfirm unzip
    else
        echo "无法自动检测系统包管理器。请手动安装 unzip。"
        exit 1
    fi
else
    echo "unzip 已安装。"
fi

# 根据系统架构执行相应的命令
case $architecture in
    x86_64)
        echo "检测到AMD架构，下载并安装nezha-agent..."
        wget https://github.com/nezhahq/agent/releases/download/v0.16.5/nezha-agent_linux_amd64.zip \
        && unzip nezha-agent_linux_amd64.zip \
        && rm nezha-agent_linux_amd64.zip \
        && mv nezha-agent /opt/nezha/agent/nezha-agent \
        && systemctl restart nezha-agent
        ;;
    arm64|aarch64)
        echo "检测到ARM64架构，下载并安装nezha-agent..."
        wget https://github.com/nezhahq/agent/releases/download/v0.16.5/nezha-agent_linux_arm64.zip \
        && unzip nezha-agent_linux_arm64.zip \
        && rm nezha-agent_linux_arm64.zip \
        && mv nezha-agent /opt/nezha/agent/nezha-agent \
        && systemctl restart nezha-agent
        ;;
    *)
        echo "未知或不支持的系统架构: $architecture"
        ;;
esac

# 删除 /root 文件夹中所有以 nezha-agent_linux 开头的文件
echo "删除 /root 文件夹中所有以 nezha-agent_linux 开头的文件..."
rm -f /root/nezha-agent_linux*

# 删除 /opt/nezha/agent 文件夹中所有以 nezha-agent_linux 开头的文件
echo "删除 /opt/nezha/agent 文件夹中所有以 nezha-agent_linux 开头的文件..."
rm -f /opt/nezha/agent/nezha-agent_linux*
