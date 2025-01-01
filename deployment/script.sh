#!/bin/bash

# Load variables from .env file
if [ -f .env ]; then
  export $(cat .env | xargs)
else
  echo ".env file not found!"
  exit 1
fi

# Validate required variables
: "${OCIR_NAMESPACE:?Variable not set or empty}"
: "${OCI_SERVICE_ACCOUNT_USERNAME:?Variable not set or empty}"
: "${OCI_SERVICE_AUTH_TOKEN:?Variable not set or empty}"
: "${OCIR_REGISTRY_URL:?Variable not set or empty}"
: "${CUSTOM_COMPONENT_NAME:?Variable not set or empty}"
: "${CUSTOM_COMPONENT_VERSION:?Variable not set or empty}"
: "${CUSTOM_COMPONENT_DIR:?Variable not set or empty}"

docker login -u "$OCIR_NAMESPACE/$OCI_SERVICE_ACCOUNT_USERNAME" -p "$OCI_SERVICE_AUTH_TOKEN" "$OCIR_REGISTRY_URL"
docker buildx build --platform linux/amd64 -t "$OCIR_REGISTRY_URL/$OCIR_NAMESPACE/$CUSTOM_COMPONENT_NAME:$CUSTOM_COMPONENT_VERSION" -f ./Dockerfile "$CUSTOM_COMPONENT_DIR"
docker push "$OCIR_REGISTRY_URL/$OCIR_NAMESPACE/$CUSTOM_COMPONENT_NAME:$CUSTOM_COMPONENT_VERSION"


# Define the input and output files
INPUT_FILE="sample.deployment.yaml"
OUTPUT_FILE="deployment.yaml"

# Perform the substitution
envsubst < "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Deployment file generated: $OUTPUT_FILE"

# Delete existing deployment if it exists
kubectl delete deployment "$CUSTOM_COMPONENT_NAME" --ignore-not-found

# Deploy to Kubernetes
kubectl apply -f "$OUTPUT_FILE"

echo "Deployment applied to Kubernetes cluster."



echo "Waiting for background processes to complete..."

sleep 10

# Make a request to the API Gateway and capture the HTTP status code
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "${API_GATEWAY_ENDPOINT}/${CUSTOM_COMPONENT_NAME}/components")

# Check if the status code is 200
if [ "$HTTP_STATUS" -eq 200 ]; then
  echo "API Gateway is reachable at: ${API_GATEWAY_ENDPOINT}/${CUSTOM_COMPONENT_NAME}"
else
  echo "Failed to reach API Gateway. HTTP status code: $HTTP_STATUS"
  kubectl delete -f deployment.yaml
fi
