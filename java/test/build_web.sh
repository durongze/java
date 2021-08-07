#!/bin/bash
export proj_dir=$(pwd)
export all_jar="${proj_dir}/lib/selenium-server-standalone-3.141.59.jar"
export all_jar="$all_jar:$proj_dirlibpoi-4.1.1.jar"
export all_jar="$all_jar:$proj_dirlibpoi-examples-4.1.1.jar"
export all_jar="$all_jar:$proj_dirlibpoi-excelant-4.1.1.jar"
export all_jar="$all_jar:$proj_dirlibpoi-ooxml-4.1.1.jar"
export all_jar="$all_jar:$proj_dirlibpoi-ooxml-schemas-4.1.1.jar"
export all_jar="$all_jar:$proj_dirlibpoi-scratchpad-4.1.1.jar"
export all_jar="$all_jar:$proj_dirlibselenium-server-standalone-3.141.59.jar"
export all_jar="$all_jar:$proj_dirliblibactivation-1.1.1.jar"
export all_jar="$all_jar:$proj_dirliblibcommons-codec-1.13.jar"
export all_jar="$all_jar:$proj_dirliblibcommons-collections4-4.4.jar"
export all_jar="$all_jar:$proj_dirliblibcommons-compress-1.19.jar"
export all_jar="$all_jar:$proj_dirliblibcommons-logging-1.2.jar"
export all_jar="$all_jar:$proj_dirliblibcommons-math3-3.6.1.jar"
export all_jar="$all_jar:$proj_dirliblibjaxb-api-2.3.1.jar"
export all_jar="$all_jar:$proj_dirliblibjaxb-core-2.3.0.1.jar"
export all_jar="$all_jar:$proj_dirliblibjaxb-impl-2.3.2.jar"
export all_jar="$all_jar:$proj_dirliblibjunit-4.12.jar"
export all_jar="$all_jar:$proj_dirlibliblog4j-1.2.17.jar"
export all_jar="$all_jar:$proj_dirlibooxml-libcurvesapi-1.06.jar"
export all_jar="$all_jar:$proj_dirlibooxml-libxmlbeans-3.1.0.jar"

export PATH=$PATH:$JAVA_HOMEbin:
echo "javac -classpath $all_jar Web.java"
javac -classpath $all_jar Web.java

export CLASSPATH=$CLASSPATH:$all_jar:

mkdir com/durongze

mv Web.class com/durongze

java com.durongze.Web
 
pause
