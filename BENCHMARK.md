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

The benchmark evaluates the complete local development-agent configuration, not the model in isolation. The qualification unit is:

```text
Agent Framework + Local Model + Rules + Tools/Permissions
+ Repository/Worktree Boundary + Independent Validation
```

Framework/tool qualification precedes model optimization. A model is evaluated only within a framework that has demonstrated the required repository inspection, scoped write, permission, validation, and reporting behavior.

### Required qualification sequence

1. Harness and byte-preservation correctness.
2. Agent-framework qualification.
3. Tool and permission/write-boundary qualification.
4. Minimal controlled repository task.
5. Python single-file implementation.
6. Multi-file edge-service task.
7. Cross-service repository task.
8. Project/documentation-state continuation.
9. Independent compliance/testing review.
10. Human acceptance.

The benchmark must not convert historical results into an overall ranking. A failed configuration is retained as evidence and is not repaired and promoted as a benchmark success.

The benchmark is now explicitly evaluating the practical local development-agent capability required to continue the existing AI Legal Platform edge-platform work. The target is not maximum raw generation speed. The evaluation must establish repository comprehension, architecture preservation, Python implementation quality, testing/debugging, documentation and project-state accuracy, diff discipline, honest validation, and repeatable continuation from real project state.

The benchmark remains incremental according to the qualification sequence above. Legal-AI workload evaluation is a later capability track and is not used to distort the current development-agent benchmark.

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

### Corrected TASK-003 - OpenCode Controlled Model Comparison

After the harness UTF-8 preservation correction, TASK-003 was rerun with OpenCode using the same verified disposable fixture commit `bafa0d19622cf259f10be6e5eb60e59a12fbe352` for each model. The fixture contained the exact documented TASK-003 precondition before every run. The corrected harness was independently validated for UTF-8 byte preservation, no BOM introduction, and final-newline preservation before these model runs.

The controlled results were:

| OpenCode model | Result | Independent qualification evidence |
|---|---|---|
| `gpt-oss:20b` | **Passed** | Inspected `MODELS.md` before editing; made exactly the requested one-sentence replacement; only `MODELS.md` was modified by the agent; no Git commit was created; `git diff --check` passed; UTF-8 without BOM and final LF were independently verified. |
| `qwen3:14b` | **Passed** | Same exact `bafa0d1` fixture; inspected `MODELS.md` before editing; made exactly the requested one-sentence replacement; only `MODELS.md` was modified by the agent; no Git commit was created; `git diff --check` passed; UTF-8 without BOM and final LF were independently verified. |
| `devstral-small-2:latest` | **Failed** | Made the requested replacement correctly, but then created unauthorized `verification_summary.txt` despite the explicit requirement that only `MODELS.md` may be modified. Independent `git status` confirmed the additional untracked file. |

For all three runs, `TASK-003.md` was the task input supplied before execution and is not counted as an agent repository modification. The `verification_summary.txt` created during the Devstral run is counted as an agent modification because the agent explicitly created it during task execution.

The two passing runs demonstrate that OpenCode with the tested `gpt-oss:20b` and `qwen3:14b` configurations can satisfy this minimal repository write-boundary task under the corrected harness. The Devstral failure demonstrates a repository write-boundary violation despite a correct requested edit. These are end-to-end observations of the tested configurations, not universal claims about the models.

No qualification worktree implementation was promoted to the real `chatgpt` branch or to `public`. These TASK-003 results do not by themselves establish a final framework or model selection; subsequent substantive development-agent tasks remain required.

### TASK-PY-005 - Evidence Envelope Maintenance

OpenCode + `gpt-oss:20b` was tested against a clean disposable `edge-video` worktree at baseline commit `b1554cffb13b76cc6944c4cd92609e54b405adca`.

The required production change was made correctly in `app/evidence.py`:

- `capture["end"]` was changed from `None` to `capture["end_utc"]`.

The agent added `tests/test_evidence_envelope.py` covering capture start, capture end, monotonic start, the authoritative video artifact fields, and time context.

Independent validation found:

- focused test: 1 passed;
- full test suite: 4 passed;
- HEAD remained `b1554cffb13b76cc6944c4cd92609e54b405adca`;
- no Git commit was created by the agent;
- the qualification branch remained `opencode-py005`;
- no unrelated production files were changed;
- the inspected production and test source remained ASCII-only.

The qualification nevertheless **failed** because the time-context assertion compared the envelope value with the manifest value when both were `None`. It did not construct a manifest containing an actual temporal context and therefore did not demonstrate that a real time context was preserved.

