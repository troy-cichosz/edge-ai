# edge-ai

Reusable local AI development environment for the AI Legal Platform and its edge-service repositories.

## Purpose

`edge-ai` manages the local AI infrastructure used by the development process. It is intentionally broader than an Ollama wrapper.

The environment provides:
- local Ollama model execution;
- explicit model definitions and selection policy;
- role-specific local agents;
- coding-agent contracts and guardrails;
- independent rules/compliance review;
- testing and review-agent integration points;
- controlled repository/tool access;
- context and handoff conventions;
- Windows workstation setup and verification;
- resource and concurrency policy for the local GPU;
- operational logs and reproducible validation.

The environment must be reusable across:
- `ai-legal-platform-development`;
- `edge-controller`;
- `edge-time`;
- `edge-gps`;
- `edge-video`;
- `edge-audio`;
- future AI Legal Platform repositories.

## Current Development-Agent Objective

The immediate purpose of this environment is to establish a local development agent that can continue the actual AI Legal Platform edge-platform work from the current repository and project state. The agent must be able to inspect authoritative documentation and source, understand existing architecture and service boundaries, implement scoped changes in Python, test and debug those changes, review its diff, update appropriate project documentation, and report verified versus unverified state accurately.

This is a development capability objective, not a model-size or token-speed competition. A model is useful for the role only when representative real repository tasks demonstrate the required behavior. The same local AI host may later be reused for legal-AI workloads; that later workload is evaluated separately.

## Cost boundary

The base development environment must require **$0 incremental AI cost**.

Local inference uses Ollama and locally hosted models. ChatGPT Free may be used by the human for architecture, requirements, reasoning, and review, but the local development environment must not depend on:
- a paid OpenAI API;
- ChatGPT Free as an API backend;
- a paid hosted coding-agent subscription;
- any other paid hosted inference service.

Optional hosted integrations may be added later only when explicitly approved; they are not part of the baseline.

## Architectural boundary

`edge-ai` is the implementation and operational home for the reusable local AI environment.

It is **not** the authoritative source for:
- AI Legal Platform service architecture;
- evidence authority or provenance rules;
- temporal authority;
- controller/service contracts;
- repository release policy;
- runtime deployment truth.

Those remain authoritative in the project and service repositories.

## Agent roles

The initial role model is:
1. **Human** - final authority and operational control.
2. **ChatGPT** - architecture, requirements, cross-repository reasoning, and review.
3. **Coding Agent** - implements an explicitly scoped task using local models/tools.
4. **Rules/Compliance Agent** - independently checks adherence after implementation.
5. **Testing/Review Agents** - test and inspect behavior independently.

The coding agent must preserve the existing architecture and working behavior unless an explicitly approved task changes them. Broad unsolicited rewrites are prohibited.

## Repository workflow

```
Human / ChatGPT
      |
      v
GitHub Issue / task scope
      |
      v
edge-ai local agent environment
      |
      +--> Coding Agent
      |
      +--> Rules / Compliance Agent
      |
      +--> Testing / Review Agents
      |
      v
GitHub chatgpt
      |
      v
edge-platform-automation
      |
      v
ADO chatgpt mirror
      |
      v
existing repository CI/CD or public-maintenance path
      |
      v
GitHub public
```

The local AI environment does not bypass GitHub source control, repository instructions, or the established ADO verification path.

## Current status

Initial repository structure and governance are established.

The next implementation increment is intentionally focused on establishing a controlled local development-agent configuration:
1. qualify an established free/open-source repository-oriented agent framework;
2. qualify its repository, filesystem, tool, permission, and write boundaries;
3. validate a minimal controlled repository task with one local model;
4. validate representative Python and multi-file repository work;
5. evaluate local models within the qualified framework;
6. add independent compliance and testing stages;
7. validate cross-repository and project-state continuation;
8. document the resulting operating procedure.

Model selection therefore follows framework and tool-boundary qualification. Ollama installation itself is already complete on the baseline Windows workstation.

Ollama installation itself is already complete on the baseline Windows workstation. Reinstallation or replacement is not part of this increment unless verification identifies a concrete problem.

## Security

Never commit:
- Ollama API credentials;
- GitHub tokens;
- ADO credentials;
- SSH private keys;
- repository secrets;
- model caches;
- personal data;
- evidence data from the AI Legal Platform.

Repository and filesystem access should be explicitly scoped. Agents must not receive unrestricted destructive access merely because a task can be completed with it.
