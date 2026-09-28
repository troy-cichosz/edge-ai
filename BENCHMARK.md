# Local Model Benchmark

## Purpose

This benchmark establishes reproducible evidence for selecting local models for the edge-ai agent roles. Model selection is based on controlled repository-task performance plus measured resource behavior, not model size, reputation, or subjective preference.

## Current Candidate Set

Verified on 2026-09-25:

- gemma3:4b
- llama3.1:8b
- devstral-small-2:latest

The workstation is running Ollama 0.34.4. The RTX 3060 12 GB is dedicated to local AI/CUDA workloads and the AMD FirePro W4100 drives Windows displays. The workstation has approximately 27.9 GB visible system RAM and approximately 16.1 GB free at the current idle baseline.

## Phase 1 - Runtime Baseline

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

- `qwen3:14b` - approximately 9.3 GB in Ollama; Qwen3 provides native tool support and includes dense and MoE variants.
- `gpt-oss:20b` - approximately 14 GB in Ollama; the model provides native function calling and structured-output capabilities.
- `qwen3-coder:30b` - approximately 19 GB in Ollama; this coding-focused MoE model has 30B total parameters with approximately 3.3B active parameters and native tool-calling support.

These candidates are an evaluation set, not a ranking or selection. Pull and benchmark them one at a time. Do not keep multiple large candidates loaded concurrently.

The workstation has approximately 27.9 GB visible system RAM and approximately 16.1 GB free at the current idle baseline. The `qwen3-coder:30b` and `gpt-oss:20b` candidates are therefore expected to require meaningful CPU/system-RAM offloading on this workstation; measure actual behavior rather than assuming feasibility from model size.

## Development-Agent Benchmark Objective

The benchmark is now explicitly evaluating the practical local development-agent capability required to continue the existing AI Legal Platform edge-platform work. The target is not maximum raw generation speed. The evaluation must establish repository comprehension, architecture preservation, Python implementation quality, testing/debugging, documentation and project-state accuracy, diff discipline, honest validation, and repeatable continuation from real project state.

The benchmark remains incremental: controlled harness correctness first, then focused repository tasks, then representative Python edge-service work, multi-file/cross-service work, and finally development-agent acceptance with independent review. Legal-AI workload evaluation is a later capability track and is not used to distort the current development-agent benchmark.

## Phase 2 - Repository Task

Use a clean working copy of the exact edge-ai chatgpt benchmark starting commit.

The first controlled task is:

### TASK-001 - Scoped Repository Documentation Change

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

### TASK-001 - Scoped Repository Documentation Change

All three current candidates failed to complete TASK-001.

| Model | Result | Evidence |
|---|---|---|
| gemma3:4b | Failed | Native tool calling is unsupported; controlled text fallback did not produce the required file operation. No repository change. |
| llama3.1:8b | Failed | Native tool capability was available, but the model returned a textual pseudo-tool call instead of a structured tool call. No repository change. |
| devstral-small-2:latest | Failed | Structured tool use succeeded for repository inspection, but the model stopped before performing the required `write_file`. No repository change. |

Earlier runner/harness defects encountered during development were corrected and are not counted as model-performance failures. The final Devstral TASK-001 run demonstrated that the structured tool path was operational.

### TASK-002 - Verified Model Inventory Documentation Change

TASK-002 was introduced because TASK-001 did not exercise an actual completed repository write for any candidate.

| Model | Result | Evidence |
|---|---|---|
| gemma3:4b | Failed | Native tool calling is unsupported; controlled text fallback did not produce the required file operation. No repository change. |
| llama3.1:8b | Failed | The model produced a textual pseudo-`write_file` call rather than executing the structured operation. Its proposed content was also inconsistent with the requested inventory. No repository change. |
| devstral-small-2:latest | Failed | Structured repository reads succeeded, but the model attempted to select itself as the coding model despite an explicit prohibition and never executed `write_file`. No repository change. |

### TASK-003 - Minimal Write-Boundary Test

TASK-003 deliberately reduced the repository task to one sentence replacement in `MODELS.md` so that actual write capability, preservation of unrelated content, and validation accuracy could be evaluated independently of broader documentation reasoning.

Required change:

