set JAVA_HOME=D:\Program Files\Java\jdk1.8.0_60
set PATH=%PATH%;%JAVA_HOME%\bin;E:\Android\sdk\ndk-bundle\android-ndk-r20
java -version
rem ndk-build NDK_PROJECT_PATH=. NDK_APPLICATION_MK=Application.mk APP_BUILD_SCRIPT=Android.mk

mkdir dyzbuild
pushd dyzbuild
cmake -G "Visual Studio 14 2015 Win64" ..
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\vcvars32.bat"
msbuild CppCallJni.vcxproj
Debug\CppCallJni.exe
dumpbin /dependents Debug\CppCallJni.exe
popd

echo "调试时如果报异常，记得不要点击中断，要点击继续"

pause