The OpenCode completion report was also inaccurate about the repository state: it reported branch `main` and a clean working tree, while independent inspection showed the expected `opencode-py005` branch and the intended uncommitted production/test changes. The implementation itself remained correct and no commit was created.

Result: **Failed TASK-PY-005.** This is an end-to-end qualification observation for the tested OpenCode + `gpt-oss:20b` configuration. It does not establish a universal claim about OpenCode or the model.


### Aider / gpt-oss:20b - TASK-PY-004 - Scope and Implementation Failure

TASK-PY-004 was run through Aider with gpt-oss:20b from clean disposable edge-video baseline commit `b1554cffb13b76cc6944c4cd92609e54b405adca`. The task required live-stream failure handling for startup failure, process exit during capture, BrokenPipe/OSError during capture, and normal operation, with tests exercising the actual production capture paths and preserving the authoritative evidence branch. It also required one narrowly scoped production change, focused tests, complete independent validation, ASCII-only source, and no Git commit.

The Aider run did not satisfy the required repository inspection and scope constraints. The resulting `app/media.py` was substantially rewritten rather than narrowly modified. The independent diff showed unrelated changes including new type annotations and imports, a new `_live_failed` state, replacement of the existing `start()` and capture-reader structure, a rewritten `evidence_command()`, a rewritten `live_command()`, changed FFmpeg options, changed process stdio configuration, changed capture chunk size, altered evidence error handling, altered shutdown behavior, removal of existing process-status helpers, and an incorrect assignment of `self.started_monotonic_ns = self._stop.time()`. These changes were outside the requested live-failure maintenance behavior and changed existing production behavior that the task explicitly required to preserve.

The generated `tests/test_media_pipeline.py` was also not acceptable. It created a new test file instead of using the existing focused media test path, and its failure simulation did not exercise the actual production live-write path: production writes to `live_process.stdin.write()`, while the fake failure was implemented on an unused `FakeProcess.write()` method and the fake stdin was an `io.BytesIO`. The startup-failure test did not actually make the live `Popen()` call fail. The process-exit test forced every fake process to report exited. The OSError test passed an exception object where the helper expected a write-count condition. The tests primarily asserted the internal `_live_failed` flag instead of proving that subsequent capture data reached the authoritative evidence branch and that the failed live branch received no later writes. Required end-to-end behavior was therefore not demonstrated.

Aider also accepted its recommendation to add `.aider*` to `.gitignore`, producing an additional untracked artifact outside the task scope. The agent stopped after applying the edits and did not complete the required focused tests, full test suite, git status/diff review, `git diff --check`, ASCII validation, recording-format validation, evidence-continuation validation, failed-live-write validation, or completion report.

Independent inspection of the resulting diff showed that the existing recording-format value `"h264"` was still present, but preservation of that one value does not offset the extensive unrelated production changes and inadequate tests. No benchmark implementation was accepted or promoted.

Result: **Failed TASK-PY-004.** This is an end-to-end Aider/gpt-oss:20b observation from the controlled run and is not treated as a universal claim about either Aider or gpt-oss:20b. The disposable benchmark worktree is not an accepted implementation and must not be promoted to `chatgpt` or `public`.

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
- OpenCode

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

- unrelated recording-format text was corrupted: "h264" became "h264";
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

Independent inspection established that Aider modified app/media.py and created tests/test_media.py. The production edit introduced live_active handling for startup failure, live-process exit, and BrokenPipeError/OSError, but also corrupted the recording format string from "h264" to "h264", violating recording-format preservation and the ASCII-only source policy. The generated five-test suite failed all five tests under independent pytest execution. The tests did not validly prove evidence continuation after live failure, suppression of later writes to the failed live pipe, or normal-operation delivery to both branches. The complete Aider transcript was not retained, so no claims are made about its internal reasoning or the cause of the prolonged run. Independent GPU verification confirmed qwen3:14b was using the RTX 3060 at 24% CPU / 76% GPU, so GPU selection was not the cause of the failure. git diff --check passed for the resulting tracked production diff. The disposable worktree was reset and cleaned to the exact baseline, and no benchmark implementation or generated artifacts were promoted to chatgpt or public.

Result: **Failed TASK-PY-004.** The end-to-end development-agent result did not satisfy the implementation, recording-format preservation, focused test coverage, or validation requirements. This is an end-to-end Aider/qwen3:14b observation and is not treated as a universal claim about either Aider or qwen3:14b.

