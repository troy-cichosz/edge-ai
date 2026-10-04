# TASK-AGENT-006 Corrected Plan

## Purpose

This plan defines the controlled implementation of the common Evidence Envelope increment across edge-video and edge-audio. It is a qualification artifact, not authorization for an agent to make additional architectural decisions.

Implementation is gated on this plan passing independent review. The service repositories remain untouched until that gate passes.

## Authoritative contract

The service-neutral contract is owned by edge-ai.

Authoritative files:

- `EVIDENCE_ENVELOPE_V1.md` — normative human-readable contract.
- `schema/evidence-envelope-v1.json` — the normative language-neutral JSON Schema used as the common contract validator.

There is no shared Python runtime package.

The schema artifact is the interoperability boundary. Each service's tests must validate its independent fixture against an exact copy of the canonical schema artifact identified by its content hash. A service may use its existing test tooling to perform that validation; no new shared runtime dependency or cross-service runtime import is authorized.

The contract identifier is `ai-legal.evidence.envelope.v1`. Unknown major versions MUST be rejected. Additive properties within v1 are permitted; consumers MUST preserve required known-property validation and MUST NOT interpret an unknown additive property as evidence of a new major version. Breaking changes require v2.

## Current state

The following implementation facts were verified during TASK-AGENT-006 and must be re-verified against the current service commits immediately before implementation:

- edge-video has `app/evidence.py` with an existing `build_evidence_envelope()` foundation, but the runtime persistence path does not currently invoke it.
- edge-video has a service-specific video manifest; that manifest remains authoritative for video artifact structure.
- edge-video currently validates fewer than the canonical 20 Capture Time Context members in its consumer path.
- edge-audio currently requires only `context_id` and `capture_utc` from temporal context.
- edge-audio does not yet provide the common envelope's required integrity and temporal_provenance structures.
- No shared Python runtime package is authorized.
- Existing service-specific manifests and raw media are working evidence structures and must be preserved.

If any current-state statement or named path is stale, implementation stops and the plan is escalated rather than silently changed.

## Canonical Capture Time Context

The authoritative 20-field Capture Time Context is the current edge-time `CaptureTimeContext` model at:

`edge-time/app/models.py`, `chatgpt` baseline verified for this plan.

The 20 members, in canonical order, are:

1. `context_id`
2. `capture_utc`
3. `capture_monotonic_ns`
4. `device_id`
5. `selected_source`
6. `source_observation`
7. `uncertainty_ms`
8. `freshness`
9. `freshness_age_ms`
10. `synchronization_state`
11. `authority_id`
12. `authority_source`
13. `consistency_state`
14. `consistency_offset_ms`
15. `consistency_uncertainty_ms`
16. `consistency_threshold_ms`
17. `holdover_state`
18. `attestation_sequence`
19. `attestation_record_hash`
20. `attestation_signature`

The nested `source_observation` retains the edge-time fields `source_id`, `source_type`, `utc`, `uncertainty_ms`, `valid`, `details`, `observed_monotonic_ns`, and `observed_wall_utc`.

All 20 member names are required in an Evidence Envelope `time_context` object. A value is either its canonical edge-time value or the standardized unavailable object below. Consumers MUST NOT silently omit a member.

For canonical edge-time values, the original edge-time types and meanings are preserved. The envelope does not redefine edge-time authority.

## Standard unavailable representation

When a consumer cannot establish a canonical Capture Time Context member, the member MUST remain present with:

```json
{
  "status": "unavailable",
  "reason_code": "not_available_to_service"
}
```

Allowed `status` values are:

- `available` — represented by the canonical field value; the unavailable object is not used.
- `unavailable` — represented by the object above.

Allowed unavailable `reason_code` values are:

- `not_available_to_service`
- `not_observed`
- `not_applicable`

`invalid`, malformed values, and failed validation are errors, not unavailable states.

The unavailable object is the only contract-defined representation of unavailable temporal context. Null-only, omitted, empty-string, and service-specific string conventions are not equivalent.

## time_semantics

The controlled vocabulary is exactly:

- `context_acquisition` — the timestamp represents acquisition/receipt of temporal context by the service.
- `physical_capture` — the timestamp represents physical sensor/media capture only when the service's evidence establishes that fact.
- `derived` — the timestamp is calculated from other recorded evidence.

`time_semantics` is an object under `temporal_provenance` mapping timestamp paths to one of these values. At minimum, finalized envelopes MUST classify `capture.start`, `capture.end`, and `time_context.capture_utc`.

A service MUST NOT label a timestamp `physical_capture` merely because it received a Capture Time Context from edge-time.

## Envelope layering

The common Evidence Envelope is a governance/provenance layer.

Existing service-specific artifact manifests remain separate and authoritative. The common envelope MUST reference artifacts and their integrity information without replacing the service-specific manifest.

Minimum common fields:

- `schema`
- `evidence_id`
- `service`
- `service_version`
- `node_id`
- `capture`
- `time_context`
- `artifacts`
- `integrity`
- `temporal_provenance`
- `service_metadata`
- `derivation`
- `configuration`

Raw media is never embedded in the envelope.

## Persistence

Both services persist the common envelope as a sidecar adjacent to the finalized existing evidence output.

### edge-video

Complete and wire the existing `app/evidence.py` envelope builder into the finalized recorder persistence path. Do not create a second envelope builder.

### edge-audio

