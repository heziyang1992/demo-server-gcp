# Demo server gcp
 A server 


# create
# gcloud container clusters create demo-cluster --zone us-central1-a

# Use kubectl
gcloud components install kubectl

check version
kubectl version --client




fix docker config: gcloud auth configure-docker
docker build -t lora-server .  


docker run -p 50051:50051 lora-server

demo-server-service   LoadBalancer   34.118.234.237   35.224.71.18   80:32086/TCP   9m22s



docker buildx create --use
docker buildx build --platform linux/amd64 -t gcr.io/fiery-webbing-434004-g6/demo_server_image:latest .
docker push gcr.io/fiery-webbing-434004-g6/demo_server_image:latest
create cluster: gcloud container clusters create demo-cluster  --zone us-central1-a  --num-nodes 1

get credential : gcloud container clusters get-credentials demo-cluster --zone us-central1-a
apply: kubectl apply -f kubernetes-deployment.yaml


check status: kubectl get pods 
check service: kubectl get services

