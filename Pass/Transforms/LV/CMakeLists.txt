set(CMAKE_CXX_STANDARD 14)
cmake_minimum_required(VERSION 3.9)
SET (CMAKE_CXX_FLAGS "-fno-rtti -fPIC")

find_package(LLVM REQUIRED CONFIG)

add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})

add_library(Liveness MODULE Liveness.cpp)
set_target_properties(Liveness PROPERTIES COMPILE_FLAGS "-D__GLIBCXX_USE_CXX11_ABI=0 ")
#SET(CMAKE_MODULE_LINKER_FLAGS "-undefined dynamic_lookup")

target_link_libraries(Liveness)


