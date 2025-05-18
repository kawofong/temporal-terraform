from enum import StrEnum
from pathlib import Path

import yaml
from google.cloud import secretmanager


class WorkspaceType(StrEnum):
    STARTER = "starter"
    GCP = "gcp"


class TemporalCloudTlsRetriever:
    def __init__(self, workspace: WorkspaceType, namespace: str):
        self.namespace = namespace
        self.workspace = workspace
        self.client_cert: bytes | None = None
        self.client_key: bytes | None = None

    def load(self) -> None:
        """
        Extract client cert and client key from GCP secret manager.
        """
        config_path = Path(f"workspaces/{self.workspace}/temporal_cloud_namespaces.yml")
        if not config_path.exists():
            raise FileNotFoundError(
                f"Config file not found: '{config_path}'. "
                f"Make sure to run the '{self.workspace}' Terraform workspace first."
            )
        with open(config_path, "r", encoding="utf-8") as f:
            config = yaml.safe_load(f)
        namespace_config = config["namespaces"][self.namespace]

        match self.workspace:
            case WorkspaceType.GCP:
                # Extract client cert and key from Google Cloud secret manager
                secret_client = secretmanager.SecretManagerServiceClient()
                cert_data = secret_client.access_secret_version(
                    name=namespace_config["gcp_secret_name_for_cert"]
                )
                key_data = secret_client.access_secret_version(
                    name=namespace_config["gcp_secret_name_for_key"]
                )
                self.client_cert = cert_data.payload.data
                self.client_key = key_data.payload.data

            case WorkspaceType.STARTER:
                raise NotImplementedError("Workspace type not supported")

            case _:
                raise NotImplementedError("Workspace type not supported")
