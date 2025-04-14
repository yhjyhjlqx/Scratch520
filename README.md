# Scratch520 - 优化Scratch访问体验

[![自动更新](https://github.com/yhjyhjlqx/Scratch520/actions/workflows/auto_update.yml/badge.svg)](https://github.com/yhjyhjlqx/Scratch520/actions/workflows/auto_update.yml)
[![最新版本](https://img.shields.io/github/v/release/yhjyhjlqx/Scratch520)](https://github.com/yhjyhjlqx/Scratch520/releases)

## 功能

- 解除Scratch访问限制
- 防止强制重定向
- 自动更新域名列表
- 支持Windows/macOS/Linux

## Raw分发
https://raw.githubusercontent.com/yhjyhjlqx/Scratch520/main/hosts

## 安装
https://vercel.com

# Windows
irm https://raw.githubusercontent.com/yhjyhjlqx/Scratch520/main/scripts/windows_update.ps1 | iex

# macOS/Linux
curl -sL https://raw.githubusercontent.com/yhjyhjlqx/Scratch520/main/scripts/macos_update.sh | sudo bash

[完整文档](https://github.com/yhjyhjlqx/Scratch520#readme)

## 部署说明

1. 创建新仓库 `Scratch520`
2. 添加上述所有文件
3. 设置文件权限：
   chmod +x scripts/*.sh
