cmake_minimum_required(VERSION 3.13)
project(DemoServer LANGUAGES CXX)

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
set(CMAKE_CXX_STANDARD 17)

add_subdirectory(server)
add_subdirectory(proto)