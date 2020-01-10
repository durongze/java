call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\vcvars32.bat"
mkdir lib
rem tlbimp excel.exe /out:lib\excel.dll 
mkdir dyzbuild
pushd dyzbuild
cmake ..
MSBuild WebExcel.csproj /p:Configuration=Release /p:Platform=x86
popd

for /f %%i in ('dir /s /b "*.dll"') do (copy %%i .\)
pause