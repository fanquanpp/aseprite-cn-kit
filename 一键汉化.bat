@echo off
setlocal enabledelayedexpansion
title Aseprite 一键汉化 + 中文字体优化

echo.
echo  ============================================
echo    Aseprite 一键汉化 + 中文字体优化工具
echo    汉化：sChinese 增强版 / 主题：Aseprite-CN
echo  ============================================
echo.

cd /d "%~dp0"

:: ---------- 0. 检查文件 ----------
if not exist "extensions\hanhua-*.aseprite-extension" (
    echo [错误] 未找到 extensions\hanhua-*.aseprite-extension
    echo        请保持 一键汉化.bat 与 extensions 文件夹的相对位置不变。
    goto :fail
)
if not exist "extensions\aseprite-theme-cn-*.aseprite-extension" (
    echo [错误] 未找到 extensions\aseprite-theme-cn-*.aseprite-extension
    goto :fail
)

:: ---------- 1. 检查 Aseprite 是否在运行 ----------
tasklist /fi "imagename eq aseprite.exe" 2>nul | findstr /i "aseprite.exe" >nul
if !errorlevel! equ 0 (
    echo [提示] 检测到 Aseprite 正在运行。
    set /p "KILL=检测到 Aseprite 正在运行。是否自动关闭以便安装? Y=关闭并继续, N=退出: "
    if /i "!KILL!"=="Y" (
        taskkill /im aseprite.exe /f >nul 2>&1
        timeout /t 2 /nobreak >nul
    ) else (
        echo 已取消。请先关闭 Aseprite 再运行本脚本。
        goto :fail
    )
)

:: ---------- 2. 安装扩展到用户目录 ----------
set "EXTDIR=%APPDATA%\Aseprite\extensions"
if not exist "%EXTDIR%" mkdir "%EXTDIR%" >nul 2>&1

set "HANHUA_SRC="
for /f "delims=" %%f in ('dir /b "extensions\hanhua-*.aseprite-extension" 2^>nul') do set "HANHUA_SRC=extensions\%%f"
set "THEME_SRC="
for /f "delims=" %%f in ('dir /b "extensions\aseprite-theme-cn-*.aseprite-extension" 2^>nul') do set "THEME_SRC=extensions\%%f"

echo [1/3] 正在安装汉化扩展 "%HANHUA_SRC%" ...
call :install_ext "%HANHUA_SRC%" "aseprite-language-sChinese"
if !errorlevel! neq 0 goto :fail

echo [2/3] 正在安装中文字体主题 "%THEME_SRC%" ...
call :install_ext "%THEME_SRC%" "aseprite-theme-cn"
if !errorlevel! neq 0 goto :fail

:: ---------- 3. 写入语言与主题设置 ----------
echo [3/3] 正在配置语言 (sChinese) 与主题 (cn-clear) ...
>> "%TEMP%\aseprite_cn_setup.ps1" echo $ErrorActionPreference = 'Stop'
>> "%TEMP%\aseprite_cn_setup.ps1" echo $ini = Join-Path $env:APPDATA 'Aseprite\aseprite.ini'
>> "%TEMP%\aseprite_cn_setup.ps1" echo function Set-IniKey([string]$Section, [string]$Key, [string]$Value) {
>> "%TEMP%\aseprite_cn_setup.ps1" echo   $enc = New-Object System.Text.UTF8Encoding($false)
>> "%TEMP%\aseprite_cn_setup.ps1" echo   $lines = @()
>> "%TEMP%\aseprite_cn_setup.ps1" echo   if (Test-Path $ini) { $lines = [System.IO.File]::ReadAllLines($ini) }
>> "%TEMP%\aseprite_cn_setup.ps1" echo   $inSec = $false; $secFound = $false; $done = $false
>> "%TEMP%\aseprite_cn_setup.ps1" echo   for ($i = 0; $i -lt $lines.Count; $i++) {
>> "%TEMP%\aseprite_cn_setup.ps1" echo     $l = $lines[$i].Trim()
>> "%TEMP%\aseprite_cn_setup.ps1" echo     if ($l -match '^^\[(.+)\]$') {
>> "%TEMP%\aseprite_cn_setup.ps1" echo       if ($inSec -and -not $done) { $lines[$i] = "$Key = $Value"; $done = $true }
>> "%TEMP%\aseprite_cn_setup.ps1" echo       $inSec = ($Matches[1] -ieq $Section)
>> "%TEMP%\aseprite_cn_setup.ps1" echo       if ($inSec) { $secFound = $true }
>> "%TEMP%\aseprite_cn_setup.ps1" echo     } elseif ($inSec -and $l -match "^$Key\s*=") {
>> "%TEMP%\aseprite_cn_setup.ps1" echo       $lines[$i] = "$Key = $Value"; $done = $true
>> "%TEMP%\aseprite_cn_setup.ps1" echo     }
>> "%TEMP%\aseprite_cn_setup.ps1" echo   }
>> "%TEMP%\aseprite_cn_setup.ps1" echo   if (-not $done) {
>> "%TEMP%\aseprite_cn_setup.ps1" echo     if ($secFound) {
>> "%TEMP%\aseprite_cn_setup.ps1" echo       $new = @(); $inSec = $false
>> "%TEMP%\aseprite_cn_setup.ps1" echo       foreach ($l in $lines) { $new += $l; if ($l -match '^^\[(.+)\]$') { $inSec = ($Matches[1] -ieq $Section) } elseif ($inSec -and $l -notmatch '\S') { $new += "$Key = $Value"; $inSec = $false } }
>> "%TEMP%\aseprite_cn_setup.ps1" echo       $lines = $new
>> "%TEMP%\aseprite_cn_setup.ps1" echo     } else {
>> "%TEMP%\aseprite_cn_setup.ps1" echo       if ($lines.Count -gt 0) { $lines += '' }
>> "%TEMP%\aseprite_cn_setup.ps1" echo       $lines += "[$Section]"; $lines += "$Key = $Value"
>> "%TEMP%\aseprite_cn_setup.ps1" echo     }
>> "%TEMP%\aseprite_cn_setup.ps1" echo   }
>> "%TEMP%\aseprite_cn_setup.ps1" echo   [System.IO.File]::WriteAllLines($ini, $lines, $enc)
>> "%TEMP%\aseprite_cn_setup.ps1" echo }
>> "%TEMP%\aseprite_cn_setup.ps1" echo Set-IniKey 'general' 'language' 'sChinese'
>> "%TEMP%\aseprite_cn_setup.ps1" echo Set-IniKey 'theme' 'selected' 'cn-clear'
>> "%TEMP%\aseprite_cn_setup.ps1" echo Write-Host 'INI-OK'
powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP%\aseprite_cn_setup.ps1" >nul 2>&1
if !errorlevel! neq 0 (
    echo [警告] 配置写入失败，请手动在 Aseprite 中选择：
    echo        Edit ^> Preferences ^> General ^> Language: sChinese
    echo        Edit ^> Preferences ^> Theme: Aseprite-CN
) else (
    findstr /i /c:"language = sChinese" "%APPDATA%\Aseprite\aseprite.ini" >nul
    if !errorlevel! neq 0 (
        echo [警告] 语言设置未生效，请手动在 Aseprite 中切换语言。
    )
)
del "%TEMP%\aseprite_cn_setup.ps1" >nul 2>&1

