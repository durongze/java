@echo off
set cmd_srcs=MyThread.cs TcpServer.cs TcpClient.cs MyProcess.cs
set app_srcs=MyApp.cs
set dll_srcs=MyDll.cs

for %%i in (%cmd_srcs%) do (
    csc /r:System.dll  %%i
    if not %errorlevel% == 0 (
        goto proc_err
    ) else (
        echo %%i succ.................................
    )
)

for %%i in (%dll_srcs%) do (
    csc /t:library /r:System.dll /out:MyDll.dll  %%i
    if not %errorlevel% == 0 (
        goto proc_err
    ) else (
        echo %%i succ.................................
    )
)

for %%i in (%app_srcs%) do (
    csc /t:winexe /r:System.dll /r:System.Windows.Forms.dll  /r:MyDll.dll /out:MyApp.exe %%i
    if not %errorlevel% == 0 (
        goto proc_err
    ) else (
        echo %%i succ.................................
    )
)

:proc_err
pause