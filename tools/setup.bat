@echo off
setlocal EnableDelayedExpansion

rem INPUT VARIABLES
set /p missions="Enter full path to your missions folder (usually 'Documents\Arma 3 - Other Profiles\<profile>\missions'): "
set /p operation="Enter operation ('all' to create symbolic links and copy mission.sqm files, 'symlink' to create symbolic links only, 'sqm' to copy mission.sqm files only): "

rem Exit if input variable is empty
if [%missions%]==[] (
    echo.
    echo Missions folder path empty, exiting...
    pause
    exit /b
)

rem Save current branch
for /f %%b in ('git rev-parse --abbrev-ref HEAD^^') do ( set branch=%%b )

rem Exit if on SQM branch
echo.
if %branch%==masterSQM (
    echo On SQM branch, please switch to a non-SQM branch, exiting...
    pause
    exit /b
)

cd ..\missions

rem Perform requested operation(s)
if %operation%==all (
    echo WARNING - This script will overwrite mission.sqm files if you have any modifications!
    pause
    call :symlinkFolders
    echo -----------------------------
    call :copySQMs
) else (
    if %operation%==symlink (
        call :symlinkFolders
    ) else (
        if %operation%==sqm (
            echo WARNING - This script will overwrite mission.sqm files if you have any modifications!
            pause
            call :copySQMs
        ) else (
            echo.
            echo Valid operation not selected, exiting...
            pause
            exit /b
        )
    )
)

endlocal
goto :eof



:symlinkFolders
echo.
echo Symbolic linking folders...
echo -----------------------------
for /d %%x in (*) do (
    echo.
    echo Mission: %%x

    rem Read $MAPSUFFIX$
    set /p suffix=<%%x\$MAPSUFFIX$
    echo Suffix: .!suffix!

    rem Create symlink to Arma's mission folder
    mklink /d /j %missions%\%%x.!suffix! "%cd%\%%x"
)
goto :eof


:copySQMs
git checkout masterSQM

echo.
echo Making temp...
echo -----------------------------

for /d %%x in (*) do (
    if not %%x==temp (
        xcopy "%cd%\%%x" temp\%%x /s /i /y
        echo Moved to temp: %%x\mission.sqm
    )
)

echo.
echo -----------------------------
git checkout %branch%

echo.
echo Removing temp...
echo -----------------------------

for /d %%x in (*) do (
    if not %%x==temp (
        move temp\%%x\mission.sqm %%x\mission.sqm
        echo Moved out of temp: temp\%%x\mission.sqm - "%cd%\%%x"
    )
)
rmdir /s temp /q
goto :eof
