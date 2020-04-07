set JAVA_HOME=D:\Program Files\Java\jdk1.8.0_60
set PATH=%PATH%;%JAVA_HOME%\bin;E:\Android\sdk\ndk-bundle\android-ndk-r20
javac -encoding utf-8 -d . callc.java
rem javah -jni com.durongze.jni.CallC
javac -encoding utf-8 -h . callc.java

rem ndk-build NDK_PROJECT_PATH=. NDK_APPLICATION_MK=Application.mk APP_BUILD_SCRIPT=Android.mk

mkdir dyzbuild
pushd dyzbuild
cmake -G "Visual Studio 14 2015 Win64" ..
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\vcvars32.bat"
msbuild CLibrary.vcxproj
popd

rem del "%JAVA_HOME%\bin\CLibrary.dll"
for /f %%i in ('dir /s /b "*.dll"') do (copy %%i .\)
copy ".\CLibrary.dll" "%JAVA_HOME%\bin\CLibrary.dll"
java com.durongze.jni.CallC
pause