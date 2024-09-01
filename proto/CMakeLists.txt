find_package(protobuf CONFIG REQUIRED)
find_package(gRPC CONFIG REQUIRED)
find_package(Threads)



#
# Protobuf/Grpc source files
#
set(PROTO_FILES demo_service_proto/demo_service.proto)




#
# Add Library target with protobuf sources
#
add_library(demo_service_proto ${PROTO_FILES} )
target_include_directories(demo_service_proto PUBLIC ${CMAKE_CURRENT_BINARY_DIR})
target_link_libraries(demo_service_proto 
    PUBLIC
        protobuf::libprotobuf
        gRPC::grpc
        gRPC::grpc++)

get_target_property(grpc_cpp_plugin_location gRPC::grpc_cpp_plugin LOCATION)
protobuf_generate(TARGET demo_service_proto LANGUAGE cpp)
protobuf_generate(TARGET demo_service_proto LANGUAGE grpc GENERATE_EXTENSIONS .grpc.pb.h .grpc.pb.cc PLUGIN "protoc-gen-grpc=${grpc_cpp_plugin_location}")

target_include_directories(demo_service_proto PUBLIC ${CMAKE_CURRENT_BINARY_DIR})

