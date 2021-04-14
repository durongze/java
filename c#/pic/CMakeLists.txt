cmake_minimum_required(VERSION 3.8)

project("gifApp" CSharp)

set(BASE_SRC_DIR ${PROJECT_SOURCE_DIR} CACHE STRING "BASE_SRC_DIR.")

#set(NET_VER_DIR "net35" CACHE STRING "BASE_SRC_DIR.")
set(NET_VER_DIR "net40" CACHE STRING "BASE_SRC_DIR.")
#set(NET_VER_DIR "net45" CACHE STRING "BASE_SRC_DIR.")
#set(NET_VER_DIR "netstandard2.0" CACHE STRING "BASE_SRC_DIR.")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DDYZ_DBG")

include(CSharpUtilities)

file(GLOB GIF_DLL_SRC src/AnimatedGifEncoder.cs src/AssemblyInfo.cs src/GifDecoder.cs src/LZWEncoder.cs src/NeuQuant.cs)
file(GLOB GIF_APP_SRC ExampleMain.cs)

add_library(libgif STATIC ${GIF_DLL_SRC})
add_executable(gifApp ${GIF_APP_SRC} ${GIF_DLL_SRC})

# Set the .NET Framework version for the executable.
# set_property(TARGET gifApp PROPERTY VS_DOTNET_TARGET_FRAMEWORK_VERSION "v4.6.1")

# Set the executable to be 32-bit.
set_property(TARGET libgif PROPERTY WINDOWS_EXPORT_ALL_SYMBOLS TRUE)
set_property(TARGET gifApp PROPERTY WIN32_EXECUTABLE TRUE)


# Set the C# language version (defaults to 3.0).
set(CMAKE_CSharp_FLAGS "/langversion:latest")

#csharp_set_windows_forms_properties()

# target_link_libraries(gifApp libgif)

# If necessary, link in other library/DLL references, such as 3rd party libraries.
# set_property(TARGET gifApp PROPERTY VS_DOTNET_REFERENCE_gif lib/${NET_VER_DIR}/libgif.dll)

# Add in the .NET reference libraries.
set_property(TARGET libgif PROPERTY VS_DOTNET_REFERENCES
    "Microsoft.CSharp"
    "System"
    "System.Core"
    "System.Data"
    "System.Drawing"
    "System.Windows.Forms"
)
set_property(TARGET gifApp PROPERTY VS_DOTNET_REFERENCES
    "Microsoft.CSharp"
    "System"
    "System.Core"
    "System.Data"
    "System.Drawing"
    "System.Windows.Forms"
)
SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES LINK_FLAGS "/Release")


