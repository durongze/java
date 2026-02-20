@echo off
call :DetectJavaPath   JAVA_HOME

rem jar -tvf lib/selenium-server-4.4.0.jar

set PATH=%PATH%;%JAVA_HOME%\bin;
set CLASSPATH=%JAVA_HOME%\lib;%JAVA_HOME%\jre\lib\jrt-fs.jar;.

set base_dir=pic\
set pkg_name=mypkg

goto :bat_start

pause
goto :eof

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
goto :eof

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
goto :eof

:move_class
    set src_file=%1
    if not exist %pkg_name% ( mkdir %pkg_name% )
    setlocal ENABLEDELAYEDEXPANSION
    set obj_file=!src_file:~0,-4!class
    if exist !obj_file! (
        move !obj_file! %pkg_name%
    )
    endlocal
goto :eof

:compile_
    set src_file=%*
    echo src_file : %src_file%
    javac -encoding utf-8 -d . %src_file%
goto :eof

:compile_java
    set srcs=%*
    call :color_text 2F " +++++++++++++++ compile_java +++++++++++++++ "
    set idx=0
    for %%i in (%srcs%) do (
        set /a idx+=1
        set src_file=%%i
        echo [!idx!] src_file: !src_file!
        call :compile_ %%i
        if not %errorlevel% == 0 (
            echo [!idx!] javac -encoding utf-8 %%i fail.................................
            goto :eof
        ) else (
            call :move_class %%i
        )
    )
    call :color_text 2F " --------------- compile_java --------------- "
goto :eof

:execute_java
    set srcs=%*
    setlocal ENABLEDELAYEDEXPANSION
    call :color_text 2F " +++++++++++++++ execute_java +++++++++++++++ "
    set idx=0
    for %%i in (%srcs%) do (
        set /a idx+=1
        set src_file=%%i
        echo [!idx!] src_file: !src_file!
        set obj_name=!src_file:~0,-5!
        set obj_=!obj_name:%cd%\%base_dir%=!
        set pkg_=!obj_:\=.!
        java %pkg_name%.!pkg_!
        if not %errorlevel% == 0 (
            echo [!idx!] java %pkg_name%.!pkg_! fail.................................
            goto :eof
        ) 
    )
    call :color_text 2F " --------------- execute_java --------------- "
    endlocal
goto :eof

:set_all_file
    @rem del mypkg\*.class
    call :set_all_java  m_srcs
    echo m_srcs=%m_srcs%
    call :set_all_class m_objs
    echo m_objs=%m_objs%
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
    setlocal EnableDelayedExpansion
    set base_dir=%~1
    call :color_text 2F " +++++++++++++++ bat_main +++++++++++++++ "
    call :set_all_file
    call :compile_java %m_srcs%
    call :execute_java %m_srcs% 
    call :color_text 2F " --------------- bat_main --------------- "
    endlocal
goto :eof

:bat_test
    setlocal EnableDelayedExpansion
    pushd test\
        call build_email.bat
        call build_excel.bat
        call build_file.bat
        call build_web.bat
    popd
    endlocal
goto :eof

:bat_start
    setlocal EnableDelayedExpansion
    call :bat_main pic\
    @rem call:bat_main test\
    call :color_text 2F " +++++++++++++++ bat_start +++++++++++++++ "
    call :set_classpath CLASSPATH
    echo CLASSPATH:%class_path%
    call :bat_main test\
    call :color_text 2F " --------------- bat_start --------------- "
    endlocal
goto :eof

:DetectJavaPath
    setlocal EnableDelayedExpansion

    call :color_text 2f " ++++++++++++++++++ DetectJavaPath +++++++++++++++++++++++ "
    set VSDiskSet=C;D;E;F;G;

    set AllProgramsPathSet="program"
    set AllProgramsPathSet=%AllProgramsPathSet%;"programs"
    set AllProgramsPathSet=%AllProgramsPathSet%;"Program Files"
    set AllProgramsPathSet=%AllProgramsPathSet%;"Program Files (x86)"

    set JavaPathSet=%JavaPathSet%;"Java\jdk-1.8"
    set JavaPathSet=%JavaPathSet%;"Java\jdk-1.8.0_60"
    set JavaPathSet=%JavaPathSet%;"Java\jdk-12.0.2"
    set JavaPathSet=%JavaPathSet%;"Java\jdk-23"

    set idx_a=0
    for %%A in (!VSDiskSet!) do (
        set /a idx_a+=1
        set idx_b=0
        for %%B in (!AllProgramsPathSet!) do (
            set /a idx_b+=1
            set idx_c=0
            for %%C in (!JavaPathSet!) do (
                set /a idx_c+=1
                set CurJavaDirName=%%A:\%%~B\%%~C\
                echo [!idx_a!][!idx_b!][!idx_c!] !CurJavaDirName!
                if exist !CurJavaDirName! (
                    set JavaDirName=!CurJavaDirName!
                    goto :DetectJavaPathBreak
                )
            )
        )
    )
    :DetectJavaPathBreak
    echo Use:%JavaDirName%
    set PATH=%PATH%;%JavaDirName%\bin;
    java -version
    call :color_text 2f " -------------------- DetectJavaPath ----------------------- "
    endlocal & set "%~1=%JavaDirName%"
goto :eof

:BuildJavaProj
    setlocal EnableDelayedExpansion
    set ProjDir=%~1

    call :color_text 2f " +++++++++++++++++++ BuildJavaProj +++++++++++++++++++ "

    call :DetectJavaPath   JAVA_HOME
    set PATH=%JAVA_HOME%\bin;%PATH%;
	
	pushd %ProjDir%
        javac -encoding utf-8 -d . callc.java
        javap -s com.durongze.jni.CallC
        rem javah -jni com.durongze.jni.CallC
        javac -encoding utf-8 -h . callc.java
    popd

    call :color_text 2f " ------------------- BuildJavaProj ------------------- "

    endlocal
goto :eof