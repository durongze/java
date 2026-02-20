set proj_name=FileList
set proj_dir=%cd%
set all_jar=%proj_dir%\lib\selenium-server-standalone-3.141.59.jar

set PATH=%PATH%;%JAVA_HOME%\bin;

set CLASSPATH=%CLASSPATH%;%all_jar%;

:bat_start
    call:color_text 4e " +++++++++++++++ bat_start +++++++++++++++ "
    javac  -encoding utf-8 -d . -classpath %all_jar% %proj_name%.java
    mkdir com\durongze
    move %proj_name%.class com\durongze
    call:color_text 4e " --------------- bat_start --------------- "
    java com.durongze.%proj_name%
goto :eof

:color_text
    setlocal EnableDelayedExpansion
    for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
        set "DEL=%%a"
    )
    echo off
    <nul set /p ".=%DEL%" > "%~2"
    findstr /v /a:%1 /R "^$" "%~2" nul
    del "%~2" > nul 2>&1
    endlocal
    echo .
goto :eof

call:bat_start
pause