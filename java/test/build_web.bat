set proj_name=Web
set proj_dir=%cd%
set all_jar=%proj_dir%\lib\selenium-server-standalone-3.141.59.jar
set all_jar=%all_jar%;%proj_dir%\lib\poi-4.1.1.jar
set all_jar=%all_jar%;%proj_dir%\lib\poi-examples-4.1.1.jar
set all_jar=%all_jar%;%proj_dir%\lib\poi-excelant-4.1.1.jar
set all_jar=%all_jar%;%proj_dir%\lib\poi-ooxml-4.1.1.jar
set all_jar=%all_jar%;%proj_dir%\lib\poi-ooxml-schemas-4.1.1.jar
set all_jar=%all_jar%;%proj_dir%\lib\poi-scratchpad-4.1.1.jar
set all_jar=%all_jar%;%proj_dir%\lib\selenium-server-standalone-3.141.59.jar
set all_jar=%all_jar%;%proj_dir%\lib\lib\activation-1.1.1.jar
set all_jar=%all_jar%;%proj_dir%\lib\lib\commons-codec-1.13.jar
set all_jar=%all_jar%;%proj_dir%\lib\lib\commons-collections4-4.4.jar
set all_jar=%all_jar%;%proj_dir%\lib\lib\commons-compress-1.19.jar
set all_jar=%all_jar%;%proj_dir%\lib\lib\commons-logging-1.2.jar
set all_jar=%all_jar%;%proj_dir%\lib\lib\commons-math3-3.6.1.jar
set all_jar=%all_jar%;%proj_dir%\lib\lib\jaxb-api-2.3.1.jar
set all_jar=%all_jar%;%proj_dir%\lib\lib\jaxb-core-2.3.0.1.jar
set all_jar=%all_jar%;%proj_dir%\lib\lib\jaxb-impl-2.3.2.jar
set all_jar=%all_jar%;%proj_dir%\lib\lib\junit-4.12.jar
set all_jar=%all_jar%;%proj_dir%\lib\lib\log4j-1.2.17.jar
set all_jar=%all_jar%;%proj_dir%\lib\ooxml-lib\curvesapi-1.06.jar
set all_jar=%all_jar%;%proj_dir%\lib\ooxml-lib\xmlbeans-3.1.0.jar

set PATH=%PATH%;%JAVA_HOME%\bin;

set CLASSPATH=%CLASSPATH%;%all_jar%;

:bat_start
    javac -classpath %all_jar% %proj_name%.java
    mkdir com\durongze\
    move %proj_name%.class com/durongze/
    call:color_text 4e "+++++++++++++++java+++++++++++++"
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