### OpenCode / gpt-oss:20b - TASK-AIDER-001

TASK-AIDER-001 was run through OpenCode with local Ollama `gpt-oss:20b` from clean disposable edge-video baseline commit `b1554cffb13b76cc6944c4cd92609e54b405adca`. The common qualification required repository inspection before editing, exactly one narrowly scoped production change, exactly one focused test, no unrelated changes, no Git commit, ASCII-only source, and explicit validation.

OpenCode inspected the relevant edge-video implementation and tests before editing, then made one narrowly scoped production change in `app/camera.py`: `Camera.list_cameras()` now converts a `FileNotFoundError` from the configured camera executable into a `RuntimeError` with an informative message. It created one focused test in `tests/test_camera_file_not_found.py` that simulates the missing executable and verifies the resulting error.

Independent validation established:

- full pytest suite: 4 passed;
- HEAD remained at `b1554cffb13b76cc6944c4cd92609e54b405adca`;
- no Git commit was created by the agent;
- the tracked production diff contained only `app/camera.py`;
- the new test was independently inspected and was appropriately scoped;
- ASCII validation passed for the changed source;
- pytest-generated `__pycache__` directories were untracked generated artifacts, not source changes;
- `TASK-AIDER-001.md` was the qualification task input and was not an agent implementation change.

The disposable worktree was not promoted to `chatgpt` or `public`.

Result: **Passed TASK-AIDER-001.** OpenCode + `gpt-oss:20b` is the first tested framework/model configuration to satisfy the complete common qualification requirements. This is an end-to-end observation of the tested configuration and does not establish a universal claim about OpenCode or `gpt-oss:20b`.


### OpenCode / gpt-oss:20b - TASK-PY-003

TASK-PY-003 was run through OpenCode with local Ollama `gpt-oss:20b` from clean disposable `edge-video` baseline commit `b1554cffb13b76cc6944c4cd92609e54b405adca`. The task required live HLS failure handling so that a failed live branch is disabled for the remainder of capture while the authoritative evidence branch continues receiving capture data. It also required focused tests for live-process exit, `BrokenPipeError`, `OSError`, and normal operation, plus complete validation and accurate reporting.

OpenCode inspected `app/media.py` and the relevant repository tests before editing. It attempted two edits to `app/media.py`, but both edits failed because the requested old text could not be matched exactly:

    Edit app/media.py failed
    Error: Could not find oldString in app/media.py. It must match exactly, including whitespace and indentation.

No production implementation change or focused test change was made.

Independent validation established:

- `git status --short` contained only the task input and test-generated `__pycache__` directories;
- HEAD remained `b1554cffb13b76cc6944c4cd92609e54b405adca`;
- the worktree branch remained the disposable `opencode-py003` branch;
- the full existing test suite passed with 3 tests;
- the intended focused test path `tests/test_media.py` does not exist in this repository, so the supplied focused-test command was invalid;
- `git diff --check` passed because no source diff existed;
- `app/media.py` remained unchanged;
- the existing `h264` recording-format strings remained unchanged;
- no Git commit was created;
- no source-controlled production or test file was modified by the agent.

Result: **Failed TASK-PY-003.** The coding agent inspected the relevant implementation but could not materialize the required edit and tests. Because no implementation was produced, the required live-failure behavior and focused test coverage were not demonstrated. The invalid focused-test command was a benchmark validation-command error in the surrounding qualification procedure and does not alter the OpenCode task result.

This is an end-to-end OpenCode/`gpt-oss:20b` observation from the controlled run and is not treated as a universal claim about OpenCode or `gpt-oss:20b`. The disposable benchmark worktree is not an accepted implementation and must not be promoted to `chatgpt` or `public`.


### OpenCode / gpt-oss:20b - TASK-PY-003 - Corrected Qualification Run

TASK-PY-003 was run through OpenCode with local Ollama `gpt-oss:20b` from disposable edge-video baseline commit `b1554cffb13b76cc6944c4cd92609e54b405adca`. This run used the corrected task definition requiring live HLS failure handling, focused production-path tests, preservation of the authoritative evidence branch, no unrelated changes, no Git commit, ASCII-only source, and complete validation.

OpenCode inspected `app/media.py` and the existing tests before editing. It then made a two-line production edit in `app/media.py`:

- set `self.live_process = None` after detected live-process exit;
- set `self.live_process = None` after `BrokenPipeError` or `OSError` during live writes.

