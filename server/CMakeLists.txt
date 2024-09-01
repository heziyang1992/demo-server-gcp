# Sources
set(SOURCES src/demo_server.cpp)

source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR} FILES ${SOURCES})

# Target
add_executable(demo_server ${SOURCES})
target_link_libraries(demo_server
    PRIVATE
        demo_service_proto
)