cmake_minimum_required(VERSION 3.8)

project("EmailHelper" CSharp)

set(EMAIL_HELPER_SRC_DIR ${PROJECT_SOURCE_DIR} CACHE STRING "EMAIL_HELPER_SRC_DIR.")

# set(NET_VER_DIR "net35" CACHE STRING "DOTNET_DIR.")
# set(NET_VER_DIR "net40" CACHE STRING "DOTNET_DIR.")
# set(NET_VER_DIR "net45" CACHE STRING "DOTNET_DIR.")
set(NET_VER_DIR "net48" CACHE STRING "DOTNET_DIR.")
# set(NET_VER_DIR "netstandard2.0" CACHE STRING "DOTNET_DIR.")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DDYZ_DBG")

include(CSharpUtilities)

file(GLOB EMAIL_HELPER_SRC ${EMAIL_HELPER_SRC_DIR}/*.cs)

#add_library(libExcel STATIC ${EMAIL_HELPER_SRC})
add_executable(EmailHelper ${EMAIL_HELPER_SRC})

# Set the .NET Framework version for the executable.
set (ALL_PROJ EmailHelper)

# v2.0  v3.0  v3.5  v4.0  v4.5  v4.5.1  v4.5.2  v4.6  v4.6.1  v4.6.2  v4.7  v4.7.1  v4.7.2  v4.8
foreach(subproj ${ALL_PROJ})
    set_property(TARGET ${subproj} PROPERTY VS_DOTNET_TARGET_FRAMEWORK_VERSION "v4.8")
endforeach()

# Set the executable to be 32-bit.
foreach(subproj ${ALL_PROJ})
    if ("${subproj}" STREQUAL "EmailHelper")
        set_property(TARGET ${subproj} PROPERTY WIN32_EXECUTABLE TRUE)
    else()
        # don't forget to set start object
        set_property(TARGET ${subproj} PROPERTY WIN32_EXECUTABLE FALSE)
    endif()
endforeach()

# Set the C# language version (defaults to 3.0).
set(CMAKE_CSharp_FLAGS "/langversion:latest")

#csharp_set_windows_forms_properties()

target_link_libraries(EmailHelper Microsoft.Office.Interop.Outlook)

# If necessary, link in other library/DLL references, such as 3rd party libraries.
set_property(TARGET EmailHelper PROPERTY VS_DOTNET_REFERENCE_Microsoft.Office.Interop.Outlook lib/${NET_VER_DIR}/Microsoft.Office.Interop.Outlook.dll)
# Add in the .NET reference libraries.
set(index 0)
foreach(subproj ${ALL_PROJ} )
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
        "Microsoft.Office.Interop.Outlook"
    )

    set_property(TARGET ${subproj}  
        PROPERTY VS_DOTNET_REFERENCE_Microsoft.Office.Interop.Outlook
        "${BASE_SRC_DIR}/lib/${NET_VER_DIR}/Microsoft.Office.Interop.Outlook.dll"
    )
endforeach()

SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES LINK_FLAGS "/Release")