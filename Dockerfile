FROM --platform=linux/amd64  ubuntu:22.04

RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y cmake
RUN apt-get install -y build-essential
RUN apt-get install -y protobuf-compiler
RUN apt-get install -y libprotobuf-dev
RUN apt-get install -y libgrpc-dev
RUN apt-get install -y libgrpc++-dev
RUN apt-get clean


# Install Protocol Buffers and gRPC
RUN git clone --recurse-submodules -b v1.58.0 https://github.com/grpc/grpc /tmp/grpc 
RUN cd /tmp/grpc && mkdir -p cmake/build 
RUN cd /tmp/grpc/cmake/build \
    && cmake -DgRPC_INSTALL=ON -DgRPC_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=/usr/local ../.. \
    && make -j$(nproc) \
    && make install


# Set up the working directory
WORKDIR /app

# Copy the project files into the container
COPY . /app

RUN echo "Debug: Listing contents of /app" && ls -a /app && echo "Debug: Finished listing /app"


# Run CMake to configure the build
RUN mkdir -p build && cd build && cmake .. && cmake --build .

# Expose any necessary ports (if needed)
EXPOSE 50051

# Specify the command to run your server
CMD ["./build/server/demo_server"]
