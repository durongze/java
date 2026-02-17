cmake_minimum_required(VERSION 3.4.1)

project(CallCpp)

if (MSVC)
    set(CompilerFlags
        CMAKE_CXX_FLAGS
        CMAKE_CXX_FLAGS_DEBUG
        CMAKE_CXX_FLAGS_RELEASE
        CMAKE_C_FLAGS
        CMAKE_C_FLAGS_DEBUG
        CMAKE_C_FLAGS_RELEASE
        )
    foreach(CompilerFlag ${CompilerFlags})
        string(REPLACE "/MD" "/MT" ${CompilerFlag} "${${CompilerFlag}}")
    endforeach()
endif(MSVC)

# close openssl
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DDYZ_DBG")
set(JAVA_HOME "$ENV{JAVA_HOME}")
file(GLOB C_LIBRARY_SRC *.cpp *.h)
#list(REMOVE_ITEM C_LIBRARY_SRC main.cpp)

MESSAGE(STATUS "JAVA_HOME DIR: ${JAVA_HOME} ENV_JAVA_HOME DIR: $ENV{HOME}")

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/ ${JAVA_HOME}/include/ ${JAVA_HOME}/include/win32)
add_library(CLibrary SHARED ${C_LIBRARY_SRC})

file(GLOB CPP_CALL_JNI_SRC ../*.cpp )

add_executable(CppCallJni ${C_LIBRARY_SRC} ${CPP_CALL_JNI_SRC})
