set proj_name=FileList
set proj_dir=%cd%
set all_jar=%proj_dir%\lib\selenium-server-standalone-3.141.59.jar

set PATH=%PATH%;%JAVA_HOME%\bin;
javac  -encoding utf-8 -d . -classpath %all_jar% %proj_name%.java

set CLASSPATH=%CLASSPATH%;%all_jar%;

mkdir com\durongze

move %proj_name%.class com\durongze

java com.durongze.%proj_name%
 
pause