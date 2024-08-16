import base64
import logging
import os
from google.cloud import secretmanager
from kubernetes import client, config

def list_secrets(project_id) -> secretmanager.ListSecretsResponse:
    """
    List all secrets in the given project.
    """
    # Create the Secret Manager client.
    client = secretmanager.SecretManagerServiceClient()
    # Build the resource name of the parent project.
    parent = f"projects/{project_id}"
    # List all secrets.
    return client.list_secrets(request={"parent": parent})

def list_secret_versions(secret_id) -> secretmanager.ListSecretVersionsResponse:
    """
    List all secret versions in the given secret and their metadata.
    """
    # Import the Secret Manager client library.
    # Create the Secret Manager client.
    client = secretmanager.SecretManagerServiceClient()
    # List all secret versions.
    return client.list_secret_versions(request={"parent": secret_id})

def access_secret_version(version_id) -> secretmanager.AccessSecretVersionResponse:
    """
    Access the payload for the given secret version if one exists. The version
    can be a version number as a string (e.g. "5") or an alias (e.g. "latest").
    """
    # Import the Secret Manager client library.
    # Create the Secret Manager client.
    client = secretmanager.SecretManagerServiceClient()
    # Build the resource name of the secret version.
    # Access the secret version.
    response = client.access_secret_version(request={"name": version_id})
    # Print the secret payload.
    # WARNING: Do not print the secret in a production environment - this
    # snippet is showing how to access the secret material.
    payload = response.payload.data.decode("UTF-8")
    return payload

def create_k8s_secret_with_content(api: client.CoreV1Api, name, version, content, namespace) -> None:
    api.create_namespaced_secret(
        namespace=namespace,
        body=client.V1Secret(
            data={"content": base64.b64encode(content.encode("ascii")).decode("utf-8")},
            metadata={"name": name, "labels": {"gcp.secret.name": name, "gcp.secret.version": version}},
        ),
    )
    logging.info(f"Created new secret with name: {name} and version: {version} in {namespace} namespace")

# Main
env = os.environ.get("env", "dev")
PROJECT_ID = os.environ.get("PROJECT_ID", "<fill_project_id>")
if env == "dev":
    config.load_kube_config()
else:
    config.load_incluster_config()
v1 = client.CoreV1Api()

# List all secrets from GCP and create them in the k8s cluster
secrets = list_secrets(PROJECT_ID)
for secret in secrets:
    logging.debug(f"Found secret with name {secret.name}")
    versions = list_secret_versions(secret.name)
    versions = sorted(versions, key=lambda x: x.name)
    latest_version = versions[-1]
    logging.debug(f"Found latest version {latest_version.name}")
    content = access_secret_version(latest_version.name)
    logging.debug(f"Latest content: {content}")
    create_k8s_secret_with_content(
        v1, secret.name.split("/")[-1], latest_version.name.split("/")[-1], content, "default"
    )