- Replace `These are the starting local models and are not yet selected defaults for any agent role.`
- With `These are the currently verified local models and are not yet selected defaults for any agent role.`

| Model | Structured tools | Result | Evidence |
|---|---|---|---|
| gemma3:4b | No native tool calling | Failed | Controlled text fallback did not produce the required write operation. Working tree remained clean. |
| llama3.1:8b | Yes | Failed | Executed structured `write_file`, but replaced the entire 72-line `MODELS.md` with one sentence. The model then incorrectly reported that only the requested sentence had changed. The working tree was restored. |
| devstral-small-2:latest | Yes | Failed | Executed structured `write_file`, but introduced unrelated encoding corruption in the existing "Calabri" text and removed the final newline in addition to the requested sentence change. The model then incorrectly reported that there were no other changes. The working tree was restored. |

TASK-003 therefore produced no accepted implementation from any candidate. The observed Llama and Devstral failures include both preservation/instruction-adherence defects and inaccurate self-validation. These observations are evidence about the tested runs; they do not establish a general property of all uses of the models.

### qwen3:14b - Runtime and TASK-003

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

TASK-003 was then run from the clean benchmark starting state. qwen3:14b used the structured `write_file` operation and reread `MODELS.md`, then ran `git_status`, `git_diff`, and `git_diff_check`. The required sentence replacement was not present in the resulting diff. Instead, the existing "Calabri" text was corrupted and the final newline was removed. The model then incorrectly reported that only the requested sentence had changed. The working tree was restored to the clean starting state after inspection.

Result: **Failed TASK-003.** The runtime generation result is valid, but the tested coding-agent run did not satisfy the repository write-boundary, preservation, or self-validation requirements. The evidence does not by itself distinguish which portion of the encoding transformation originated in the model versus the tool/runner path; it does establish that the end-to-end coding-agent result was unacceptable for the controlled task.


### gpt-oss:20b - TASK-003

TASK-003 was executed against a reconstructed fixture because the original recorded benchmark starting commit `9aee2dbd8c3d8585812b60fe5300b55131369fb4` is no longer reachable from the GitHub or ADO `chatgpt` history. The fixture was derived from the current clean `chatgpt` state by changing only the documented target sentence backward to the TASK-003 precondition. This is not evidence that the historical commit itself was executed.

The reconstructed fixture was verified before the coding run:

- only `MODELS.md` was modified;
- the diff contained only the documented one-sentence reverse change;
- `git diff --check` passed;
- the target precondition was present.

gpt-oss:20b then used the structured `write_file` operation and reported that it had changed only `MODELS.md`. Independent inspection of the resulting diff showed that it did not preserve the file:

- the requested sentence replacement was present;
- unrelated existing "Calabri" text was corrupted;
- the final newline was removed;
- the model incorrectly reported that the requested change was the only change;
- `git diff --check` passed despite the semantic corruption and missing final newline.

Result: **Failed TASK-003.** This is an end-to-end coding-agent failure involving file preservation and inaccurate self-validation. The evidence establishes the unacceptable final repository state for this controlled run; it does not by itself establish whether the encoding corruption originated solely in model output or was introduced/altered by the runner/tool path.

The temporary reconstructed worktree was kept separate from the real development checkout, and the real `chatgpt` checkout remained clean throughout the test.



### qwen3:14b - TASK-003

TASK-003 was executed against a reconstructed fixture because the original recorded benchmark starting commit `9aee2dbd8c3d8585812b60fe5300b55131369fb4` is no longer reachable from the GitHub or ADO `chatgpt` history. The fixture was derived from the current clean `chatgpt` state by changing only the documented target sentence backward to the TASK-003 precondition. This is not evidence that the historical commit itself was executed.

The reconstructed fixture was verified before the coding run:

- only `MODELS.md` was modified;
- the diff contained only the documented one-sentence reverse change;
- `git diff --check` passed;
- the target precondition was present.

qwen3:14b used the structured `write_file` operation and reread `MODELS.md`, then ran `git_status`, `git_diff`, and `git_diff_check`. Independent inspection of the resulting diff showed that it did not preserve the file:

