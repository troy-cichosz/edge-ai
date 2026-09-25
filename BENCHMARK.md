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

## Next Candidate Set

The initial three candidates have now been measured through runtime and repository-task phases. Additional candidates may therefore be evaluated.

The next controlled candidate set is:

- `qwen3:14b` — approximately 9.3 GB in Ollama; Qwen3 provides native tool support and includes dense and MoE variants.
- `gpt-oss:20b` — approximately 14 GB in Ollama; the model provides native function calling and structured-output capabilities.
- `qwen3-coder:30b` — approximately 19 GB in Ollama; this coding-focused MoE model has 30B total parameters with approximately 3.3B active parameters and native tool-calling support.

These candidates are an evaluation set, not a ranking or selection. Pull and benchmark them one at a time. Do not keep multiple large candidates loaded concurrently.

The workstation has approximately 27.9 GB visible system RAM and approximately 16.1 GB free at the current idle baseline. The `qwen3-coder:30b` and `gpt-oss:20b` candidates are therefore expected to require meaningful CPU/system-RAM offloading on this workstation; measure actual behavior rather than assuming feasibility from model size.

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

### qwen3:14b — Runtime and TASK-003

Runtime measurement was completed on 2026-09-25 using Ollama 0.34.4. The benchmark harness was configured with `think=false` so that the final response was measured separately from model reasoning output.

| Metric | Result |
|---|---:|
| Wall clock | 4.164 s |
| Load | 0.005 s |
| Prompt tokens | 31 |
| Prompt evaluation | 3.885 s |
| Generated tokens | 9 |
| Generation time | 0.240 s |
| Generation rate | 37.47 tok/s |
| Thinking tokens | 0 |
| Response | Correct |

The earlier qwen3:14b run produced an empty visible `response` while generating 128 tokens. That run is not used as the corrected runtime result because the benchmark harness was subsequently changed to disable thinking and record the separate thinking field.

TASK-003 was then run from the clean benchmark starting state. qwen3:14b used the structured `write_file` operation and reread `MODELS.md`, then ran `git_status`, `git_diff`, and `git_diff_check`. The required sentence replacement was not present in the resulting diff. Instead, the existing “Calabri” text was corrupted and the final newline was removed. The model then incorrectly reported that only the requested sentence had changed. The working tree was restored to the clean starting state after inspection.

Result: **Failed TASK-003.** The runtime generation result is valid, but the tested coding-agent run did not satisfy the repository write-boundary, preservation, or self-validation requirements. The evidence does not by itself distinguish which portion of the encoding transformation originated in the model versus the tool/runner path; it does establish that the end-to-end coding-agent result was unacceptable for the controlled task.


### gpt-oss:20b — TASK-003

TASK-003 was executed against a reconstructed fixture because the original recorded benchmark starting commit `9aee2dbd8c3d8585812b60fe5300b55131369fb4` is no longer reachable from the GitHub or ADO `chatgpt` history. The fixture was derived from the current clean `chatgpt` state by changing only the documented target sentence backward to the TASK-003 precondition. This is not evidence that the historical commit itself was executed.

The reconstructed fixture was verified before the coding run:

- only `MODELS.md` was modified;
- the diff contained only the documented one-sentence reverse change;
- `git diff --check` passed;
- the target precondition was present.

gpt-oss:20b then used the structured `write_file` operation and reported that it had changed only `MODELS.md`. Independent inspection of the resulting diff showed that it did not preserve the file:

- the requested sentence replacement was present;
- unrelated existing “Calabri” text was corrupted;
- the final newline was removed;
- the model incorrectly reported that the requested change was the only change;
- `git diff --check` passed despite the semantic corruption and missing final newline.

Result: **Failed TASK-003.** This is an end-to-end coding-agent failure involving file preservation and inaccurate self-validation. The evidence establishes the unacceptable final repository state for this controlled run; it does not by itself establish whether the encoding corruption originated solely in model output or was introduced/altered by the runner/tool path.

The temporary reconstructed worktree was kept separate from the real development checkout, and the real `chatgpt` checkout remained clean throughout the test.



### qwen3:14b — TASK-003

TASK-003 was executed against a reconstructed fixture because the original recorded benchmark starting commit `9aee2dbd8c3d8585812b60fe5300b55131369fb4` is no longer reachable from the GitHub or ADO `chatgpt` history. The fixture was derived from the current clean `chatgpt` state by changing only the documented target sentence backward to the TASK-003 precondition. This is not evidence that the historical commit itself was executed.

The reconstructed fixture was verified before the coding run:

- only `MODELS.md` was modified;
- the diff contained only the documented one-sentence reverse change;
- `git diff --check` passed;
- the target precondition was present.

