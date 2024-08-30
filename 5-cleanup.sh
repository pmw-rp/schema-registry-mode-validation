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