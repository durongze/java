@rem set VSCMD_DEBUG=2
@rem %comspec% /k "F:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"

call :DetectVsPath     VisualStudioCmd
call :DetectProgramDir ProgramDir
call :DetectQtDir      QtEnvBat          QtMsvcPath
call :DetectAndroidDir AndroidDir

echo ProgramDir=%ProgramDir%
echo AndroidDir=%AndroidDir%

set CurDir=%~dp0
set ProjDir=%CurDir:~0,-1%
set software_dir="%ProjDir%\thirdparty"
set HomeDir=%ProjDir%\out\windows

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


pause
chcp 65001

@rem x86  or x64
call "%VisualStudioCmd%" x64

call "%QtEnvBat%"

pushd %CurDir%

@rem Win32  or x64
set ArchType=x64

set BuildDir=BuildLib
set BuildType=Debug

set ProjName=CppCallJni
@rem call :get_suf_sub_str %ProjDir% \ ProjName

call :BuildJavaProj     %CurDir%

call :BuildAndroidProj  %CurDir%

call :CompileProject "%BuildDir%" "%BuildType%" "%ProjName%" "%HomeDir%"

@rem %QtMsvcPath%\bin\windeployqt6.exe %BuildDir%\%BuildType%\%ProjName%.exe

pause
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

:BuildAndroidProj
    setlocal EnableDelayedExpansion
    set ProjDir=%~1
    set ProgramDir=%ProgramDir%
    set AndroidDir=%AndroidDir%
    call :color_text 2f " +++++++++++++++++++ BuildAndroidProj +++++++++++++++++++ "

    call :DetectJavaPath   JAVA_HOME
    set PATH=%JAVA_HOME%\bin;%PATH%;

    call :DetectAndroidDir AndroidDir
    set PATH=%AndroidDir%\ndk\android-ndk-r19c;%PATH%;
    set PATH=%AndroidDir%\ndk\25.1.8937393;%PATH%;
    set PATH=%AndroidDir%\ndk-bundle\android-ndk-r20;%PATH%;

    java  -version
    javac -version

    pushd %ProjDir%
        @rem must be call xxx
        call ndk-build    NDK_PROJECT_PATH=.    NDK_APPLICATION_MK=Application.mk    APP_BUILD_SCRIPT=Android.mk
    popd

    call :color_text 2f " ------------------- BuildAndroidProj ------------------- "

    endlocal
goto :eof

:MainStart
    setlocal EnableDelayedExpansion
    call :color_text 2f " +++++++++++++++++++ MainStart +++++++++++++++++++ "
    call :BuildAndroidProj "."
    call :color_text 2f " ------------------- MainStart ------------------- "
    endlocal
goto :eof

