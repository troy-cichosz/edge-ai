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

## D-009 - Framework and Model Are Separate Components

The local development-agent architecture separates the agent framework/tool layer from the local model. Framework qualification precedes model optimization.

The qualified unit is the framework, model, repository rules, tool permissions, repository/worktree boundary, and independent validation together. A model is not accepted as a coding-agent default based on isolated generation quality.

## D-010 - Deterministic Boundaries and Independent Validation

Hard repository, branch, permission, and release boundaries must be enforced deterministically where practical rather than relying solely on model instruction following.

The coding agent's own report is informational. Actual repository state, tests, diff inspection, and independent compliance/review evidence are authoritative for acceptance.

## D-011 - Model Selection Is Replaceable

Model names and versions may change as benchmarking identifies better local choices. Agent contracts and project rules must not depend on a single model vendor or model family.

## D-012 - Common Evidence Envelope Contract

The Evidence Envelope increment is governed by a service-neutral contract owned by `edge-ai`.

The authoritative contract artifacts are `EVIDENCE_ENVELOPE_V1.md` and `schema/evidence-envelope-v1.json`. These are specification/schema material only. No shared Python runtime package is part of this increment.

The common envelope is a governance/provenance layer. Existing service-specific artifact manifests remain separate and authoritative for their service-specific artifact structure.

The contract identifier is `ai-legal.evidence.envelope.v1`. Unknown major versions are rejected. Additive properties remain within v1; breaking changes require a new major version.

The canonical Capture Time Context is the complete 20-field edge-time contract. All 20 member names are required in the envelope `time_context`; fields a service cannot establish use the standardized unavailable representation rather than omission.

Temporal unavailability uses `status: unavailable` with a permitted reason code of `not_available_to_service`, `not_observed`, or `not_applicable`. Null-only, omitted, empty-string, and service-specific string representations are not equivalent.

The controlled `time_semantics` vocabulary is `context_acquisition`, `physical_capture`, and `derived`. Receiving time context does not establish physical capture timing.

Video and audio persist the envelope as a sidecar. Raw media and existing authoritative manifests remain unchanged.

The existing video envelope builder must be wired into finalized persistence rather than duplicated. Audio envelope construction is owned by its existing finalized recorder/metadata path.

A finalized envelope sidecar uses atomic-write discipline without claiming a transaction across the existing manifest and sidecar. If sidecar creation fails, the existing authoritative manifest remains valid and detectable and no partial final sidecar is exposed.

Finalized `capture.end` is derived from recorded `end_utc` and is not represented as physical exposure end unless independently established.

Cross-service validation uses the canonical language-neutral schema artifact and independent per-service fixtures. Services do not import each other's runtime implementations.

The increment must prove raw-media and authoritative-manifest immutability.

## D-013 - Evidence Envelope Development Gate

The approved Evidence Envelope architecture may be implemented only after the corrected TASK-AGENT-006 plan and contract artifacts pass independent review. Planning, implementation, testing, and compliance review remain separate qualification stages. No implementation is authorized by D-012 alone.

## D-014 - Agent Tool-Use Execution Is Part of Qualification

A local coding-agent configuration must be evaluated on its complete end-to-end execution behavior, including use of available repository tools, shell/tool compatibility with the host environment, repository inspection, scoped editing, testing, diff inspection, and accurate completion reporting. Repeated invented tool calls, incompatible command use, inspection loops, or failure to reach the authorized implementation/validation stages constitute qualification failures even when the underlying model has passed narrower coding tasks.

Such a failure is evidence about the tested framework/model/rules/tool configuration. It must not be generalized into a universal claim about the model or framework, and it must not be repaired and reclassified as a benchmark success.
