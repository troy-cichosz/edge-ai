# Local Model Policy

## Objective

Select local models for specific agent roles based on observed repository-task performance, not model reputation alone.

## Initial Roles

| Role | Primary requirement | Status |
|---|---|---|
| Coding | Reliable multi-file repository implementation with instruction adherence | To benchmark |
| Rules / Compliance | Independent inspection against durable project rules | To benchmark |
| Testing / Review | Test interpretation, defect detection, and verification reporting | To benchmark |
| General / Planning | Local fallback for planning and context preparation | To benchmark |

## Selection Criteria

Candidate models should be evaluated for:
- instruction adherence;
- ability to inspect an existing repository before editing;
- preservation of established architecture;
- multi-file consistency;
- test generation and execution reasoning;
- diff quality;
- resistance to unrelated rewrites;
- long-context repository comprehension;
- tool-use reliability;
- latency and resource consumption on the local workstation.

## Hardware Constraint

The first benchmark target is the existing Windows workstation with its local Ollama installation. Model fit must be measured by actual coding performance and resource behavior, not only by whether a model technically loads.

## Benchmark Rule

No model becomes the default coding model solely because it is the largest or newest available model. The selected model must complete a controlled real repository task and pass independent review.
