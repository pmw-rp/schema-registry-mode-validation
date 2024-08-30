ID=$(uuidgen | tr 'A-Z' 'a-z' | cut -f1 -d'-')

SCHEMA="{\\\"${ID}\\\": \\\"string\\\", \\\"type\\\": \\\"string\\\"}"

echo "+-----------------------------------------+"
echo "| Creating subject Test-${ID} on Green |"
echo "+-----------------------------------------+"

kubectl exec green-0 -n green -- curl -s -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  --data "{\"schema\": \"${SCHEMA}\"}" \
  http://localhost:8081/subjects/Test-"${ID}"/versions 2>/dev/null && echo

echo "+----------------------------------------+"
echo "| Creating subject Test-${ID} on Blue |"
echo "+----------------------------------------+"

kubectl exec blue-0 -n blue -- curl -s -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  --data "{\"schema\": \"${SCHEMA}\"}" \
  http://localhost:8081/subjects/Test-"${ID}"/versions 2>/dev/null && echo