set proj_name=Web
set proj_dir=%cd%
set all_jar=%proj_dir%\lib\selenium-server-standalone-3.141.59.jar
set all_jar=%all_jar%;%proj_dir%\lib\poi-4.1.1.jar
set all_jar=%all_jar%;%proj_dir%\lib\poi-examples-4.1.1.jar
set all_jar=%all_jar%;%proj_dir%\lib\poi-excelant-4.1.1.jar
set all_jar=%all_jar%;%proj_dir%\lib\poi-ooxml-4.1.1.jar
set all_jar=%all_jar%;%proj_dir%\lib\poi-ooxml-schemas-4.1.1.jar
set all_jar=%all_jar%;%proj_dir%\lib\poi-scratchpad-4.1.1.jar
set all_jar=%all_jar%;%proj_dir%\lib\selenium-server-standalone-3.141.59.jar
set all_jar=%all_jar%;%proj_dir%\lib\lib\activation-1.1.1.jar
set all_jar=%all_jar%;%proj_dir%\lib\lib\commons-codec-1.13.jar
set all_jar=%all_jar%;%proj_dir%\lib\lib\commons-collections4-4.4.jar
set all_jar=%all_jar%;%proj_dir%\lib\lib\commons-compress-1.19.jar
set all_jar=%all_jar%;%proj_dir%\lib\lib\commons-logging-1.2.jar
set all_jar=%all_jar%;%proj_dir%\lib\lib\commons-math3-3.6.1.jar
set all_jar=%all_jar%;%proj_dir%\lib\lib\jaxb-api-2.3.1.jar
set all_jar=%all_jar%;%proj_dir%\lib\lib\jaxb-core-2.3.0.1.jar
set all_jar=%all_jar%;%proj_dir%\lib\lib\jaxb-impl-2.3.2.jar
set all_jar=%all_jar%;%proj_dir%\lib\lib\junit-4.12.jar
set all_jar=%all_jar%;%proj_dir%\lib\lib\log4j-1.2.17.jar
set all_jar=%all_jar%;%proj_dir%\lib\ooxml-lib\curvesapi-1.06.jar
set all_jar=%all_jar%;%proj_dir%\lib\ooxml-lib\xmlbeans-3.1.0.jar

set PATH=%PATH%;%JAVA_HOME%\bin;
javac -classpath %all_jar% %proj_name%.java

set CLASSPATH=%CLASSPATH%;%all_jar%;

mkdir com\durongze\

move %proj_name%.class com/durongze/

java com.durongze.%proj_name%
 
pause