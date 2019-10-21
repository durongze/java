javac -d . callc.java
javah -jni com.durongze.jni.CallC
mkdir dyzbuild
pushd dyzbuild
cmake -G "Visual Studio 14 2015 Win64" ..
msbuild CLibrary.vcxproj
popd
set JAVA_HOME=D:\Program Files\Java\jdk1.8.0_60\
rem del "%JAVA_HOME%\bin\CLibrary.dll"
copy "D:\code\java\callc\dyzbuild\Debug\CLibrary.dll" "%JAVA_HOME%\bin\CLibrary.dll"
java com.durongze.jni.CallC