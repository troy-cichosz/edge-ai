param(
    [Parameter(Mandatory = $true)]
    [string]$Model,

    [Parameter(Mandatory = $true)]
    [string]$Task,

    [string[]]$AllowedWritePaths = @(),

    [int]$MaxTurns = 20,

    [string]$OllamaUrl = "http://127.0.0.1:11434"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repoRoot = (Get-Location).Path
$repoRootFull = [System.IO.Path]::GetFullPath($repoRoot).TrimEnd([System.IO.Path]::DirectorySeparatorChar)

function Get-SafeRelativePath {
    param([Parameter(Mandatory = $true)][string]$Path)

    if ([System.IO.Path]::IsPathRooted($Path)) {
        throw "Absolute paths are not permitted: $Path"
    }

    $candidate = [System.IO.Path]::GetFullPath((Join-Path $repoRoot $Path))
    $prefix = $repoRootFull + [System.IO.Path]::DirectorySeparatorChar

    if (-not $candidate.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Path escapes repository root: $Path"
    }

    $relative = $candidate.Substring($prefix.Length).Replace("\", "/")

    if ($relative -eq ".git" -or $relative.StartsWith(".git/")) {
        throw "Access to .git is not permitted: $Path"
    }

    return $relative
}

$allowedWrites = @{}
foreach ($path in $AllowedWritePaths) {
    $allowedWrites[(Get-SafeRelativePath $path).ToLowerInvariant()] = $true
}

function Assert-WriteAllowed {
    param([Parameter(Mandatory = $true)][string]$Path)

    $relative = Get-SafeRelativePath $Path

    if ($allowedWrites.Count -eq 0) {
        throw "No write paths were authorized for this run."
    }

    if (-not $allowedWrites.ContainsKey($relative.ToLowerInvariant())) {
        throw "Write denied for '$relative'. Authorized write paths: $($allowedWrites.Keys -join ', ')"
    }

    return $relative
}

function Invoke-RepoTool {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)]$Arguments
    )

    switch ($Name) {
        "list_files" {
            $files = Get-ChildItem -Path $repoRoot -Recurse -File -Force |
                Where-Object {
                    $_.FullName -notmatch ([regex]::Escape([System.IO.Path]::DirectorySeparatorChar + ".git" + [System.IO.Path]::DirectorySeparatorChar))
                } |
                ForEach-Object {
                    $_.FullName.Substring($repoRootFull.Length + 1).Replace("\", "/")
                } |
                Sort-Object

            return ($files -join [Environment]::NewLine)
        }

        "read_file" {
            $relative = Get-SafeRelativePath ([string]$Arguments.path)
            $full = Join-Path $repoRoot $relative

            if (-not (Test-Path -LiteralPath $full -PathType Leaf)) {
                throw "File not found: $relative"
            }

            return Get-Content -LiteralPath $full -Raw
        }

        "git_status" {
            $output = & git -C $repoRoot status --short
            if ($LASTEXITCODE -ne 0) {
                throw "git status failed."
            }

            if ($null -eq $output) {
                return "(clean working tree)"
            }

            return ($output -join [Environment]::NewLine)
        }

        "git_diff" {
            $output = & git -C $repoRoot diff --no-ext-diff -- . ':!.git'
            if ($LASTEXITCODE -ne 0) {
                throw "git diff failed."
            }

            if ($null -eq $output -or $output.Count -eq 0) {
                return "(no working-tree diff)"
            }

            return ($output -join [Environment]::NewLine)
        }

        "git_diff_check" {
            $output = & git -C $repoRoot diff --check -- .
            if ($LASTEXITCODE -ne 0) {
                $details = if ($output) { $output -join [Environment]::NewLine } else { "git diff --check reported an error." }
                throw $details
            }

            return "git diff --check passed."
        }

        "write_file" {
            $relative = Assert-WriteAllowed ([string]$Arguments.path)
            $full = Join-Path $repoRoot $relative
            $parent = Split-Path -Parent $full

            if (-not (Test-Path -LiteralPath $parent -PathType Container)) {
                New-Item -ItemType Directory -Path $parent -Force | Out-Null
            }

            [System.IO.File]::WriteAllText(
                $full,
                [string]$Arguments.content,
                [System.Text.UTF8Encoding]::new($false)
            )

            return "Wrote $relative"
        }

        default {
            throw "Unknown tool: $Name"
        }
    }
}

