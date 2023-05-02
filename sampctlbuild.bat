taskkill /f /im samp-server.exe
@echo off
cls
echo All running samp servers have been killed.
echo Now starting...
sampctl build&&sampctl run