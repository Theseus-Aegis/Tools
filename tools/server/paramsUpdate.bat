@echo off
setlocal EnableDelayedExpansion

rem STATIC VARIABLES
rem Custom servers
set serversFolder="C:\Theseus\Arma 3\Servers"
rem Mod line
set mods=(tac_core)
set serverMods=(tac_server)
set modsPreload=(tac_core\@CBA_A3 tac_core\@ace tac_core\@tac_mods)
set headlessServerMods=()

cd /d %serversFolder%

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

rem Exit if folder does not exists
for /d %%x in (*) do (
    if %server%==%%x (
        set existsServer=true
    )
)
if !existsServer!=="true" (
    echo.
    echo Server or HC name does NOT exist, exiting...
    pause
    exit /b
)

cd /d %server%

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

endlocal
goto :eof
