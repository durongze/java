@rem set VSCMD_DEBUG=2
@rem %comspec% /k "F:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"

call :DetectVsPath     VisualStudioCmd
call :DetectProgramDir ProgramDir
call :DetectAndroidDir AndroidDir

echo ProgramDir=%ProgramDir%
echo AndroidDir=%AndroidDir%


set PERL5LIB=%PERL5LIB%
set PerlPath=%ProgramDir%\Perl\bin
set TclshPath=%ProgramDir%\tcl\bin
set NASMPath=%ProgramDir%\nasm\bin
set YASMPath=%ProgramDir%\yasm\bin
set GPERFPath=%ProgramDir%\gperf\bin
set CMakePath=%ProgramDir%\cmake\bin
set SDCCPath=%ProgramDir%\SDCC\bin
set MakePath=%ProgramDir%\make-3.81-bin\bin
set PythonHome=%ProgramDir%\python\Python312
set PYTHONPATH=%PYTHONHOME%\lib;%PythonHome%;
set SwigHome=%ProgramDir%\swigwin\bin
set PATH=%NASMPath%;%YASMPath%;%GPERFPath%;%PerlPath%;%CMakePath%;%SDCCPath%;%MakePath%;%PYTHONHOME%;%PYTHONHOME%\Scripts;%SwigHome%;%PATH%

set MakeProgram=%MakePath%\make.exe

call :TaskKillSpecProcess  "cl.exe"
call :TaskKillSpecProcess  "MSBuild.exe"

chcp 65001

rem set JAVA_HOME=%ProgramDir%\Java\jdk1.8.0_60
rem set JAVA_HOME=%ProgramDir%\Java\jdk-12.0.2
set JAVA_HOME=%ProgramDir%\Java\jdk-1.8

set PATH=%PATH%;%JAVA_HOME%\bin;

set PATH=%PATH%;%AndroidDir%\sdk\ndk-bundle\android-ndk-r20
set PATH=%PATH%;%AndroidDir%\ndk\android-ndk-r19c

java -version
rem ndk-build NDK_PROJECT_PATH=. NDK_APPLICATION_MK=Application.mk APP_BUILD_SCRIPT=Android.mk


@rem x86  or x64
call "%VisualStudioCmd%" x86

call "%QtEnvBat%"

pushd %CurDir%

@rem Win32  or x64
set ArchType=x64

set BuildDir=BuildLib
set BuildType=Debug

set ProjName=CLibrary
@rem call :get_suf_sub_str %ProjDir% \ ProjName

set HomeDir=%ProjDir%\out\windows

javac -encoding utf-8 -d . callc.java
javap -s com.durongze.jni.CallC
rem javah -jni com.durongze.jni.CallC
javac -encoding utf-8 -h . callc.java

rem ndk-build NDK_PROJECT_PATH=. NDK_APPLICATION_MK=Application.mk APP_BUILD_SCRIPT=Android.mk

call :CompileProject "%BuildDir%" "%BuildType%" "%ProjName%" "%HomeDir%"

rem del "%JAVA_HOME%\bin\CLibrary.dll"
for /f %%i in ('dir /s /b "*.dll"') do (copy %%i .\)
del                   "%JAVA_HOME%\bin\CLibrary.dll"
copy ".\CLibrary.dll" "%JAVA_HOME%\bin\CLibrary.dll"

java com.durongze.jni.CallC

pause
goto :eof

:BuildAndroidProj
    setlocal EnableDelayedExpansion
    set ProjDir=%~1
    set ProgramDir=%ProgramDir%
    set AndroidDir=%AndroidDir%
    call :color_text 2f " +++++++++++++++++++ FuncBuildAndroidProj +++++++++++++++++++ "

    @rem set JAVA_HOME=%ProgramDir%\Java\jdk-12.0.2
    @rem set JAVA_HOME=%ProgramDir%\Java\jdk-23
    set JAVA_HOME=%ProgramDir%\Java\jdk-1.8

    set PATH=%JAVA_HOME%\bin;%PATH%;

    set PATH=%AndroidDir%\ndk\25.1.8937393;%PATH%;
    @rem set PATH=E:\program\android-ndk-r26b;%PATH%;
    set PATH=%AndroidDir%\sdk\ndk-bundle\android-ndk-r20;%PATH%;

    @rem set PATH=%AndroidDir%\ndk\android-ndk-r19c;%PATH%;

    java  -version
    javac -version

    pushd %ProjDir%
        @rem must be call xxx
        call ndk-build    NDK_PROJECT_PATH=.    NDK_APPLICATION_MK=Application.mk    APP_BUILD_SCRIPT=Android.mk
    popd

    call :color_text 2f " ------------------- FuncBuildAndroidProj ------------------- "

    endlocal
goto :eof

:MainStart
    setlocal EnableDelayedExpansion
    call :color_text 2f " +++++++++++++++++++ FuncBuildAndroidProj +++++++++++++++++++ "
    call :BuildAndroidProj "."
    call :color_text 2f " ------------------- FuncBuildAndroidProj ------------------- "
    endlocal
goto :eof



:DetectProgramDir
    setlocal EnableDelayedExpansion
    @rem SkySdk\VS2005\VC
    set SkySdkDiskSet=C;D;E;F;G;
    set CurProgramDir=
    set idx=0
    call :color_text 2f " +++++++++++++++++++ DetectProgramDir +++++++++++++++++++++++ "
    for %%i in (%SkySdkDiskSet%) do (
        set /a idx+=1
        for /f "tokens=1-2 delims=|" %%B in ("programs|program") do (
            set CurProgramDir=%%i:\%%B
            echo [!idx!] !CurProgramDir!
            if exist !CurProgramDir!\SkySdk (
                set ProgramDir=!CurProgramDir!
                goto :DetectProgramDirBreak
            )
            set CurProgramDir=%%i:\%%C
            echo [!idx!] !CurProgramDir!
            if exist !CurProgramDir!\SkySdk (
                set ProgramDir=!CurProgramDir!
                goto :DetectProgramDirBreak
            )
        )
    )
    :DetectProgramDirBreak
    echo Use:%ProgramDir%
    call :color_text 2f " ------------------- DetectProgramDir ----------------------- "
    endlocal & set %~1=%ProgramDir%
