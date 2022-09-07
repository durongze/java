#!/bin/bash

DOTNET_CPP=dotnet
#DOTNET_CPP=mcs

JAVA_SCRIPT_ENGINE_LIB_DIR="$(pwd)/bin/Debug/net5.0/"
JAVA_SCRIPT_ENGINE_LIBS=" -r:JavaScriptEngineSwitcher.V8 -r:JavaScriptEngineSwitcher.ChakraCore -r:JavaScriptEngineSwitcher.Core "

if [ "$DOTNET_CPP" == "dotnet" ];then
    SELENIUM_HOME=/opt/selenium.webdriver.4.4.0
    SELENIUM_VER=net5.0
    SELENIUM_LIB_DIR="$SELENIUM_HOME/lib/$SELENIUM_VER"
    SELENIUM_LIBS=" -r:WebDriver.dll "
else
    SELENIUM_HOME=$(pwd)/lib
    SELENIUM_VER=net45
    SELENIUM_LIB_DIR="$SELENIUM_HOME/$SELENIUM_VER"
    SELENIUM_LIBS=" -r:WebDriver.dll -r:Selenium.WebDriverBackedSelenium.dll "
fi

if [ "$DOTNET_CPP" == "dotnet" ];then
    DOTNET_ROOT=/opt/dotnet5
    DOTNET_VER=5.0.9
    DOTNET_LIB_DIR="$DOTNET_ROOT/shared/Microsoft.NETCore.App/$DOTNET_VER"
    DOTNET_LIBS="" #" -r:System.dll -r:System.Drawing.dll -r:System.Core.dll -r:System.ValueTuple.dll "
    DOTNET_CPP=$DOTNET_ROOT/$DOTNET_CPP
else
    DOTNET_ROOT=/opt/mono
    DOTNET_VER=5.0
    DOTNET_LIB_DIR="$DOTNET_ROOT/shared/Microsoft.NETCore.App/$DOTNET_VER"
    DOTNET_LIBS=" -r:System -r:System.Drawing -r:System.Core "
fi

ALL_LIBS="$ALL_LIBS -lib:$DOTNET_LIB_DIR $DOTNET_LIBS "
ALL_LIBS="$ALL_LIBS -lib:$SELENIUM_LIB_DIR $SELENIUM_LIBS "
ALL_LIBS="$ALL_LIBS -lib:$JAVA_SCRIPT_ENGINE_LIB_DIR $JAVA_SCRIPT_ENGINE_LIBS"

#export PATH=$DOTNET_ROOT:$PATH

function InstallSelenium()
{
    wget https://globalcdn.nuget.org/packages/selenium.webdriver.4.4.0.nupkg --no-check-certificate

    sudo mv $SELENIUM_HOME /opt/

}

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
        echo -e "\033[32m $FUNCNAME SrcFile: ${SrcFile} ObjFile: ${ObjFile} \033[0m"

        echo "${DOTNET_CPP} ${SrcFile} ${ALL_LIBS}"
        ${DOTNET_CPP} ${SrcFile}  ${ALL_LIBS}

        #mv ${ObjFile}.class mypkg
    done
}

function CompileCsharp()
{
    local Srcs=$*
    echo -e "\033[32m ${DOTNET_CPP} ${Srcs} ${ALL_LIBS} \033[0m"
    FixMain $Srcs
    ${DOTNET_CPP} new console
    ${DOTNET_CPP} add package Selenium.WebDriverBackedSelenium
    ${DOTNET_CPP} add package JavaScriptEngineSwitcher.V8
    ${DOTNET_CPP} add package JavaScriptEngineSwitcher.ChakraCore
    ${DOTNET_CPP} build web.csproj
}

function FixMain()
{
    local Srcs=$*
    for SrcFile in ${Srcs}
    do
        FileName=${SrcFile%*.cs}
        FileName=${FileName#*/}
        echo -e "\033[32m $FUNCNAME SrcFile: ${SrcFile} FileName: ${FileName} \033[0m" 
        if [ "$FileName" == "Web" ];then
            continue
        fi
        if [ "${DOTNET_CPP}" != "mcs" ];then
            sed 's# Main# '"${FileName}"'Main#g' -i ${SrcFile}
        else
            sed 's# '"${FileName}"'Main# Main#g' -i ${SrcFile}
        fi
    done
}

web_srcs=$(find ./ -maxdepth 1 -iname "*.cs" -type f )
web_srcs="$web_srcs"

# https://www.selenium.dev/downloads/
# https://chromedriver.chromium.org/
# http://chromedriver.storage.googleapis.com/index.html

if [ "$DOTNET_CPP" == "mcs" ];then
    CompileAllCsharp "$web_srcs"
else 
    CompileCsharp "$web_srcs"
fi


