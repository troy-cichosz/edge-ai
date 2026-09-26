# Windows Workstation

## Purpose

Defines the workstation-side contract for the reusable local AI environment.

## Hardware Baseline

The current benchmark workstation is a Dell Precision Tower 3620 running Windows 11 with:

- Intel Xeon E3-1270 v5 @ 3.60 GHz;
- 4 physical cores / 8 logical processors;
- 27.9 GB visible system RAM;
- NVIDIA GeForce RTX 3060 with 12 GB VRAM;
- NVIDIA driver 591.86;
- CUDA 13.1 reported by nvidia-smi;
- approximately 8.3 GB free system RAM at the baseline measurement;
- approximately 6.34 GB of RTX 3060 VRAM in use and 5.78 GB free at the baseline measurement;
- Visual Studio Code;
- Git and GitHub access;
- local Ollama installation.

The memory and GPU-memory figures are point-in-time measurements while normal desktop applications were running. They are benchmark baseline evidence, not fixed capacity guarantees.

### Integrated Graphics Limitation

Although the Precision Tower 3620 platform can provide integrated Intel graphics on processors that include an integrated GPU, this workstation uses an Intel Xeon E3-1270 v5. That processor does not provide integrated graphics.

Therefore the motherboard video outputs are not an available second GPU for this workstation. Do not plan the local AI resource strategy around moving monitors or desktop applications to integrated graphics.

The RTX 3060 remains the workstation's available graphics processor for display and local AI compute unless additional hardware is installed.

## Workflow

1. Receive a scoped GitHub Issue/task.
2. Prepare the repository from GitHub chatgpt.
3. Read repository instructions and architecture/status documentation.
4. Run the local coding agent with the required task scope.
5. Run independent rules/compliance review.
6. Run tests/review agents.
7. Inspect the final diff.
8. Commit the approved work to GitHub chatgpt.
9. Let the established GitHub -> ADO automation path handle synchronization and downstream verification.

## Safety

Agents should have access only to repositories and paths required for the current task. Credentials and secrets must remain outside repositories.

Do not install Docker Desktop merely to satisfy the local AI environment. Individual repositories may have their own runtime requirements.
