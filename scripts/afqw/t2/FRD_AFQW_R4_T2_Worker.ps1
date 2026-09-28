#requires -Version 7.0
[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Host.UI.RawUI.WindowTitle = 'FRD Ops Site — Governance | FRD Drive Automation | Atria ForgeLoop T2 R3 Bridge Worker | A0'

$TaskId = 'FRD-DRIVE-AFQW-R4-T2'
$AttemptId = 'FRD-DRIVE-AFQW-R4-T2-A0'
$ExpectedR3ScriptSha = '3CFAE9EA6B10F96270824431600F125778EEAFC154B02FEC61E5497D25DE9E79'
$ExpectedCredentialSha = '8EEE8866414807131C9E0203362CAA72D0FC8EC5F02A5BE390CB2C456625B303'
$ExpectedR3ReceiptSha = 'FE7B95D06F3CA8322B29B362924877B62A3B9C3BCEE6C0B564845F5DBE094D1D'
$ExpectedScope = 'https://www.googleapis.com/auth/drive.file'

$BootstrapRoot = 'C:\AI-Orchestrator\bootstrap\FRD-Drive-Automation'
$ScriptsRoot = Join-Path $BootstrapRoot 'scripts'
$ReceiptsRoot = Join-Path $BootstrapRoot 'receipts'
$CredentialPath = Join-Path $BootstrapRoot 'credentials\qual-oauth.dpapi'
$StateRoot = 'C:\AI-Orchestrator\workspaces\FRD-Drive-Automation\Atria-Qualification\tasks\FRD-DRIVE-AFQW-R4-T2\FRD-DRIVE-AFQW-R4-T2-A0'
$EvidenceRoot = 'C:\AI-Orchestrator\Governance Files\FRD-Drive-Automation\Atria-Qualification\tasks\FRD-DRIVE-AFQW-R4-T2\FRD-DRIVE-AFQW-R4-T2-A0'
$StartMarker = Join-Path $StateRoot 'STARTED.json'
$FinalReceipt = Join-Path $StateRoot 'FINAL.json'
$BindingReceipt = Join-Path $EvidenceRoot 'R3_BINDING_DISCOVERY.sanitized.json'
$Utf8NoBom = [Text.UTF8Encoding]::new($false)

function Write-JsonCreateNew {
    param([Parameter(Mandatory)]$Object,[Parameter(Mandatory)][string]$Path)
    $dir = Split-Path -Parent $Path
    [IO.Directory]::CreateDirectory($dir) | Out-Null
    $json = ($Object | ConvertTo-Json -Depth 20 -Compress) + "`n"
    $bytes = $Utf8NoBom.GetBytes($json)
    $stream = [IO.File]::Open($Path,[IO.FileMode]::CreateNew,[IO.FileAccess]::Write,[IO.FileShare]::Read)
    try { $stream.Write($bytes,0,$bytes.Length); $stream.Flush($true) } finally { $stream.Dispose() }
}

function Write-JsonAtomic {
    param([Parameter(Mandatory)]$Object,[Parameter(Mandatory)][string]$Path)
    $dir = Split-Path -Parent $Path
    [IO.Directory]::CreateDirectory($dir) | Out-Null
    $temp = "$Path.tmp.$PID.$([Guid]::NewGuid().ToString('N'))"
    try {
        [IO.File]::WriteAllText($temp,(($Object | ConvertTo-Json -Depth 20 -Compress) + "`n"),$Utf8NoBom)
        [IO.File]::Move($temp,$Path,$true)
    } finally {
        if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Force -ErrorAction SilentlyContinue }
    }
}

function Format-ElapsedMs {
    param([Parameter(Mandatory)][long]$ElapsedMs)
    $span = [TimeSpan]::FromMilliseconds($ElapsedMs)
    $hours = [int][Math]::Floor($span.TotalHours)
    return ('{0:D2}:{1:D2}:{2:D2}' -f $hours,$span.Minutes,$span.Seconds)
}

