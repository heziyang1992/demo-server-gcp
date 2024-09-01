#include <grpcpp/grpcpp.h>
#include <demo_service_proto/demo_service.pb.h>
#include <demo_service_proto/demo_service.grpc.pb.h>

#include <iostream>
#include <memory>
#include <string>

class DemoServiceImpl final : public demo::DemoService::Service
{
public:
    grpc::Status DemoAPI(grpc::ServerContext *context, const demo::DemoRequest *request,
                         demo::DemoResponse *response) override
    {
        std::string reply = "Hello " + request->query();
        response->set_message(reply);
        return grpc::Status::OK;
    }
};

int main(int argc, char **argv)
{
    {
        std::string server_address("0.0.0.0:50051");
        DemoServiceImpl service;

        grpc::ServerBuilder builder;
        builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
        builder.RegisterService(&service);
        std::unique_ptr<grpc::Server> server(builder.BuildAndStart());
        std::cout << "Server listening on " << server_address << std::endl;

        server->Wait();
    }
    return 0;
}
