# Ollama Operational Contract

## Installation

Ollama is already installed on the development workstation. edge-ai does not install or replace Ollama as part of normal repository setup.

## Verification

The workstation baseline has been verified locally:

- Ollama version: 0.34.4
- gemma3:4b
- llama3.1:8b
- devstral-small-2:latest

The exact installed Ollama version and available model inventory should remain benchmark evidence rather than being assumed from documentation. Re-run the verification commands when the workstation baseline changes:

    ollama --version
    ollama list

## Workstation Resource Baseline

The current benchmark workstation is a Dell Precision Tower 3620 with:

- Intel Xeon E3-1270 v5 @ 3.60 GHz;
- 4 cores / 8 logical processors;
- 27.9 GB visible system RAM;
- NVIDIA GeForce RTX 3060 with 12 GB VRAM;
- NVIDIA driver 591.86;
- CUDA 13.1 reported by nvidia-smi.

At the baseline measurement, approximately 8.3 GB of system RAM and 5.78 GB of RTX 3060 VRAM were free while normal Windows applications were running.

The workstation's Xeon E3-1270 v5 does not provide integrated graphics. The motherboard video outputs therefore cannot be treated as an available second GPU for offloading desktop graphics workloads.

Memory measurements are point-in-time evidence. Benchmark runs should record resource usage before and after each candidate model test.

## Baseline Endpoint

Local agents should use the local Ollama service. Do not hard-code credentials or expose the local inference endpoint beyond the intended workstation boundary.

## Model Management

Model pulls are explicit workstation operations. Model cache data does not belong in Git. Model download/storage size is not itself a selection constraint; runtime resource requirements and observed task performance are.

## Resource Policy

Only a controlled number of inference workloads should run concurrently. Benchmark candidates should be evaluated for GPU VRAM usage, system RAM pressure, CPU utilization, latency, context behavior, and repository-task quality.

Large quantized models may be tested even when they exceed available GPU VRAM, provided the resulting GPU/system-RAM offloading behavior is measured and the workstation remains operational.

## Failure Handling

If a model cannot load, times out, exhausts resources, or produces materially unreliable work, record the result and select another candidate. Do not compensate by weakening repository rules.
