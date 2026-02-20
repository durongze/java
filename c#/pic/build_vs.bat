@rem set VSCMD_DEBUG=2
@rem %comspec% /k "F:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"

call :DetectVsPath     VisualStudioCmd
call :DetectProgramDir ProgramDir

set CurDir=%~dp0
set ProjDir=%CurDir:~0,-1%

set PERL5LIB=%PERL5LIB%
set PerlPath=%ProgramDir%\Perl\bin
set NASMPath=%ProgramDir%\nasm\bin
set YASMPath=%ProgramDir%\yasm\bin
set GPERFPath=%ProgramDir%\gperf\bin
set CMakePath=%ProgramDir%\cmake\bin
set SDCCPath=%ProgramDir%\SDCC\bin
set MakePath=%ProgramDir%\make-3.81-bin\bin
set PythonHome=%ProgramDir%\python\Python312
set PATH=%NASMPath%;%YASMPath%;%GPERFPath%;%PerlPath%;%CMakePath%;%SDCCPath%;%MakePath%;%PythonHome%;%PythonHome%\Scripts;%PATH%

set MakeProgram=%MakePath%\make.exe

set HomeDir=%ProjDir%\out\windows

@rem x86  or x64
call "%VisualStudioCmd%" x86

@rem Win32  or x64
set ArchType=Win32

set BuildDir=dyzbuild
set BuildType=Debug

@rem call :get_suf_sub_str %ProjDir% \ ProjName
set ProjName=HaceauGoogleTranslate

call :CompileProject "%BuildDir%" "%BuildType%" "%ProjName%" "%HomeDir%"
pause
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
        set idx=0
        for /f %%i in ('dir /s /b "%LibHomeDir%\*.dll"') do (
            set /a idx+=1
            set cur_lib_file=%%i
            echo [!idx!] !cur_lib_file!
            copy !cur_lib_file! !BuildDir!\!BuildType!\ 
            copy !cur_lib_file! !BuildDir!\!BuildType!\..
        )
    )
    pushd %BuildDir%
        set ALL_DEFS=            -DCMAKE_TOOLCHAIN_FILE="../toolchain.cmake" -DCMAKE_MAKE_PROGRAM="%MakeProgram%"           -DCMAKE_C_COMPILER_WORKS=ON
        set ALL_DEFS=            -DCMAKE_BUILD_TYPE=%BuildType%              -DCMAKE_INSTALL_PREFIX=%LibHomeDir%\%ProjName%
        set ALL_DEFS=%ALL_DEFS%  -DDYZ_DBG=ON

        @rem del * /q /s
        @rem cmake .. -G "Visual Studio 14 2015" -A  %ArchType%
        @rem cmake .. -G "Visual Studio 16 2019" -A  %ArchType%
        @rem cmake .. -G "Visual Studio 17 2022" -A  %ArchType%
        @rem cmake    -G "Visual Studio 8  2005"     ..
        @rem cmake --build . --target clean
        cmake ..  %ALL_DEFS%  -A %ArchType%
        @rem cmake      ..  %ALL_DEFS%  -G "NMake Makefiles" 

        MSBuild %ProjName%.csproj /p:Configuration=%BuildType% /p:Platform=%ArchType%

        @rem call :ResetSystemEnv
        @rem cmake --build .       --config %BuildType%  --target %ProjName%
        cmake      --build .       --config %BuildType%  --target %ProjName%
        @rem %MakeProgram%  VERBOSE=1
    popd
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