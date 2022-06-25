#!/bin/bash

DOTNET_ROOT=/opt/dotnet5
DOTNET_VER=5.0.9
DOTNET_LIB_DIR="$DOTNET_ROOT/shared/Microsoft.NETCore.App/$DOTNET_VER"

DOTNET_LIBS=" -r:System.dll -r:System.Drawing.dll -r:System.Core.dll -r:System.ValueTuple.dll "
#DOTNET_CPP="${DOTNET_ROOT}/dotnet"

DOTNET_LIBS=""
DOTNET_CPP=mcs

#export PATH=$DOTNET_ROOT:$PATH

function GenDotNetLibs()
{
    local DotNetDir=$1
    local DotNetLib=""

    pushd $DotNetDir >> /dev/null
    for lib in $(ls *.dll)
    do
        DotNetLib="${DotNetLib} $lib"
    done
    popd >>/dev/null

    echo $DotNetLib
}

function CompileAllCsharp()
{
    local Srcs=$*
    for SrcFile in ${Srcs}
    do
        ObjFile=${SrcFile%*.cs}
        ObjFile=${ObjFile}.exe
        echo $FUNCNAME ObjFile: ${ObjFile}

        echo "${DOTNET_CPP} ${SrcFile} $DOTNET_LIBS -lib:$DOTNET_LIB_DIR"
        ${DOTNET_CPP} ${SrcFile}  #"  $DOTNET_LIBS -lib:$DOTNET_LIB_DIR"

        #mv ${ObjFile}.class mypkg
    done
}

function CompileCsharp()
{
    local Srcs=$*
    echo "${DOTNET_CPP} ${Srcs} $DOTNET_LIBS -lib:$DOTNET_LIB_DIR"
    ${DOTNET_CPP}  ${Srcs} -lib:$DOTNET_LIB_DIR $DOTNET_LIBS -sdk:2
}

pic_srcs=$(find ./ -iname "*.cs" -type f)
pic_srcs="$pic_srcs"
CompileAllCsharp "$pic_srcs"
