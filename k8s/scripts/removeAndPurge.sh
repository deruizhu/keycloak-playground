export KUBE_NAMESPACE="qmc-playground"
export HELM_RELEASE_NAME="qmc-keycloak-playground-test"

helm delete $HELM_RELEASE_NAME --purge