function Find-ExactHashFile {
    param([Parameter(Mandatory)][string]$Root,[Parameter(Mandatory)][string]$ExpectedSha)
    if (-not (Test-Path -LiteralPath $Root -PathType Container)) { return @() }
    $matches = @()
    foreach ($file in Get-ChildItem -LiteralPath $Root -File -Recurse -ErrorAction Stop) {
        $sha = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash
        if ($sha -eq $ExpectedSha) { $matches += $file.FullName }
    }
    return @($matches)
}

if ((Test-Path -LiteralPath $StartMarker) -or (Test-Path -LiteralPath $FinalReceipt)) {
    throw 'T2_A0_ALREADY_CONSUMED_OR_TERMINAL_NO_REPLAY'
}

[IO.Directory]::CreateDirectory($StateRoot) | Out-Null
[IO.Directory]::CreateDirectory($EvidenceRoot) | Out-Null
$watch = [Diagnostics.Stopwatch]::StartNew()
$startUtc = [DateTime]::UtcNow.ToString('o')
Write-JsonCreateNew -Path $StartMarker -Object ([ordered]@{
    schema_version='1.0'; task_id=$TaskId; attempt_id=$AttemptId; state='STARTED'; task_active_start_utc=$startUtc;
    provider_budget=0; drive_api_budget=0; docs_api_budget=0; browser_oauth_budget=0; mutation_budget=0
})

$resultState = 'FAILED'
$errorCode = $null
$scriptPath = $null
$receiptPath = $null
$entropyMode = 'UNKNOWN'
$schemaKeys = @()
$hasClientId = $false
$hasClientSecret = $false
$hasRefreshToken = $false
$hasScope = $false
$scopeExact = $false
$hasTokenUri = $false
$scriptHasUnprotect = $false
$scriptHasCurrentUser = $false
$scriptHasRefreshGrant = $false
$scriptHasTokenEndpoint = $false
$credentialDecryptionPerformed = $false
$credentialBytes = $null
$plainBytes = $null
$plainText = $null
$credentialObject = $null

