BLUE_MODE=$(kubectl exec blue-0 -n blue -- curl -s -X GET http://localhost:8081/mode 2>/dev/null && echo)

if [ "${BLUE_MODE}" == '{"mode":"READONLY"}' ]; then
  FIRST=green
  NEXT=blue
else
  FIRST=blue
  NEXT=green
fi

echo "+--------------------------------+"
echo "| Switching ${FIRST} to READONLY |"
echo "+--------------------------------+"

kubectl exec "${FIRST}"-0 -n "${FIRST}" -- curl -s -X PUT -H "Content-Type: application/vnd.schemaregistry.v1+json" --data '{"mode": "READONLY"}' http://localhost:8081/mode 2>/dev/null && echo

echo "+--------------------------------+"
echo "| Switching ${NEXT} to READWRITE |"
echo "+--------------------------------+"

kubectl exec "${NEXT}"-0 -n "${NEXT}" -- curl -s -X PUT -H "Content-Type: application/vnd.schemaregistry.v1+json" --data '{"mode": "READWRITE"}' http://localhost:8081/mode 2>/dev/null && echo