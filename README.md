# Demo server gcp

A demo server with minimum setup and dependency that demonstrate:
1. How to build/run a server locally.
2. How to build/run a server using Docker.
3. How to build/run/deploy a server on Google Cloud's Kubernetes Engine.

## Dependency
- Docker - Download from [official website](https://www.docker.com/)
- CMake  - Download from [official website](https://cmake.org/download/) or install `brew install cmake` on MacOS or `sudo apt install cmake` on Linux.

## Build and run locally
In the repo root folder
- Run `mkdir -p build && cd build && cmake .. && cmake --build .` to build the server.
- Run `./build/server/demo_server` to start the server.

## Build and run using docker
In the repo root folder:
- Run `docker build -t demo-server .` to build a docker image on local machine with tag `demo-server`. **Note**: the first time build is extremely long because compiling gRPC.
- Run `docker run -p 50051:50051 demo-server` to start the server using docker. The server now will running at local server at port 50051.
- Run `docker ps` to find the runinng docker process id and run `docker stop {your container process ID}` to stop the server

## Build and running dockder

Now, let's try to build and run the server on Google Cloud.

To deploy server on Google cloud, we need to:
- Install gcloud on local machine.
- Follow `Google Cloud console` instruction to create a project
- In `Google clound console`, enable Billing so that we could enable Kubernetes Engine.
- **Optional**: build on cloud also require to enable `cloud build` api.

### Build docker locally 

> **Note:** In this repo, we assume server will be deployed in GCP with its amd64 machine. If you are using Apple's arm64 chips, docker image built locally will crash on Google cloud. 

**Tag and push to server** 
- Run `docker build --platform=linux/amd64 -t gcr.io/[PROJECT_ID]/demo_server_image:latest .`.

- If docker already build in previous section: Re-tag the docker image built in above section to follow google cloud docker image naming convension: `docker tag demo_server gcr.io/[PROJECT_ID]/demo_server_image:latest`.  The google cloud require docker image name as`gcr.io/[PROJECT_ID]/[IMAGE_NAME]:[TAG]`. 

### Build docker on Google cloud

To build on Google cloud, simply run `gcloud builds submit --config=cloudbuild.yaml .
` and the build will start. It may take 1 hour for first time run.

## Deploy on Google Cloud

1. To deploy server, we fisrt need to create a cluster to host the docker image: `gcloud container clusters create demo-cluster  --zone us-central1-a  --num-nodes 1`. As this is a demo server, we just set number of nodes a 1.

2. Get credential of the new created cluster:  `gcloud container clusters get-credentials demo-cluster --zone us-central1-a`

3. Deploy docker image using Kubernetes: `kubectl apply -f kubernetes-deployment.yaml`. In the Kubernetes, we let Kubernetes expose port 80. The docker expose port 50051. Kubernetes will forward the api call to docker port. The config is in kubernetes-deployment.yaml file.

4. To check the status of service, run `kubectl get pods`. The status should be RUNNING. 

5. To get the server external api, run `kubectl get services`.

## Testing
To test the server api, using Postman to load the `demo_service.proto` api and set the input and port.

The demo api will simply add `Hello ` on the given string.

## Troubleshooting 

### Docker cannot push to cloud
It might because the docker not have gcloud credential yet. Run `gcloud auth configure-docker` could fix the issue.

### Install kubectl using gcloud
kubectl should already available in Docker but Google cloud might profer to install its own version. When error shows up, run `gcloud components install kubectl` could resolve the problem. 

# Create a issue if you meet any issue. I will try to find the fix.