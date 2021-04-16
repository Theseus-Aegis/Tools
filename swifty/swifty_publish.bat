@echo off
setlocal EnableDelayedExpansion

rem Publishes a swifty-cli repo in [dest] (appends "_bak" to old and removes "_new" from new)
rem generated repo (with "_new" appended) in [dest] folder

rem CONFIGURATION START
set dest="C:\Theseus\www\repos"
rem CONFIGURATION END

rem Input
set /p repo="Enter modpack (folder) name: "

set repobak=%repo%_bak
set reponew=%repo%_new

rem Exit if requirements not satisfied
if not exist %dest%\%reponew% (
    echo Error: Repository folder does not exist
    goto end
)

rem Clear old backup repo
if exist %dest%\%repobak% (
    echo Removing backup %repobak% ...
    rd /s /q %dest%\%repobak%
)

rem Move active repo to backup repo
if exist %dest%\%repo% (
    echo Deactivating %repo% ... %repobak%
    rename %dest%\%repo% %repobak%
)

rem Make new repo active
echo Activating %reponew% ... %repo%
rename %dest%\%reponew% %repo%

:end
endlocal
pause
