# Evidence Envelope v1

**Contract ID:** `ai-legal.evidence.envelope.v1`  
**Schema artifact:** `schema/evidence-envelope-v1.json`

This document is the normative service-neutral governance/provenance contract for finalized evidence envelopes.

## 1. Scope and layering

The Evidence Envelope is additive governance/provenance metadata. It does not replace a service's authoritative artifact manifest and does not contain raw media.

The service-specific manifest remains authoritative for service-specific artifact structure. The envelope identifies the evidence, temporal provenance, artifacts, integrity information, and service metadata needed to govern that evidence.

No shared Python runtime package is defined by this contract.

## 2. Versioning

The `schema` member MUST equal `ai-legal.evidence.envelope.v1` for this contract.

Consumers MUST reject an unknown major contract identifier.

Additive properties may be introduced within v1. Existing required properties and meanings MUST NOT be changed incompatibly within v1. Any breaking change requires a new major identifier such as `ai-legal.evidence.envelope.v2`.

## 3. Required top-level members

The envelope MUST contain:

`schema`, `evidence_id`, `service`, `service_version`, `node_id`, `capture`, `time_context`, `artifacts`, `integrity`, `temporal_provenance`, `service_metadata`, `derivation`, and `configuration`.

Unknown additive members are permitted.

## 4. Capture

`capture.start` is the finalized service capture start timestamp and MUST be a non-null RFC 3339 date-time value. A missing or unavailable finalized capture start is a validation/implementation error; this contract does not define a null or unavailable representation for `capture.start`.

`capture.end` is the finalized service capture end timestamp derived from the authoritative `end_utc`. If the authoritative manifest has no `end_utc`, `capture.end` is null.

Envelope timestamps use RFC 3339 date-time syntax. The serialized `capture.start` value MUST represent the finalized service capture start. The serialized `capture.end` value MUST match the authoritative `end_utc` value exactly, including fractional-second precision.

The envelope MUST NOT claim physical exposure timing unless the service's evidence establishes it.

## 5. Canonical Capture Time Context

The envelope `time_context` contains all 20 canonical edge-time members:

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

The nested `source_observation` contains `source_id`, `source_type`, `utc`, `uncertainty_ms`, `valid`, `details`, `observed_monotonic_ns`, and `observed_wall_utc`.

For an available value, the canonical edge-time value and type are preserved.

For a value that the service cannot establish, the member remains present with:

```json
{
  "status": "unavailable",
  "reason_code": "not_available_to_service"
}
```

Allowed unavailable reason codes are `not_available_to_service`, `not_observed`, and `not_applicable`.

Invalid or malformed values are validation errors, not unavailable values.

## 6. time_semantics

The only permitted values are:

- `context_acquisition`
- `physical_capture`
- `derived`

The value is recorded under `temporal_provenance.time_semantics` as a mapping from timestamp path to semantic value.

At minimum the mapping classifies `capture.start`, `capture.end`, and `time_context.capture_utc`.

A received Capture Time Context does not by itself establish physical sensor exposure.

## 7. Artifacts and integrity

`artifacts` identifies the finalized evidence artifacts without embedding their bytes.

Each artifact entry identifies an artifact role and its stable service-specific identity/path.

`integrity.algorithm` is `sha256` for v1.

`integrity.digests` contains SHA-256 digests identified by stable target names. The existing authoritative manifest and raw media are not rewritten to produce these values.

## 8. Other common fields

`service_metadata`, `derivation`, and `configuration` are JSON objects. Their service-specific contents remain service-owned and MUST NOT redefine common envelope semantics.

## 9. Persistence and immutability

The envelope is persisted as a sidecar adjacent to the existing finalized evidence output.

Raw media bytes and existing authoritative manifest bytes MUST remain unchanged.

The sidecar MUST be created atomically. The minimum contract is temporary-file creation in the same directory followed by atomic rename to the final sidecar name.

No transaction across the existing manifest and envelope sidecar is claimed.

If sidecar creation fails, the existing manifest remains valid and detectable, no partial final sidecar is exposed, and the service reports the missing-envelope failure.

## 10. Validation boundary

The canonical validator is the JSON Schema artifact `schema/evidence-envelope-v1.json`.

Each service validates independent fixtures against the same schema artifact revision. A service MUST NOT import another service's runtime implementation for contract validation.
