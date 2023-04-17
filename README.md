# GCP load balancing

Expose service running on GKE over external Load Balancer using ingress with internal Load Balancer.

`client ---> external LB (L4 or L7) ---> internal LB (ingress) ---> GKE ---> svc`

GKE is public not private (it can be private).

Before you run 'apply' you can either use (uncomment one) [LB L4](./lb_layer4.tf) or [LB L7](./lb_layer7.tf) .

```
export GOOGLE_APPLICATION_CREDENTIALS=<credentials>.json

terraform plan -var project=<project>

terraform apply -var project=<project>

export USE_GKE_GCLOUD_AUTH_PLUGIN=True &&\
gcloud container clusters get-credentials public-gke-cluster \
--region us-central1 \
--project <project>

kubectl apply -f hello_app.yaml


> check if there are no errors:

$ kubectl describe ingress ingress

$ kubectl describe svc sws-service
(...)
Normal  Create  70s   neg-controller  Created NEG "k8s1-70b04f80-default-sws-service-80-135d96a0" for default/sws-service-k8s1-70b04f80-default-sws-service-80-135d96a0--/80-1234-GCE_VM_IP_PORT-L7 in "us-central1-a".
Normal  Attach  68s   neg-controller  Attach 1 network endpoint(s) (NEG "k8s1-70b04f80-default-sws-service-80-135d96a0" in zone "us-central1-a")

$ kubectl get ingress
NAME      CLASS    HOSTS   ADDRESS     PORTS   AGE
ingress   <none>   *       10.10.0.7   80      14m


$ gcloud compute network-endpoint-groups list
NAME                                                        LOCATION       ENDPOINT_TYPE   SIZE
k8s1-70b04f80-default-sws-service-80-135d96a0               us-central1-a  GCE_VM_IP_PORT  1        << use this one below
k8s1-a057ebd9-kube-system-default-http-backend-80-d3359c8c  us-central1-a  GCE_VM_IP_PORT  1

> uncomment 'backend' part in one of the .tf files and edit '<to_be_provided>' with NEG, 
e.g. 'k8s1-70b04f80-default-sws-service-80-135d96a0':
>> lb_layer4.tf >> google_compute_backend_service >> backend
>> lb_layer7.tf >> google_compute_backend_service >> backend

> apply new changes
terraform apply -var project=michal-testing-saas -auto-approve


> after few minutes you should be able to reach 'simple-web-server'

$ curl <external_ip>:80

> if you get 502 server error, check if health check for created Load Balancer is green
