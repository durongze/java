@rem call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\vcvars32.bat"
@rem call "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
@rem call "E:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
@rem call "E:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\VsDevCmd.bat"
call "E:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars32.bat"

set BuildType=Release

@rem call :InstallSelenium
call :vs_compile
call :RunProject
pause
goto :eof

:vs_compile
    mkdir dyzbuild
    pushd dyzbuild
    del * /s /q
    @rem cmake ..
    @rem cmake -G "Visual Studio 16 2019" -A x64 ..
    cmake -G "Visual Studio 17 2022" -A x64 ..

    @rem MSBuild Web.csproj /p:Configuration=Release /p:Platform=x64
    @rem cmake --build . -j16  --config %BuildType%
    cmake --build . --target Web  --config %BuildType%
    popd

    for /f %%i in ('dir /s /b "*.dll"') do (copy %%i .\)
    for /f %%i in ('dir /s /b "*.exe"') do (copy %%i .\)
goto :eof


:InstallSelenium
    wget https://globalcdn.nuget.org/packages/selenium.webdriver.4.4.0.nupkg --no-check-certificate
    wget https://globalcdn.nuget.org/packages/javascriptengineswitcher.v8.3.19.0.nupkg --no-check-certificate
    wget https://globalcdn.nuget.org/packages/javascriptengineswitcher.core.3.19.0.nupkg --no-check-certificate
    wget https://globalcdn.nuget.org/packages/javascriptengineswitcher.chakracore.3.19.0.nupkg --no-check-certificate
goto :eof

:RunProject
    set path=%cd%;%path%
    .\web.exe
goto :eof