cls
@echo off
taskkill /f /im samp-server.exe
del gamemodes\roleplay.amx
pawncc -iincludes -d2 -ogamemodes\roleplay.amx gamemodes\roleplay.pwn
echo Continue?
pause
samp-server.exe
