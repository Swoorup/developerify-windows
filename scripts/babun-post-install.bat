@echo off
setlocal enableextensions enabledelayedexpansion

set BABUN_HOME=%USERPROFILE%/.babun

:BEGIN
set CYGWIN_HOME=%BABUN_HOME%\cygwin

set SCRIPT_PATH=%~dp0
set SCRIPT_PATH=%SCRIPT_PATH:\=/%

for /f %%i in ('%CYGWIN_HOME%\bin\cygpath.exe "%SCRIPT_PATH%scripts/babun-post-install"') do set VAR=%%i
echo %VAR%

cd /d %BABUN_HOME%
start "" %CYGWIN_HOME%\bin\mintty.exe -h always /bin/zsh -l -e '%VAR%' -