cmake_minimum_required(VERSION 3.4.1)
# close openssl
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DDYZ_DBG")
set(JAVA_HOME "D:/Program Files/Java/jdk1.8.0_60")
file(GLOB C_LIBRARY_SRC *.cpp *.h)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/ ${JAVA_HOME}/include/ ${JAVA_HOME}/include/win32)
add_library(CLibrary SHARED ${C_LIBRARY_SRC})

