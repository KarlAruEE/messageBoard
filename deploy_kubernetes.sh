cd kubernetes || exit

export KOPS_STATE_STORE=s3://karl-aru-mb-state

kops create -f cluster-deployment.yaml

kops update cluster --name karlaru.com --yes --admin

kops validate cluster --wait 15m

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/aws/deploy.yaml

kubectl create secret generic aws-credentials --from-file=boto.cfg

kubectl create secret tls main-tls --key="SectigoSSL.key" --cert="SectigoSSL.crt"

kubectl create secret generic flask-conf --from-file=../message-board/conf.cfg

kubectl apply -f deployment.yaml

echo "Waiting 30s before appling ingress"
sleep 30
kubectl apply -f ingress.yaml
