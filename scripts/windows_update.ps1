<#
.SYNOPSIS
    Scratch520 Windows自动更新脚本
#>

param([switch]$Auto=$false)

$RepoOwner = "yhjyhjlqx"
$RepoName = "Scratch520"
$DownloadUrl = "https://github.com/$RepoOwner/$RepoName/releases/latest/download/Scratch520_Scripts.zip"
$TempDir = "$env:temp\Scratch520"
$SystemHosts = "$env:windir\System32\drivers\etc\hosts"

function Test-Admin {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    return (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not $Auto) {
    Write-Host "=== Scratch520 更新工具 ===" -ForegroundColor Cyan
    Write-Host "项目: https://github.com/yhjyhjlqx/Scratch520"
}

if (-not (Test-Admin)) {
    if ($Auto) { Write-Host "需要管理员权限" -ForegroundColor Red; exit 1 }
    Start-Process powershell "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -Auto" -Verb RunAs
    exit
}

try {
    if (-not (Test-Path $TempDir)) { New-Item -ItemType Directory -Path $TempDir | Out-Null }
    
    Write-Host "下载最新版本..." -NoNewline
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest $DownloadUrl -OutFile "$TempDir\scripts.zip"
    Write-Host "完成" -ForegroundColor Green

    Write-Host "解压文件..." -NoNewline
    Expand-Archive "$TempDir\scripts.zip" -DestinationPath $TempDir -Force
    Write-Host "完成" -ForegroundColor Green

    if (Test-Path $SystemHosts)) {
        Copy-Item $SystemHosts "$TempDir\hosts.backup"
        Write-Host "已备份hosts文件"
    }

    $NewHosts = "$TempDir\release_package\hosts"
    if (Test-Path $NewHosts)) {
        Copy-Item $NewHosts $SystemHosts -Force
        Write-Host "hosts文件已更新" -ForegroundColor Green
    } else { throw "未找到新hosts文件" }

    ipconfig /flushdns | Out-Null
    Write-Host "DNS缓存已刷新" -ForegroundColor Green
}
catch {
    Write-Host "错误: $_" -ForegroundColor Red
    if (Test-Path "$TempDir\hosts.backup")) {
        Copy-Item "$TempDir\hosts.backup" $SystemHosts -Force
        Write-Host "已恢复原始hosts文件"
    }
    exit 1
}
finally {
    if (-not $Auto) { pause }
}