qwen3:14b used the structured `write_file` operation and reread `MODELS.md`, then ran `git_status`, `git_diff`, and `git_diff_check`. Independent inspection of the resulting diff showed that it did not preserve the file:

- the requested sentence replacement was present;
- unrelated existing “Calabri” text was corrupted;
- the final newline was removed;
- the model incorrectly reported that only the requested sentence had changed;
- `git diff --check` passed despite the semantic corruption and missing final newline.

Result: **Failed TASK-003.** This is an end-to-end coding-agent failure involving file preservation and inaccurate self-validation. The evidence establishes the unacceptable final repository state for this controlled run; it does not by itself establish whether the encoding corruption originated solely in model output or was introduced/altered by the runner/tool path.

The temporary reconstructed worktree was separate from the real development checkout, and the real `chatgpt` checkout remained clean throughout the test.



### gpt-oss:20b — Runtime

Runtime measurement was completed on 2026-09-25 using Ollama 0.34.4. The benchmark harness was configured with `think=false` so that the final response was measured separately from model reasoning output.

| Metric | Result |
|---|---:|
| Wall clock | 84.687 s |
| Load | 57.540 s |
| Prompt tokens | 77 |
| Prompt evaluation | 23.140 s |
| Generated tokens | 114 |
| Generation time | 3.993 s |
| Generation rate | 28.55 tok/s |
| Thinking tokens | 82* |
| Response | Correct |
| Ollama placement | 24% CPU / 76% GPU |
| Ollama context | 4096 |
| NVIDIA VRAM after run | 12010 MiB / 12288 MiB |

\* The benchmark script's `ThinkingTokens` field is a whitespace-split diagnostic count of the returned thinking text, not an Ollama tokenizer count.

The model loaded successfully but required CPU/system-RAM offloading because its Ollama-reported model size is approximately 14 GB while the workstation has a 12 GB RTX 3060. Ollama reports the tested placement as 24% CPU / 76% GPU. The post-run NVIDIA measurement showed 12010 MiB of 12288 MiB VRAM in use. System-RAM peak was not captured during this run, so it remains unverified.

The final visible response was correct. Runtime evidence is valid for this run; it does not by itself establish suitability for a coding-agent role.

No model is selected as a coding, compliance, testing/review, or planning default as a result of these tasks.

### Harness correction — 2026-09-25

The TASK-003 runs for qwen3:14b and gpt-oss:20b, as well as the earlier devstral-small-2:latest run, exposed the same class of unrelated Unicode corruption and final-newline loss during complete-file replacement. Because the tested models shared the same coding-agent runner and repository read/write path, the end-to-end results cannot safely attribute that corruption to the models alone.

The runner was therefore inspected before continuing the candidate sequence. The repository read path used PowerShell `Get-Content -Raw` without an explicit encoding. On Windows PowerShell 5.1, BOM-less UTF-8 files are read using the system's default ANSI code page when no encoding is specified. This is incompatible with the repository's UTF-8 text files and is a credible common-path cause of the observed corruption. The runner has been corrected to use an explicit UTF-8, no-BOM .NET reader for repository text and the existing explicit UTF-8, no-BOM writer for file replacement.

This harness correction is committed on GitHub `chatgpt` and must be validated with an isolated read/write preservation test before additional model benchmarking. No `public` branch was modified.

Until that validation and a clean rerun of the affected TASK-003 runs, the observed model-specific preservation conclusions remain **end-to-end observations under the previous runner**, not isolated evidence about model capability.

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

The initial candidates have completed the current benchmark procedure under the earlier harness:

1. gemma3:4b
2. llama3.1:8b
3. devstral-small-2:latest

The next candidate set should be resumed only after the corrected runner passes the isolated text-preservation validation. Because qwen3:14b and gpt-oss:20b were tested before that correction, rerun those two candidates first from clean reconstructed fixtures. Do not proceed to qwen3-coder:30b until the affected runs have been repeated under the corrected harness.

1. qwen3:14b — rerun TASK-003
2. gpt-oss:20b — rerun TASK-003
3. qwen3-coder:30b — then test if the corrected harness remains clean

Do not select a role default from the new candidates based on model size, vendor, or reputation. Record runtime behavior first, then run the controlled repository task from the same clean starting state, inspect the resulting diff, and complete independent review.

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
2. the coding-agent harness passes its current preservation validation;
3. the applicable repository task is completed from the same starting state;
3. the resulting diff is inspected;
4. independent review is completed;
5. failures and unverified behavior are recorded.

The selected model-to-role policy will be documented only after those observations exist.