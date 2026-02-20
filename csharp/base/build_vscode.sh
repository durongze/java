#!/bin/bash

VENDER="MS"
VENDER="OPEN"

if [ $VENDER == "MS" ];then
    DOTNET_ROOT=/opt/dotnet5
    DOTNET_VER=5.0.9
    DOTNET_LIB_DIR=$DOTNET_ROOT/shared/Microsoft.NETCore.App/$DOTNET_VER
    DOTNET_LIBS="-r:System.Windows.dll -r:System.dll -r:System.Drawing.dll -r:System.Core.dll -r:System.ValueTuple.dll"
    DOTNET_CPP=${DOTNET_ROOT}/dotnet
else
    DOTNET_LIB_DIR=""
    DOTNET_LIBS=" -r:System.Drawing -r:System.Windows.Forms "
    DOTNET_CPP=mcs
fi

ALL_LIBS=" -lib:$DOTNET_LIB_DIR $DOTNET_LIBS "

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
        if [ "$SrcFile" == "./MyDll.cs" ] || [ "$SrcFile" == "./MyApp.cs" ] ;then
            continue
        fi
        ObjFile=${SrcFile%*.cs}
        ObjFile=${ObjFile}.exe
        echo -e "\033[32m $FUNCNAME SrcFile: ${SrcFile} ObjFile: ${ObjFile} \033[0m"

        echo "${DOTNET_CPP} ${SrcFile} ${ALL_LIBS}"
        ${DOTNET_CPP} ${SrcFile} ${ALL_LIBS}

        #mv ${ObjFile}.class mypkg
    done
}

function CompileCsharp()
{
    local Srcs=$*
    echo "${DOTNET_CPP} ${Srcs} ${ALL_LIBS}"
    ${DOTNET_CPP} ${Srcs} ${ALL_LIBS}
}

pic_srcs=$(find ./ -iname "*.cs" -type f)
pic_srcs="$pic_srcs"
CompileAllCsharp "$pic_srcs"

#DOTNET_LIBS=$(GenDotNetLibs "$DOTNET_LIB_DIR")
echo "DOTNET_LIB_DIR : $DOTNET_LIB_DIR"
echo "DOTNET_LIBS : $DOTNET_LIBS"
