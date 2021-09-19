#!/bin/bash

DOTNET_ROOT=/opt/dotnet5
DOTNET_VER=5.0.9
DOTNET_LIB=$DOTNET_ROOT/shared/Microsoft.NETCore.App/$DOTNET_VER


function CompileAllCsharp()
{
    local Srcs=$*
    for SrcFile in ${Srcs}
    do
        echo SrcFile : ${SrcFile}
        mcs ${SrcFile}
        ObjFile=${SrcFile%*.cs}
        ObjFile=${ObjFile}.exe
        echo $FUNCNAME ObjFile: ${ObjFile}
        #mv ${ObjFile}.class mypkg
    done
}

function CompileCsharp()
{
    local Srcs=$*
    echo "mcs ${Srcs} -r:System.dll -r:System.Drawing.dll -lib:$DOTNET_LIB"
    #mcs ${Srcs} -r:System.dll -r:System.Drawing.dll -r:System.Core.dll -r:System.ValueTyple.dll -lib:$DOTNET_LIB
    mcs ${Srcs}
}

pic_srcs=$(find ./src -type f)
pic_srcs="$pic_srcs ExampleMain.cs"
# CompileCsharp "$pic_srcs"

dotnet build pic.csproj