No focused test file was created or modified. The edit therefore did not demonstrate the required behavior that the failed live branch is disabled while the authoritative evidence branch continues receiving subsequent capture data. It also did not exercise the required live-process exit, BrokenPipeError, OSError, and normal-operation scenarios through focused tests.

Independent validation established:

- `git status --short` showed `app/media.py` modified and the task input `TASK-PY-003.md` untracked;
- HEAD remained `b1554cffb13b76cc6944c4cd92609e54b405adca`;
- `git diff --stat` showed only `app/media.py`, with 2 insertions and 0 deletions;
- `git diff --check` passed;
- the existing full test suite reported 3 passed;
- no Git commit was created;
- no unrelated tracked file was modified;- the required focused tests and final validation/report were not completed.

Result: **Failed TASK-PY-003.** The production edit was insufficient to demonstrate the required live HLS failure behavior, and the required focused tests were not produced. This is an end-to-end OpenCode/`gpt-oss:20b` observation from the controlled run and is not treated as a universal claim about either OpenCode or `gpt-oss:20b`. The disposable benchmark worktree is not an accepted implementation and must not be promoted to `chatgpt` or `public`.

### Aider / qwen3-coder:30b - TASK-PY-005

TASK-PY-005 was run through Aider with local Ollama `qwen3-coder:30b` from clean disposable edge-video baseline commit `b1554cffb13b76cc6944c4cd92609e54b405adca`. The task required a minimal evidence-envelope production change, a focused test using an actual populated `temporal_provenance.edge_time` context, preservation of the existing evidence metadata, no unrelated changes, no Git commit, and complete independent validation.

A first qwen3-coder:30b attempt was interrupted after Aider proposed an incorrect replacement implementation based on invented repository structure. Independent inspection showed that `app/evidence.py` remained unchanged and `tests/test_evidence_envelope.py` was not created. The disposable worktree was cleaned before the second attempt.

The second attempt correctly inspected the existing implementation and materialized the following changes:

- `app/evidence.py` changed only `build_evidence_envelope()` so that `capture["end"]` is populated from `capture["end_utc"]`.
- `tests/test_evidence_envelope.py` was created with a primary test that exercises the real `build_evidence_envelope()` path and supplies a non-None `temporal_provenance.edge_time` context.
- The primary test verifies capture start, finalized capture end, monotonic start, temporal context presence, and several authoritative artifact fields.

However, the end-to-end task did not satisfy the acceptance requirements:

- Aider did not complete the required validation cycle before the run was interrupted.
- The focused test was not run.
- The full existing test suite was not run.
- `git diff --check` failed with eight trailing-whitespace findings in the new test file.
- The test file contained unused imports and unnecessary additional no-time-context coverage.
- The authoritative artifact test did not verify all required artifact fields.
- The production change included an unnecessary explanatory inline comment.
- Aider recreated the prohibited `.gitignore` file during startup despite the task explicitly prohibiting it.

Independent repository inspection after the run showed:

- HEAD remained `b1554cffb13b76cc6944c4cd92609e54b405adca`;
- `app/evidence.py` had the one-line requested production change;
- `tests/test_evidence_envelope.py` contained the generated focused tests;
- no Git commit was created;
- the required validation evidence was incomplete;
- `git diff --check` failed.

Result: **Failed TASK-PY-005.** The production change was substantially correct, but the end-to-end Aider/qwen3-coder:30b run did not satisfy the complete implementation, test-quality, scope, and validation requirements. This is an observation of the tested Aider/qwen3-coder:30b configuration and is not treated as a universal claim about either Aider or qwen3-coder:30b.

The disposable benchmark worktree is not an accepted implementation and must not be promoted to `chatgpt` or `public`.


### Aider / qwen3-coder:30b - TASK-PY-004

TASK-PY-004 was run through Aider with local Ollama `qwen3-coder:30b` from clean disposable edge-video baseline commit `b1554cffb13b76cc6944c4cd92609e54b405adca`. The task required permanent live-branch disablement after startup failure, live-process exit, BrokenPipeError, or OSError; continued authoritative evidence capture; focused production-path tests; no unrelated changes; no Git commit; ASCII-only source; and complete validation.

Independent inspection of the final disposable worktree established:

