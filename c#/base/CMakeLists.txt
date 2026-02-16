cmake_minimum_required(VERSION 3.8)

project("BaseApp" CSharp)

set(BASE_SRC_DIR ${PROJECT_SOURCE_DIR} CACHE STRING "BASE_SRC_DIR.")

# set(NET_VER_DIR "net35" CACHE STRING "DOTNET_DIR.")
# set(NET_VER_DIR "net40" CACHE STRING "DOTNET_DIR.")
# set(NET_VER_DIR "net45" CACHE STRING "DOTNET_DIR.")
set(NET_VER_DIR "net48" CACHE STRING "DOTNET_DIR.")
# set(NET_VER_DIR "netstandard2.0" CACHE STRING "DOTNET_DIR.")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DDYZ_DBG")

include(CSharpUtilities)

file(GLOB BASE_DLL_SRC "MyDll.cs")
file(GLOB BASE_APP_SRC "MyApp.cs")
file(GLOB BASE_THR_SRC "MyThread.cs")
file(GLOB BASE_CLI_SRC "TcpClient.cs")
file(GLOB BASE_SVR_SRC "TcpServer.cs")
file(GLOB BASE_PROC_SRC "MyProcess.cs")

file(GLOB BASE_QQ_SRC "MyQQ.cs")
file(GLOB BASE_MyWin_SRC "MyWin32Api.cs")

add_library(libMyDll STATIC ${BASE_DLL_SRC})
add_executable(BaseApp ${BASE_APP_SRC} ${BASE_DLL_SRC})
add_executable(BaseThr ${BASE_THR_SRC})
add_executable(BaseCli ${BASE_CLI_SRC})
add_executable(BaseSvr ${BASE_SVR_SRC})
add_executable(BaseProc ${BASE_PROC_SRC})
add_executable(BaseQQ ${BASE_QQ_SRC})
add_executable(BaseWin ${BASE_MyWin_SRC})

# Set the .NET Framework version for the executable.
set (ALL_PROJ BaseApp BaseThr BaseCli BaseSvr BaseProc BaseQQ BaseWin)

# v2.0  v3.0  v3.5  v4.0  v4.5  v4.5.1  v4.5.2  v4.6  v4.6.1  v4.6.2  v4.7  v4.7.1  v4.7.2  v4.8
foreach(subproj ${ALL_PROJ})
    set_property(TARGET ${subproj} PROPERTY VS_DOTNET_TARGET_FRAMEWORK_VERSION "v4.5")
endforeach()

# Set the executable to be 32-bit.
foreach(subproj ${ALL_PROJ})
    if ("${subproj}" STREQUAL "BaseApp")
        set_property(TARGET ${subproj} PROPERTY WIN32_EXECUTABLE TRUE)
    else()
        # don't forget to set start object
        set_property(TARGET ${subproj} PROPERTY WIN32_EXECUTABLE FALSE)
    endif()
endforeach()

# Set the C# language version (defaults to 3.0).
set(CMAKE_CSharp_FLAGS "/langversion:latest")

#csharp_set_windows_forms_properties()


# If necessary, link in other library/DLL references, such as 3rd party libraries.
# set_property(TARGET BaseApp PROPERTY VS_DOTNET_REFERENCE_my lib/${NET_VER_DIR}/my.dll)

# Add in the .NET reference libraries.
set(index 0)
foreach(subproj ${ALL_PROJ} libMyDll)
    math(EXPR index "${index} + 1")
    message("[${index}] ${subproj}")
    set_property(TARGET ${subproj} PROPERTY VS_DOTNET_REFERENCES
        "Microsoft.CSharp"
        "System"
        "System.Core"
        "System.Data"
        "System.Drawing"
        "System.Windows.Forms"
        "System.Net.Http"
        "System.Runtime.Serialization"
        "System.Xml"
    )

    # set_property(TARGET ${subproj}  PROPERTY VS_DOTNET_REFERENCE_Jurassic "${BASE_SRC_DIR}/lib/Jurassic.dll" )
endforeach()

SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES LINK_FLAGS "/Release")