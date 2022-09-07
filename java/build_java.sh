#!/bin/bash

#jar -tvf lib/selenium-server-4.4.0.jar

#export JAVA_HOME=/usr/lib/jvm/java-1.14.0-openjdk-amd64
#export JAVA_HOME=/usr/lib/jvm/java-14-openjdk-amd64
#export JAVA_HOME=/usr/lib/jvm/openjdk-14
#export PATH=${PATH}:${JAVA_HOME}/bin:
#export CLASSPATH=.:${JAVA_HOME}/lib:${JAVA_HOME}/jre/lib #:${JAVA_HOME}/lib/jrt-fs.jar:.
export JAVA_HOME=${JAVA_HOME}
export PATH=${PATH}
export CLASSPATH=${CLASSPATH}

function CompileJava()
{
    local Srcs=$*
    for SrcFile in ${Srcs}
    do
        echo SrcFile : ${SrcFile}
        javac -encoding utf-8 -d . ${SrcFile}
        ObjFile=${SrcFile%*.java}
        ObjFile=${ObjFile}.class
        echo $FUNCNAME ObjFile: ${ObjFile}
        #mv ${ObjFile}.class mypkg
    done
}

function ExecuteClass()
{
    local Objs=$*
    for ObjFile in ${Objs} 
    do 
        echo ObjFile: ${ObjFile}
        ObjFile=${ObjFile%*.class}
        ObjFile=$(echo ${ObjFile} | tr -s "/" ".")
        echo -e "\033[32m java ${ObjFile} \033[0m"
        java ${ObjFile}
    done
}

function CopyRes()
{
    cp -a res mypkg
}

if [[ -f mypkg ]] || [[ -d mypkg ]] ;then
    #rm -rf mypkg
    echo "mypkg"
fi

export Srcs=$(ls pic/*.java)
export Srcs=$(ls test/*AnimatedGifEncoder.java)

CompileJava "${Srcs}"

CopyRes

export Objs=$(ls mypkg/*.class)
ExecuteClass "${Objs}"

echo ${JAVA_HOME}
echo ${CLASSPATH}
