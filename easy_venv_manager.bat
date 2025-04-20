@echo off
chcp 65001 >nul

rem ===================================================================
rem ManagePyEnvs.bat ― Combined Creator & Deletor for Python virtual envs
rem First step: select operation mode (Creator or Deletor)
rem ===================================================================

rem Display operation options to the user
echo Select operation:
echo(
echo  ➕ [1] Creator - Create a Python virtual environment
echo  🗑️ [2] Deletor - Delete a Python virtual environment
echo(

rem Enable extensions and delayed variable expansion
setlocal EnableExtensions EnableDelayedExpansion

rem Default choice is Creator
set "choice=1"
rem Prompt user for operation choice
set /p "choice= ➡️ Enter choice [1-2] (default=1): "
if /I "%choice%"=="2" (
    rem If choice is 2, go to DELETOR section
    endlocal
    goto DELETOR
)
rem Default to Creator if no valid input
endlocal
goto CREATOR

:CREATOR
@echo off
setlocal enabledelayedexpansion

rem ----------------------------------------------------------------------------
rem Script: create_venv.bat
rem Description:
rem   Handles the creation of Python virtual environments.
rem ----------------------------------------------------------------------------

rem Inform user about the search for Python interpreters
echo(
echo ==================================================
echo  Searching for all "python.exe" on this system...
echo ==================================================
echo(

rem Initialize index for Python interpreters
set /a index=0

rem Loop through all found Python executables
for /f "delims=" %%p in ('where python 2^>nul') do (
    rem Retrieve Python version for each executable
    for /f "tokens=1,2 delims= " %%i in ('"%%p" --version 2^>nul') do (
        if "%%i"=="Python" (
            set "version=%%j"
        )
    )
    rem Increment index and store path and version
    set /a index=!index! + 1
    set "pythonPath[!index!]=%%p"
    set "pythonVersion[!index!]=!version!"
)

rem Add an option for custom Python path
set /a index=!index! + 1
set "pythonPath[!index!]=CUSTOM_PATH"
set "pythonVersion[!index!]=Custom"

rem Display found Python interpreters
echo Found the following Python interpreters:
echo(
set /a i=1
:LIST_PYTHONS
if %i% GTR %index% goto LIST_DONE
if "!pythonPath[%i%]!"=="CUSTOM_PATH" (
    rem Display custom path option
    echo  %i%. [Custom] Specify a different Python path
) else (
    rem Display Python version and path
    echo  %i%. [!pythonVersion[%i%]!]  !pythonPath[%i%]!
)
set /a i+=1
goto LIST_PYTHONS
:LIST_DONE
echo(

rem Prompt user to select a Python interpreter
set /p selection= ➡️ Which Python do you want to use? [1-%index%] (default=1):
if %selection% LSS 1 (
    rem Handle invalid selection
    echo Invalid choice: out of range.
    pause
    exit /b 1
)
if %selection% GTR %index% (
    rem Handle invalid selection
    echo Invalid choice: out of range.
    pause
    exit /b 1
)

rem Handle custom Python path selection
if "!pythonPath[%selection%]!"=="CUSTOM_PATH" (
    echo(
    echo You selected to specify a custom Python path.
    echo(
    rem Prompt user for custom Python path
    set /p CHOSEN_PYTHON= ➡️ Enter the full path to python.exe:

    rem Validate custom Python path
    if not exist "%CHOSEN_PYTHON%" (
        echo Error: The specified python.exe does not exist.
        pause
        exit /b 1
    )

    rem Retrieve Python version for custom path
    for /f "tokens=1,2 delims= " %%i in ('"!CHOSEN_PYTHON!" --version 2^>nul') do (
        if "%%i"=="Python" (
            set "CHOSEN_VERSION=%%j"
        ) else (
            echo Error: The specified file is not a valid Python interpreter.
            pause
            exit /b 1
        )
    )
) else (
    rem Use selected Python path and version
    set "CHOSEN_PYTHON=!pythonPath[%selection%]!"
    set "CHOSEN_VERSION=!pythonVersion[%selection%]!"
)

rem Display selected Python interpreter
echo(
echo You selected: %CHOSEN_PYTHON%  (Python %CHOSEN_VERSION%)
echo(
REM Determine folder of chosen python.exe
for %%A in ("%CHOSEN_PYTHON%") do set "CHOSEN_PYDIR=%%~dpA"

REM Ask for environment name
set /p ENVNAME= ➡️ Name your virtual environment:
if "%ENVNAME%"=="" (
    echo You did not specify a valid environment name.
    pause
    exit /b 1
)

REM Ask for the venv install folder (or use default)
echo(
echo Default path to store is:
echo   %USERPROFILE%\Documents\PythonEnvs
echo(
set /p ENVDIR= ➡️ Enter path to store the venv (leave blank=default):
if "%ENVDIR%"=="" (
    set "ENVDIR=%USERPROFILE%\Documents\PythonEnvs"
)
if not exist "%ENVDIR%" (
    mkdir "%ENVDIR%"
)
set "VENV_PATH=%ENVDIR%\%ENVNAME%"

echo(
echo ......Creating virtual environment in:
echo   %VENV_PATH%

REM Check if environment folder already exists
if exist "%VENV_PATH%" (
    echo Error: The folder "%VENV_PATH%" already exists.
    echo Please choose a different environment name or delete the existing folder.
    pause
    exit /b 1
)

"%CHOSEN_PYTHON%" -m venv "%VENV_PATH%"
if errorlevel 1 (
    echo Failed to create virtual environment.
    pause
    exit /b 1
)

REM Ask if user wants to create a command shortcut
echo(
set /p CREATE_SHORTCUT= ➡️ Would you like a command line shortcut [Recommended]? (Y/N, default=Y):
if "%CREATE_SHORTCUT%"=="" set "CREATE_SHORTCUT=Y"
if /i "%CREATE_SHORTCUT%"=="N" goto SKIP_SHORTCUT

REM Ask for command name (default is environment name)
:ASK_CMDNAME
echo(
set /p CMDNAME= ➡️ Enter the command name (default=%ENVNAME%):
if "%CMDNAME%"=="" set "CMDNAME=%ENVNAME%"

REM Check for duplicate command name
where /q "%CMDNAME%" 2>nul
if %ERRORLEVEL%==0 (
    echo Error: A command named "%CMDNAME%" already exists on your PATH.
    echo Please choose a different command name.
    goto ASK_CMDNAME
)

REM ---------------------------------------------------------------------------
REM Create [CMDNAME].bat in the chosen Python directory
REM ---------------------------------------------------------------------------
set "ACTIVATE_BAT=%CHOSEN_PYDIR%%CMDNAME%.bat"

echo(
echo Creating activation script:
echo   %ACTIVATE_BAT%

(
    echo @echo off
    echo call "%VENV_PATH%\Scripts\activate"
) > "%ACTIVATE_BAT%"
echo(
echo  ✅ Command shortcut created successfully!

REM ---------------------------------------------------------------------------
REM NEW FEATURE: create a "path" directory under the venv + envname.txt inside
REM              containing full path to the shortcut .bat
REM ---------------------------------------------------------------------------
set "PATH_DIR=%VENV_PATH%\path"
if not exist "%PATH_DIR%" mkdir "%PATH_DIR%"

(
    echo %ACTIVATE_BAT%
) > "%PATH_DIR%\%ENVNAME%.txt"

goto CONTINUE_SCRIPT

:SKIP_SHORTCUT
echo Command shortcut creation skipped.

:CONTINUE_SCRIPT
echo(
echo  ✅ Done!!
echo(
echo To start using your new environment:
if /i not "%CREATE_SHORTCUT%"=="N" (
    echo   1. Navigate to:
    echo      "%CHOSEN_PYDIR%"
    echo   2. Run:  %CMDNAME%.bat
    echo   3. Your prompt should change, indicating it's active.
    echo   4. "python" and "pip" will now point to the venv.
) else (
    echo   1. Navigate to: "%VENV_PATH%\Scripts"
    echo   2. Run: activate.bat
    echo   3. Your prompt should change, indicating it's active.
    echo   4. "python" and "pip" will now point to the venv.
)
echo(
goto EXIT_SCRIPT


:DELETOR
@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem ============================================================
rem DeletePyEnvs.bat ― interactive venv & .bat remover (fixed)
rem Usage:
rem   DeletePyEnvs.bat                 ← scans "%USERPROFILE%\Documents\PythonEnvs"
rem   DeletePyEnvs.bat "D:\Other\Path" ← scans the folder you specify
rem ============================================================

rem 1. Determine root folder
if "%~1"=="" (
    set "ROOT=%USERPROFILE%\Documents\PythonEnvs"
) else (
    set "ROOT=%~1"
)
if not exist "%ROOT%" (
    echo [ERROR] Folder "%ROOT%" does not exist.
    goto :EXIT_SCRIPT
)
echo(
rem 2. Detect all venvs under ROOT
set "cnt=0"
for /D %%F in ("%ROOT%\*") do (
    if exist "%%F\Scripts\activate*" (
        set /A cnt+=1
        set "envName[!cnt!]=%%~nxF"
        set "envPath[!cnt!]=%%~fF"
    )
)
if "!cnt!"=="0" (
    echo No Python virtual environments found under "%ROOT%".
    goto :EXIT_SCRIPT
)

rem 3. List them with full paths
echo Available Python environments under: "%ROOT%"
echo(
for /L %%I in (1,1,!cnt!) do (
    call echo    [%%I] %%envName[%%I]%% (%%envPath[%%I]%%)
)

echo.
set /p "sel= ➡️ Which environment to delete: "
if "%sel%"=="0" (
    echo Operation cancelled.
    goto :EXIT_SCRIPT
)

rem 4. Validate selection
set "valid=0"
for /L %%I in (1,1,!cnt!) do if "%sel%"=="%%I" set "valid=1"
if "!valid!"=="0" (
    echo Invalid selection.
    goto :EXIT_SCRIPT
)

rem 5. Retrieve chosen env’s name & path
call set "TARGET_NAME=%%envName[%sel%]%%"
call set "TARGET_PATH=%%envPath[%sel%]%%"

echo.
echo Selected: %TARGET_NAME% (%TARGET_PATH%)
echo.

rem 6. Read .txt files and build a quoted list of .bat paths
set "TODELETE="
if exist "%TARGET_PATH%\path" (
    for %%T in ("%TARGET_PATH%\path\*.txt") do (
        for /f "usebackq delims=" %%L in ("%%~fT") do (
            rem show what we’re about to delete
            echo   *Will also delete the command shortcut
            rem accumulate each path in quotes, separated by space
            set "TODELETE=!TODELETE! "%%L""
        )
    )
) else (
    echo   [WARN] No 'path' directory found in this environment.
)

echo.
set /p "confirm= ⚠️ Sure to delete '%TARGET_NAME%'? [Y/N] "
if /I not "%confirm%"=="Y" (
    echo Deletion aborted.
    goto :EXIT_SCRIPT
)
echo(
rem 7. Loop over each quoted entry in TODELETE and delete it
for %%B in (!TODELETE!) do (
    rem %%~B removes surrounding quotes for commands
    if exist %%~B (
        del /f /q "%%~B" && echo   Deleted: %%~B
    ) else (
        echo   [WARN] Not found: %%~B
    )
)

echo(
rem 8. Finally remove the entire venv folder
rmdir /s /q "%TARGET_PATH%" && echo    ✅ Removed environment : %TARGET_NAME%

echo.
echo ✅ Done!!.
:EXIT_SCRIPT
endlocal
echo(
pause
exit /b 0
