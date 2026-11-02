#!/usr/bin/env bash
set -euo pipefail
# Kensaku 一键安装脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/yjid/kensaku#install
# 更新日期：2026-11-02
# 类型：binary
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v curl >/dev/null 2>&1 || { echo "需要先安装 curl"; exit 1; }

mkdir -p .download
cd .download

curl -fL -O https://github.com/yjid/kensaku/releases/download/v1.0.11/kensaku_1.0.11_amd64.AppImage
chmod +x kensaku_1.0.11_amd64.AppImage
./kensaku_1.0.11_amd64.AppImage
echo "首次运行：先选要索引的目录"

echo ""

echo "下载与校验完成，安装包在 .download 目录"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/yjid/kensaku#install"
