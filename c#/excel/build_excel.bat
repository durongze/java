rem call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\vcvars32.bat"
call "E:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"

mkdir lib
rem tlbimp excel.exe /out:lib\excel.dll 
mkdir dyzbuild
pushd dyzbuild
rem cmake ..
cmake -G "Visual Studio 16 2019" -A x64 ..
MSBuild WebExcel.csproj /p:Configuration=Release /p:Platform=x64
popd

for /f %%i in ('dir /s /b "*.dll"') do (copy %%i .\)
tasklist  | findstr /i "excel"
taskkill /f /im WebExcel.exe
taskkill /f /im EXCEL.exe
pause