@echo off
setlocal EnableDelayedExpansion

rem Builds a given swifty-cli repo from [source] (with "_new" appended) to [dest]
rem *.json and mod folder (with repo image and @mods inside) must be present in [source] folder

rem CONFIGURATION START
set swiftycli="C:\Theseus\Arma 3\Tools\swifty-cli.exe"
set source="C:\Theseus\Arma 3\Modpack\development"
set dest="C:\Theseus\www\repos"
rem CONFIGURATION END

rem Input
set /p repo="Enter modpack (folder) name: "

set reponew=%repo%_new

rem Exit if requirements not satisfied
if not exist %source%\%repo% (
    echo Error: Repository source folder does not exist
    goto end
)
if not exist %source%\%repo%.json (
    echo Error: Repository configuration file does not exist: %repo%.json
    goto end
)

rem Check for existing new repo
if exist %dest%\%reponew% (
    set /p clean="Remove existing %reponew% (Y/[N]): "
    if /i "!clean!" neq "Y" goto end
    
    echo Removing ...
    rd /s /q %dest%\%reponew%
)

rem Build
echo Building ...
%swiftycli% create %source%\%repo%.json %dest%\%reponew%

:end
endlocal
pause