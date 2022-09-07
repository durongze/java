#!/bin/bash

THIRD_LIB_ROOT=$(pwd)/lib
THIRD_LIB_VER=net40
THIRD_LIB_DIR="${THIRD_LIB_ROOT}/${THIRD_LIB_VER}"
THIRD_LIBS=" -r:Selenium.WebDriverBackedSelenium  -r:WebDriver -r:WebDriver.Support "

DOTNET_ROOT=/opt/dotnet31
DOTNET_VER=3.1.25          #5.0.9
DOTNET_LIB_DIR="$DOTNET_ROOT/shared/Microsoft.NETCore.App/$DOTNET_VER"
DOTNET_LIBS=" -r:System.dll -r:System.Drawing.dll -r:System.Core.dll -r:System.ValueTuple.dll "

#DOTNET_CPP="${DOTNET_ROOT}/dotnet"

ALL_LIB_DIR="-lib:${THIRD_LIB_DIR} -lib:${DOTNET_LIB_DIR}"
ALL_LIBS="${THIRD_LIBS} ${DOTNET_LIBS}"

DOTNET_CPP=mcs
#DOTNET_CPP=${DOTNET_ROOT}/dotnet

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

        echo "${DOTNET_CPP} ${SrcFile} $ALL_LIBS $ALL_LIB_DIR"
        ${DOTNET_CPP} ${SrcFile}  #"  $ALL_LIBS $ALL_LIB_DIR"

        #mv ${ObjFile}.class mypkg
    done
}

function FixMain()
{
    local Srcs=$*
    for SrcFile in ${Srcs}
    do
        FileName=${SrcFile%*.cs}
                FileName=${FileName#*/}
        echo $FUNCNAME FileName: ${FileName}
                if [ "$FileName" == "Web" ];then
                        continue
                fi
                if [ "${DOTNET_CPP}" != "mcs" ];then
                        sed 's# Main# '"${FileName}"'Main#g' -i $SrcFile
                else
                        sed 's# '"${FileName}"'Main# Main#g' -i $SrcFile
                fi
        done
}

function CompileCsharp()
{
    local Srcs=$*
    echo "${DOTNET_CPP} ${Srcs} $ALL_LIBS $ALL_LIB_DIR"
        FixMain $Srcs
    ${DOTNET_CPP} new console
    # www.nuget.org
    ${DOTNET_CPP} add package Selenium.WebDriverBackedSelenium -s lib 
    ${DOTNET_CPP} add package JavaScriptEngineSwitcher.V8 -s lib
    ${DOTNET_CPP} add package JavaScriptEngineSwitcher.ChakraCore -s lib
        ${DOTNET_CPP} run
    #${DOTNET_CPP} build ${Srcs} $ALL_LIB_DIR $ALL_LIBS -sdk:3
}

pic_srcs=$(find ./ -maxdepth 1 -iname "*.cs" -type f)
pic_srcs="$pic_srcs"
CompileAllCsharp "$pic_srcs"
#CompileCsharp "$pic_srcs"
