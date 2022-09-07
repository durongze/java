@echo off

rem jar -tvf lib/selenium-server-4.4.0.jar

rem set JAVA_HOME=D:\Programs\jdk-13
rem set CLASSPATH=%JAVA_HOME%\lib;%JAVA_HOME%\lib\jrt-fs.jar;.
rem set PATH=%PATH%;%JAVA_HOME%\bin
set JAVA_HOME=D:\Program Files\Java\jdk-12.0.2
set PATH=%PATH%;%JAVA_HOME%\bin;
set CLASSPATH=%JAVA_HOME%\lib;%JAVA_HOME%\jre\lib\jrt-fs.jar;.

set base_dir=pic\
set pkg_name=mypkg

goto:bat_start

:set_all_class
    setlocal ENABLEDELAYEDEXPANSION
    set objs1=
    for /f %%i in ('dir /s /b "%base_dir%\*.java"') do (
        set src_file=%%i
        set obj_file=!src_file:~0,-4!class
        set objs1=!objs1! !obj_file!
    )
    echo objs : %objs1%
    endlocal & set "%~1=%objs1%"
goto:eof

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

:move_class
    set src_file=%1
    if not exist %pkg_name% ( mkdir %pkg_name% )
    setlocal ENABLEDELAYEDEXPANSION
    set obj_file=!src_file:~0,-4!class
    if exist !obj_file! (
        move !obj_file! %pkg_name%
    )
    endlocal
goto:eof

:compile_
    set src_file=%*
    echo src_file : %src_file%
    javac -encoding utf-8 -d . %src_file%
goto:eof

:compile_java
    set srcs=%*
    for %%i in (%srcs%) do (
        call:compile_ %%i
        if not %errorlevel% == 0 (
            echo javac -encoding utf-8 %%i fail.................................
            goto:eof
        ) else (
            call:move_class %%i
        )
    )
goto:eof

:execute_java
    set srcs=%*
    setlocal ENABLEDELAYEDEXPANSION
    for %%i in (%srcs%) do (
        set src_file=%%i
        echo src_file: !src_file!
        set obj_name=!src_file:~0,-5!
        set obj_=!obj_name:%cd%\%base_dir%=!
        set pkg_=!obj_:\=.!
        java %pkg_name%.!pkg_!
        if not %errorlevel% == 0 (
            echo java %pkg_name%.!pkg_! fail.................................
            goto:eof
        ) 
    )
    endlocal
goto:eof

:set_all_file
    @rem del mypkg\*.class
    call:set_all_java m_srcs
    echo m_srcs %m_srcs%
    call:set_all_class m_objs
    echo m_objs %m_objs%
goto:eof

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

:set_classpath
    set proj_dir=%cd%\test\lib
    setlocal ENABLEDELAYEDEXPANSION
    set libjar=%CLASSPATH%;.
    for /f %%i in ('dir /s /b "%proj_dir%\*.jar"') do (
        set jar_file=%%i
        set libjar=!libjar!;!jar_file!
    )
    echo libjar : %libjar%
    endlocal & set "%~1=%libjar%"
goto :eof

:bat_main
    set base_dir=%1
    call:color_text 4e "+++++++++++++++start+++++++++++++"
    call:set_all_file

    call:color_text 19 "+++++++++++++++compile srcs+++++++++++++"
    call:compile_java %m_srcs%
 
    call:color_text 2F "---------------execute srcs-------------"
    call:execute_java %m_srcs% 
goto :eof

:bat_test
    pushd test\
    call build_email.bat
    call build_excel.bat
    call build_file.bat
    call build_web.bat
    popd
goto :eof

:bat_start
    call:bat_main pic\
    @rem call:bat_main test\
    call:color_text 2F "---------------class_path-------------"
    call:set_classpath CLASSPATH
    echo CLASSPATH:%class_path%
    call:bat_main test\
goto :eof

:bat_end
    pause