cmake_minimum_required(VERSION 3.4.1)
# close openssl

project(CppCallJni)

add_subdirectory(callc)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DDYZ_DBG")
set(JAVA_HOME "$ENV{JAVA_HOME}")
file(GLOB C_LIBRARY_SRC callc/*.cpp callc/*.h)
file(GLOB CPP_CALL_JNI_SRC *.cpp *.h)
MESSAGE(STATUS "JAVA_HOME DIR: ${JAVA_HOME} ENV_JAVA_HOME DIR: $ENV{HOME}")

include_directories(CppCallJni ${CMAKE_CURRENT_SOURCE_DIR}/ ${CMAKE_CURRENT_SOURCE_DIR}/callc ${JAVA_HOME}/include/ ${JAVA_HOME}/include/win32)
link_directories(CppCallJni ${CMAKE_CURRENT_SOURCE_DIR}/callc ${JAVA_HOME}/lib/)
add_executable(CppCallJni ${C_LIBRARY_SRC} ${CPP_CALL_JNI_SRC})
#target_link_libraries(CppCallJni jvm)