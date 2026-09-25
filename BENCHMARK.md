# Local Model Benchmark

## Purpose

This benchmark establishes reproducible evidence for selecting local models for the edge-ai agent roles. Model selection is based on controlled repository-task performance plus measured resource behavior, not model size, reputation, or subjective preference.

## Current Candidate Set

Verified on 2026-09-25:

- gemma3:4b
- llama3.1:8b
- devstral-small-2:latest

The workstation is running Ollama 0.34.4. The RTX 3060 12 GB is dedicated to local AI/CUDA workloads and the AMD FirePro W4100 drives Windows displays. The workstation has approximately 27.9 GB visible system RAM and approximately 16.1 GB free at the current idle baseline.

## Phase 1 — Runtime Baseline

For each model, record:

- exact Ollama model name;
- Ollama version;
- start/end time;
- model load duration when exposed by the Ollama API;
- prompt token count;
- generated token count;
- prompt evaluation duration;
- generation duration;
- prompt tokens/second;
- generation tokens/second;
- peak RTX 3060 VRAM;
- peak system RAM;
- CPU utilization where practical;
- whether inference remains responsive and operational.

Runtime results alone do not select a model.

### Existing historical baselines

Before Devstral Small 2 was installed, the same Ollama API measurement produced:

- llama3.1:8b: load 5.356 s; generation 62.7 tok/s; peak VRAM approximately 5.14 GB.
- gemma3:4b: load 5.748 s; generation 90.1 tok/s; peak VRAM approximately 3.75 GB.

These are historical measurements. Re-run them under the controlled benchmark procedure before making direct performance comparisons.

## Phase 2 — Repository Task

Use a clean working copy of the exact edge-ai chatgpt benchmark starting commit.

The first controlled task is:

### TASK-001 — Scoped Repository Documentation Change

Make a small, real change to edge-ai that tests repository comprehension, instruction adherence, documentation consistency, and change discipline without changing runtime behavior.

Before editing, the coding model must read:

- README.md
- AGENTS.md
- ARCHITECTURE.md
- DECISIONS.md
- MODELS.md
- OLLAMA.md

The task is to add a new README section titled **Benchmarking** that:

1. states that local model selection is based on controlled repository-task evidence and runtime resource measurements;
2. identifies BENCHMARK.md as the benchmark procedure;
3. states that coding-agent output requires independent review before acceptance;
4. does not duplicate the full benchmark procedure;
5. does not change the cost boundary, branch workflow, architecture, or security rules.

### Task constraints

- Expected changed file: README.md only.
- Do not modify AGENTS.md, ARCHITECTURE.md, DECISIONS.md, MODELS.md, or OLLAMA.md.
- Do not modify application repositories.
- Do not modify GitHub public.
- Do not modify Ollama configuration or model storage.
- Do not add dependencies.
- Do not rename or reorganize files.
- Do not invent benchmark results.
- Do not rewrite unrelated documentation.

The model must inspect the complete final file and Git diff and report any validation it could not perform.

## Controlled Repository Task Results

The controlled repository tasks below were run from the benchmark baseline commit:

- Starting commit: `9aee2dbd8c3d8585812b60fe5300b55131369fb4`
- Repository: `troy-cichosz/edge-ai`
- Development branch: `chatgpt`
- Public branch: not modified
- Working tree was restored to a clean state between model runs.
- The coding-agent runner version used for these final runs was from the `chatgpt` development history after the benchmark baseline; harness changes were recorded separately from model behavior.

### TASK-001 — Scoped Repository Documentation Change

All three current candidates failed to complete TASK-001.

| Model | Result | Evidence |
|---|---|---|
| gemma3:4b | Failed | Native tool calling is unsupported; controlled text fallback did not produce the required file operation. No repository change. |
| llama3.1:8b | Failed | Native tool capability was available, but the model returned a textual pseudo-tool call instead of a structured tool call. No repository change. |
| devstral-small-2:latest | Failed | Structured tool use succeeded for repository inspection, but the model stopped before performing the required `write_file`. No repository change. |

Earlier runner/harness defects encountered during development were corrected and are not counted as model-performance failures. The final Devstral TASK-001 run demonstrated that the structured tool path was operational.

### TASK-002 — Verified Model Inventory Documentation Change

