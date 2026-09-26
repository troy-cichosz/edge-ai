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

## Evaluation Wishlist

The benchmark set should deliberately include more than conventional small dense models. Model disk size is not a primary constraint for this project; runtime feasibility, memory pressure, latency, context behavior, and repository-task quality are.

Candidate families and classes to investigate include:
- current coding-focused models with strong agent/tool-use behavior;
- Qwen coding and reasoning models;
- Gemma models and other general models that may perform well in coding/review roles;
- mixture-of-experts (MoE) models with large total parameter counts but relatively few active parameters per token;
- large quantized models that may exceed GPU VRAM but remain viable using system RAM;
- models with very long context windows suitable for repository-scale work;
- unusually large models worth testing when their quality may justify slower inference;
- efficient models specifically designed for consumer/local hardware;
- any candidate that demonstrates strong real-world coding-agent performance despite modest active-parameter counts.

A previously recalled model name sounding like "Calabri" has not been positively identified. Do not add an assumed model under that name; investigate the identity if it becomes relevant.

The wishlist is an evaluation queue, not a commitment to download every candidate. Candidates should be narrowed after the workstation hardware/resource baseline is established.

## Current Verified Inventory

The workstation currently has:
- Ollama 0.34.4;
- gemma3:4b;
- llama3.1:8b;
- devstral-small-2:latest.

These are the currently verified local models and are not yet selected defaults for any agent role.

## Hardware Constraint

The current workstation has 12 GB of RTX 3060 VRAM and approximately 28 GB of system RAM, but normal Windows desktop workloads consume a material portion of both resources.

The current baseline measurement showed approximately:
- 5.78 GB free RTX 3060 VRAM;
- 8.3 GB free system RAM.

These figures are not hard model-size limits. They establish the starting point for measuring GPU-only inference, GPU/system-RAM offloading, latency, memory pressure, and task quality.

The workstation's Intel Xeon E3-1270 v5 does not provide integrated graphics, so the benchmark plan must not assume that desktop applications can be moved to an integrated GPU to free RTX 3060 VRAM.

## Benchmark Rule

No model becomes the default coding model solely because it is the largest or newest available model. The selected model must complete a controlled real repository task and pass independent review.
