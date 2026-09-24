# Windows Workstation

## Purpose

Defines the workstation-side contract for the reusable local AI environment.

## Baseline

- Windows 11;
- Git and GitHub access;
- Visual Studio Code;
- local Ollama installation;
- existing local repository checkouts;
- local test/build tooling required by each target repository.

## Workflow

1. Receive a scoped GitHub Issue/task.
2. Prepare the repository from GitHub `chatgpt`.
3. Read repository instructions and architecture/status documentation.
4. Run the local coding agent with the required task scope.
5. Run independent rules/compliance review.
6. Run tests/review agents.
7. Inspect the final diff.
8. Commit the approved work to GitHub `chatgpt`.
9. Let the established GitHub → ADO automation path handle synchronization and downstream verification.

## Safety

Agents should have access only to repositories and paths required for the current task. Credentials and secrets must remain outside repositories.

Do not install Docker Desktop merely to satisfy the local AI environment. Individual repositories may have their own runtime requirements.
