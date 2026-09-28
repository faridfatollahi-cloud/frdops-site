#requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Host.UI.RawUI.WindowTitle = 'FRD Ops Site — Governance | FRD Drive Automation | Atria ForgeLoop T2 Freeze Gate'

$ScriptRoot = 'C:\AI-Orchestrator\scripts\FRD-Drive-Automation\AFQW\T2'
$Worker = Join-Path $ScriptRoot 'FRD_AFQW_R4_T2_Worker.ps1'
$ExpectedR3ScriptSha = '3CFAE9EA6B10F96270824431600F125778EEAFC154B02FEC61E5497D25DE9E79'
$ExpectedCredentialSha = '8EEE8866414807131C9E0203362CAA72D0FC8EC5F02A5BE390CB2C456625B303'
$ExpectedReceiptSha = 'FE7B95D06F3CA8322B29B362924877B62A3B9C3BCEE6C0B564845F5DBE094D1D'
$Pass = $true
$ParserCount = -1
$WorkerHash = 'MISSING'
$Surface = 'FAIL'

if (Test-Path -LiteralPath $Worker -PathType Leaf) {
    $tokens = $null
    $errors = $null
    [Management.Automation.Language.Parser]::ParseFile($Worker,[ref]$tokens,[ref]$errors) | Out-Null
    $ParserCount = $errors.Count
    $WorkerHash = (Get-FileHash -LiteralPath $Worker -Algorithm SHA256).Hash
    $text = Get-Content -LiteralPath $Worker -Raw
    $Surface = 'PASS'
    if ($ParserCount -ne 0) { $Surface = 'FAIL' }
    foreach ($pattern in @('(?i)Invoke-WebRequest','(?i)Invoke-RestMethod','(?i)HttpClient','(?i)WebRequest','(?i)Start-Process')) {
        if ($text -match $pattern) { $Surface = 'FAIL' }
    }
    foreach ($required in @($ExpectedR3ScriptSha,$ExpectedCredentialSha,$ExpectedReceiptSha,'qual-oauth.dpapi','DPAPI_ENTROPY_MODE')) {
        if (-not $text.Contains($required)) { $Surface = 'FAIL' }
    }
    if ($Surface -ne 'PASS') { $Pass = $false }
} else {
    $Pass = $false
}

$selfTokens = $null
$selfErrors = $null
[Management.Automation.Language.Parser]::ParseFile($PSCommandPath,[ref]$selfTokens,[ref]$selfErrors) | Out-Null
if ($selfErrors.Count -ne 0) { $Pass = $false }

Write-Host '======================================================================'
Write-Host 'AFQW RESULT | FRD-DRIVE-AFQW-R4-T2 | FREEZE GATE'
Write-Host '======================================================================'
Write-Host 'TASK_ID=FRD-DRIVE-AFQW-R4-T2'
Write-Host 'ATTEMPT_ID=FRD-DRIVE-AFQW-R4-T2-A0'
Write-Host ('AFQW_T2_FREEZE_RESULT=' + $(if ($Pass) { 'PASS' } else { 'FAIL' }))
Write-Host "FILE=FRD_AFQW_R4_T2_Worker.ps1 | PARSER_ERROR_COUNT=$ParserCount | SHA256=$WorkerHash | ZERO_NETWORK_SURFACE_SCAN=$Surface"
Write-Host "FREEZE_SCRIPT_PARSER_ERROR_COUNT=$($selfErrors.Count)"
Write-Host 'PROVIDER_CALL_PERFORMED=False'
Write-Host 'DRIVE_API_CALL_PERFORMED=False'
Write-Host 'DOCS_API_CALL_PERFORMED=False'
Write-Host 'CREDENTIAL_DECRYPTION_PERFORMED=False'
Write-Host 'MAIN_EXECUTION_PERFORMED=False'
Write-Host '======================================================================'
if (-not $Pass) { exit 10 }
exit 0