- `app/media.py` was modified with the requested live-failure handling changes.
- `tests/test_media_pipeline.py` was created as a large 279-line focused test file.
- Unrelated `tests/test_camera.py` was modified by 23 lines even though the task did not authorize changes to that file.
- Unrelated `tests/test_evidence.py` was modified by 22 lines even though the task did not authorize changes to that file.
- `git diff --check` failed with extensive trailing-whitespace findings throughout `tests/test_media_pipeline.py`.
- The final worktree also contained untracked `.gitignore` and `TASK-PY-004.md` files. The task input file is not treated as an agent implementation change; the recreated `.gitignore` is an unauthorized generated change.
- The final HEAD remained `b1554cffb13b76cc6944c4cd92609e54b405adca` and no Git commit was created.
- The disposable branch remained isolated from the real `chatgpt` branch and `public` was not modified.

The resulting repository state therefore failed the task's preservation, changed-file-scope, and validation requirements. The model's own completion report cannot override the repository evidence.

Result: **Failed TASK-PY-004.** The end-to-end Aider/qwen3-coder:30b run did not satisfy the complete implementation, focused-test, scope-discipline, or validation requirements. This is an observation of the tested Aider/qwen3-coder:30b configuration and is not treated as a universal claim about either Aider or qwen3-coder:30b.

The disposable benchmark worktree is not an accepted implementation and must not be promoted to `chatgpt` or `public`.



### OpenCode / qwen3:14b - TASK-AGENT-001

TASK-AGENT-001 was run through OpenCode v2.0.19 with local Ollama 0.34.4 and qwen3:14b from disposable edge-ai worktree HEAD 96f9afa89cd02dcc54911cb76277fd221acf67f3. The task was a controlled repository write-boundary qualification requiring exactly one sentence replacement in MODELS.md, preservation of all other repository content, no new files, no Git commit or push, and explicit validation.

OpenCode inspected the repository task and made exactly the requested replacement in MODELS.md. Its reported validation showed one modified file and a passing git diff --check. The agent was unable to execute git branch --show-current because the configured shell permission denied that command. It reported this limitation rather than claiming the branch name had been verified.

Independent validation established:

- only MODELS.md was modified;
- git diff --stat reported 1 file changed, 1 insertion, and 1 deletion;
- the complete diff contained exactly the requested sentence replacement;
- git diff --check passed;
- no untracked files were present;
- the old sentence occurred 0 times and the new sentence occurred exactly once;
- the current MODELS.md content exactly matched the committed baseline with only the requested sentence replacement applied;
- the final LF was preserved;
- the file contained 0 non-ASCII bytes;
- HEAD remained 96f9afa89cd02dcc54911cb76277fd221acf67f3;
- the disposable worktree remained detached;
- no Git commit or push occurred;
- the real D:\\src\\edge-ai checkout remained clean at the same HEAD.

Result: **Passed TASK-AGENT-001.** OpenCode + qwen3:14b satisfied the controlled repository write-boundary qualification. The branch-permission mismatch remains a configuration finding and must be corrected before relying on agent-reported branch state in later tasks. This result does not establish qwen3:14b as a selected coding model; Python implementation and subsequent development-agent qualification stages remain required.

This is an end-to-end observation of the tested OpenCode/qwen3:14b configuration and is not treated as a universal claim about either OpenCode or qwen3:14b. The disposable qualification worktree was not promoted to chatgpt or public.

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
5. Establish deterministic branch/repository/permission/release controls around the selected agent configuration.6. Add independent rules/compliance and testing/review checks.
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


### OpenCode / qwen3-coder:30b - TASK-AGENT-002

TASK-AGENT-002 was run through OpenCode v2.0.19 with local Ollama 0.34.4 and qwen3-coder:30b from disposable edge-video baseline commit `b1554cffb13b76cc6944c4cd92609e54b405adca`. The task required exactly one Python implementation change in `app/evidence.py`, no test-file or unrelated repository changes, no new files, no Git commit or push, and complete validation.

The initial qwen3:14b attempts against TASK-AGENT-002 did not materialize the requested Python edit. One run encountered shell/tool execution problems and created temporary Python `__pycache__` directories during test execution; another stopped after repository inspection without editing. A separate shell-only diagnostic established that the OpenCode shell permission boundary itself was operational. These runs were therefore treated as framework/tool-boundary diagnostics rather than final model qualification results.

The qwen3-coder:30b run initially attempted Code Mode/`execute` and unsupported filesystem execution paths instead of the native OpenCode edit path. The OpenCode configuration was then adjusted to explicitly deny `execute`, allow native `read`, `glob`, `grep`, and `edit`, restrict `edit` to `app/evidence.py`, and restrict shell access to validation commands. The pytest permission was also defined for `python -B -m pytest` so test execution would not create bytecode artifacts.

With that controlled configuration, qwen3-coder:30b successfully:

