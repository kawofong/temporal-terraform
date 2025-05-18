import argparse
import asyncio

from temporalio.client import Client
from temporalio.service import TLSConfig
from temporalio.worker import Worker

from workflows.hello import GreetingWorkflow, compose_greeting
from workflows.secrets import TemporalCloudTlsRetriever, WorkspaceType


async def main():
    """
    Run a simple workflow in Temporal Cloud.
    """
    # Parse CLI arguments
    parser = argparse.ArgumentParser(description="Use mTLS with server")
    parser.add_argument("--account", help="Temporal Cloud account Id", default="abcde")
    parser.add_argument(
        "--namespace", help="Temporal Cloud namespace.", default="default"
    )
    parser.add_argument(
        "--workspace",
        help="Terraform workspace.",
        default=WorkspaceType.STARTER,
        choices=list(WorkspaceType),
    )
    args = parser.parse_args()

    retriever = TemporalCloudTlsRetriever(
        workspace=args.workspace, namespace=args.namespace
    )
    retriever.load()

    # Start client with TLS configured
    namespace_id = f"{args.namespace}.{args.account}"
    target_host = f"{namespace_id}.tmprl.cloud:7233"
    temporal_client = await Client.connect(
        target_host,
        namespace=namespace_id,
        tls=TLSConfig(
            client_cert=retriever.client_cert,
            client_private_key=retriever.client_key,
        ),
    )

    # Run a worker and execute the greeting workflow once the worker is running.
    async with Worker(
        temporal_client,
        task_queue="hello-mtls-task-queue",
        workflows=[GreetingWorkflow],
        activities=[compose_greeting],
    ):
        result = await temporal_client.execute_workflow(
            GreetingWorkflow.run,
            "World",
            id="hello-mtls-workflow-id",
            task_queue="hello-mtls-task-queue",
        )
        print(f"Result: {result}")


if __name__ == "__main__":
    asyncio.run(main())
