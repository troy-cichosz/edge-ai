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
1. **Human** — final authority and operational control.
2. **ChatGPT** — architecture, requirements, cross-repository reasoning, and review.
3. **Coding Agent** — implements an explicitly scoped task using local models/tools.
4. **Rules/Compliance Agent** — independently checks adherence after implementation.
5. **Testing/Review Agents** — test and inspect behavior independently.

The coding agent must preserve the existing architecture and working behavior unless an explicitly approved task changes them. Broad unsolicited rewrites are prohibited.

## Repository workflow

```text
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

Initial repository structure is being established.

The first implementation increment is intentionally small:
1. establish repository contracts and architecture;
2. verify the existing Ollama installation;
3. define model-selection and resource policy;
4. establish agent configuration;
5. establish controlled local execution;
6. benchmark candidate coding models on the workstation;
7. validate a coding agent against a small real task;
8. add independent compliance and testing stages.

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
