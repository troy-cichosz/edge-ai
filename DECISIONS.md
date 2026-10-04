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

## D-010 - Model Selection Is Replaceable

Model names and versions may change as benchmarking identifies better local choices. Agent contracts and project rules must not depend on a single model vendor or model family.

## D-011 - Common Evidence Envelope Contract

The Evidence Envelope increment is governed by a service-neutral contract owned by `edge-ai`. The contract is specification/schema material, not a shared Python runtime package.

The common envelope is a governance/provenance layer. Existing service-specific artifact manifests remain separate and authoritative for their service-specific artifact structure. The common envelope must not replace existing video or audio manifest structures with a single service-specific object.

The envelope contract is `ai-legal.evidence.envelope.v1`. Breaking changes require a new major contract version (for example v2); additive backward-compatible fields may remain within v1.

The canonical Capture Time Context is the full 20-field contract established by `edge-time`. Consumers must represent fields they cannot establish through explicit contract-defined optional/unavailable semantics rather than silently omitting required temporal meaning.

Temporal unavailability uses one standardized structured representation across services; service-specific strings, null-only conventions, or silent omission are not alternate contract forms.

The controlled `time_semantics` vocabulary must distinguish context acquisition from physical exposure/capture and derived timing. A temporal context record does not by itself prove physical exposure timing.

Video and audio persist the common envelope as a sidecar alongside their existing manifest/metadata structures. Raw media and existing authoritative manifests remain unchanged by the envelope addition. The existing video envelope builder is treated as incomplete foundation and must be wired into finalized persistence rather than duplicated.

A finalized envelope sidecar must use atomic-write discipline. This does not imply an unsupported transactional claim across two independent files; the implementation must explicitly preserve the validity and detectability of the existing authoritative manifest if sidecar creation fails.

For finalized evidence, `capture.end` represents the service's finalized capture end timestamp derived from its recorded `end_utc`; it must not be represented as physical exposure end unless the service can establish that fact.

Cross-service validation must use a shared contract validator and independent per-service fixtures. Tests must not make one service's implementation depend on or validate another service by importing its runtime code.

The Evidence Envelope increment must preserve evidence immutability and prove that adding the sidecar does not alter the bytes of the existing authoritative manifest.

## D-012 - Evidence Envelope Development Gate

The approved Evidence Envelope architecture must be implemented only after the corrected TASK-AGENT-006 plan has passed independent review. Planning, implementation, testing, and compliance review remain separate qualification stages. No implementation is authorized by D-011 alone.