:DetectQtDir
    setlocal EnableDelayedExpansion
    @rem call "C:\Qt\6.5.2\msvc2019_64\bin\qtenv2.bat"
    @rem call "C:\Qt\6.6.0\msvc2019_64\bin\qtenv2.bat"
    @rem call "C:\Qt\6.9.0\msvc2022_64\bin\qtenv2.bat"
    @rem call "D:/Qt/Qt5.12.0/5.12.0/msvc2017_64/bin/qtenv2.bat"
    @rem call "D:\Qt\Qt5.14.2\5.14.2\msvc2017_64\bin\qtenv2.bat"

    set VsBatFileVar=%~1
    call :color_text 2f " ++++++++++++++++++ DetectQtDir +++++++++++++++++++++++ "
    set VSDiskSet=C;D;E;F;G;

    set QtPathSet="Qt"

    set QtVerSet=%QtVerSet%;"6.5.2"
    set QtVerSet=%QtVerSet%;"6.6.0"
    set QtVerSet=%QtVerSet%;"6.9.0"
    set QtVerSet=%QtVerSet%;"Qt5.12.0\5.12.0"
    set QtVerSet=%QtVerSet%;"Qt5.14.2\5.14.2"

    set QtMsvcSet=%QtMsvcSet%;"msvc2017_64"
    set QtMsvcSet=%QtMsvcSet%;"msvc2019_64"
    set QtMsvcSet=%QtMsvcSet%;"msvc2022_64"

    set idx_a=0
    for %%A in (!VSDiskSet!) do (
        set /a idx_a+=1
        set idx_b=0
        for %%B in (!QtPathSet!) do (
            set /a idx_b+=1
            set idx_c=0
            for %%C in (!QtVerSet!) do (
                set /a idx_c+=1
                for %%D in (!QtMsvcSet!) do (
                    set /a idx_d+=1
                    set CurQtEnvBatFile=%%A:\%%~B\%%~C\%%~D\bin\qtenv2.bat
                    set CurQtMsvcPath=%%A:\%%~B\%%~C\%%~D
                    echo [!idx_a!][!idx_b!][!idx_c!][!idx_d!] !CurQtEnvBatFile!
                    if exist !CurQtEnvBatFile! (
                        set QtEnvBatFile=!CurQtEnvBatFile!
                        set QtMsvcPath=!CurQtMsvcPath!
                        goto :DetectQtEnvPathBreak
                    )
                )
            )
        )
    )
    :DetectQtEnvPathBreak
    echo Use:%QtEnvBatFile%
    call :color_text 2f " ------------------ DetectQtDir ----------------------- "
    endlocal & set "%~1=%QtEnvBatFile%"& set "%~2=%QtMsvcPath%"
goto :eof

:GenQtIncDirOpts
    setlocal EnableDelayedExpansion

    set QtMsvcPath=%~1
    set OptIncFlag=%~2

    call :color_text 2f " ++++++++++++++++++ GenQtIncDirOpts +++++++++++++++++++++++ "

    set QtMsvcSet=%QtMsvcSet%;"msvc2017_64"
    set QtMsvcSet=%QtMsvcSet%;"msvc2019_64"
    set QtMsvcSet=%QtMsvcSet%;"msvc2022_64"

    if "%OptIncFlag%"=="1" (
        set OptIncFlag=-I
    ) else (
        set OptIncFlag=/external:I 
    )

    set QtMsvcIncDirs=%QtMsvcIncDirs%  %OptIncFlag%  %QtMsvcPath%/include 
    set QtMsvcIncDirs=%QtMsvcIncDirs%  %OptIncFlag%  %QtMsvcPath%/mkspecs/win32-msvc 

    set QtModDirs=%QtModDirs% QtCore 
    set QtModDirs=%QtModDirs% QtCore5Compat 
    set QtModDirs=%QtModDirs% QtGui 
    set QtModDirs=%QtModDirs% QtWidgets 
    set QtModDirs=%QtModDirs% QtConcurrent 
    set QtModDirs=%QtModDirs% QtNetwork 
    set QtModDirs=%QtModDirs% QtPrintSupport 
    set QtModDirs=%QtModDirs% QtXml 
    set QtModDirs=%QtModDirs% QtWebEngineCore 
    set QtModDirs=%QtModDirs% QtQuick 
    set QtModDirs=%QtModDirs% QtQml 
    set QtModDirs=%QtModDirs% QtQmlIntegration 
    set QtModDirs=%QtModDirs% QtQmlModels 
    set QtModDirs=%QtModDirs% QtOpenGL 
    set QtModDirs=%QtModDirs% QtWebChannel 
    set QtModDirs=%QtModDirs% QtPositioning 

    set idx_a=0
    for %%A in (!QtMsvcPath!) do (
        set /a idx_a+=1
        set idx_b=0
        for %%B in (!QtModDirs!) do (
            set /a idx_b+=1

            set CurQtMsvcModIncDirs=!OptIncFlag! %%A\include\%%~B
            set QtMsvcIncDirs=!QtMsvcIncDirs! !CurQtMsvcModIncDirs!
            echo [!idx_a!][!idx_b!] !CurQtMsvcModIncDirs!

        )
    )

    call :color_text 2f " ------------------ GenQtIncDirOpts ----------------------- "
    endlocal & set "%~3=%QtMsvcIncDirs%"
