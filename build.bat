chcp 65001
rem set JAVA_HOME=D:\Program Files\Java\jdk1.8.0_60
set JAVA_HOME=D:\Program Files\Java\jdk-12.0.2
set PATH=%PATH%;%JAVA_HOME%\bin;E:\Android\sdk\ndk-bundle\android-ndk-r20
java -version
rem ndk-build NDK_PROJECT_PATH=. NDK_APPLICATION_MK=Application.mk APP_BUILD_SCRIPT=Android.mk
rem call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\vcvars32.bat"
call "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"

mkdir dyzbuild
pushd dyzbuild
rem cmake -G "Visual Studio 14 2015 Win64" ..
cmake -G "Visual Studio 16 2019" -A x64 ..

msbuild CppCallJni.vcxproj
Debug\CppCallJni.exe
dumpbin /dependents Debug\CppCallJni.exe
popd


echo "调试时如果报异常，记得不要点击中断，要点击继续"

pause