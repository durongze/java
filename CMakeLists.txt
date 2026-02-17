cmake_minimum_required(VERSION 3.4.1)
# close openssl

project(CppCall)

set(CMAKE_CPPCALLJNI_FLAGS "${CMAKE_CXX_FLAGS} -DUPNP_API")

set(CMAKE_C_FLAGS          "${CMAKE_C_FLAGS}")
set(JAVA_HOME              "$ENV{JAVA_HOME}" )

set(CPP_CALL_JNI_BIN_DIR ${CMAKE_CURRENT_BINARY_DIR})                  
set(CPP_CALL_JNI_TOP_DIR ${CMAKE_CURRENT_SOURCE_DIR}) #CMAKE_SOURCE_DIR

file(GLOB C_LIBRARY_SRC      callc/*.cpp    callc/*.h)
file(GLOB CPP_CALL_JNI_SRC         *.cpp          *.h)

MESSAGE(STATUS "JAVA_HOME         : ${JAVA_HOME}"     )
MESSAGE(STATUS "ENV{JAVA_HOME}    : $ENV{JAVA_HOME}"  )

set                         (  CPP_CALL_JNI_DEP_LIBS       jvm          )
set                         (  CPP_CALL_JNI                CppCallJni   )
add_executable              (${CPP_CALL_JNI}             ${C_LIBRARY_SRC}                    ${CPP_CALL_JNI_SRC})
target_compile_definitions  (${CPP_CALL_JNI} PRIVATE     ${C_LIBRARY_SRC}                    ${CPP_CALL_JNI_SRC})
target_include_directories  (${CPP_CALL_JNI} PUBLIC      ${CPP_CALL_JNI_TOP_DIR}/            ${CPP_CALL_JNI_TOP_DIR}/callc    ${JAVA_HOME}/include/    ${JAVA_HOME}/include/win32)
target_link_directories     (${CPP_CALL_JNI} PUBLIC      ${CPP_CALL_JNI_TOP_DIR}/callc       ${JAVA_HOME}/lib/  )
target_link_libraries       (${CPP_CALL_JNI} PUBLIC      ${CPP_CALL_JNI_DEP_LIBS}                               )
set_target_properties       (${CPP_CALL_JNI} PROPERTIES   COMPILE_FLAGS                      ${CMAKE_CPPCALLJNI_FLAGS})




