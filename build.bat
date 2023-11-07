@rem set VSCMD_DEBUG=2
@rem %comspec% /k "F:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"

set VisualStudioCmd="F:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat"

set VisualStudioCmd="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\vcvars32.bat"
set VisualStudioCmd="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\amd64\vcvars64.bat"

set VisualStudioCmd="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\vcvars32.bat"
set VisualStudioCmd="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\amd64\vcvars64.bat"

set VisualStudioCmd="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"

set VisualStudioCmd="E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
set VisualStudioCmd="E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"

set VisualStudioCmd="E:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
set VisualStudioCmd="E:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat"

@rem set VisualStudioCmd="E:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\VsDevCmd.bat"

@rem set VisualStudioCmd="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars32.bat"
@rem set VisualStudioCmd="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"

set old_sys_include="%include%"
set old_sys_lib="%lib%"
set old_sys_path="%path%"

set CurDir=%~dp0
set ProjDir=%CurDir:~0,-1%
set software_dir="%ProjDir%\thirdparty"
set HomeDir=%ProjDir%\out\windows

set ProgramDir=E:\programs
set PerlPath=%ProgramDir%\Perl\bin
set NASMPath=%ProgramDir%\nasm
set CMakePath=%ProgramDir%\cmake\bin
set PythonHome=%ProgramDir%\python
set PATH=%NASMPath%;%PerlPath%;%CMakePath%;%PythonHome%;%PATH%

chcp 65001
rem set JAVA_HOME=D:\Program Files\Java\jdk1.8.0_60
set JAVA_HOME=D:\Program Files\Java\jdk-12.0.2
set PATH=%PATH%;%JAVA_HOME%\bin;E:\Android\sdk\ndk-bundle\android-ndk-r20
java -version
rem ndk-build NDK_PROJECT_PATH=. NDK_APPLICATION_MK=Application.mk APP_BUILD_SCRIPT=Android.mk

CALL %VisualStudioCmd%

set BuildDir=dyzbuild
set BuildType=Debug
set ProjName=CppCall
call :CompileProject %BuildDir% %BuildType% %ProjName%

pause
goto :eof

:CompileProject
    setlocal EnableDelayedExpansion
    set BuildDir=%~1
    set BuildType=%~2
    set ProjName=%~3

    if not exist %BuildDir% (
        mkdir %BuildDir%
    ) else (
        mkdir %BuildDir%\%BuildType%\
    )
    for /f %%i in (' dir /s /b out\windows\*.dll ') do (
        echo copy %%i %BuildDir%\%BuildType%\
        copy %%i %BuildDir%\%BuildType%\
    )
    pushd %BuildDir%
        @rem del * /q /s
        @rem cmake .. -G"Visual Studio 16 2019" -A Win64
        @rem cmake --build . --target clean
        cmake .. -DCMAKE_BUILD_TYPE=%BuildType% -DCMAKE_INSTALL_PREFIX=F:\program\%ProjName%
        @rem call :ResetSystemEnv
        cmake --build . -j16  --config %BuildType% --target CppCallJni
        Debug\CppCallJni.exe
        dumpbin /dependents Debug\CppCallJni.exe
    popd
    echo "调试时如果报异常，记得不要点击中断，要点击继续"
    endlocal
goto :eof

