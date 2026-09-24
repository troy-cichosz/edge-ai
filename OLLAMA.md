# Ollama Operational Contract

## Installation

Ollama is already installed on the development workstation. `edge-ai` does not install or replace Ollama as part of normal repository setup.

## Verification

The workstation baseline has been verified locally:

- Ollama version: `0.34.2`
- `llama3.1:8b` — 4.9 GB
- `gemma3:4b` — 3.3 GB

The exact installed Ollama version and available model inventory should remain benchmark evidence rather than being assumed from documentation. Re-run the verification commands when the workstation baseline changes:

    ollama --version
    ollama list

## Baseline Endpoint

Local agents should use the local Ollama service. Do not hard-code credentials or expose the local inference endpoint beyond the intended workstation boundary.

## Model Management

Model pulls are explicit workstation operations. Model cache data does not belong in Git. Model download/storage size is not itself a selection constraint; runtime resource requirements and observed task performance are.

## Resource Policy

Only a controlled number of inference workloads should run concurrently. Before selecting benchmark candidates, establish the workstation CPU, system RAM, GPU/VRAM, driver, and available storage baseline. Initial benchmarking should then measure VRAM/RAM pressure, latency, context behavior, and task quality.

## Failure Handling

If a model cannot load, times out, exhausts resources, or produces materially unreliable work, record the result and select another candidate. Do not compensate by weakening repository rules.
