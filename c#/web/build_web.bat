call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\vcvars32.bat"
mkdir dyzbuild
pushd dyzbuild
cmake ..
MSBuild Web.csproj /p:Configuration=Release /p:Platform=x86
popd

for /f %%i in ('dir /s /b "*.dll"') do (copy %%i .\)
for /f %%i in ('dir /s /b "*.exe"') do (copy %%i .\)
pause