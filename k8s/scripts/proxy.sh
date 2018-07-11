export POD_NAME=$(kubectl get pods --namespace core -l app=keycloak,release=keycloak -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward --namespace core $POD_NAME 8080
