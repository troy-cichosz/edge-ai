# edge-ai Architecture

## Purpose

`edge-ai` is the reusable local AI development environment for the AI Legal Platform. It supplies the local inference, agent roles, controls, and operational conventions used to implement and independently review work across the platform repositories.

## Boundary

`edge-ai` owns the local AI environment. It does not become the source of truth for the application architecture of `edge-controller`, `edge-time`, `edge-gps`, `edge-video`, `edge-audio`, or other platform services.

Those repositories remain authoritative for their own implementation, service contracts, runtime behavior, and service documentation.

## Role Architecture

```text
Human / ChatGPT
      |
      v
GitHub Issue / scoped task
      |
      v
Qualified Agent Framework
      |
      +--> repository rules
      +--> scoped tools and permissions
      +--> repository/worktree boundary
      |
      v
Local Ollama Model
      |
      v
Coding Agent
      |
      v
Independent Rules / Compliance Agent
      |
      v
Testing / Review Agents
      |
      v
GitHub chatgpt
      |
      v
edge-platform-automation
      |
      v
ADO chatgpt
```

## Model Separation

Model choice is a replaceable implementation detail. Agent contracts, repository rules, task scope, and verification requirements are not model-dependent.

A stronger model may be selected for coding, while a separate model or invocation is used for compliance. The system must not assume that the same model can reliably enforce its own work.

## Agent Configuration Boundary

The qualified unit is the complete development-agent configuration:

```text
Agent Framework
    +
Local Model
    +
Repository Rules
    +
Tool Permissions
    +
Repository/Worktree Boundary
    +
Independent Validation
```

The framework and model are replaceable components. A model that performs well in isolation is not thereby a qualified coding agent. Deterministic repository, branch, permission, and release controls must not depend solely on model instruction following.
## Repository Context

Agents must construct context from source-controlled files and the current task rather than relying on conversational memory alone.

At minimum, coding context should include:
- task/Issue;
- repository instructions;
- applicable architecture and project rules;
- README/status documentation;
- target source files;
- relevant tests;
- relevant cross-service contracts.

## Execution Boundary

Local agents should operate with explicit repository and filesystem scopes. Destructive operations require an explicit task need and should be prevented by default where practical.

Local inference is provided by Ollama. The baseline does not require a paid hosted inference API.