TASK-002 was introduced because TASK-001 did not exercise an actual completed repository write for any candidate.

| Model | Result | Evidence |
|---|---|---|
| gemma3:4b | Failed | Native tool calling is unsupported; controlled text fallback did not produce the required file operation. No repository change. |
| llama3.1:8b | Failed | The model produced a textual pseudo-`write_file` call rather than executing the structured operation. Its proposed content was also inconsistent with the requested inventory. No repository change. |
| devstral-small-2:latest | Failed | Structured repository reads succeeded, but the model attempted to select itself as the coding model despite an explicit prohibition and never executed `write_file`. No repository change. |

### TASK-003 — Minimal Write-Boundary Test

TASK-003 deliberately reduced the repository task to one sentence replacement in `MODELS.md` so that actual write capability, preservation of unrelated content, and validation accuracy could be evaluated independently of broader documentation reasoning.

Required change:

- Replace `These are the starting local models and are not yet selected defaults for any agent role.`
- With `These are the currently verified local models and are not yet selected defaults for any agent role.`

| Model | Structured tools | Result | Evidence |
|---|---|---|---|
| gemma3:4b | No native tool calling | Failed | Controlled text fallback did not produce the required write operation. Working tree remained clean. |
| llama3.1:8b | Yes | Failed | Executed structured `write_file`, but replaced the entire 72-line `MODELS.md` with one sentence. The model then incorrectly reported that only the requested sentence had changed. The working tree was restored. |
| devstral-small-2:latest | Yes | Failed | Executed structured `write_file`, but introduced unrelated encoding corruption in the existing “Calabri” text and removed the final newline in addition to the requested sentence change. The model then incorrectly reported that there were no other changes. The working tree was restored. |

TASK-003 therefore produced no accepted implementation from any candidate. The observed Llama and Devstral failures include both preservation/instruction-adherence defects and inaccurate self-validation. These observations are evidence about the tested runs; they do not establish a general property of all uses of the models.

No model is selected as a coding, compliance, testing/review, or planning default as a result of these tasks.

## Phase 3 — Independent Review

A separate review invocation/model must inspect each coding result against:

1. TASK-001 requirements;
2. AGENTS.md;
3. ARCHITECTURE.md;
4. DECISIONS.md;
5. expected changed-file scope;
6. validation evidence.

The coding model must not be the sole authority for accepting its own work.

## Result Record

Record one result per model:

| Field | Value |
|---|---|
| Model | exact Ollama model name |
| Ollama version | exact version |
| Task | TASK-001 |
| Starting commit | exact SHA |
| Elapsed time | measured |
| Load time | measured/API-reported |
| Prompt tokens | measured |
| Generated tokens | measured |
| Generation tok/s | measured |
| Peak VRAM | measured |
| Peak system RAM | measured |
| Files changed | exact list |
| Tests/validation | exact commands/results |
| Independent review | findings |
| Unverified behavior | explicit list |

Do not assign an overall score or ranking. The evidence determines whether a candidate satisfies a documented role requirement.

## Execution Order

Run the three current candidates using the same procedure:

1. gemma3:4b
2. llama3.1:8b
3. devstral-small-2:latest

Do not pull additional models until these candidates have been measured against TASK-001.

## Runtime Measurement Command

The basic Ollama API call for a controlled generation is:

    $body = @{
        model = "MODEL_NAME"
        prompt = "Reply with exactly one sentence stating that this is a controlled local model benchmark."
        stream = $false
        options = @{ num_predict = 128 }
    } | ConvertTo-Json

    Measure-Command {
        $result = Invoke-RestMethod `
            -Uri "http://127.0.0.1:11434/api/generate" `
            -Method Post `
            -ContentType "application/json" `
            -Body $body
    }

The JSON response contains Ollama timing and token counters used for the runtime record.

Resource measurements must be captured separately with nvidia-smi and Windows resource tooling. A single API timing does not establish peak GPU or system-RAM usage.

## Acceptance Boundary

The benchmark establishes evidence. It does not automatically select a coding model.

A model becomes a role candidate only after:

1. runtime behavior is measured;
2. TASK-001 is completed from the same starting state;
3. the resulting diff is inspected;
4. independent review is completed;
5. failures and unverified behavior are recorded.

The selected model-to-role policy will be documented only after those observations exist.