cmake_minimum_required(VERSION 3.4.1)
# close openssl

project(CppCall)

set(CMAKE_CPPCALLJNI_FLAGS "${CMAKE_CXX_FLAGS} -DUPNP_API")

set(CMAKE_C_FLAGS          "${CMAKE_C_FLAGS}")
set(JAVA_HOME              "$ENV{JAVA_HOME}" )

file(GLOB C_LIBRARY_SRC      callc/*.cpp    callc/*.h)
file(GLOB CPP_CALL_JNI_SRC         *.cpp          *.h)

MESSAGE(STATUS "JAVA_HOME         : ${JAVA_HOME}"     )
MESSAGE(STATUS "ENV{JAVA_HOME}    : $ENV{JAVA_HOME}"  )

include_directories  (CppCallJni ${CMAKE_CURRENT_SOURCE_DIR}/        ${CMAKE_CURRENT_SOURCE_DIR}/callc    ${JAVA_HOME}/include/    ${JAVA_HOME}/include/win32)
link_directories     (CppCallJni ${CMAKE_CURRENT_SOURCE_DIR}/callc   ${JAVA_HOME}/lib/  )
add_executable       (CppCallJni ${C_LIBRARY_SRC}                    ${CPP_CALL_JNI_SRC})
set_target_properties(CppCallJni PROPERTIES   COMPILE_FLAGS    ${CMAKE_CPPCALLJNI_FLAGS})

#target_link_libraries(CppCallJni jvm)



