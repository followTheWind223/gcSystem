@echo off
rem Use the shared launcher so the working directory and Java version stay consistent.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0..\start.ps1" %*
exit /b %errorlevel%
