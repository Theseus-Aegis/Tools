
@echo off
setlocal EnableDelayedExpansion

rem REQUIREMENTS
rem nssm.exe in PATH (service runs through the Non-Sucking Service Manager)
rem properly setup Arma 3 Server installation and all files listed in STATIC VARIABLES

rem STATIC VARIABLES
rem Arma 3 Steam
set a3server="C:\SteamCMD\steamapps\common\Arma 3 Server"
    set symA3dirs=(addons argo curator dll dta enoch expansion heli jets kart mark orange tacops tank)
    set symA3files=(arma3server.exe arma3server_readme.txt arma3server_x64.exe msvcr100.dll openssl_license.txt steam.dll steam_api.dll steam_api64.dll steam_appid.txt steamclient.dll steamclient64.dll tier0_s.dll tier0_s64.dll vstdlib_s.dll vstdlib_s64.dll)
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


rem rem Install service
echo.
echo Installing service...
echo -----------------------------
nssm install "Arma 3 %server%" "%serversFolder%\%server%\arma3server_x64.exe" -exThreads=7 -enableHT -hugepages -profiles=profiles -par=params.cfg
nssm set "Arma 3 %server%" Description Runs through nssm.
nssm set "Arma 3 %server%" Start SERVICE_DELAYED_AUTO_START
nssm set "Arma 3 %server%" Type SERVICE_INTERACTIVE_PROCESS
nssm set "Arma 3 %server%" AppStdin %serversFolder%\%server%\profiles\service_nssm.log
nssm set "Arma 3 %server%" AppStdout %serversFolder%\%server%\profiles\service_nssm.log
nssm set "Arma 3 %server%" AppStderr %serversFolder%\%server%\profiles\service_nssm.log


rem Parameters file
echo.
echo Creating startup parameters file...
echo -----------------------------
echo -port=%port%> params.cfg
echo -mod=%modsCore%>> params.cfg
if %type%==server (
    echo -serverMod=%serverModsCore%>> params.cfg
    echo -config=server.cfg>> params.cfg
    echo -loadMissionToMemory>> params.cfg
    echo -cfg=basic.cfg>> params.cfg
    echo -bandwidthAlg=2>> params.cfg
    echo -limitFPS=100>> params.cfg
) else (
    echo -client>> params.cfg
    echo -connect=localhost>> params.cfg
    echo -password=%password%>> params.cfg
    echo -limitFPS=100>> params.cfg
)
type params.cfg

rem Network file
echo.
echo Creating network parameters file...
echo -----------------------------
echo // Based on server network and updated for today's standards>> basic.cfg
echo MaxMsgSend = 1480; // MTU (default: 128)>> basic.cfg
echo MaxSizeGuaranteed = 1024; // (default: 512)>> basic.cfg
echo MaxSizeNonguaranteed = 512; // (default: 256)>> basic.cfg
echo MinBandwidth = 107374182; // ~100 Mb based on server bandwidth (value in bits)>> basic.cfg
echo MaxBandwidth = 1073741824; // ~1 Gb based on server bandwidth (value in bits)>> basic.cfg
echo MinErrorToSend = 0.001; // (default)>> basic.cfg
echo MinErrorToSendNear = 0.01; // (default)>> basic.cfg
echo MaxCustomFileSize = 0; // Disable custom faces>> basic.cfg
echo class sockets {>> basic.cfg
echo     maxPacketSize = 1480; // MTU>> basic.cfg
echo     initBandwidth = 2000000; // 16 Mb (value in bytes)>> basic.cfg
echo     MinBandwidth = 64000; // 512 Kb lowest DSL (value in bytes)>> basic.cfg
echo     MaxBandwidth = 2000000; // 16 Mb average DSL (value in bytes)>> basic.cfg
echo };>> basic.cfg
type basic.cfg

rem Notes
if %type%==server (
    echo.
    echo --------- NOTES -------------
    echo Make sure to edit 'server.cfg'
    echo -----------------------------
)

endlocal
goto :eof
