#user: hms-admin
kubectl get secret --namespace core keycloak-keycloak-http -o jsonpath="{.data.password}" | base64 --decode; echo
