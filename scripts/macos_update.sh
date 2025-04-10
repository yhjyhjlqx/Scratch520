#!/bin/bash

# Scratch520 macOS更新脚本

REPO_OWNER="yhjyhjlqx"
REPO_NAME="Scratch520"
DOWNLOAD_URL="https://github.com/$REPO_OWNER/$REPO_NAME/releases/latest/download/Scratch520_Scripts.zip"
TEMP_DIR="/tmp/Scratch520"
SYSTEM_HOSTS="/etc/hosts"

function check_root() {
    [ "$(id -u)" -ne 0 ] && { echo "请使用sudo运行此脚本"; exit 1; }
}

function cleanup() {
    rm -rf "$TEMP_DIR"
}

check_root

echo "=== Scratch520 更新工具 ==="
echo "项目: https://github.com/$REPO_OWNER/$REPO_NAME"

mkdir -p "$TEMP_DIR" || exit 1
trap cleanup EXIT

echo "下载最新版本..."
if ! curl -sL "$DOWNLOAD_URL" -o "$TEMP_DIR/scripts.zip"; then
    echo "下载失败" >&2
    exit 1
fi

echo "解压文件..."
unzip -o "$TEMP_DIR/scripts.zip" -d "$TEMP_DIR" || exit 1

echo "备份当前hosts文件..."
cp "$SYSTEM_HOSTS" "$TEMP_DIR/hosts.backup" || echo "备份失败" >&2

NEW_HOSTS="$TEMP_DIR/release_package/hosts"
if [ -f "$NEW_HOSTS" ]; then
    cp "$NEW_HOSTS" "$SYSTEM_HOSTS" || { echo "更新失败" >&2; exit 1; }
    echo "hosts文件已更新"
else
    echo "未找到新hosts文件" >&2
    exit 1
fi

echo "刷新DNS缓存..."
killall -HUP mDNSResponder && echo "完成" || echo "刷新失败"

echo "操作成功完成！"
