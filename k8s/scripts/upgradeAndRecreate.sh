export KUBE_NAMESPACE="qmc-playground"
export HELM_RELEASE_NAME="qmc-keycloak-playground-test"
export HELM_VALUES_PATH="../values_v2.yaml"
export HELM_CHART_PATH=".."
helm upgrade $HELM_RELEASE_NAME --namespace $KUBE_NAMESPACE --recreate-pods  -f $HELM_VALUES_PATH $HELM_CHART_PATH
