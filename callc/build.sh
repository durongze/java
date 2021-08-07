#!/bin/bash

export JAVA_HOME=/usr/lib/jvm/java-14-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin:${HOME}/Android/Sdk/ndk/22.0.7026061

#javac -d . callc.java
#rem javah -jni com.durongze.jni.CallC
#javac -h . callc.java

ndk-build NDK_PROJECT_PATH=. NDK_APPLICATION_MK=Application.mk APP_BUILD_SCRIPT=Android.mk

