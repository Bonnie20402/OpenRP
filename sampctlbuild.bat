cls
@echo off
taskkill /f /im samp-server.exe
echo All samp server instances have been killed.
del gamemodes\roleplay.amx
echo Compiling...
pawncc -iincludes -d2 -ogamemodes\roleplay.amx gamemodes\roleplay.pwn
IF %ERRORLEVEL% EQU 0 (
    echo Compile success, starting server...
    start samp-server.exe
)
ELSE (
    echo There was an error while compiling the gamemode. The compiler exited with end code %ERRORLEVEL%
)
