@echo off

REM --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorLevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin) 

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
cscript "%temp%\getadmin.vbs"
exit /B
    
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
CD /D "%~dp0"

REM --> Install chocolatey
Powershell.exe -executionpolicy remotesigned -File scripts/install-chocolatey.ps1

REM --> Install chocolatey packages
Powershell.exe -executionpolicy remotesigned -File scripts/install-choco-pkgs.ps1

REM --> Post babun installation
babun scripts/babun-post-install