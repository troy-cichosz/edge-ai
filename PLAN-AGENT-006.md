# TASK-AGENT-006 Corrected Plan

## Purpose

This plan defines the controlled implementation of the common Evidence Envelope increment across edge-video and edge-audio. It is a qualification artifact for the local development-agent workflow, not authorization for the agent to make additional architectural decisions.

The implementation must follow the approved architecture recorded in edge-ai DECISIONS.md and the existing AI Legal Platform rules. Planning, independent review, implementation, testing, and compliance review remain separate stages.

## Current State Verified During TASK-AGENT-006

- edge-video contains an existing evidence-envelope builder in app/evidence.py, but the builder is not currently invoked by the runtime persistence path. It is therefore incomplete foundation, not evidence that edge-video already emits persisted envelopes.
- edge-video has an existing service-specific video manifest and a separate envelope schema identifier, ai-legal.evidence.envelope.v1.
- edge-video currently validates 16 Capture Time Context fields in its consumer path.
- edge-audio currently requires only context_id and capture_utc from temporal context.
- edge-audio's existing evidence metadata does not yet provide the common integrity and temporal_provenance structures required by the common envelope.
- No shared Python runtime package is authorized or required for this increment.
- Existing service-specific manifests and raw media are working evidence structures and must be preserved.

## Approved Architecture

### 1. Canonical contract ownership

The service-neutral Evidence Envelope contract is owned by edge-ai.

Create the authoritative contract specification as:

    EVIDENCE_ENVELOPE_V1.md

The contract is specification/schema material only. Do not create a shared Python runtime package as part of this increment.

The contract identifier is:

    ai-legal.evidence.envelope.v1

Breaking contract changes require a new major version. Additive backward-compatible fields remain within v1.

### 2. Layering

The common Evidence Envelope is a governance/provenance layer.

Existing service-specific artifact manifests remain separate and authoritative for service-specific artifact structure. Do not replace the video or audio manifest with one universal service-specific object.

The envelope must include, at minimum, the contract-defined representations of:

- schema
- evidence_id
- service
- service_version
- node_id
- capture
- time_context
- artifacts
- integrity
- temporal_provenance
- service_metadata
- derivation
- configuration

Exact field types and validation rules belong in EVIDENCE_ENVELOPE_V1.md and must not be invented independently by either service.

### 3. Capture Time Context

The canonical Capture Time Context is the complete 20-field edge-time contract established by the existing edge-time implementation.

Both consumers must conform to that canonical contract.

A consumer must not silently omit temporal fields merely because the consumer cannot establish them. The contract must explicitly distinguish required fields, conditionally applicable fields, and unavailable values.

The implementation must use the existing edge-time contract as the source of truth rather than duplicating or redefining it in a service.

### 4. Temporal unavailability

Temporal unavailability must have one standardized structured representation across edge-video and edge-audio.

The representation must distinguish unavailable temporal context from a valid value and from an omitted field. Service-specific strings, null-only conventions, and silent omission are not alternate representations.

The contract must define the structured status and the permitted reason information. Services must emit the same representation.

### 5. time_semantics

time_semantics uses a controlled vocabulary defined by the common contract.

The vocabulary must preserve the distinction between:

- context acquisition timing;
- physical exposure/capture timing; and
- derived timing.

A Capture Time Context does not, by itself, establish physical exposure timing.

A service may claim physical exposure timing only when its own evidence establishes it.

### 6. Persistence

Both edge-video and edge-audio persist the common Evidence Envelope as a sidecar adjacent to their existing evidence output.

Do not embed the governance envelope into raw media.

Do not replace or rewrite the existing authoritative service-specific manifest merely to add the envelope.

For edge-video, the existing app/evidence.py builder must be completed and wired into the finalized recorder persistence path. Do not create a second parallel envelope builder.

For edge-audio, add the common envelope to the finalized evidence persistence path using the service's existing metadata flow.

### 7. Capture timestamp semantics

For finalized evidence, envelope `capture.start` is the service's finalized capture start timestamp and MUST be a non-null RFC 3339 date-time value. A missing or unavailable finalized capture start is an implementation/validation error; this contract does not define a null or unavailable representation for `capture.start`.

Envelope `capture.end` is derived from the service's recorded `end_utc`. If the authoritative manifest has no `end_utc`, `capture.end` is null.

`capture.end` means the service's finalized capture end timestamp. It must not be described as physical exposure end unless the service can establish that fact.

### 8. Atomicity and failure behavior

The envelope sidecar must be written using the same atomic-write discipline required for finalized evidence metadata.

Do not claim transactional atomicity across two independent files unless the implementation actually provides it.

The existing authoritative manifest must remain valid and detectable if sidecar creation fails. The implementation and tests must document and verify the resulting failure behavior.

The task must not silently defer required audio metadata atomicity while simultaneously claiming atomic finalized evidence output.

### 9. Immutability

Adding the envelope is additive.

Raw media bytes must remain unchanged.

Existing authoritative manifest bytes must remain unchanged.

