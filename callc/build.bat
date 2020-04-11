set JAVA_HOME=D:\Program Files\Java\jdk1.8.0_60
set PATH=%PATH%;%JAVA_HOME%\bin;
set PATH=%PATH%;E:\Android\sdk\ndk-bundle\android-ndk-r20;D:\Android\ndk\android-ndk-r19c
javac -encoding utf-8 -d . callc.java
javap -s com.durongze.jni.CallC
rem javah -jni com.durongze.jni.CallC
javac -encoding utf-8 -h . callc.java

rem ndk-build NDK_PROJECT_PATH=. NDK_APPLICATION_MK=Application.mk APP_BUILD_SCRIPT=Android.mk
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\vcvars32.bat"
mkdir dyzbuild
pushd dyzbuild
cmake -G "Visual Studio 14 2015 Win64" ..
msbuild CLibrary.vcxproj
popd

rem del "%JAVA_HOME%\bin\CLibrary.dll"
for /f %%i in ('dir /s /b "*.dll"') do (copy %%i .\)
copy ".\CLibrary.dll" "%JAVA_HOME%\bin\CLibrary.dll"
java com.durongze.jni.CallC
pause