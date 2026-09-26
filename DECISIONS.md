# edge-ai Decisions

## D-001 - Local-First AI

The baseline development environment uses local model inference through Ollama. No paid hosted AI service is required for normal operation.

## D-002 - ChatGPT Free Is Not an API Dependency

ChatGPT Free may remain the human-facing architecture and reasoning tool. The local environment must not depend on ChatGPT Free as an API backend.

## D-003 - Reusable Across Repositories

`edge-ai` is a reusable development capability for the control-plane repository and the actual AI Legal Platform/edge repositories. It is not limited to `ai-legal-platform-development`.

## D-004 - Independent Compliance

The coding agent and compliance agent are separate roles. A coding model is not the sole authority for deciding whether its own implementation followed project rules.

## D-005 - Preserve Working Architecture

Local coding agents must preserve established architecture and working behavior unless the task explicitly authorizes an architectural change. Broad unsolicited rewrites are prohibited.

## D-006 - Repository State Over Conversation State

Agents must derive durable project facts from the current repository and its source-controlled instructions rather than relying solely on prior conversation context.

## D-007 - GitHub chatgpt Is Development Branch

Development changes are made on GitHub `chatgpt`. GitHub `public` remains a release-candidate boundary and is not a direct target for local coding agents.

## D-008 - ADO Remains Operational Verification

`edge-platform-automation` synchronizes accepted GitHub `chatgpt` source to ADO. Existing ADO CI/CD and runtime verification remain part of the release path.

## D-009 - Model Selection Is Replaceable

Model names and versions may change as benchmarking identifies better local choices. Agent contracts and project rules must not depend on a single model vendor or model family.
