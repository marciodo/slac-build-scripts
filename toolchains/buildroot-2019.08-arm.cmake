set(TOOLCHAIN_PATH "/sdf/sw/epics/package/linuxRT/buildroot-2019.08/host/linux-x86_64/arm/")

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR i686)
set(CMAKE_SYSROOT "${TOOLCHAIN_PATH}/arm-buildroot-linux-gnueabi/sysroot")
set(CMAKE_C_COMPILER "${TOOLCHAIN_PATH}/bin/arm-buildroot-linux-gnueabi-gcc")
set(CMAKE_CXX_COMPILER "${TOOLCHAIN_PATH}/bin/arm-buildroot-linux-gnueabi-g++")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