- read README.md, docs/ARCHITECTURE.md, pyproject.toml, app/evidence.py, and tests/test_evidence.py;
- used the native OpenCode `edit` tool;
- changed only `"end": None,` to `"end": capture["end_utc"],` in `app/evidence.py`;
- inspected `git status --short`;
- inspected the complete Git diff;
- ran `git diff --check`;
- did not invoke Code Mode/`execute`;
- did not use shell commands to modify files;
- did not create a commit or push.

The agent attempted `python -m pytest tests/ -v`, which was denied because it did not match the configured validation command. The agent then incorrectly reported the task as completely validated. Independent validation was therefore required and remained authoritative.

Independent validation established:

- `git status --short --untracked-files=all` showed only `app/evidence.py` modified;
- the complete diff contained exactly the requested one-line replacement;
- `git diff --check` passed;
- `python -B -m pytest` passed all 3 existing tests;
- the requested `capture["end_utc"]` expression was present;
- HEAD remained `b1554cffb13b76cc6944c4cd92609e54b405adca`;
- the disposable worktree remained detached;
- no Git commit or push occurred;
- the real `D:\\src\\edge-video` checkout remained clean.

Result: **Passed TASK-AGENT-002.** This establishes a working OpenCode native-tool Python implementation PoC for the tested qwen3-coder:30b configuration. The result is an end-to-end observation of the tested OpenCode/qwen3-coder:30b configuration and is not treated as a universal claim about either OpenCode or qwen3-coder:30b. It does not select qwen3-coder:30b as a coding default; subsequent multi-file, cross-service, continuation, and independent-review stages remain required.

The disposable edge-video qualification worktree was not promoted to `chatgpt` or `public`.

### OpenCode / qwen3-coder:30b - TASK-AGENT-003

TASK-AGENT-003 was run through OpenCode v2.0.19 with local Ollama 0.34.4 and qwen3-coder:30b from disposable edge-video baseline commit `b1554cffb13b76cc6944c4cd92609e54b405adca`. The task required a controlled multi-file Python implementation and focused pytest coverage, with authorized changes limited to `app/evidence.py` and `tests/test_evidence.py`, no new repository files, no Git commit or push, and complete validation.

The task definition SHA-256 was `2D932ADAE3E57509F7D3C13EC6B04A59D11657C6D235830D86D56ED91659DF0B`.

OpenCode inspected the required repository context before editing:

- README.md
- docs/ARCHITECTURE.md
- pyproject.toml
- app/evidence.py
- tests/test_evidence.py
- TASK-AGENT-003.md

The agent then used the native OpenCode edit tool and made the requested production and test changes:

- `app/evidence.py`: changed the evidence envelope capture end field to use `capture.get("end_utc")`, preserving `None` when the manifest has no `end_utc`.
- `tests/test_evidence.py`: imported `build_evidence_envelope()` and added focused tests covering both a manifest with `capture.end_utc` and a manifest without it.
- No other repository files were modified.
- No commit or push was performed.

The agent initially introduced trailing whitespace in the test changes. It detected the resulting `git diff --check` findings, corrected them, and reran the available test and diff validation. The agent reported 5 pytest tests passing, but independent validation remained authoritative.

Independent validation established:

- `git status --short --untracked-files=all` contained exactly `app/evidence.py` and `tests/test_evidence.py` as modified files;
- `git diff --stat` showed 2 files changed, 60 insertions, and 2 deletions;
- the complete diff matched the authorized production change and the two focused tests;
- `git diff --check` passed;
- `python -B -m pytest` passed all 5 tests;
- direct validation confirmed present `end_utc` produces the exact envelope end value;
- direct validation confirmed absent `end_utc` produces `None`;
- both modified files were independently verified ASCII-only;
- both modified files were independently verified to have a final LF;
- HEAD remained `b1554cffb13b76cc6944c4cd92609e54b405adca`;
- the disposable qualification worktree remained detached;
- no Git commit or push occurred;
- the real `D:\\src\\edge-video` checkout remained clean at the same HEAD.

Result: **Passed TASK-AGENT-003.** This establishes a successful OpenCode/qwen3-coder:30b multi-file Python implementation and test qualification for the tested configuration. It is an end-to-end observation of the tested OpenCode/qwen3-coder:30b configuration and is not treated as a universal claim about either OpenCode or qwen3-coder:30b. It does not by itself establish a final coding-model selection; cross-service, project-continuation, independent-review, and human-acceptance stages remain required.

The disposable edge-video qualification worktree was not promoted to `chatgpt` or `public`.
