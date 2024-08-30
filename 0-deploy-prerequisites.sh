echo "+-------------------------+"
echo "| Installing Cert Manager |"
echo "+-------------------------+"

helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --set crds.enabled=true --namespace cert-manager --create-namespace

echo "+-----------------------+"
echo "| Installing Prometheus |"
echo "+-----------------------+"

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus

echo "+-----------------------------------------+"
echo "| Adding Redpanda Connect Helm Chart Repo |"
echo "+-----------------------------------------+"

helm repo add benthos https://benthosdev.github.io/charts/
helm repo update