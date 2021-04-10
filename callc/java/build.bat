@echo off

set JAVA_HOME=D:\Program Files\Java\jdk-12.0.2
set PATH=%PATH%;%JAVA_HOME%\bin;

set srcs=ForScanner.java ForScannerChild.java TxtParseUtils.java ServerThread.java SocketClient.java SocketServer.java

for %%i in (%srcs%) do (
    javac -encoding utf-8 -h . %%i
    if not %errorlevel% == 0 (
        goto proc_err
    ) else (
        echo %%i succ.................................
    )
)

mkdir mypkg
move *.class mypkg

java mypkg.SocketServer

:proc_err