@echo off

set JAVA_HOME=D:\Program Files\Java\jdk-12.0.2
set PATH=%PATH%;%JAVA_HOME%\bin;
set CLASSHOME=%JAVA_HOME%\lib;%JAVA_HOME%\jre\lib\jrt-fs.jar;.

set base_dir=base

setlocal ENABLEDELAYEDEXPANSION
for /f %%i in ( 'dir /s /b "%base_dir%\*.java"' ) do (
    set src_file=%%i
    javac -encoding utf-8 -h . !src_file!
    if not %errorlevel% == 0 (
        goto proc_err
    ) else (
        if not exist mypkg ( md mypkg )
        set obj_file=!src_file:~0,-4!class
        move !obj_file! mypkg
        echo %%i succ.................................
    )
)
endlocal
rem java mypkg.SocketServer

:proc_err