@echo off
rem ============================================================
rem  CheckPyEnvs.bat ― list virtual‑env folders under a target
rem  Usage:
rem     CheckPyEnvs.bat               ← scans "%USERPROFILE%\Documents\PythonEnvs"
rem     CheckPyEnvs.bat  "D:\path"    ← scans the folder you specify
rem ------------------------------------------------------------
rem  Criteria for a virtual‑env folder:
rem     <candidate>\Scripts\activate*   OR
rem     <candidate>\Script\activate*
rem ============================================================

setlocal EnableExtensions EnableDelayedExpansion

rem --- 1. Determine the root to scan --------------------------
if "%~1"=="" (
    set "ROOT=%USERPROFILE%\Documents\PythonEnvs"
) else (
    set "ROOT=%~1"
)

if not exist "%ROOT%" (
    echo   [ERROR] Folder "%ROOT%" does not exist.
    goto :EOF
)

echo   Scanning: "%ROOT%"
echo   --------------------------------------------------------

rem --- 2. Examine each direct child directory ----------------
for /D %%F in ("%ROOT%\*") do (
    rem Look for Scripts\activate*  or Script\activate*
    set "CAND=%%~fF"
    if exist "!CAND!\Scripts\activate*" (
        echo   [VENV] %%~nxF
        rem Check for path folder and extensionless file
        if exist "!CAND!\path" (
            for %%P in ("!CAND!\path\*") do (
                set "FNAME=%%~nxP"
                set "FEXT=%%~xP"
                if "!FEXT!"=="" (
                    echo      [PATH FILE] !FNAME!
                )
            )
        )
    )
)

echo   --------------------------------------------------------
echo   Scan complete.
endlocal