Construct and persist the common envelope through the existing finalized metadata flow. The authorized audio construction/persistence owner is the existing `app/recorder.py` finalized-evidence path, using `app/time_context.py` for temporal context and `app/main.py` only if required to connect the existing persistence flow. A new dedicated envelope module is not authorized unless implementation inspection proves the existing path cannot own the construction; such a case must be escalated before adding a file.

## capture.end

For finalized evidence, envelope `capture.end` MUST be derived from the service's recorded `end_utc`.

If the authoritative manifest has no `end_utc`, envelope `capture.end` remains null, consistent with the existing video envelope behavior.

The envelope timestamp MUST use the same serialized timestamp value/precision as the authoritative manifest value from which it was derived. The envelope MUST NOT relabel this as physical exposure end unless independently established.

Timestamp interchange uses RFC 3339 date-time syntax. urlRFC 3339 referencehttps://www.rfc-editor.org/rfc/rfc3339.html

## Atomicity and failure behavior

The envelope sidecar is written with the service's existing atomic metadata-write discipline. The minimum sidecar mechanism is: write a temporary file in the same directory, flush/close it using the service's existing mechanism, then atomically rename it to the final sidecar name. A partial final sidecar MUST NOT be exposed.

No transaction across the existing manifest and envelope sidecar is claimed.

If sidecar creation fails:

- the existing authoritative manifest remains valid and detectable;
- no partial final envelope sidecar is left behind;
- the failure is surfaced through the service's existing error/reporting mechanism;
- the evidence remains distinguishable as missing its required envelope rather than being silently reported as fully envelope-compliant.

The implementation MUST use the existing audio/video atomic-write mechanism where available and must not silently defer the required envelope atomicity.

## Immutability

Adding the envelope is additive.

- Raw media bytes MUST remain unchanged.
- Existing authoritative manifest bytes MUST remain unchanged.
- Tests MUST capture the original manifest bytes, add/finalize the envelope, and prove byte-for-byte equality afterward.
- The envelope's integrity information MUST refer to the preserved evidence artifacts/manifests; it MUST NOT require rewriting them.

## Cross-service validation

The common validator is the canonical JSON Schema artifact in edge-ai. There is no shared runtime Python package.

Each service supplies independent fixtures:

- one fully populated Capture Time Context fixture;
- one fixture exercising standardized unavailable values;
- one finalized capture fixture with `end_utc`;
- one malformed/unknown-major-version fixture that MUST be rejected.

Each service validates its own fixtures against the same schema artifact revision. Tests MUST NOT import the other service's runtime implementation.

The populated fixture requirement is explicit: tests MUST contain real non-null temporal values so a None-vs-None comparison cannot masquerade as contract preservation.

## Authorized implementation scope

### edge-ai

- Create/update `EVIDENCE_ENVELOPE_V1.md`.
- Create `schema/evidence-envelope-v1.json`.
- Correct the already-approved decision record only to remove the duplicate D-010 numbering and record the clarified contract details.
- Do not alter unrelated benchmark/model-selection policy.

### edge-video

Expected paths are limited to:

- `app/evidence.py`
- `app/recorder.py`
- `app/time.py` only if required
- focused evidence/recorder tests
- `docs/EVIDENCE_SCHEMA.md`
- `docs/ARCHITECTURE.md`
- relevant status/README documentation only where required

### edge-audio

Expected paths are limited to:

- `app/recorder.py`
- `app/time_context.py`
- `app/main.py` only if required
- focused time-context/evidence-envelope tests
- relevant status/README documentation only where required

No unrelated source, tests, configuration, Docker, dependencies, deployment, CI/CD, controller, edge-time, or edge-gps changes are authorized.

## Required tests and acceptance criteria

1. Both services produce envelopes conforming to `ai-legal.evidence.envelope.v1`.
2. Both services use all 20 canonical Capture Time Context member names.
3. Unavailable temporal values use the exact standardized object and reason vocabulary.
4. `time_semantics` uses only the three controlled values.
5. Finalized `capture.end` derives from `end_utc`, with identical serialized timestamp value/precision.
6. A fully populated temporal fixture is validated; tests cannot pass using only null/unavailable values.
7. Malformed envelopes and unknown major versions are rejected.
8. Raw media bytes are unchanged.
9. Existing authoritative manifest bytes are byte-for-byte unchanged.
10. Envelope sidecar writes use atomic final-file creation.
11. Sidecar failure leaves the existing manifest valid/detectable, leaves no partial final sidecar, and surfaces an error.
12. Per-service fixtures validate independently against the same canonical schema artifact.
13. Existing service tests pass.
14. Qualification diff inspection shows no unrelated files.
15. Independent compliance/review finds no unauthorized architectural or scope changes.
16. GitHub `public` remains untouched.

Where cross-file crash consistency cannot be transactional, the tests MUST verify the failure semantics above and MUST NOT claim both-or-neither transactionality.

## Qualification sequence

1. Correct the plan and authoritative edge-ai contract artifacts.
2. Independently review the corrected plan and contract.
3. Only after review passes, re-verify current edge-video and edge-audio state at their exact baselines.
4. Run implementation in disposable qualification worktrees.
5. Independently inspect diffs and repository state.
6. Run focused and regression tests.
7. Perform independent compliance/review.
8. Only after qualification passes may implementation be considered for promotion to GitHub `chatgpt`.
9. GitHub `public` remains untouched unless explicitly authorized.

## Qualification objective

Success is not merely producing working Evidence Envelope code. Success requires demonstrating that a local development agent can understand the existing architecture, follow durable rules, implement the explicitly approved increment without inventing architecture, preserve existing intent, and withstand independent review.