Tests must prove that adding/finalizing the envelope does not alter the existing manifest bytes.

### 10. Cross-service validation

Cross-service validation must use the common contract specification/validator and independent per-service fixtures.

Do not import edge-video runtime code into edge-audio tests or vice versa.

The common contract is the interoperability boundary.

## Authorized Implementation Scope

### edge-ai

- Add EVIDENCE_ENVELOPE_V1.md defining the canonical common contract and validation semantics.
- Update DECISIONS.md only as necessary to maintain the already-approved decision record.
- Do not alter unrelated benchmark or model-selection policy.

### edge-video

Expected implementation areas are limited to the existing evidence/recorder/time paths and their focused tests and documentation:

- app/evidence.py
- app/recorder.py
- app/time.py only if required by the canonical contract
- focused evidence/recorder tests
- docs/EVIDENCE_SCHEMA.md
- docs/ARCHITECTURE.md
- relevant README/status/sprint documentation only where required to describe the implemented behavior

Do not rewrite unrelated video code.

### edge-audio

Expected implementation areas are limited to the existing evidence/recorder/time-context paths and their focused tests and documentation:

- app/recorder.py
- app/time_context.py
- app/main.py only if required by the existing persistence flow
- focused time-context/evidence-envelope tests
- relevant README/status/sprint documentation only where required to describe the implemented behavior

For finalized envelope persistence, app/recorder.py must explicitly implement or invoke the required temp-file-in-same-directory, flush/close, and atomic-rename discipline; this atomicity work is part of the authorized audio scope and must not be treated as optional.

Do not rewrite unrelated audio code.

## Required Tests

At minimum, implementation validation must establish:

1. Both services can produce an envelope conforming to ai-legal.evidence.envelope.v1.
2. Both services use the same canonical Capture Time Context contract.
3. Each service has a fully populated Capture Time Context fixture containing all 20 canonical members with available values, and that fixture serializes and validates against the common contract.
4. Temporal unavailable state is represented identically by both services.
5. time_semantics values conform to the controlled vocabulary.
6. Finalized capture.end is derived from end_utc.
7. When end_utc is present, the serialized envelope capture.end exactly matches the authoritative manifest end_utc, including fractional-second precision; when end_utc is absent, envelope capture.end is null.
8. Envelopes with an unknown or malformed schema/major-version identifier are rejected by validation.
9. Existing raw media is unchanged.
10. Existing authoritative manifest bytes are unchanged after envelope addition.
11. Finalized envelope sidecar writes are atomic: the implementation uses a temporary file in the same directory, flushes/closes it, and atomically renames it to the finalized sidecar path. The edge-audio test must explicitly cover the recorder.py/save_metadata path or the actual envelope persistence path that provides this guarantee.
12. Failure of envelope creation does not corrupt or invalidate the existing authoritative manifest, leaves no partial finalized envelope, surfaces the failure, and makes the evidence distinguishable as missing its envelope.
13. Per-service fixtures validate independently against the common contract.
14. Existing service tests continue to pass.
15. No unrelated files are modified.

Where two-file crash consistency cannot be made transactional, tests must verify the explicitly documented failure state rather than asserting unsupported both-or-neither semantics.

## Acceptance Criteria

The implementation is acceptable only if:

- the common contract is authoritative in edge-ai;
- edge-video and edge-audio conform without importing each other's runtime implementation;
- the existing service-specific manifests remain intact;
- envelope persistence is actually exercised by the finalized runtime path in both services;
- the complete Capture Time Context contract is handled explicitly;
- temporal unavailability is standardized;
- capture.end semantics are correct;
- atomic-write and failure behavior are demonstrated;
- existing media and manifest bytes are proven unchanged;
- focused and existing regression tests pass;
- independent compliance/review finds no unauthorized architectural or scope changes;
- GitHub public is not modified.

## Explicit Non-Goals

This increment does not:

- create a shared Python package;
- redesign edge-controller;
- change edge-time authority;
- implement edge-gps;
- replace service-specific manifests;
- alter raw media formats;
- redesign deployment or CI/CD;
- select a final local AI model;
- select a final agent framework;
- authorize implementation before independent review of this corrected plan.

## Qualification Sequence

1. Independently review this corrected plan.
2. Resolve any remaining plan defects before implementation.
3. Run implementation in disposable qualification worktrees from the established baselines.
4. Require the coding agent to operate only within authorized repositories and paths.
5. Independently inspect the resulting diff and repository state.
6. Run focused and regression tests.
7. Perform independent compliance/review.
8. Only after qualification passes may any implementation be considered for promotion to the development branch.
9. GitHub public remains untouched unless explicitly authorized.

## Qualification Objective

The primary purpose of this task remains agent qualification.

Success is not merely producing working Evidence Envelope code. Success requires demonstrating that a local development agent can understand the existing AI Legal Platform architecture, follow its durable rules, preserve existing intent, execute an explicitly approved cross-service architectural increment, and withstand independent review without unrelated changes or architectural drift.
