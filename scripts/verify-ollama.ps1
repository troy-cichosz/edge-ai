$ErrorActionPreference = 'Stop'

Write-Host 'Ollama installation verification'

$version = ollama --version
if ($LASTEXITCODE -ne 0) {
    throw 'Unable to execute ollama --version.'
}

Write-Host $version
Write-Host ''
Write-Host 'Installed models:'
ollama list
if ($LASTEXITCODE -ne 0) {
    throw 'Unable to enumerate Ollama models.'
}

Write-Host ''
Write-Host 'Verification complete.'
