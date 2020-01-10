cmake_minimum_required(VERSION 3.8)

project("WebExcel" CSharp)

set(WEB_EXCEL_SRC_DIR ${PROJECT_SOURCE_DIR} CACHE STRING "WEB_EXCEL_SRC_DIR.")

#set(NET_VER_DIR "net35" CACHE STRING "WEB_SRC_DIR.")
set(NET_VER_DIR "net40" CACHE STRING "WEB_SRC_DIR.")
#set(NET_VER_DIR "net45" CACHE STRING "WEB_SRC_DIR.")
#set(NET_VER_DIR "netstandard2.0" CACHE STRING "WEB_SRC_DIR.")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DDYZ_DBG")

include(CSharpUtilities)

file(GLOB WEB_EXCEL_SRC "*.cs")

add_executable(WebExcel ${WEB_EXCEL_SRC})
#add_library(libExcel STATIC ${WEB_EXCEL_SRC})

# Set the .NET Framework version for the executable.
# set_property(TARGET WebExcel PROPERTY VS_DOTNET_TARGET_FRAMEWORK_VERSION "v4.6.1")

# Set the executable to be 32-bit.
set_property(TARGET WebExcel PROPERTY WIN32_EXECUTABLE TRUE)

# Set the C# language version (defaults to 3.0).
set(CMAKE_CSharp_FLAGS "/langversion:latest")

#csharp_set_windows_forms_properties()

target_link_libraries(WebExcel Excel)

# If necessary, link in other library/DLL references, such as 3rd party libraries.
set_property(TARGET WebExcel PROPERTY VS_DOTNET_REFERENCE_Excel lib/${NET_VER_DIR}/Excel.dll)

# Add in the .NET reference libraries.
set_property(TARGET WebExcel PROPERTY VS_DOTNET_REFERENCES
    "Microsoft.CSharp"
    "System"
    "System.Core"
    "System.Data"
    "System.Drawing"
    "System.Windows.Forms"
)
SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES LINK_FLAGS "/Release")