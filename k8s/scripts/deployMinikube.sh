export KUBE_NAMESPACE="qmc-playground"
export HELM_RELEASE_NAME="qmc-keycloak-playground-test"
export HELM_VALUES_PATH="../values_minikube.yaml"
export HELM_CHART_PATH=".."
helm install --name $HELM_RELEASE_NAME --namespace $KUBE_NAMESPACE --debug -f $HELM_VALUES_PATH $HELM_CHART_PATH