goto :eof

:GenQtDepLibs
    setlocal EnableDelayedExpansion

    set QtMsvcPath=%~1
    set OptLinkFlag=

    call :color_text 2f " ++++++++++++++++++ GenQtDepLibs +++++++++++++++++++++++ "

    set QtMsvcSet=%QtMsvcSet%;"msvc2017_64"
    set QtMsvcSet=%QtMsvcSet%;"msvc2019_64"
    set QtMsvcSet=%QtMsvcSet%;"msvc2022_64"

    set QtMsvcDepLibs=

    set QtModLibs=%QtModLibs% Qt5Core 
    @rem set QtModLibs=%QtModLibs% QtCore5Compat 
    set QtModLibs=%QtModLibs% Qt5Gui 
    set QtModLibs=%QtModLibs% Qt5Widgets 
    set QtModLibs=%QtModLibs% Qt5Concurrent 
    set QtModLibs=%QtModLibs% Qt5Network 
    set QtModLibs=%QtModLibs% Qt5PrintSupport 
    set QtModLibs=%QtModLibs% Qt5Xml 
    set QtModLibs=%QtModLibs% Qt5WebEngineCore 
    set QtModLibs=%QtModLibs% Qt5Quick 
    set QtModLibs=%QtModLibs% Qt5Qml 
    @rem set QtModLibs=%QtModLibs% Qt5QmlIntegration 
    set QtModLibs=%QtModLibs% Qt5QmlModels 
    set QtModLibs=%QtModLibs% Qt5OpenGL 
    set QtModLibs=%QtModLibs% Qt5WebChannel 
    set QtModLibs=%QtModLibs% Qt5Positioning 

    set idx_a=0
    for %%A in (!QtMsvcPath!) do (
        set /a idx_a+=1
        set idx_b=0
        for %%B in (!QtModLibs!) do (
            set /a idx_b+=1

            set CurQtMsvcModLib=!OptLinkFlag! %%A\lib\%%~B.lib
            set QtMsvcDepLibs=!QtMsvcDepLibs! !CurQtMsvcModLib!
            echo [!idx_a!][!idx_b!] !CurQtMsvcModLib!

        )
    )

    call :color_text 2f " ------------------ GenQtDepLibs ----------------------- "
    endlocal & set "%~2=%QtMsvcDepLibs%"
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
    @rem set VCPathSet=%VCPathSet%;"SkySdk\VS2005\VC"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 8\VC"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 12.0\VC\bin"
    set VCPathSet=%VCPathSet%;"Microsoft Visual Studio 14.0\VC\bin"

    set idx_a=0
    for %%C in (!VCPathSet!) do (
        set /a idx_a+=1
        set idx_b=0
        for %%B in (!AllProgramsPathSet!) do (
            set /a idx_b+=1
            set idx_c=0
            for %%A in (!VSDiskSet!) do (
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

:DetectWinSdk
    setlocal EnableDelayedExpansion
    set VsBatFileVar=%~1
    set VS_ARCH=%~1

    call :color_text 2f " ++++++++++++++++++ DetectWinSdk +++++++++++++++++++++++ "

    set WindowsSdkVersion=10.0.22621.0

    set VSDiskSet=C;D;E;F;G;

    set AllProgramsPathSet=program
    set AllProgramsPathSet=%AllProgramsPathSet%;programs

    set VCPathSet=%VCPathSet%;"VS2022\Windows Kits\10"
    set VCPathSet=%VCPathSet%;"SkySdk\VS2005\SDK\v2.0"

    set idx_a=0
    for %%C in (!VCPathSet!) do (
        set /a idx_a+=1
        set idx_b=0
        for %%B in (!AllProgramsPathSet!) do (
            set /a idx_b+=1
            set idx_c=0
            for %%A in (!VSDiskSet!) do (
                set /a idx_c+=1
                set CurWinSdkDirName=%%A:\%%B\%%~C
                echo [!idx_a!][!idx_b!][!idx_c!] !CurWinSdkDirName!
                if exist !CurWinSdkDirName! (
                    set WindowsSdkDirName=!CurWinSdkDirName!
                    set WIN_SDK_BIN=!WindowsSdkDirName!\bin\!WindowsSdkVersion!\!VS_ARCH!;
                    set WIN_SDK_INC=!WIN_SDK_INC!;!WindowsSdkDirName!\Include\!WindowsSdkVersion!\um;
                    set WIN_SDK_INC=!WIN_SDK_INC!;!WindowsSdkDirName!\Include\!WindowsSdkVersion!\ucrt;
                    set WIN_SDK_INC=!WIN_SDK_INC!;!WindowsSdkDirName!\Include\!WindowsSdkVersion!\shared;
                    set WIN_SDK_LIB=!WIN_SDK_LIB!;!WindowsSdkDirName!\Lib\!WindowsSdkVersion!\um\!VS_ARCH!;
                    set WIN_SDK_LIB=!WIN_SDK_LIB!;!WindowsSdkDirName!\Lib\!WindowsSdkVersion!\ucrt\!VS_ARCH!;
                    goto :DetectWinSdkBreak
                )
            )
        )
    )
    :DetectWinSdkBreak
    echo Use:%WindowsSdkDirName%
    call :color_text 2f " ------------------ DetectWinSdk ----------------------- "
    endlocal & set "%~2=%WindowsSdkDirName%" & set %~3=%WIN_SDK_BIN% & set %~4=%WIN_SDK_INC% & set %~5=%WIN_SDK_LIB%
goto :eof

:DetectAndroidDir
    setlocal EnableDelayedExpansion
    @rem SkySdk\VS2005\VC
    set SkySdkDiskSet=C;D;E;F;G;

    set AndroidPathSet="AndroidSdk\sdk"
    set AndroidPathSet=%AndroidPathSet%;"Android\sdk"

    set i_idx=0
    call :color_text 2f " +++++++++++++++++++ DetectAndroidDir +++++++++++++++++++++++ "
    for %%i in (%SkySdkDiskSet%) do (
        set /a i_idx+=1
        set j_idx=0
        for %%j in (%AndroidPathSet%) do (
            set /a j_idx+=1
            set AndroidSdkDir=%%i:\%%~j
            for /f "tokens=1-2 delims=|" %%B in ("ndk-bundle|ndk") do (
                set CurAndroidNdkDir=!AndroidSdkDir!\%%~B
                echo [!i_idx!][!j_idx!] !CurAndroidNdkDir!
                if exist !CurAndroidNdkDir! (
                    set AndroidNdkDir=!CurAndroidNdkDir!
                    goto :DetectAndroidDirBreak
                )
                set CurAndroidNdkDir=!AndroidSdkDir!\%%~C
                echo [!i_idx!][!j_idx!] !CurAndroidNdkDir!
                if exist !CurAndroidNdkDir! (
                    set AndroidNdkDir=!CurAndroidNdkDir!
                    goto :DetectAndroidDirBreak
                )
            )
        )
    )
    :DetectAndroidDirBreak
    echo Use:%AndroidSdkDir%
    call :color_text 2f " ------------------- DetectAndroidDir ----------------------- "
    endlocal & set %~1=%AndroidSdkDir%
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
        @rem cmake --build .       --config %BuildType%  --target %ProjName%
        cmake      --build .       --config %BuildType%  --target %ProjName%
        @rem %MakeProgram%  VERBOSE=1
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