- the requested sentence replacement was present;
- unrelated existing "Calabri" text was corrupted; the final newline was removed;
- the model incorrectly reported that only the requested sentence had changed;
- `git diff --check` passed despite the semantic corruption and missing final newline.

Result: **Failed TASK-003.** This is an end-to-end coding-agent failure involving file preservation and inaccurate self-validation. The evidence establishes the unacceptable final repository state for this controlled run; it does not by itself establish whether the encoding corruption originated solely in model output or was introduced/altered by the runner/tool path.

The temporary reconstructed worktree was separate from the real development checkout, and the real `chatgpt` checkout remained clean throughout the test.



### gpt-oss:20b - Runtime

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

### Harness correction - 2026-09-25

The TASK-003 runs for qwen3:14b and gpt-oss:20b, as well as the earlier devstral-small-2:latest run, exposed the same class of unrelated Unicode corruption and final-newline loss during complete-file replacement. Because the tested models shared the same coding-agent runner and repository read/write path, the end-to-end results cannot safely attribute that corruption to the models alone.

The runner was therefore inspected before continuing the candidate sequence. The repository read path used PowerShell `Get-Content -Raw` without an explicit encoding. On Windows PowerShell 5.1, BOM-less UTF-8 files are read using the system's default ANSI code page when no encoding is specified. This is incompatible with the repository's UTF-8 text files and is a credible common-path cause of the observed corruption. The runner has been corrected to use an explicit UTF-8, no-BOM .NET reader for repository text and the existing explicit UTF-8, no-BOM writer for file replacement.

This harness correction is committed on GitHub `chatgpt` and must be validated with an isolated read/write preservation test before additional model benchmarking. No `public` branch was modified.

Until that validation and a clean rerun of the affected TASK-003 runs, the observed model-specific preservation conclusions remain **end-to-end observations under the previous runner**, not isolated evidence about model capability.

## Current Direction

The benchmark now qualifies a practical local development-agent configuration rather than indefinitely ranking individual models. The preferred path is to use an established free/open-source repository-oriented coding-agent framework that works with the existing Windows, Git, Ollama, and repository workflow.

Model behavior remains important, but model selection is evaluated within a framework configuration. Deterministic repository, branch, permission, and release controls must enforce hard boundaries instead of relying on model instruction-following alone. Independent testing/compliance review and human acceptance remain separate acceptance controls.

The existing bespoke runner and its historical results remain useful evidence about harness behavior and earlier model/framework runs. They do not require continued expansion of bespoke infrastructure when an established framework provides the required capabilities.

## Coding-Agent Framework Discovery

Before extending the custom runner or committing to a single framework, evaluate established local/repository-oriented candidates that fit the project constraints. The initial discovery set is:

- Aider
- Cline
- Roo Code
- Continue
- OpenHands

The discovery criteria are:

- free/open-source operation without a paid hosted coding-agent requirement;
- Windows support;
- local Ollama/model support;
- Git-aware repository operation;
- repository instructions/context handling;
- tool execution and file-edit reliability;
- test execution and validation support;
- controllable permissions and working boundaries;
- compatibility with the chatgpt development branch and no-direct-public rule;
- practical operation on the current RTX 3060 12 GB / approximately 28 GB RAM workstation.

Aider remains the first established framework under active evaluation. Its normal workflow can create commits automatically, so Aider qualification must explicitly configure --no-auto-commits when the task requires the agent not to commit. This is a framework configuration boundary and must not be treated as a model instruction-following test.

## Coding-Agent Framework Evaluation

### Framework pivot - 2026-09-27

The benchmark moved from the bespoke PowerShell coding-agent runner to an established repository-oriented coding-agent framework before continuing substantive development-agent evaluation. Aider was selected as the first framework to evaluate because it provides Git-aware repository mapping, structured file editing, testing integration, and local Ollama support without requiring a paid hosted coding service.

The bespoke runner remains documented as harness history. Its observed transport and tool-path defects are not being treated as model capability results when the harness itself prevented valid task execution.

The development-agent benchmark now evaluates the end-to-end combination of coding-agent framework plus local model. A successful run requires correct implementation, focused tests, preservation of unrelated content, required validation, scoped changes, ASCII compliance, and accurate reporting. Independent review remains mandatory.

