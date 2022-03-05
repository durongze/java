@echo off

set JAVA_HOME=D:\Program Files\Java\jdk-12.0.2
set PATH=%PATH%;%JAVA_HOME%\bin;
set CLASSHOME=%JAVA_HOME%\lib;%JAVA_HOME%\jre\lib\jrt-fs.jar;.

set base_dir=
goto:bat_main

:set_all_java
    setlocal ENABLEDELAYEDEXPANSION
    set srcs1=
    set srcs2=
    for /f %%i in ('dir /s /b "%base_dir%\*.java"') do (
        set src=%%i
        set srcs1=%srcs1% %src%
        set srcs2=!srcs2! !src!
    )
    echo srcs1 : %srcs1%
    echo srcs2 : !srcs2!
    endlocal & set "%~1=%srcs2%"
goto:eof

:execute_java
    set all_java=%*
    setlocal ENABLEDELAYEDEXPANSION
    for /f %%i in ( %all_java% ) do (
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
goto:eof

:bat_main
    set base_dir=pic
    call:color_text 4e "+++++++++++++++start+++++++++++++"
    call:set_all_java m_srcs
    
    call:color_text 19 "+++++++++++++++compile srcs+++++++++++++"
    call:compile_java %m_srcs%
 
    call:color_text 2F "---------------execute srcs-------------"
    javac -encoding utf-8 -h . test\MakeAnimatedGifEncoder.java
    move test\*.class mypkg\
    @rem xcopy /s/e res mypkg\
    xcopy /e/h/q/y res mypkg\
    java mypkg.MakeAnimatedGifEncoder
goto:eof



