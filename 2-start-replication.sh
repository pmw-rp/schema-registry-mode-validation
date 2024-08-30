echo "+-------------------------------------+"
echo "| Installing Schema Replication Flows |"
echo "+-------------------------------------+"

helm install forward benthos/benthos -f config/replicate-green-to-blue.yaml
helm install reverse benthos/benthos -f config/replicate-blue-to-green.yaml
