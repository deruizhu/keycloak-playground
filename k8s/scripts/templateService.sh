export KUBE_NAMESPACE="qmc-playground"
export HELM_RELEASE_NAME="qmc-keycloak-playground-test"
export HELM_VALUES_PATH="../values_aws.yaml"
export HELM_CHART_PATH=".."
TEMPLATE_PATH="./templates/http-service.yaml"
helm template --name $HELM_RELEASE_NAME --namespace $KUBE_NAMESPACE -f $HELM_VALUES_PATH $HELM_CHART_PATH -x $TEMPLATE_PATH
