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
set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DDYZ_DBG")
set (JAVA_HOME     "$ENV{JAVA_HOME}")

set (C_LIBRARY_BIN_DIR  ${CMAKE_CURRENT_BINARY_DIR})                  
set (C_LIBRARY_TOP_DIR  ${CMAKE_CURRENT_SOURCE_DIR}) #CMAKE_SOURCE_DIR

set (C_LIBRARY_INC_DIRS ${C_LIBRARY_TOP_DIR}/inc  ${C_LIBRARY_TOP_DIR}/ )                  
set (C_LIBRARY_LIB_DIRS ${C_LIBRARY_TOP_DIR}/lib                        )  

set (C_LIBRARY_DEP_LIBS          )

file(GLOB C_LIBRARY_SRC *.cpp *.h)
#list(REMOVE_ITEM C_LIBRARY_SRC main.cpp)

MESSAGE(STATUS "JAVA_HOME: ${JAVA_HOME} ENV{JAVA_HOME}: $ENV{JAVA_HOME}")

file(GLOB CPP_CALL_JNI_SRC ../*.cpp )

set                       (  C_LIBRARY_SHARED                 CLibrary           )
add_library               (${C_LIBRARY_SHARED}   SHARED     ${C_LIBRARY_SRC}     )
target_compile_definitions(${C_LIBRARY_SHARED}   PRIVATE    ${C_LIBRARY_DEF_LIST}     HAVE_CONFIG_H      )
target_include_directories(${C_LIBRARY_SHARED}   PUBLIC     ${C_LIBRARY_INC_DIRS}/    ${JAVA_HOME}/include/ ${JAVA_HOME}/include/win32 )
target_link_directories   (${C_LIBRARY_SHARED}   PUBLIC     ${C_LIBRARY_LIB_DIRS}                        )
target_link_libraries     (${C_LIBRARY_SHARED}              ${C_LIBRARY_DEP_LIBS}     ${dep_libs}       )
target_compile_options    (${C_LIBRARY_SHARED}   PRIVATE     /Z7     /W4         )
set_target_properties     (${C_LIBRARY_SHARED}   PROPERTIES CLEAN_DIRECT_OUTPUT 1     OUTPUT_NAME c_library_shared  )

set                         (  CMAKE_CPPCALLJNI_FLAGS    "-D C_LIBRARY_API"      )

set                         (  CPP_CALL_JNI                 CppCallJni           )
add_executable              (${CPP_CALL_JNI}             ${C_LIBRARY_SRC}              ${CPP_CALL_JNI_SRC})
target_compile_definitions  (${CPP_CALL_JNI} PRIVATE     ${C_LIBRARY_DEF_LIST}         HAVE_CONFIG_H)
target_include_directories  (${CPP_CALL_JNI} PUBLIC      ${C_LIBRARY_INC_DIRS}/        ${JAVA_HOME}/include/ ${JAVA_HOME}/include/win32 )
target_link_directories     (${CPP_CALL_JNI} PUBLIC      ${C_LIBRARY_LIB_DIRS}/        ${JAVA_HOME}/lib/  )
target_link_libraries       (${CPP_CALL_JNI} PUBLIC      ${C_LIBRARY_DEP_LIBS}                               )
set_target_properties       (${CPP_CALL_JNI} PROPERTIES   COMPILE_FLAGS                ${CMAKE_CPPCALLJNI_FLAGS})