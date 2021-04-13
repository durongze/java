cmake_minimum_required(VERSION 3.8)

project("BaseApp" CSharp)

set(BASE_SRC_DIR ${PROJECT_SOURCE_DIR} CACHE STRING "BASE_SRC_DIR.")

#set(NET_VER_DIR "net35" CACHE STRING "BASE_SRC_DIR.")
set(NET_VER_DIR "net40" CACHE STRING "BASE_SRC_DIR.")
#set(NET_VER_DIR "net45" CACHE STRING "BASE_SRC_DIR.")
#set(NET_VER_DIR "netstandard2.0" CACHE STRING "BASE_SRC_DIR.")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DDYZ_DBG")

include(CSharpUtilities)

file(GLOB BASE_DLL_SRC "MyDll.cs")
file(GLOB BASE_APP_SRC "MyApp.cs")
file(GLOB BASE_THR_SRC "MyThread.cs")
file(GLOB BASE_CLI_SRC "TcpClient.cs")
file(GLOB BASE_SVR_SRC "TcpServer.cs")
file(GLOB BASE_PROC_SRC "MyProcess.cs")

add_library(libMyDll STATIC ${BASE_DLL_SRC})
add_executable(BaseApp ${BASE_APP_SRC} ${BASE_DLL_SRC})
add_executable(BaseThr ${BASE_THR_SRC})
add_executable(BaseCli ${BASE_CLI_SRC})
add_executable(BaseSvr ${BASE_SVR_SRC})
add_executable(BaseProc ${BASE_PROC_SRC})
# Set the .NET Framework version for the executable.
# set_property(TARGET BaseApp PROPERTY VS_DOTNET_TARGET_FRAMEWORK_VERSION "v4.6.1")

# Set the executable to be 32-bit.
# set_property(TARGET libMyDll PROPERTY WIN32_EXECUTABLE TRUE)
set_property(TARGET BaseApp PROPERTY WIN32_EXECUTABLE TRUE)
set_property(TARGET BaseThr PROPERTY WIN32_EXECUTABLE TRUE)
set_property(TARGET BaseCli PROPERTY WIN32_EXECUTABLE TRUE)
set_property(TARGET BaseSvr PROPERTY WIN32_EXECUTABLE TRUE)
set_property(TARGET BaseProc PROPERTY WIN32_EXECUTABLE TRUE)

# Set the C# language version (defaults to 3.0).
set(CMAKE_CSharp_FLAGS "/langversion:latest")

#csharp_set_windows_forms_properties()

# target_link_libraries(BaseApp MyDll)

# If necessary, link in other library/DLL references, such as 3rd party libraries.
# set_property(TARGET BaseApp PROPERTY VS_DOTNET_REFERENCE_my lib/${NET_VER_DIR}/my.dll)

# Add in the .NET reference libraries.
set_property(TARGET libMyDll PROPERTY VS_DOTNET_REFERENCES
    "Microsoft.CSharp"
    "System"
    "System.Core"
    "System.Data"
    "System.Drawing"
    "System.Windows.Forms"
)

set_property(TARGET BaseApp PROPERTY VS_DOTNET_REFERENCES
    "Microsoft.CSharp"
    "System"
    "System.Core"
    "System.Data"
    "System.Drawing"
    "System.Windows.Forms"
)

set_property(TARGET BaseThr PROPERTY VS_DOTNET_REFERENCES
    "Microsoft.CSharp"
    "System"
    "System.Core"
    "System.Data"
    "System.Drawing"
    "System.Windows.Forms"
)

set_property(TARGET BaseCli PROPERTY VS_DOTNET_REFERENCES
    "Microsoft.CSharp"
    "System"
    "System.Core"
    "System.Data"
    "System.Drawing"
    "System.Windows.Forms"
)

set_property(TARGET BaseSvr PROPERTY VS_DOTNET_REFERENCES
    "Microsoft.CSharp"
    "System"
    "System.Core"
    "System.Data"
    "System.Drawing"
    "System.Windows.Forms"
)

set_property(TARGET BaseProc PROPERTY VS_DOTNET_REFERENCES
    "Microsoft.CSharp"
    "System"
    "System.Core"
    "System.Data"
    "System.Drawing"
    "System.Windows.Forms"
)
SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES LINK_FLAGS "/Release")