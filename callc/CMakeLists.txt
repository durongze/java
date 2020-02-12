cmake_minimum_required(VERSION 3.4.1)
# close openssl
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DDYZ_DBG")
set(JAVA_HOME "$ENV{JAVA_HOME}")
file(GLOB C_LIBRARY_SRC *.cpp *.h)

MESSAGE(STATUS "JAVA_HOME DIR: ${JAVA_HOME} ENV_JAVA_HOME DIR: $ENV{HOME}")

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/ ${JAVA_HOME}/include/ ${JAVA_HOME}/include/win32)
add_library(CLibrary SHARED ${C_LIBRARY_SRC})