### Aider / gpt-oss:20b - TASK-PY-003

TASK-PY-003 was the first substantive Python edge-service task run through Aider. The task required a live HLS failure to disable the live branch for the remainder of capture while the authoritative evidence branch continued receiving data, with focused pytest coverage and explicit diff/validation checks.

The Aider run produced the intended production change in app/media.py:

- set self.live_enabled = False when the live process is already exited;
- set self.live_enabled = False when the live pipe raises BrokenPipeError or OSError.

The generated tests/test_media.py was not acceptable. The failure simulation was implemented on DummyProcess.write(), while the production code writes to live.stdin.write() and stdin was an io.BytesIO; therefore the simulated failure was never actually triggered. The tests also attempted to inspect BytesIO after the production shutdown path had closed it. Independent execution produced two failures:

- test_live_failure_disables_live - ValueError: I/O operation on closed file;
- test_live_normal_operation - ValueError: I/O operation on closed file.

The run also introduced an unrelated .gitignore file and a non-ASCII whitespace character in tests/test_media.py, violating the repository ASCII-only rule. The Aider transcript did not demonstrate completion of the requested pytest, final-diff, and git diff --check validation before the run stopped for interactive input.

Result: **Failed TASK-PY-003.** The production implementation direction was correct, but the end-to-end development-agent result failed test correctness, validation discipline, scope/encoding compliance, and autonomous completion requirements. This is an Aider/gpt-oss:20b end-to-end observation and is not treated as a universal claim about either Aider or gpt-oss:20b.

The disposable benchmark worktree is not an accepted implementation and must not be promoted to chatgpt or public.

### Current framework evaluation state

Aider is the active coding-agent framework under evaluation. The next controlled run should use a clean disposable worktree and a different substantive task/model combination where practical. Do not repair a failed benchmark result before recording it; repairs would contaminate the evaluation. The qwen3:14b and qwen3-coder:30b candidates remain available for subsequent Aider evaluation.



### Aider / qwen3:14b - TASK-PY-003

TASK-PY-003 was run through Aider with qwen3:14b from a clean disposable edge-video worktree. The task required the live HLS branch to be disabled after failure while the authoritative evidence branch continued receiving data, with focused pytest coverage for failure and normal-operation behavior.

The model identified the need to track live-branch failure and attempted to implement that behavior. However, the resulting production edit was not acceptable:

- unrelated recording-format text was corrupted: "h264" became "h26线";
- the inserted non-ASCII character violates the repository ASCII-only source policy;
- the displayed _read_capture() diff was malformed/incomplete and could not be accepted as a trustworthy implementation.

The generated tests/test_media.py was also not acceptable:

- only one test was visibly created;
- it manually set pipeline.live_failed = True instead of exercising an actual live process or pipe failure;
- it therefore did not demonstrate that evidence continues after a real failure;
- it did not demonstrate that the failed live pipe is not written to again;
- it did not demonstrate the existing live_error mechanism;
- it did not provide the requested normal-operation coverage.

Aider's auto-test reported:

    tests/test_media.py
    1 passed in 0.59s

That result did not validate the requested behavior because the test itself bypassed the failure mechanism. The transcript did not demonstrate the requested final git diff or git diff --check validation. Aider also automatically added .aider* to .gitignore, creating an unrelated working-tree change.

The run ended with Aider summarization failures after the test result. Those summarization errors are secondary; the benchmark failure was already established by the invalid production edit, inadequate tests, ASCII violation, and incomplete validation evidence.

Result: **Failed TASK-PY-003.** This is an end-to-end Aider/qwen3:14b observation from the controlled run and is not treated as a universal claim about either Aider or qwen3:14b.

The disposable benchmark worktree is not an accepted implementation and must not be promoted to chatgpt or public.

### Aider / devstral-small-2:latest - TASK-PY-004

TASK-PY-004 was run through Aider against a clean disposable edge-video worktree at baseline commit `b1554cffb13b76cc6944c4cd92609e54b405adca`. The task required live-stream failure handling for startup failure, process exit during capture, BrokenPipe/OSError during capture, and normal operation, with tests exercising the actual production paths and preserving the authoritative evidence branch.

