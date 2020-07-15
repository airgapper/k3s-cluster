https://metallb.universe.tf/installation/

```
kubectl apply -f namespace.yml
kubectl apply -f metallb.yml
# update configmap with IP range
kubectl apply -f configmap.yml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
```
