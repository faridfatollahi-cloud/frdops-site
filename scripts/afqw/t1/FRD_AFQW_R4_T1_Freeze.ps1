#requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Host.UI.RawUI.WindowTitle = 'FRD Ops Site — Governance | FRD Drive Automation | Atria ForgeLoop T1 Freeze Gate'
$ScriptRoot = 'C:\AI-Orchestrator\scripts\FRD-Drive-Automation\AFQW\T1'
$Files = @(
    'FRD_AFQW_R4_T1_Worker.ps1',
    'FRD_AFQW_R4_T1_TaskTimer.ps1',
    'FRD_AFQW_R4_T1_Launch.ps1',
    'FRD_AFQW_R4_T1_Run.ps1'
)
$ExpectedEndpoint = 'https://api.atria-asi.ai/v1/responses'
$ExpectedModel = 'Atria-Dawn-Preview'
$ExpectedCredentialId = 'FRD-DRIVE-QUAL-ATRIA-EXEC-01'
$ExpectedCipherSha256 = '01C5306E6B1CCE4D2AEBA3E122E4EE3FA34D0B2CF2182EF6DCF4F9EA981B30F9'
$AllPass = $true
$Records = @()
foreach ($Name in $Files) {
    $Path = Join-Path $ScriptRoot $Name
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        $Records += [ordered]@{ file = $Name; parser_errors = -1; sha256 = 'MISSING'; surface = 'FAIL' }
        $AllPass = $false
        continue
    }
    $Tokens = $null
    $Errors = $null
    [Management.Automation.Language.Parser]::ParseFile($Path, [ref]$Tokens, [ref]$Errors) | Out-Null
    $Hash = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
    $Text = Get-Content -LiteralPath $Path -Raw
    $Surface = 'PASS'
    if ($Errors.Count -ne 0) { $Surface = 'FAIL' }
    if ($Text -match '(?i)googleapis\.com|accounts\.google\.com|oauth2\.googleapis\.com') { $Surface = 'FAIL' }
    if ($Text -match '(?i)%LOCALAPPDATA%|AppData\\Local\\WIOS') { $Surface = 'FAIL' }
    if ($Name -eq 'FRD_AFQW_R4_T1_Worker.ps1') {
        if (-not $Text.Contains($ExpectedEndpoint)) { $Surface = 'FAIL' }
        if (-not $Text.Contains($ExpectedModel)) { $Surface = 'FAIL' }
        if (-not $Text.Contains($ExpectedCredentialId)) { $Surface = 'FAIL' }
        if (-not $Text.Contains($ExpectedCipherSha256)) { $Surface = 'FAIL' }
        $EndpointMatches = ([regex]::Matches($Text, [regex]::Escape($ExpectedEndpoint))).Count
        if ($EndpointMatches -ne 1) { $Surface = 'FAIL' }
    }
    if ($Surface -ne 'PASS') { $AllPass = $false }
    $Records += [ordered]@{ file = $Name; parser_errors = $Errors.Count; sha256 = $Hash; surface = $Surface }
}
$SelfTokens = $null
$SelfErrors = $null
[Management.Automation.Language.Parser]::ParseFile($PSCommandPath, [ref]$SelfTokens, [ref]$SelfErrors) | Out-Null
if ($SelfErrors.Count -ne 0) { $AllPass = $false }
Write-Host '======================================================================'
Write-Host 'AFQW RESULT | FRD-DRIVE-AFQW-R4-T1 | FREEZE GATE'
Write-Host '======================================================================'
Write-Host 'TASK_ID=FRD-DRIVE-AFQW-R4-T1'
Write-Host 'ATTEMPT_ID=FRD-DRIVE-AFQW-R4-T1-A0'
Write-Host ('AFQW_T1_FREEZE_RESULT=' + $(if ($AllPass) { 'PASS' } else { 'FAIL' }))
foreach ($Record in $Records) {
    Write-Host ("FILE=$($Record.file) | PARSER_ERROR_COUNT=$($Record.parser_errors) | SHA256=$($Record.sha256) | SURFACE_SCAN=$($Record.surface)")
}
Write-Host "FREEZE_SCRIPT_PARSER_ERROR_COUNT=$($SelfErrors.Count)"
Write-Host 'PROVIDER_CALL_PERFORMED=False'
Write-Host 'DRIVE_API_CALL_PERFORMED=False'
Write-Host 'DOCS_API_CALL_PERFORMED=False'
Write-Host 'CREDENTIAL_DECRYPTION_PERFORMED=False'
Write-Host 'MAIN_EXECUTION_PERFORMED=False'
Write-Host 'NEXT_ACTION=RETURN_FREEZE_RESULT_TO_GOVERNANCE'
Write-Host '======================================================================'
if (-not $AllPass) { exit 10 }
exit 0
