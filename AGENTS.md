# edge-ai Agent Contract

## Before Work

Before changing this repository, the agent must read:
1. `README.md`;
2. `ARCHITECTURE.md`;
3. `DECISIONS.md`;
4. the applicable configuration under `config/`;
5. the target task or GitHub Issue.

If the task affects an AI Legal Platform repository, the agent must also read that repository's current instructions and authoritative architecture/status documentation.

## Core Rules

- Preserve existing architecture and working behavior unless the task explicitly changes them.
- Make the smallest change that satisfies the task.
- Preserve repository text encoding and line endings when modifying existing files; do not introduce unrelated Unicode or newline changes.
- Do not perform broad rewrites, framework migrations, model substitutions, or cross-service redesigns without explicit approval.
- Do not invent APIs, runtime behavior, hardware capabilities, deployment facts, or test results.
- Treat repository instructions and source-controlled documentation as durable authority.
- Never expose or commit credentials, tokens, private keys, model caches, personal data, or evidence data.
- Do not push GitHub `public` directly.
- Development work belongs on GitHub `chatgpt` unless a task explicitly states otherwise.
- Do not treat a model's confidence as proof of compliance.

## Agent Separation

The coding agent is not the final compliance authority. After implementation, an independent rules/compliance stage must inspect the result.

The compliance stage must check at minimum:
- task scope;
- repository instructions;
- architecture preservation;
- evidence/provenance boundaries;
- temporal authority where applicable;
- controller/service boundaries;
- branch/workflow rules;
- documentation ownership;
- tests and verification evidence;
- unnecessary or unrelated changes.

## Verification

Before declaring a task complete, report:
- files changed;
- tests executed and their results;
- build results where applicable;
- warnings or failures;
- behavior that remains unverified;
- exact Git branch and commit.

Never claim deployment or runtime verification unless it was actually observed.

## Escalation

Escalate instead of guessing when a task changes:
- cross-repository contracts;
- evidence authority or immutability;
- temporal authority;
- controller boundaries;
- database architecture;
- deployment dependencies;
- branch or release workflow;
- security boundaries;
- local-agent permission boundaries.
