@echo off

set JAVA_HOME=D:\Program Files\Java\jdk-12.0.2
set PATH=%PATH%;%JAVA_HOME%\bin;

set srcs=ForScanner.java ForScannerChild.java TxtParseUtils.java ServerThread.java SocketClient.java SocketServer.java MyFrame.java

for %%i in (%srcs%) do (
    javac -encoding utf-8 -h . %%i
    if not %errorlevel% == 0 (
        goto proc_err
    ) else (
        mkdir mypkg
        move *.class mypkg
        echo %%i succ.................................
    )
)

rem java mypkg.SocketServer

:proc_err