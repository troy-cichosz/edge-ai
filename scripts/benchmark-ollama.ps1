param(
    [Parameter(Mandatory = $true)]
    [string]$Model,

    [int]$MaxTokens = 128
)

$ErrorActionPreference = "Stop"

Write-Host "=== Ollama Benchmark ===" -ForegroundColor Cyan
Write-Host "Model: $Model"
Write-Host "Max tokens: $MaxTokens"

$version = ollama --version
if ($LASTEXITCODE -ne 0) {
    throw "ollama --version failed."
}

Write-Host "Ollama: $version"

$payload = @{
    model = $Model
    prompt = "Reply with exactly one sentence stating that this is a controlled local model benchmark."
    stream = $false
    options = @{
        num_predict = $MaxTokens
    }
} | ConvertTo-Json -Depth 5

$start = Get-Date
$response = Invoke-RestMethod `
    -Uri "http://127.0.0.1:11434/api/generate" `
    -Method Post `
    -ContentType "application/json" `
    -Body $payload
$end = Get-Date

$elapsed = ($end - $start).TotalSeconds

[pscustomobject]@{
    Model = $Model
    StartedUtc = $start.ToUniversalTime().ToString("o")
    CompletedUtc = $end.ToUniversalTime().ToString("o")
    WallClockSeconds = [math]::Round($elapsed, 3)
    LoadSeconds = if ($response.load_duration) { [math]::Round($response.load_duration / 1e9, 3) } else { $null }
    PromptTokens = $response.prompt_eval_count
    PromptSeconds = if ($response.prompt_eval_duration) { [math]::Round($response.prompt_eval_duration / 1e9, 3) } else { $null }
    GeneratedTokens = $response.eval_count
    GenerationSeconds = if ($response.eval_duration) { [math]::Round($response.eval_duration / 1e9, 3) } else { $null }
    PromptTokensPerSecond = if ($response.prompt_eval_duration -gt 0) { [math]::Round($response.prompt_eval_count / ($response.prompt_eval_duration / 1e9), 2) } else { $null }
    GenerationTokensPerSecond = if ($response.eval_duration -gt 0) { [math]::Round($response.eval_count / ($response.eval_duration / 1e9), 2) } else { $null }
}

Write-Host "`nResponse:"
Write-Host $response.response
