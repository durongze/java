cmake_minimum_required(VERSION 3.8)

project("Web" CSharp)

set(WEB_SRC_DIR ${PROJECT_SOURCE_DIR} CACHE STRING "WEB_SRC_DIR.")

#set(NET_VER_DIR "net35" CACHE STRING "WEB_SRC_DIR.")
set(NET_VER_DIR "net40" CACHE STRING "WEB_SRC_DIR.")
#set(NET_VER_DIR "net45" CACHE STRING "WEB_SRC_DIR.")
#set(NET_VER_DIR "net47" CACHE STRING "WEB_SRC_DIR.")
#set(NET_VER_DIR "net48" CACHE STRING "WEB_SRC_DIR.")
#set(NET_VER_DIR "net5.0" CACHE STRING "WEB_SRC_DIR.")
#set(NET_VER_DIR "netstandard2.0" CACHE STRING "WEB_SRC_DIR.")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DDYZ_DBG")

include(CSharpUtilities)

file(GLOB WEB_SRC "*.cs")

add_executable(Web ${WEB_SRC})
#add_library(libWeb STATIC ${WEB_SRC})

# Set the .NET Framework version for the executable.
# set_property(TARGET Web PROPERTY VS_DOTNET_TARGET_FRAMEWORK_VERSION "v4.6.1")

# Set the executable to be 32-bit.
set_property(TARGET Web PROPERTY WIN32_EXECUTABLE TRUE)

# Set the C# language version (defaults to 3.0).
set(CMAKE_CSharp_FLAGS "/langversion:latest")

#csharp_set_windows_forms_properties()

target_link_libraries(Web WebDriver WebDriver.Support Selenium.WebDriverBackedSelenium)

# If necessary, link in other library/DLL references, such as 3rd party libraries.
set_property(TARGET Web PROPERTY VS_DOTNET_REFERENCE_Selenium.WebDriverBackedSelenium lib/${NET_VER_DIR}/Selenium.WebDriverBackedSelenium.dll)
set_property(TARGET Web PROPERTY VS_DOTNET_REFERENCE_WebDriver lib/${NET_VER_DIR}/WebDriver.dll)
set_property(TARGET Web PROPERTY VS_DOTNET_REFERENCE_WebDriver.Support lib/${NET_VER_DIR}/WebDriver.Support.dll)
set_property(TARGET Web PROPERTY VS_DOTNET_REFERENCE_JavaScriptEngineSwitcher.Core lib/${NET_VER_DIR}/JavaScriptEngineSwitcher.Core.dll)
set_property(TARGET Web PROPERTY VS_DOTNET_REFERENCE_JavaScriptEngineSwitcher.ChakraCore lib/${NET_VER_DIR}/JavaScriptEngineSwitcher.ChakraCore.dll)

# Add in the .NET reference libraries.
set_property(TARGET Web PROPERTY VS_DOTNET_REFERENCES
    "Microsoft.CSharp"
    "System"
    "System.Core"
    "System.Data"
    "System.Drawing"
    "System.Windows.Forms"
)
SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES LINK_FLAGS "/Release")