The run progressed into implementation and automated testing:

- Aider modified `app/media.py` and created `tests/test_media.py`.
- The production implementation attempted to track live failure with `live_failed` and suppress subsequent live writes after live startup/process/pipe failure.
- The generated tests attempted to cover all four requested scenarios.
- Independent execution of the resulting tests produced **2 failed, 2 passed**.
- The startup-failure test assigned the simulated exception to the wrong `subprocess.Popen` invocation, so it failed during capture-process startup rather than exercising the live startup-failure path.
- The process-exit test exhausted its mocked capture stream and raised `StopIteration` before correctly validating the requested live-process exit behavior.
- The normal-operation and BrokenPipe tests passed in the resulting test file.
- The production diff introduced an unrelated change from `stdin=subprocess.DEVNULL` to `stdin=subprocess.PIPE` for the capture process.
- The production diff also removed unrelated blank-line formatting.
- ASCII checks of both changed source files passed.
- The agent did not complete the repair and final validation cycle before the run was stopped.

Result: **Failed TASK-PY-004.** The run did not satisfy the required end-to-end implementation, focused test coverage, scope discipline, and validation requirements. The result is an observation of this Aider/devstral-small-2:latest run and is not treated as a universal claim about either Aider or the model.

The disposable benchmark worktree was subsequently reset to `b1554cffb13b76cc6944c4cd92609e54b405adca` and cleaned. No benchmark implementation or generated artifacts were promoted to `chatgpt` or `public`.

### Aider / qwen3:14b - TASK-PY-003 - Edit-Format Failure

A second Aider/qwen3:14b TASK-PY-003 run was started from clean disposable edge-video baseline commit b1554cffb13b76cc6944c4cd92609e54b405adca. The task was the same live-stream failure-handling and focused production-path pytest task described above.

The model produced intermediate output in which four requested tests were reported as passing:

- test_live_process_exits_during_capture
- test_broken_pipe_during_live_write
- test_os_error_during_live_write
- test_normal_operation_both_branches_receive_data

However, Aider then reported an edit-format failure: "The LLM did not conform to the edit format" and "No filename provided before ``` in file listing". The model attempted to regenerate the complete app/media.py edit and became stuck while producing the file. The run was interrupted.

Independent inspection after interruption established:

- app/media.py was unchanged from the clean baseline;
- tests/test_media.py existed only as an untracked artifact and did not contain runnable tests;
- Aider artifacts and the task file were untracked;
- independent python -m pytest tests/test_media.py -q reported "no tests ran";
- there was no tracked implementation diff to inspect;
- the worktree was then reset to b1554cffb13b76cc6944c4cd92609e54b405adca and cleaned.

Result: **Failed TASK-PY-003.** The intermediate passing-test output cannot be accepted as a repository-task result because Aider failed to materialize the implementation and tests into the worktree. This is recorded as an end-to-end Aider/qwen3:14b edit-format/materialization failure, not as evidence that the underlying code solution was incorrect.

No benchmark implementation or generated artifact was promoted to chatgpt or public.


### Aider / gpt-oss:20b - TASK-PY-004

TASK-PY-004 was run through Aider with gpt-oss:20b from clean disposable edge-video baseline commit b1554cffb13b76cc6944c4cd92609e54b405adca. The task required live-stream failure handling for startup failure, process exit during capture, BrokenPipe/OSError during capture, and normal operation, with tests exercising the actual production paths and preserving the authoritative evidence branch.

Independent inspection of the resulting worktree established:

- app/media.py contained only the three intended production changes: disable self.live_enabled after live startup failure, after a detected live-process exit, and after BrokenPipeError/OSError during live writes.
- The production implementation remained otherwise unchanged; the evidence-first capture path, recording format, manifest schema, temporal behavior, hashing behavior, and process ownership were preserved.
- tests/test_media.py contained four tests and independent pytest execution reported 4 passed.
- The tests did not fully satisfy the requested coverage. There was no separate OSError test, and the failure tests did not assert that evidence received subsequent capture chunks after live failure or that the failed live pipe received no later writes.
- Pytest emitted one PytestCollectionWarning because the helper dataclass was named TestConfig.
- git diff --check passed.
- ASCII validation passed for the tracked production diff.
- The only tracked source diff was app/media.py; tests/test_media.py was an untracked benchmark artifact and therefore was not part of the tracked diff.
- Aider did not demonstrate the required final complete-file inspection, final diff review, ASCII check, changed-file verification, or exact final report. Its final summarization also failed.

