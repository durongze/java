set all_jar=D:\code\java\java\test\lib\selenium-server-standalone-3.141.59.jar
set all_jar=%all_jar%;D:\code\java\java\test\lib\poi-4.1.1.jar
set all_jar=%all_jar%;D:\code\java\java\test\lib\poi-examples-4.1.1.jar
set all_jar=%all_jar%;D:\code\java\java\test\lib\poi-excelant-4.1.1.jar
set all_jar=%all_jar%;D:\code\java\java\test\lib\poi-ooxml-4.1.1.jar
set all_jar=%all_jar%;D:\code\java\java\test\lib\poi-ooxml-schemas-4.1.1.jar
set all_jar=%all_jar%;D:\code\java\java\test\lib\poi-scratchpad-4.1.1.jar
set all_jar=%all_jar%;D:\code\java\java\test\lib\selenium-server-standalone-3.141.59.jar
set all_jar=%all_jar%;D:\code\java\java\test\lib\lib\activation-1.1.1.jar
set all_jar=%all_jar%;D:\code\java\java\test\lib\lib\commons-codec-1.13.jar
set all_jar=%all_jar%;D:\code\java\java\test\lib\lib\commons-collections4-4.4.jar
set all_jar=%all_jar%;D:\code\java\java\test\lib\lib\commons-compress-1.19.jar
set all_jar=%all_jar%;D:\code\java\java\test\lib\lib\commons-logging-1.2.jar
set all_jar=%all_jar%;D:\code\java\java\test\lib\lib\commons-math3-3.6.1.jar
set all_jar=%all_jar%;D:\code\java\java\test\lib\lib\jaxb-api-2.3.1.jar
set all_jar=%all_jar%;D:\code\java\java\test\lib\lib\jaxb-core-2.3.0.1.jar
set all_jar=%all_jar%;D:\code\java\java\test\lib\lib\jaxb-impl-2.3.2.jar
set all_jar=%all_jar%;D:\code\java\java\test\lib\lib\junit-4.12.jar
set all_jar=%all_jar%;D:\code\java\java\test\lib\lib\log4j-1.2.17.jar
set all_jar=%all_jar%;D:\code\java\java\test\lib\ooxml-lib\curvesapi-1.06.jar
set all_jar=%all_jar%;D:\code\java\java\test\lib\ooxml-lib\xmlbeans-3.1.0.jar

javac -classpath %all_jar% web.java

set CLASSPATH=%CLASSPATH%;%all_jar%;

mkdir com\durongze\

move Web.class com/durongze/

java com.durongze.Web
 
pause