$tools = @(
    @{
        type = "function"
        function = @{
            name = "list_files"
            description = "List files in the repository. Use this to understand repository scope. The .git directory is excluded."
            parameters = @{
                type = "object"
                properties = @{}
            }
        }
    },
    @{
        type = "function"
        function = @{
            name = "read_file"
            description = "Read a complete UTF-8 text file from the repository. Paths are relative to the repository root."
            parameters = @{
                type = "object"
                properties = @{
                    path = @{
                        type = "string"
                        description = "Repository-relative file path."
                    }
                }
                required = @("path")
            }
        }
    },
    @{
        type = "function"
        function = @{
            name = "write_file"
            description = "Replace the complete contents of an authorized repository file. Writes are restricted to the explicit AllowedWritePaths supplied by the human."
            parameters = @{
                type = "object"
                properties = @{
                    path = @{
                        type = "string"
                        description = "Repository-relative file path. Must be authorized for this run."
                    }
                    content = @{
                        type = "string"
                        description = "Complete replacement file contents."
                    }
                }
                required = @("path", "content")
            }
        }
    },
    @{
        type = "function"
        function = @{
            name = "git_status"
            description = "Read the current git working-tree status. This does not modify the repository."
            parameters = @{
                type = "object"
                properties = @{}
            }
        }
    },
    @{
        type = "function"
        function = @{
            name = "git_diff"
            description = "Read the current working-tree git diff. This does not modify the repository."
            parameters = @{
                type = "object"
                properties = @{}
            }
        }
    },
    @{
        type = "function"
        function = @{
            name = "git_diff_check"
            description = "Run git diff --check against the working tree. This is read-only validation."
            parameters = @{
                type = "object"
                properties = @{}
            }
        }
    }
)

function Invoke-TextModeAgent {
    $contextPaths = @("README.md", "AGENTS.md", "ARCHITECTURE.md", "DECISIONS.md", "MODELS.md", "OLLAMA.md")
    $contextParts = @()

    foreach ($path in $contextPaths) {
        $relative = Get-SafeRelativePath $path
        $full = Join-Path $repoRoot $relative
        if (-not (Test-Path -LiteralPath $full -PathType Leaf)) {
            throw "Required task context file not found: $relative"
        }
        $content = Get-Content -LiteralPath $full -Raw
        $contextParts += "===== $relative =====`n$content`n===== END $relative ====="
    }

    $context = $contextParts -join "`n`n"
    $pathMarker = "__EDGE_AI_FILE_PATH__"
    $beginMarker = "__EDGE_AI_FILE_CONTENT_BEGIN__"
    $endMarker = "__EDGE_AI_FILE_CONTENT_END__"

    $textPrompt = @(
        "You are a controlled coding agent operating without native tool calling.",
        "Repository root: $repoRoot",
        "Model under test: $Model",
        "You cannot access files or execute commands. The required repository files are supplied as read-only context.",
        "You may replace only this authorized path: $($allowedWrites.Keys -join ", ")",
        "Follow the TASK exactly. Do not make unrelated changes.",
        "Return exactly this plain-text structure and nothing else:",
        $pathMarker,
        "README.md",
        $beginMarker,
        "<complete final file contents>",
        $endMarker,
        "Do not use markdown fences or add commentary.",
        "The file contents must be complete, not a patch.",
        "",
        $Task,
        "",
        "REPOSITORY CONTEXT:",
        $context
    ) -join "`n"

    $payload = @{
        model = $Model
        prompt = $textPrompt
        stream = $false
        options = @{ temperature = 0 }
    } | ConvertTo-Json -Depth 30

    $response = Invoke-RestMethod `
        -Uri "$OllamaUrl/api/generate" `
        -Method Post `
        -ContentType "application/json" `
        -Body $payload

    if ($null -eq $response.message -or [string]::IsNullOrWhiteSpace($response.response)) {
        throw "Ollama text-mode fallback returned no response."
    }

    $output = [string]$response.message.content
    $pathMatch = [regex]::Match($output, [regex]::Escape($pathMarker) + "s*(?<path>[^
]+)")
    $beginIndex = $output.IndexOf($beginMarker, [System.StringComparison]::Ordinal)
    $endIndex = $output.IndexOf($endMarker, [System.StringComparison]::Ordinal)

    if (-not $pathMatch.Success) {
        throw "Ollama text-mode fallback did not return the required path marker."
    }

    if ($beginIndex -lt 0 -or $endIndex -lt 0 -or $endIndex -le ($beginIndex + $beginMarker.Length)) {
        throw "Ollama text-mode fallback did not return valid content markers."
    }

    $relative = Assert-WriteAllowed $pathMatch.Groups["path"].Value.Trim()
    $contentStart = $beginIndex + $beginMarker.Length
    $fileContent = $output.Substring($contentStart, $endIndex - $contentStart).TrimStart("`r", "`n")

    if ([string]::IsNullOrWhiteSpace($fileContent)) {
        throw "Ollama text-mode fallback returned empty file content."
    }

    $full = Join-Path $repoRoot $relative
    [System.IO.File]::WriteAllText($full, $fileContent, [System.Text.UTF8Encoding]::new($false))
    Write-Host "Text-mode fallback wrote $relative" -ForegroundColor Gray
}
$systemPrompt = @"
You are the coding agent for a controlled local repository task.