goto :eof

:DetectVsPath
    setlocal EnableDelayedExpansion
    set VsBatFileVar=%~1
    call :color_text 2f " ++++++++++++++++++ DetectVsPath +++++++++++++++++++++++ "
    set VSDiskSet=C;D;E;F;G;

    set AllProgramsPathSet="program"
    set AllProgramsPathSet=%AllProgramsPathSet%;"programs"
    set AllProgramsPathSet=%AllProgramsPathSet%;"Program Files"
    set AllProgramsPathSet=%AllProgramsPathSet%;"Program Files (x86)"

    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2019\Professional\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"VS2022\VC\Auxiliary\Build"
    set VCPathSet=%VCPathSet%;"SkySdk\VS2005\VC"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 8\VC"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 12.0\VC\bin"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 14.0\VC\bin"

    set idx_a=0
    for %%A in (!VSDiskSet!) do (
        set /a idx_a+=1
        set idx_b=0
        for %%B in (!AllProgramsPathSet!) do (
            set /a idx_b+=1
            set idx_c=0
            for %%C in (!VCPathSet!) do (
                set /a idx_c+=1
                set CurBatFile=%%A:\%%~B\%%~C\vcvarsall.bat
                echo [!idx_a!][!idx_b!][!idx_c!] !CurBatFile!
                if exist !CurBatFile! (
                    set VsVcBatFile=!CurBatFile!
                    goto :DetectVsPathBreak
                )
            )
        )
    )
    :DetectVsPathBreak
    echo Use:%VsVcBatFile%
    call :color_text 2f " -------------------- DetectVsPath ----------------------- "
    endlocal & set "%~1=%VsVcBatFile%"
goto :eof

:DetectAndroidDir
    setlocal EnableDelayedExpansion
    @rem SkySdk\VS2005\VC
    set SkySdkDiskSet=C;D;E;F;G;
    set CurAndroidDir=
    set idx=0
    call :color_text 2f " +++++++++++++++++++ DetectAndroidDir +++++++++++++++++++++++ "
    for %%i in (%SkySdkDiskSet%) do (
        set /a idx+=1
        for /f "tokens=1-2 delims=|" %%B in ("AndroidSdk|Android") do (
            set CurAndroidDir=%%i:\%%B
            echo [!idx!] !CurAndroidDir!
            if exist !CurAndroidDir!\ndk (
                goto :DetectAndroidDirBreak
            )
            set CurAndroidDir=%%i:\%%C
            echo [!idx!] !CurAndroidDir!
            if exist !CurAndroidDir!\ndk (
                goto :DetectAndroidDirBreak
            )
        )
    )
    :DetectAndroidDirBreak
    set AndroidDir=!CurAndroidDir!
    call :color_text 2f " ------------------- DetectAndroidDir ----------------------- "
    endlocal & set %~1=%AndroidDir%
goto :eof

:CompileProject
    setlocal EnableDelayedExpansion
    set BuildDir=%~1
    set BuildType=%~2
    set ProjName=%~3
    set LibHomeDir=%~4
    call :color_text 2f " +++++++++++++++++++ CompileProject +++++++++++++++++++++++ "
    if not exist CMakeLists.txt (
        echo CMakeLists.txt doesn't exist!
        goto :eof
    )
    if not exist %BuildDir% (
        mkdir %BuildDir%
    )
    if not exist %BuildDir%\%BuildType% (
        mkdir %BuildDir%\%BuildType%\
    )
    if exist "%LibHomeDir%" (
        echo search dll ....
        for /f %%i in ('dir /s /b "%LibHomeDir%\*.dll"') do (
            copy %%i %BuildDir%\%BuildType%\ 
            copy %%i %BuildDir%\%BuildType%\..
        )
    )
    pushd %BuildDir%
        set ALL_DEFS=            -DCMAKE_TOOLCHAIN_FILE="../toolchain.cmake" -DCMAKE_MAKE_PROGRAM="%MakeProgram%"           -DCMAKE_C_COMPILER_WORKS=ON
        set ALL_DEFS=            -DCMAKE_BUILD_TYPE=%BuildType%              -DCMAKE_INSTALL_PREFIX=%LibHomeDir%\%ProjName%
        set ALL_DEFS=%ALL_DEFS%  -DDYZ_DBG=ON

        @rem del * /q /s
        @rem cmake .. -G "Visual Studio 16 2019" -A  %ArchType%
        @rem cmake .. -G "Visual Studio 17 2022" -A  %ArchType%
        @rem cmake    -G "Visual Studio 8  2005"     ..
        @rem cmake --build . --target clean
        cmake ..  %ALL_DEFS%  -A %ArchType%
        @rem cmake      ..  %ALL_DEFS%  -G "NMake Makefiles" 
        @rem call :ResetSystemEnv
        @rem cmake --build .  --config %BuildType%  --target %ProjName%
        cmake --build . -j16  --config %BuildType% --target CppCallJni
        Debug\CppCallJni.exe
        dumpbin /dependents Debug\CppCallJni.exe
    popd
    echo "调试时如果报异常，记得不要点击中断，要点击继续"
    call :color_text 2f " ------------------- CompileProject ----------------------- "
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