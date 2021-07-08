@echo off

set JAVA_HOME=D:\Program Files\Java\jdk-12.0.2
set PATH=%PATH%;%JAVA_HOME%\bin;
set CLASSHOME=%JAVA_HOME%\lib;%JAVA_HOME%\jre\lib\jrt-fs.jar;.

set base_dir=.

setlocal ENABLEDELAYEDEXPANSION
for /f %%i in ( 'dir /b ".\*.java"' ) do (
    javac -encoding utf-8 -h . %%i
    if not %errorlevel% == 0 (
        goto proc_err
    ) else (
        if not exist mypkg ( md mypkg )
        move *.class mypkg
        echo %%i succ.................................
    )
)
endlocal
rem java mypkg.SocketServer

:proc_err