try {
    if (-not (Test-Path -LiteralPath $CredentialPath -PathType Leaf)) { throw 'R3_CREDENTIAL_FILE_MISSING' }
    $credentialSha = (Get-FileHash -LiteralPath $CredentialPath -Algorithm SHA256).Hash
    if ($credentialSha -ne $ExpectedCredentialSha) { throw 'R3_CREDENTIAL_HASH_MISMATCH' }

    $scriptMatches = @(Find-ExactHashFile -Root $ScriptsRoot -ExpectedSha $ExpectedR3ScriptSha)
    if ($scriptMatches.Count -ne 1) { throw "R3_SCRIPT_MATCH_COUNT_$($scriptMatches.Count)" }
    $scriptPath = $scriptMatches[0]

    $receiptMatches = @(Find-ExactHashFile -Root $ReceiptsRoot -ExpectedSha $ExpectedR3ReceiptSha)
    if ($receiptMatches.Count -ne 1) { throw "R3_RECEIPT_MATCH_COUNT_$($receiptMatches.Count)" }
    $receiptPath = $receiptMatches[0]

    $scriptText = [IO.File]::ReadAllText($scriptPath)
    $compact = [regex]::Replace($scriptText,'\s+','')
    $scriptHasUnprotect = $compact.Contains('::Unprotect(')
    $scriptHasCurrentUser = $compact.Contains('DataProtectionScope]::CurrentUser')
    $scriptHasRefreshGrant = ($scriptText -match '(?i)grant_type') -and ($scriptText -match '(?i)refresh_token')
    $scriptHasTokenEndpoint = $scriptText.Contains('https://oauth2.googleapis.com/token')

    if ($scriptHasUnprotect -and $scriptHasCurrentUser) {
        if ($compact -match '::Unprotect\([^,]+,\$null,\[[^\]]*DataProtectionScope\]::CurrentUser\)') {
            $entropyMode = 'NULL'
        } else {
            $entropyMode = 'NONNULL_OR_UNRESOLVED'
        }
    }

    if ($entropyMode -ne 'NULL') { throw 'R3_DPAPI_ENTROPY_NOT_NULL_OR_NOT_RESOLVED' }

    Add-Type -AssemblyName System.Security.Cryptography.ProtectedData -ErrorAction SilentlyContinue
    $credentialBytes = [IO.File]::ReadAllBytes($CredentialPath)
    $plainBytes = [Security.Cryptography.ProtectedData]::Unprotect($credentialBytes,$null,[Security.Cryptography.DataProtectionScope]::CurrentUser)
    $credentialDecryptionPerformed = $true
    if (($plainBytes.Length -le 0) -or ($plainBytes.Length -gt 131072)) { throw 'R3_DECRYPTED_CREDENTIAL_LENGTH_INVALID' }
    $plainText = [Text.Encoding]::UTF8.GetString($plainBytes)
    try { $credentialObject = $plainText | ConvertFrom-Json -ErrorAction Stop } catch { throw 'R3_DECRYPTED_CREDENTIAL_NOT_JSON' }

    $schemaKeys = @($credentialObject.PSObject.Properties.Name | Sort-Object -Unique)
    $hasClientId = $schemaKeys -contains 'client_id'
    $hasClientSecret = $schemaKeys -contains 'client_secret'
    $hasRefreshToken = $schemaKeys -contains 'refresh_token'
    $hasScope = $schemaKeys -contains 'scope'
    $hasTokenUri = ($schemaKeys -contains 'token_uri') -or ($schemaKeys -contains 'token_endpoint')
    if ($hasScope) {
        $scopeValue = [string]$credentialObject.scope
        $scopeExact = ($scopeValue -eq $ExpectedScope)
    }

    if (-not $hasClientId) { throw 'R3_SCHEMA_CLIENT_ID_MISSING' }
    if (-not $hasClientSecret) { throw 'R3_SCHEMA_CLIENT_SECRET_MISSING' }
    if (-not $hasRefreshToken) { throw 'R3_SCHEMA_REFRESH_TOKEN_MISSING' }
    if (-not $hasScope) { throw 'R3_SCHEMA_SCOPE_MISSING' }
    if (-not $scopeExact) { throw 'R3_SCHEMA_SCOPE_NOT_EXACT_DRIVE_FILE' }

    $binding = [ordered]@{
        schema_version='1.0'; task_id=$TaskId; attempt_id=$AttemptId; result='PASS';
        r3_script_sha256=$ExpectedR3ScriptSha; r3_script_filename=[IO.Path]::GetFileName($scriptPath);
        r3_credential_sha256=$ExpectedCredentialSha; r3_credential_filename=[IO.Path]::GetFileName($CredentialPath);
        r3_receipt_sha256=$ExpectedR3ReceiptSha; r3_receipt_filename=[IO.Path]::GetFileName($receiptPath);
        dpapi_unprotect_present=$scriptHasUnprotect; dpapi_current_user_present=$scriptHasCurrentUser; dpapi_entropy_mode=$entropyMode;
        credential_decryption_performed=$credentialDecryptionPerformed; decrypted_schema_keys=$schemaKeys;
        has_client_id=$hasClientId; has_client_secret=$hasClientSecret; has_refresh_token=$hasRefreshToken; has_scope=$hasScope;
        scope_exact_drive_file=$scopeExact; has_token_uri_or_endpoint_field=$hasTokenUri;
        script_has_refresh_grant=$scriptHasRefreshGrant; script_has_google_token_endpoint=$scriptHasTokenEndpoint;
        secret_values_persisted_or_shared=$false; provider_call_count=0; drive_api_call_count=0; docs_api_call_count=0; browser_oauth_count=0;
        completed_utc=[DateTime]::UtcNow.ToString('o')
    }
    Write-JsonCreateNew -Path $BindingReceipt -Object $binding
    $resultState = 'PASS'
}
catch {
    $errorCode = $_.Exception.Message
    $resultState = 'FAILED'
}
finally {
    if ($plainBytes) { [Array]::Clear($plainBytes,0,$plainBytes.Length) }
    if ($credentialBytes) { [Array]::Clear($credentialBytes,0,$credentialBytes.Length) }
    $plainText = $null
    $credentialObject = $null
    [GC]::Collect(); [GC]::WaitForPendingFinalizers(); [GC]::Collect()
    $watch.Stop()
    $elapsedMs = [long]$watch.ElapsedMilliseconds
    $final = [ordered]@{
        schema_version='1.0'; task_id=$TaskId; attempt_id=$AttemptId; state=$resultState;
        task_active_start_utc=$startUtc; task_active_end_utc=[DateTime]::UtcNow.ToString('o');
        task_active_elapsed_ms=$elapsedMs; task_active_elapsed_hhmmss=(Format-ElapsedMs -ElapsedMs $elapsedMs);
        worker_active_elapsed_ms=0; worker_active_elapsed_hhmmss='00:00:00';
        provider_call_count=0; drive_api_call_count=0; docs_api_call_count=0; browser_oauth_interaction_count=0;
        google_credential_decryption_performed=$credentialDecryptionPerformed; google_credential_file_changed=$false;
        a0_a1_residue_touched=$false; dpapi_entropy_mode=$entropyMode; decrypted_schema_keys=$schemaKeys;
        has_client_id=$hasClientId; has_client_secret=$hasClientSecret; has_refresh_token=$hasRefreshToken; has_scope=$hasScope;
        scope_exact_drive_file=$scopeExact; has_token_uri_or_endpoint_field=$hasTokenUri;
        script_has_refresh_grant=$scriptHasRefreshGrant; script_has_google_token_endpoint=$scriptHasTokenEndpoint;
        error_code=$errorCode; replay_authorized=$false
    }
    Write-JsonAtomic -Path $FinalReceipt -Object $final
}