Result: **Failed TASK-PY-004.** The production implementation was correct and minimally scoped, but the end-to-end development-agent result did not satisfy the complete task because the generated test coverage was incomplete and the required final validation/reporting was not demonstrated. The independent 4-passing-test result is retained as evidence, but it is not treated as sufficient acceptance evidence.

This is an end-to-end Aider/gpt-oss:20b observation and is not treated as a universal claim about either Aider or gpt-oss:20b. The disposable benchmark worktree is not an accepted implementation and must not be promoted to chatgpt or public.


### Aider / qwen3:14b - TASK-PY-004

TASK-PY-004 was run through Aider with qwen3:14b from clean disposable edge-video baseline commit b1554cffb13b76cc6944c4cd92609e54b405adca. The task required live-stream failure handling for startup failure, process exit during capture, BrokenPipe/OSError during capture, and normal operation, with tests exercising the actual production _read_capture() paths and preserving the authoritative evidence branch.

Independent inspection established that Aider modified app/media.py and created tests/test_media.py. The production edit introduced live_active handling for startup failure, live-process exit, and BrokenPipeError/OSError, but also corrupted the recording format string from "h264" to "h26线", violating recording-format preservation and the ASCII-only source policy. The generated five-test suite failed all five tests under independent pytest execution. The tests did not validly prove evidence continuation after live failure, suppression of later writes to the failed live pipe, or normal-operation delivery to both branches. The complete Aider transcript was not retained, so no claims are made about its internal reasoning or the cause of the prolonged run. Independent GPU verification confirmed qwen3:14b was using the RTX 3060 at 24% CPU / 76% GPU, so GPU selection was not the cause of the failure. git diff --check passed for the resulting tracked production diff. The disposable worktree was reset and cleaned to the exact baseline, and no benchmark implementation or generated artifacts were promoted to chatgpt or public.

Result: **Failed TASK-PY-004.** The end-to-end development-agent result did not satisfy the implementation, recording-format preservation, focused test coverage, or validation requirements. This is an end-to-end Aider/qwen3:14b observation and is not treated as a universal claim about either Aider or qwen3:14b.

## Phase 3 - Independent Review

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

Do not assign an overall score or ranking. The evidence determines whether a candidate satisfies a documented role requirement. For the development-agent role, successful continuation of representative real repository work is the acceptance evidence.

## Development-Agent Validation Sequence

The benchmark should progress from low-risk controlled tasks to actual continuation of the edge-platform workflow:

1. Harness correctness and byte-preservation validation.
2. Minimal repository write-boundary task.
3. Python single-file implementation task in a real repository.
4. Python multi-file implementation and test task in an edge service.
5. Cross-service task where an explicit contract requires coordinated repository changes.
6. Project/documentation-state continuation task using authoritative status and history.
7. Independent compliance/testing review and human acceptance.

The existing model-specific results below remain historical evidence from their documented runs. They are not converted into an overall ranking. Model selection remains pending until the required development-agent stages are completed.

## Execution Order

The current evaluation order is framework-first rather than an indefinite model-by-model sequence:

1. Survey established free/local repository-oriented coding-agent frameworks against the project constraints.
2. Qualify a small common repository task across the shortlisted frameworks from clean disposable worktrees.
3. Select the practical framework configuration based on end-to-end behavior, control boundaries, repository handling, and validation support.
4. Evaluate one or more local Ollama models within the selected framework, using the existing benchmark evidence where it remains applicable.
5. Establish deterministic branch/repository/permission/release controls around the selected agent configuration.
6. Add independent rules/compliance and testing/review checks.
7. Validate the resulting workflow against a low-risk real edge-repository task.
8. Human acceptance is required before the workflow is treated as operational.

Historical model-specific benchmark results remain retained above as evidence. They are not converted into an overall ranking and do not by themselves determine the framework.

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