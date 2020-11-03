set JAVA_HOME=D:\Program Files\Java\jdk-12.0.2
set PATH=%PATH%;%JAVA_HOME%\bin;
set PATH=%PATH%;E:\Android\sdk\ndk-bundle\android-ndk-r20;D:\Android\ndk\android-ndk-r19c
javac -encoding utf-8 -d . callc.java
javap -s com.durongze.jni.CallC
rem javah -jni com.durongze.jni.CallC
javac -encoding utf-8 -h . callc.java

rem ndk-build NDK_PROJECT_PATH=. NDK_APPLICATION_MK=Application.mk APP_BUILD_SCRIPT=Android.mk
rem call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\vcvars32.bat"
call "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
mkdir dyzbuild
pushd dyzbuild
rem cmake -G "Visual Studio 14 2015 Win64" ..
rem Win32 x64
del * /s /q
cmake -G "Visual Studio 16 2019" -A x64 ..
msbuild CLibrary.vcxproj
popd

rem del "%JAVA_HOME%\bin\CLibrary.dll"
for /f %%i in ('dir /s /b "*.dll"') do (copy %%i .\)
del "%JAVA_HOME%\bin\libCLibrary.dll"
copy ".\CLibrary.dll" "%JAVA_HOME%\bin\CLibrary.dll"
java com.durongze.jni.CallC
pause