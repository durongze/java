@echo off
call :DetectJavaPath   JAVA_HOME

set PATH=%PATH%;%JAVA_HOME%\bin;
set CLASSHOME=%JAVA_HOME%\lib;%JAVA_HOME%\jre\lib\jrt-fs.jar;.

set base_dir=

goto :bat_main

pause
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
goto :eof

:bat_main
    set base_dir=pic
    call :color_text 4e "+++++++++++++++ bat_main +++++++++++++"
    call :set_all_java  m_srcs
    
    call :compile_java %m_srcs%
 
    javac -encoding utf-8 -h . test\MakeAnimatedGifEncoder.java
    move test\*.class mypkg\
    @rem xcopy /s/e res mypkg\
    xcopy /e/h/q/y res mypkg\
    java mypkg.MakeAnimatedGifEncoder
    call :color_text 2F " -------------- bat_main ------------- "
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

@rem YellowBackground    6f  ef
@rem BlueBackground      9f  bf   3f
@rem GreenBackground     af  2f
@rem RedBackground       4f  cf
@rem GreyBackground      7f  8f
@rem PurpleBackground    5f

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
