set JAVA_HOME=D:\Program Files\Java\jdk1.8.0_60
set PATH=%PATH%;%JAVA_HOME%\bin;E:\Android\sdk\ndk-bundle\android-ndk-r20

rem ndk-build NDK_PROJECT_PATH=. NDK_APPLICATION_MK=Application.mk APP_BUILD_SCRIPT=Android.mk

mkdir dyzbuild
pushd dyzbuild
cmake -G "Visual Studio 14 2015 Win64" ..
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\vcvars32.bat"
msbuild CppCallJni.vcxproj
popd
