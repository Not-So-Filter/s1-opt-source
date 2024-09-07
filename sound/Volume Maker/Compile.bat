@echo off
set MAINDIR=%CD%
set COMPDIR="C:\MinGW\mingw64\bin"
cd /d %COMPDIR%

g++.exe -static-libgcc -static-libstdc++ "%MAINDIR%\Source.c" -o "%MAINDIR%\Program.exe"

pause
