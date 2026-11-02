# Kensaku 一键安装脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/yjid/kensaku#install
# 更新日期：2026-11-02
# 类型：binary
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

if (-not (Get-Command curl.exe -ErrorAction SilentlyContinue)) { throw '需要先安装 curl（Windows 10+ 自带 curl.exe）' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

curl.exe -fL -o kensaku-setup.exe https://github.com/yjid/kensaku/releases/download/v1.0.11/kensaku_1.0.11_x64-setup.exe
$h=(Get-FileHash .\kensaku-setup.exe -Algorithm SHA256).Hash.ToLower()
if ($h -ne "b63fea778c85750e9dd8909d587f3612ed37a65868729e0975165ad19281d73c") { throw "SHA256 校验失败" }
Start-Process -Wait .\kensaku-setup.exe
Write-Host "安装完成：从托盘打开 Kensaku，先选索引目录"

Write-Host ''

Write-Host '下载与校验完成，安装包在 .download 目录'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://github.com/yjid/kensaku#install'
