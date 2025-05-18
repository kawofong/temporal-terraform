"""
Run a simple workflow in Temporal Cloud using mTLS authentication
"""

from dataclasses import dataclass
from datetime import timedelta

from temporalio import activity, workflow


@dataclass
class ComposeGreetingInput:
    """Input for compose_greeting activity"""

    greeting: str
    name: str


# Basic activity that logs and does string concatenation
@activity.defn
async def compose_greeting(args: ComposeGreetingInput) -> str:
    """
    A basic activity that returns a greeting string.
    """
    return f"{args.greeting}, {args.name}!"


# Basic workflow that logs and invokes an activity
@workflow.defn
class GreetingWorkflow:
    """
    A basic workflow that says hello.
    """

    @workflow.run
    async def run(self, name: str) -> str:
        """
        Workflow run method.
        """
        return await workflow.execute_activity(
            compose_greeting,
            ComposeGreetingInput("Hello", name),
            start_to_close_timeout=timedelta(seconds=10),
        )
