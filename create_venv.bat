@echo off 
REM ---------------------------------------------------------------------------- 
REM Script: create_venv.bat 
REM Description: 
REM   1. Finds Python interpreters via 'where python'. 
REM   2. Lets user pick which Python to use (including manual path option). 
REM   3. Prompts for venv name & folder. 
REM   4. Creates the venv only if folder doesn't exist.
REM   5. Prompts for command name (defaults to envname).
REM   6. Generates [command].bat in the same directory as that Python.exe. 
REM      This .bat file: 
REM         a) Checks if the chosen Python directory is in PATH (via find). 
REM         b) Appends it if missing. 
REM         c) Activates the venv. 
REM ---------------------------------------------------------------------------- 
setlocal enabledelayedexpansion 
echo( 
echo ================================================== 
echo  Searching for all "python.exe" on this system... 
echo ================================================== 
echo( 
set /a index=0 
for /f "delims=" %%p in ('where python 2^>nul') do ( 
    REM Grab the Python version string 
    for /f "tokens=1,2 delims= " %%i in ('"%%p" --version 2^>nul') do ( 
        if "%%i"=="Python" ( 
            set "version=%%j" 
        ) 
    ) 
    set /a index=!index! + 1 
    set "pythonPath[!index!]=%%p" 
    set "pythonVersion[!index!]=!version!" 
) 

REM Always add an option to manually specify a Python path
set /a index=!index! + 1
set "pythonPath[!index!]=CUSTOM_PATH"
set "pythonVersion[!index!]=Custom"

echo Found the following Python interpreters: 
echo( 
set /a i=1 
:LIST_PYTHONS 
if %i% GTR %index% goto LIST_DONE 
if "!pythonPath[%i%]!"=="CUSTOM_PATH" (
    echo  %i%. [Custom] Specify a different Python path
) else (
    echo  %i%. [!pythonVersion[%i%]!]  !pythonPath[%i%]! 
)
set /a i+=1 
goto LIST_PYTHONS 
:LIST_DONE 
echo( 
set /p selection=Enter the number corresponding to the Python you want to use:  
if %selection% LSS 1 ( 
    echo Invalid choice: out of range. 
    pause 
    exit /b 1 
) 
if %selection% GTR %index% ( 
    echo Invalid choice: out of range. 
    pause 
    exit /b 1 
) 

if "!pythonPath[%selection%]!"=="CUSTOM_PATH" (
    echo(
    echo You selected to specify a custom Python path.
    echo(
    set /p CHOSEN_PYTHON=Enter the full path to python.exe:  
    
    if not exist "%CHOSEN_PYTHON%" (
        echo Error: The specified python.exe does not exist.
        pause
        exit /b 1
    )
    
    REM Grab the Python version string for the custom path
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
    set "CHOSEN_PYTHON=!pythonPath[%selection%]!" 
    set "CHOSEN_VERSION=!pythonVersion[%selection%]!" 
)

echo( 
echo You selected: %CHOSEN_PYTHON%  (Python %CHOSEN_VERSION%) 
echo( 

REM Determine folder of chosen python.exe 
for %%A in ("%CHOSEN_PYTHON%") do set "CHOSEN_PYDIR=%%~dpA" 

REM Ask for environment name 
set /p ENVNAME=Enter a name for your virtual environment:  
if "%ENVNAME%"=="" ( 
    echo You did not specify a valid environment name. 
    pause 
    exit /b 1 
) 
REM Ask for the venv install folder (or use default) 
echo( 
echo If you just press [Enter], the default path is: 
echo   %USERPROFILE%\Documents\PythonEnvs 
echo( 
set /p ENVDIR=Enter path to store the venv (or leave blank for default):  
if "%ENVDIR%"=="" ( 
    set "ENVDIR=%USERPROFILE%\Documents\PythonEnvs" 
) 
if not exist "%ENVDIR%" ( 
    mkdir "%ENVDIR%" 
) 
set "VENV_PATH=%ENVDIR%\%ENVNAME%" 
echo( 
echo Creating virtual environment in: 
echo   %VENV_PATH% 
echo( 

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
set /p CREATE_SHORTCUT=Would you like to create a command line shortcut? (Y/N, default=Y):  
if /i "%CREATE_SHORTCUT%"=="N" goto SKIP_SHORTCUT

REM Ask for command name (default is environment name)
echo(
echo Enter the command name for activating this environment.
echo If you just press [Enter], the default name will be: %ENVNAME%
echo(
set /p CMDNAME=Command name:  
if "%CMDNAME%"=="" (
    set "CMDNAME=%ENVNAME%"
)

REM Now generate [cmdname].bat in the chosen Python folder 
set "ACTIVATE_BAT=%CHOSEN_PYDIR%%CMDNAME%.bat" 
echo( 
echo Creating activation script: 
echo   %ACTIVATE_BAT% 
echo( 
 
( 
    echo @echo off 
    echo rem Ensure the chosen Python directory is in PATH ^(if missing^) 
    echo echo %%PATH%% ^| find /i "%CHOSEN_PYDIR%" ^>nul 2^>nul 
    echo if errorlevel 1 ^( 
    echo     set PATH=%CHOSEN_PYDIR%%%%%PATH%%%% 
    echo ^) 
    echo rem Now activate the virtual environment 
    echo call "%VENV_PATH%\Scripts\activate" 
) > "%ACTIVATE_BAT%" 

echo(
echo Command shortcut created successfully!
goto CONTINUE_SCRIPT

:SKIP_SHORTCUT
echo(
echo Command shortcut creation skipped.

:CONTINUE_SCRIPT
echo Done! 
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
endlocal 
pause 
exit /b 0
