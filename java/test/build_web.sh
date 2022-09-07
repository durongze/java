#!/bin/bash
export proj_dir=$(pwd)
export all_jar="${proj_dir}/lib/selenium-server-standalone-3.141.59.jar"
export all_jar="${proj_dir}/lib/selenium-server-4.4.0.jar"
export all_jar="$all_jar:$proj_dir/lib/poi-4.1.1.jar"
export all_jar="$all_jar:$proj_dir/lib/poi-examples-4.1.1.jar"
export all_jar="$all_jar:$proj_dir/lib/poi-excelant-4.1.1.jar"
export all_jar="$all_jar:$proj_dir/lib/poi-ooxml-4.1.1.jar"
export all_jar="$all_jar:$proj_dir/lib/poi-ooxml-schemas-4.1.1.jar"
export all_jar="$all_jar:$proj_dir/lib/poi-scratchpad-4.1.1.jar"
export all_jar="$all_jar:$proj_dir/lib/libactivation-1.1.1.jar"
export all_jar="$all_jar:$proj_dir/lib/libcommons-codec-1.13.jar"
export all_jar="$all_jar:$proj_dir/lib/libcommons-collections4-4.4.jar"
export all_jar="$all_jar:$proj_dir/lib/libcommons-compress-1.19.jar"
export all_jar="$all_jar:$proj_dir/lib/libcommons-logging-1.2.jar"
export all_jar="$all_jar:$proj_dir/lib/libcommons-math3-3.6.1.jar"
export all_jar="$all_jar:$proj_dir/lib/libjaxb-api-2.3.1.jar"
export all_jar="$all_jar:$proj_dir/lib/libjaxb-core-2.3.0.1.jar"
export all_jar="$all_jar:$proj_dir/lib/libjaxb-impl-2.3.2.jar"
export all_jar="$all_jar:$proj_dir/lib/libjunit-4.12.jar"
export all_jar="$all_jar:$proj_dir/lib/liblog4j-1.2.17.jar"
export all_jar="$all_jar:$proj_dir/lib/ooxml-libcurvesapi-1.06.jar"
export all_jar="$all_jar:$proj_dir/lib/ooxml-libxmlbeans-3.1.0.jar"

export PATH=$PATH:$JAVA_HOMEbin:
echo "javac -classpath $all_jar Web.java"
javac -classpath $all_jar Web.java

export CLASSPATH=$CLASSPATH:$all_jar:

mkdir com/durongze

mv Web.class com/durongze

java com.durongze.Web
 
