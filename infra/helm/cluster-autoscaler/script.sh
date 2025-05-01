helm repo add autoscaler https://kubernetes.github.io/autoscaler
helm repo update

helm install cluster-autoscaler autoscaler/cluster-autoscaler \
    --set 'autoDiscovery.clusterName'=<CLUSTER NAME> \
    --set awsRegion=<AWS REGION>