Repository root: $repoRoot
Model under test: $Model

You have access only to repository-scoped tools supplied by this runner.
You cannot commit, push, access .git, or access files outside the repository.
Write access is limited to these explicitly authorized paths:
$($allowedWrites.Keys -join ", ")

You must follow the task exactly. Do not make improvements, refactors, cleanup, or unrelated documentation changes.

Before editing, inspect the repository context required by the task. Use read_file for complete files, not partial guesses.

After editing:
- read the complete changed file;
- inspect git status;
- inspect git diff;
- run git_diff_check;
- report exact changed files;
- report validation performed;
- report anything you could not verify.

Do not claim a validation result you did not obtain from a tool.
Do not commit or push.
"@

$messages = @(
    @{
        role = "system"
        content = $systemPrompt
    },
    @{
        role = "user"
        content = $Task
    }
)

Write-Host "=== Local Coding Agent ===" -ForegroundColor Cyan
Write-Host "Model: $Model"
Write-Host "Repository: $repoRoot"
Write-Host "Authorized writes: $(if ($allowedWrites.Count) { $allowedWrites.Keys -join ', ' } else { '(none)' })"
Write-Host "Max turns: $MaxTurns"
Write-Host ""

for ($turn = 1; $turn -le $MaxTurns; $turn++) {
    Write-Host "--- Turn $turn ---" -ForegroundColor DarkCyan

    $payload = @{
        model = $Model
        messages = $messages
        stream = $false
        tools = $tools
        options = @{
            temperature = 0
        }
    } | ConvertTo-Json -Depth 30

    try {
        $response = Invoke-RestMethod `
            -Uri "$OllamaUrl/api/chat" `
            -Method Post `
            -ContentType "application/json" `
            -Body $payload
    }
    catch {
        $errorText = @(
            $_.Exception.Message
            $_.ErrorDetails.Message
        ) -join " "

        if ($errorText -match "does not support tools") {
            Write-Host "Model does not support native tool calling; switching to controlled text mode." -ForegroundColor Yellow
            Invoke-TextModeAgent
            break
        }
        throw
    }

    if ($null -eq $response.message) {
        throw "Ollama returned no message."
    }

    $assistantMessage = $response.message
    $messages += @{
        role = "assistant"
        content = if ($null -ne $assistantMessage.content) { [string]$assistantMessage.content } else { "" }
        tool_calls = if ($null -ne $assistantMessage.tool_calls) { $assistantMessage.tool_calls } else { @() }
    }

    if ($assistantMessage.content) {
        Write-Host $assistantMessage.content
    }

    $toolCalls = @($assistantMessage.tool_calls)

    if ($toolCalls.Count -eq 0) {
        Write-Host ""
        Write-Host "Agent completed without further tool calls."
        break
    }

    foreach ($call in $toolCalls) {
        $name = [string]$call.function.name
        $arguments = $call.function.arguments

        Write-Host "Tool: $name" -ForegroundColor Gray

        try {
            $toolResult = Invoke-RepoTool -Name $name -Arguments $arguments
            $toolContent = if ($null -eq $toolResult) { "" } else { [string]$toolResult }
        }
        catch {
            $toolContent = "ERROR: $($_.Exception.Message)"
        }

        $messages += @{
            role = "tool"
            content = $toolContent
        }

        if ($toolContent.Length -gt 1000) {
            Write-Host "$($toolContent.Substring(0, 1000))..." -ForegroundColor DarkGray
        }
        else {
            Write-Host $toolContent -ForegroundColor DarkGray
        }
    }

    if ($turn -eq $MaxTurns) {
        throw "Maximum agent turns reached before the model completed."
    }
}

Write-Host ""
Write-Host "=== Final Working Tree ===" -ForegroundColor Cyan
$status = & git -C $repoRoot status --short
if ($LASTEXITCODE -ne 0) {
    throw "Final git status failed."
}
if ($status) {
    $status | Write-Host
}
else {
    Write-Host "(clean working tree)"
}

Write-Host ""
Write-Host "=== Final Diff ===" -ForegroundColor Cyan
$diff = & git -C $repoRoot diff --no-ext-diff -- .
if ($LASTEXITCODE -ne 0) {
    throw "Final git diff failed."
}
if ($diff) {
    $diff | Write-Host
}
else {
    Write-Host "(no working-tree diff)"
}