echo.
echo  ============================================
echo    安装完成！
echo    1. 启动 Aseprite 即可看到中文界面
echo    2. 若未生效：Edit ^> Preferences ^> General
echo       Language 选择 sChinese
echo    3. 若想换回英文/原主题，卸载对应扩展即可
echo  ============================================
echo.
choice /c YN /m "是否立即启动 Aseprite"
if !errorlevel! equ 1 call :launch_aseprite

:launch_aseprite
set "ASE_EXE="
if exist "%~dp0aseprite.exe" set "ASE_EXE=%~dp0aseprite.exe"
if not defined ASE_EXE if exist "%ProgramFiles%\Asepriteseprite.exe" set "ASE_EXE=%ProgramFiles%\Asepriteseprite.exe"
if not defined ASE_EXE if exist "%ProgramFiles(x86)%\Asepriteseprite.exe" set "ASE_EXE=%ProgramFiles(x86)%\Asepriteseprite.exe"
if not defined ASE_EXE if exist "%ProgramFiles(x86)%\Steam\steamapps\common\Asepriteseprite.exe" set "ASE_EXE=%ProgramFiles(x86)%\Steam\steamapps\common\Asepriteseprite.exe"
if not defined ASE_EXE for /f "skip=2 tokens=2,*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Pathsseprite.exe" /ve 2^>nul') do set "ASE_EXE=%%b"
if defined ASE_EXE (
    start "" "!ASE_EXE!"
) else (
    echo 未找到 aseprite.exe，请手动启动 Aseprite。
)
exit /b 0
exit /b 0

:install_ext
:: %1 = 源 .aseprite-extension, %2 = 目标目录名
set "TMPZIP=%TEMP%\asprite_ext_%RANDOM%"
mkdir "%TMPZIP%" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-Type -AssemblyName 'System.IO.Compression.FileSystem'; [System.IO.Compression.ZipFile]::ExtractToDirectory('%~f1', '%TMPZIP%')" >nul 2>&1
if !errorlevel! neq 0 ( echo [错误] 解压 %~1 失败 & rd /s /q "%TMPZIP%" & exit /b 1 )
rd /s /q "%APPDATA%\Aseprite\extensions\%~2" >nul 2>&1
:: 若解压出单层目录则取其内容
set "SRC=%TMPZIP%"
if exist "%TMPZIP%\%~2" set "SRC=%TMPZIP%\%~2"
if not exist "%SRC%\package.json" (
    for /f "delims=" %%d in ('dir /b /ad "%TMPZIP%" 2^>nul') do set "SRC=%TMPZIP%\%%d"
)
if not exist "%SRC%\package.json" (
    echo [错误] %~1 内未找到 package.json，扩展包已损坏
    rd /s /q "%TMPZIP%" & exit /b 1
)
robocopy "%SRC%" "%APPDATA%\Aseprite\extensions\%~2" /e /njh /njs /ndl /nc /ns >nul
rd /s /q "%TMPZIP%" >nul 2>&1
echo        已安装到 %%APPDATA%%\Aseprite\extensions\%~2
exit /b 0

:fail
echo.
echo 安装未完成，按任意键退出。
pause >nul
endlocal
exit /b 1
