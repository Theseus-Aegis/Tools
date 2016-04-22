@echo off
setlocal EnableDelayedExpansion

rem REQUIREMENTS
rem nssm.exe in PATH (service runs through the Non-Sucking Service Manager)
rem properly setup Arma 3 Server installation and all files listed in STATIC VARIABLES

rem STATIC VARIABLES
rem Arma 3 Steam
set a3server="C:\SteamCMD\steamapps\common\Arma 3 Server"
    set symA3dirs=(addons curator dll dta heli kart mark)
    set symA3files=(arma3server.exe arma3server_readme.txt ijl15.dll msvcr100.dll physx3_x86.dll physx3common_x86.dll physx3cooking_x86.dll physx3gpu_x86.dll steam.dll steam_api.dll steam_appid.txt steamclient.dll tier0_s.dll vstdlib_s.dll)
    set symTACdirs=(keys tac_core tac_server userconfig)
    set symTACfiles=()
    rem basic.cfg
    set cpyA3dirs=(mpmissions)
    rem profiles
    set cpyA3files=(server.cfg)
rem Custom servers
set serversFolder=C:\Theseus\Arma 3\Servers
rem Mod line
set mods=(tac_core)
set serverMods=(tac_server)
set modsPreload=(tac_core\@CBA_A3 tac_core\@ace tac_core\@tac_mods)
set headlessServerMods=()

cd %serversFolder%

rem INPUT VARIABLES
set /p type="Enter type ('server' or 'hc'): "
if %type%==server (
    set /p server="Enter desired Server/Folder name (NO spaces): "
    set /p port="Enter desired port for Server to run on: "
) else (
    set /p server="Enter Server/Folder name HC connects to with 'HCx' suffix: "
    set /p port="Enter desired port for HC to connect to: "
    set /p password="Enter password of server HC connects to: "
)

rem Exit if input variable is empty
if [%server%]==[] (
    echo.
    echo Server name empty, exiting...
    pause
    exit /b
)
rem Exit if folder already exists
for /d %%x in (*) do (
    if %server%==%%x (
        echo.
        echo Server or HC name already exists, exiting...
        pause
        exit /b
    )
)


rem Create directory
echo.
echo Creating new server directory...
echo -----------------------------
mkdir %server%
echo %serversFolder%\%server%


rem Create symbolic links
echo.
echo Creating symbolic links...
echo -----------------------------
for %%i in %symA3dirs% do mklink /d %server%\%%i %a3server%\%%i
for %%i in %symTACdirs% do mklink /d %server%\%%i %a3server%\%%i
for %%i in %symA3files% do mklink %server%\%%i %a3server%\%%i
for %%i in %symTACfiles% do mklink %server%\%%i %a3server%\%%i


rem Copy directories and files (if Server setup)
if %type%==server (
    echo.
    echo Copying directories...
    echo -----------------------------
    for %%i in %cpyA3dirs% do xcopy %a3server%\%%i %server%\%%i /i /e /y
    echo.
    echo Copying files...
    echo -----------------------------
    for %%i in %cpyA3files% do copy %a3server%\%%i %server%\%%i
)

cd %server%


rem Build -mod and -serverMod parameters
echo.
echo Building modline parameters...
echo -----------------------------
rem Mods needed to be loaded first
for %%x in %modsPreload% do (
    set modsCore=!modsCore!%%x;
)
rem Mods
for %%x in %mods% do (
    for /d %%i in (%%x\*) do (
        set same=""
        rem Requires delayed expansion, separate variable to ensure it doesn't get run multiple times
        for %%n in %modsPreload% do if %%i==%%n set same=true
        if !same!=="" set modsCore=!modsCore!%%i;
    )
)
rem Server-only mods on server and selected server mods on headless
if %type%==server (
    for %%x in %serverMods% do (
        for /d %%i in (%%x\*) do (
            set serverModsCore=!serverModsCore!%%i;
        )
    )
    echo -serverMod=!serverModsCore!
) else (
    for %%x in %headlessServerMods% do (
        set modsCore=!modsCore!%%x;
    )
)
echo -mod=%modsCore%


rem rem Install service
echo.
echo Installing service...
echo -----------------------------
nssm install "Arma 3 %server%" "%serversFolder%\%server%\arma3server.exe" -exThreads=7 -enableHT -profiles=profiles -par=params.cfg
nssm set "Arma 3 %server%" Description Arma 3 Server - %server% - Theseus Inc. (runs through nssm)
nssm set "Arma 3 %server%" Start SERVICE_DELAYED_AUTO_START
nssm set "Arma 3 %server%" Type SERVICE_INTERACTIVE_PROCESS
nssm set "Arma 3 %server%" AppStdout %serversFolder%\%server%\profiles\service.log
nssm set "Arma 3 %server%" AppStderr %serversFolder%\%server%\profiles\service.log


rem Parameters file
echo.
echo Creating startup parameters file...
echo -----------------------------
echo -port=%port%> params.cfg
echo -mod=%modsCore%>> params.cfg
if %type%==server (
    echo -serverMod=%serverModsCore%>> params.cfg
    echo -config=server.cfg>> params.cfg
    echo -loadMissionToMemory>>params.cfg
) else (
    echo -client>>params.cfg
    echo -connect=localhost>>params.cfg
    echo -password=%password%>>params.cfg
)
type params.cfg


rem Notes
if %type%==server (
    echo.
    echo --------- NOTES -------------
    echo Make sure to edit 'server.cfg'
    echo -----------------------------
)

endlocal
goto :eof