Write-Host '======================================================================'
Write-Host 'AFQW RESULT | FRD-DRIVE-AFQW-R4-T2 | R3 CREDENTIAL BRIDGE DISCOVERY'
Write-Host '======================================================================'
Write-Host "TASK_ID=$TaskId"
Write-Host "ATTEMPT_ID=$AttemptId"
Write-Host "RESULT=$resultState"
Write-Host "R3_SCRIPT_SHA256=$ExpectedR3ScriptSha"
Write-Host "R3_CREDENTIAL_SHA256=$ExpectedCredentialSha"
Write-Host "R3_RECEIPT_SHA256=$ExpectedR3ReceiptSha"
Write-Host "DPAPI_ENTROPY_MODE=$entropyMode"
Write-Host "DECRYPTED_SCHEMA_KEYS=$($schemaKeys -join ',')"
Write-Host "HAS_CLIENT_ID=$hasClientId"
Write-Host "HAS_CLIENT_SECRET=$hasClientSecret"
Write-Host "HAS_REFRESH_TOKEN=$hasRefreshToken"
Write-Host "HAS_SCOPE=$hasScope"
Write-Host "SCOPE_EXACT_DRIVE_FILE=$scopeExact"
Write-Host "HAS_TOKEN_URI_OR_ENDPOINT_FIELD=$hasTokenUri"
Write-Host "SCRIPT_HAS_REFRESH_GRANT=$scriptHasRefreshGrant"
Write-Host "SCRIPT_HAS_GOOGLE_TOKEN_ENDPOINT=$scriptHasTokenEndpoint"
Write-Host "GOOGLE_CREDENTIAL_DECRYPTION_PERFORMED=$credentialDecryptionPerformed"
Write-Host 'PROVIDER_CALL_COUNT=0'
Write-Host 'DRIVE_API_CALL_COUNT=0'
Write-Host 'DOCS_API_CALL_COUNT=0'
Write-Host 'BROWSER_OAUTH_INTERACTION_COUNT=0'
Write-Host 'GOOGLE_CREDENTIAL_FILE_CHANGED=False'
Write-Host 'A0_A1_RESIDUE_TOUCHED=False'
if (Test-Path -LiteralPath $BindingReceipt -PathType Leaf) { Write-Host "BINDING_RECEIPT_SHA256=$((Get-FileHash -LiteralPath $BindingReceipt -Algorithm SHA256).Hash)" }
Write-Host "FINAL_RECEIPT_SHA256=$((Get-FileHash -LiteralPath $FinalReceipt -Algorithm SHA256).Hash)"
Write-Host "ERROR_CODE=$errorCode"
Write-Host 'RELAUNCH_AUTHORIZED=False'
Write-Host '======================================================================'

if ($resultState -eq 'PASS') { exit 0 }
exit 10
