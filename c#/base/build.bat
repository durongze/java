@echo off
set cmd_srcs=MyThread.cs TcpServer.cs TcpClient.cs MyProcess.cs
set app_srcs=MyApp.cs
set dll_srcs=MyDll.cs
set base_dir=.

goto:bat_start

:set_all_cs
    setlocal ENABLEDELAYEDEXPANSION
    set srcs1=
    set srcs2=
    for /f %%i in ('dir /b "%base_dir%\*.cs"') do (
        set src=%%i
        set srcs1=%srcs1% %src%
        set srcs2=!srcs2! !src!
    )
    echo srcs1 : %srcs1%
    echo srcs2 : !srcs2!
    endlocal & set "%~1=%srcs2%"
goto:eof

:compile_cs_to_cmd
    set cmd_srcs=%*
    setlocal ENABLEDELAYEDEXPANSION
    for %%i in (%cmd_srcs%) do (
        csc /r:System.dll  %%i
        if not "!errorlevel!" == "0" (
            echo csc /r:System.dll %%i fail
            goto proc_err
        ) else (
            echo csc /r:System.dll %%i succ
        )
    )
    endlocal
goto:eof

:compile_cs_to_dll
    set dll_srcs=%*
    setlocal ENABLEDELAYEDEXPANSION
    for %%i in (%dll_srcs%) do (
        csc /t:library /r:System.dll /out:MyDll.dll  %%i
        if not "!errorlevel!" == "0" (
            echo csc /t:library /r:System.dll /out:MyDll.dll  %%i fail
            goto proc_err
        ) else (
            echo csc /t:library /r:System.dll /out:MyDll.dll  %%i succ
        )
    )
    endlocal
goto:eof

:compile_cs_to_app
    set app_srcs=%*
    setlocal ENABLEDELAYEDEXPANSION
    for %%i in (%app_srcs%) do (
        csc /t:winexe /r:System.dll /r:System.Windows.Forms.dll  /r:MyDll.dll /out:MyApp.exe %%i
        if not "!errorlevel!" == "0" (
            echo csc /t:winexe /r:System.dll /r:System.Windows.Forms.dll  /r:MyDll.dll /out:MyApp.exe %%i fail
            goto proc_err
        ) else (
            echo csc /t:winexe /r:System.dll /r:System.Windows.Forms.dll  /r:MyDll.dll /out:MyApp.exe %%i succ
        )
    )
    endlocal
goto:eof

:execute_exe
    set srcs=%*
    setlocal ENABLEDELAYEDEXPANSION
    for %%i in (%srcs%) do (
        set src_file=%%i
        echo src_file: !src_file!
        set obj_name=!src_file:~0,-3!
        set obj_=!obj_name:%cd%\%base_dir%=!
        set pkg_=!obj_:\=.!.exe
        echo exe_file: ................................. !pkg_! .................................
        if exist !pkg_! (
            echo !pkg_! start
        ) else (
            echo !pkg_! does no exist!
        )
    )
    endlocal
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

:bat_start
    call:color_text 4e "+++++++++++++++start+++++++++++++"
    call:set_all_cs m_srcs 

    call:color_text 19 "+++++++++++++++compile srcs+++++++++++++"
    rem call:compile_cs_to_cmd %m_srcs%
 
    call:color_text 2F "---------------execute exes-------------"
    call:execute_exe %m_srcs% 

:proc_err
pause