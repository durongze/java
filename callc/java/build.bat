@echo off

set JAVA_HOME=D:\Program Files\Java\jdk-12.0.2
set PATH=%PATH%;%JAVA_HOME%\bin;

set srcs=ForScanner.java ForScannerChild.java TxtParseUtils.java

for %%i in (%srcs%) do (
    javac -encoding utf-8 -h . %%i
    if not %errorlevel% == 0 (
        goto proc_err
    ) else (
        echo %%i succ.................................
    )
)
move *.class mypkg
:proc_err