cls
@echo off
taskkill /f /im samp-server.exe
echo All samp server instances have been killed.
del gamemodes\roleplay.amx
echo Compiling...
pawncc -iincludes -d2 -O0 -Z+ -ogamemodes\roleplay.amx gamemodes\roleplay.pwn
IF %ERRORLEVEL% EQU 0 (
    echo Compile success, starting server...
    start samp-server.exe
    exit
)
echo There was an error while compiling the gamemode. The compiler exited with end code %ERRORLEVEL%

