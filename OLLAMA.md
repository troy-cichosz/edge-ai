# Ollama Operational Contract

## Installation

Ollama is already installed on the development workstation. `edge-ai` does not install or replace Ollama as part of normal repository setup.

## Verification

Before model benchmarking, verify locally:
```powershell
ollama --version
ollama list
```

The exact installed Ollama version and available model inventory should be recorded as part of the benchmark evidence rather than assumed from documentation.

## Baseline Endpoint

Local agents should use the local Ollama service. Do not hard-code credentials or expose the local inference endpoint beyond the intended workstation boundary.

## Model Management

Model pulls are explicit workstation operations. Model cache data does not belong in Git.

## Resource Policy

Only a controlled number of inference workloads should run concurrently. Initial benchmarking should measure VRAM/RAM pressure, latency, context behavior, and task quality.

## Failure Handling

If a model cannot load, times out, exhausts resources, or produces materially unreliable work, record the result and select another candidate. Do not compensate by weakening repository rules.
