echo "+-------------------------------------+"
echo "| Deleting Redpanda Connect instances |"
echo "+-------------------------------------+"

helm delete forward
helm delete reverse

echo "+------------------------+"
echo "| Deleting Green cluster |"
echo "+------------------------+"

helm delete green -n green
kubectl delete namespace green

echo "+-----------------------+"
echo "| Deleting Blue cluster |"
echo "+-----------------------+"

helm delete blue -n blue
kubectl delete namespace blue

echo "+--------------------------+"
echo "| Installing Green cluster |"
echo "+--------------------------+"

cat << EOF | helm install green redpanda/redpanda \
  --version 5.8.13 \
  --namespace green \
  --create-namespace \
  -f -
external:
  service:
    enabled: false
statefulset:
  replicas: 1
service:
  internal:
    annotations:
      prometheus.io/scrape: 'true'
      prometheus.io/path: '/metrics'
      prometheus.io/port: '9644'
config:
  cluster:
    default_topic_replications: 1
tls:
  enabled: false
EOF

echo "+-------------------------+"
echo "| Installing Blue cluster |"
echo "+-------------------------+"

echo
cat << EOF | helm install blue redpanda/redpanda \
  --version 5.8.13 \
  --namespace blue \
  --create-namespace \
  -f -
external:
  service:
    enabled: false
statefulset:
  replicas: 1
service:
  internal:
    annotations:
      prometheus.io/scrape: 'true'
      prometheus.io/path: '/metrics'
      prometheus.io/port: '9644'
config:
  cluster:
    default_topic_replications: 1
tls:
  enabled: false
EOF

sleep 5

echo "+------------------------------------------+"
echo "| Setting Blue Schema Registry to READONLY |"
echo "+------------------------------------------+"

kubectl exec blue-0 -n blue -- curl -s -X PUT -H "Content-Type: application/vnd.schemaregistry.v1+json" --data '{"mode": "READONLY"}' http://localhost:8081/mode 2>/dev/null && echo
