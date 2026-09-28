#requires -Version 7.0
[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Host.UI.RawUI.WindowTitle = 'FRD Ops Site — Governance | FRD Drive Automation | Atria ForgeLoop T2 R3 Bridge Worker | A1'

$TaskId = 'FRD-DRIVE-AFQW-R4-T2'
$AttemptId = 'FRD-DRIVE-AFQW-R4-T2-A1'
$ExpectedR3ScriptSha = '3CFAE9EA6B10F96270824431600F125778EEAFC154B02FEC61E5497D25DE9E79'
$ExpectedCredentialSha = '8EEE8866414807131C9E0203362CAA72D0FC8EC5F02A5BE390CB2C456625B303'
$ExpectedR3ReceiptSha = 'FE7B95D06F3CA8322B29B362924877B62A3B9C3BCEE6C0B564845F5DBE094D1D'
$ExpectedScope = 'https://www.googleapis.com/auth/drive.file'
$ExpectedTokenUri = 'https://oauth2.googleapis.com/token'

$BootstrapRoot = 'C:\AI-Orchestrator\bootstrap\FRD-Drive-Automation'
$ScriptsRoot = Join-Path $BootstrapRoot 'scripts'
$ReceiptsRoot = Join-Path $BootstrapRoot 'receipts'
$CredentialPath = Join-Path $BootstrapRoot 'credentials\qual-oauth.dpapi'
$StateRoot = 'C:\AI-Orchestrator\workspaces\FRD-Drive-Automation\Atria-Qualification\tasks\FRD-DRIVE-AFQW-R4-T2\FRD-DRIVE-AFQW-R4-T2-A1'
$EvidenceRoot = 'C:\AI-Orchestrator\Governance Files\FRD-Drive-Automation\Atria-Qualification\tasks\FRD-DRIVE-AFQW-R4-T2\FRD-DRIVE-AFQW-R4-T2-A1'
$StartMarker = Join-Path $StateRoot 'STARTED.json'
$FinalReceipt = Join-Path $StateRoot 'FINAL.json'
$BindingReceipt = Join-Path $EvidenceRoot 'R3_BINDING_DISCOVERY_A1.sanitized.json'
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

function Set-SafeError {
    param([Parameter(Mandatory)][string]$Code)
    $script:errorCode = $Code
    throw $Code
}

if ((Test-Path -LiteralPath $StartMarker) -or (Test-Path -LiteralPath $FinalReceipt)) {
    throw 'T2_A1_ALREADY_CONSUMED_OR_TERMINAL_NO_REPLAY'
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
$schemaKeys = @()
$envelopeKeys = @()
$envelopeProtection = $null
$envelopeCiphertextBase64Present = $false
$hasClientId = $false
$hasClientSecret = $false
$hasRefreshToken = $false
$hasScope = $false
$scopeExact = $false
$hasTokenUri = $false
$tokenUriExact = $false
$scriptHasProtect = $false
$scriptHasUnprotect = $false
$scriptHasCurrentUser = $false
$scriptHasNullEntropy = $false
$scriptHasEnvelopeCiphertext = $false
$scriptHasFromBase64 = $false
$scriptHasRefreshGrant = $false
$credentialDecryptionPerformed = $false
$transientArraysCleared = 0
$credentialFileBytes = $null
$storedCipherBytes = $null
$plainBytes = $null
$envelopeText = $null
$plainText = $null
$storedEnvelope = $null
$credentialObject = $null

try {
    if (-not (Test-Path -LiteralPath $CredentialPath -PathType Leaf)) { Set-SafeError 'R3_CREDENTIAL_FILE_MISSING' }
    $credentialSha = (Get-FileHash -LiteralPath $CredentialPath -Algorithm SHA256).Hash
    if ($credentialSha -ne $ExpectedCredentialSha) { Set-SafeError 'R3_CREDENTIAL_HASH_MISMATCH' }

    $scriptMatches = @(Find-ExactHashFile -Root $ScriptsRoot -ExpectedSha $ExpectedR3ScriptSha)
    if ($scriptMatches.Count -ne 1) { Set-SafeError ('R3_SCRIPT_MATCH_COUNT_' + $scriptMatches.Count) }
    $scriptPath = $scriptMatches[0]

    $receiptMatches = @(Find-ExactHashFile -Root $ReceiptsRoot -ExpectedSha $ExpectedR3ReceiptSha)
    if ($receiptMatches.Count -ne 1) { Set-SafeError ('R3_RECEIPT_MATCH_COUNT_' + $receiptMatches.Count) }
    $receiptPath = $receiptMatches[0]

    $scriptText = [IO.File]::ReadAllText($scriptPath)
    $compact = [regex]::Replace($scriptText,'\s+','')
    $scriptHasProtect = $compact.Contains('::Protect(')
    $scriptHasUnprotect = $compact.Contains('::Unprotect(')
    $scriptHasCurrentUser = $compact.Contains('DataProtectionScope]::CurrentUser')
    $scriptHasNullEntropy = ($compact -match '::Protect\([^,]+,\$null,\[[^\]]*DataProtectionScope\]::CurrentUser\)') -and
                            ($compact -match '::Unprotect\([^,]+,\$null,\[[^\]]*DataProtectionScope\]::CurrentUser\)')
    $scriptHasEnvelopeCiphertext = ($scriptText -match '(?i)ciphertext')
    $scriptHasFromBase64 = ($scriptText -match '(?i)FromBase64String')
    $scriptHasRefreshGrant = ($scriptText -match '(?i)grant_type') -and ($scriptText -match '(?i)refresh_token')

    if (-not $scriptHasProtect) { Set-SafeError 'R3_SCRIPT_PROTECT_CONTRACT_MISSING' }
    if (-not $scriptHasUnprotect) { Set-SafeError 'R3_SCRIPT_UNPROTECT_CONTRACT_MISSING' }
    if (-not $scriptHasCurrentUser) { Set-SafeError 'R3_SCRIPT_CURRENTUSER_CONTRACT_MISSING' }
    if (-not $scriptHasNullEntropy) { Set-SafeError 'R3_SCRIPT_NULL_ENTROPY_CONTRACT_NOT_RESOLVED' }
    if (-not $scriptHasEnvelopeCiphertext) { Set-SafeError 'R3_SCRIPT_ENVELOPE_CIPHERTEXT_CONTRACT_MISSING' }
    if (-not $scriptHasFromBase64) { Set-SafeError 'R3_SCRIPT_BASE64_DECODE_CONTRACT_MISSING' }
    if (-not $scriptHasRefreshGrant) { Set-SafeError 'R3_SCRIPT_REFRESH_GRANT_CONTRACT_MISSING' }

    $credentialFileBytes = [IO.File]::ReadAllBytes($CredentialPath)
    if (($credentialFileBytes.Length -le 0) -or ($credentialFileBytes.Length -gt 262144)) { Set-SafeError 'R3_CREDENTIAL_ENVELOPE_LENGTH_INVALID' }
    $envelopeText = [Text.Encoding]::UTF8.GetString($credentialFileBytes)
    try { $storedEnvelope = $envelopeText | ConvertFrom-Json -ErrorAction Stop } catch { Set-SafeError 'R3_CREDENTIAL_ENVELOPE_NOT_JSON' }

    $envelopeKeys = @($storedEnvelope.PSObject.Properties.Name | Sort-Object -Unique)
    if (-not ($envelopeKeys -contains 'protection')) { Set-SafeError 'R3_ENVELOPE_PROTECTION_FIELD_MISSING' }
    if (-not ($envelopeKeys -contains 'ciphertext')) { Set-SafeError 'R3_ENVELOPE_CIPHERTEXT_FIELD_MISSING' }

    $envelopeProtection = [string]$storedEnvelope.protection
    if ($envelopeProtection -ne 'DPAPI-CurrentUser') { Set-SafeError 'R3_ENVELOPE_PROTECTION_VALUE_MISMATCH' }

    $ciphertextText = [string]$storedEnvelope.ciphertext
    $envelopeCiphertextBase64Present = -not [string]::IsNullOrWhiteSpace($ciphertextText)
    if (-not $envelopeCiphertextBase64Present) { Set-SafeError 'R3_ENVELOPE_CIPHERTEXT_EMPTY' }
    try { $storedCipherBytes = [Convert]::FromBase64String($ciphertextText) } catch { Set-SafeError 'R3_ENVELOPE_CIPHERTEXT_NOT_BASE64' }

    Add-Type -AssemblyName System.Security.Cryptography.ProtectedData -ErrorAction SilentlyContinue
    try {
        $plainBytes = [Security.Cryptography.ProtectedData]::Unprotect(
            $storedCipherBytes,
            $null,
            [Security.Cryptography.DataProtectionScope]::CurrentUser
        )
    } catch {
        Set-SafeError 'R3_DPAPI_UNPROTECT_FAILED'
    }
    $credentialDecryptionPerformed = $true

    if (($plainBytes.Length -le 0) -or ($plainBytes.Length -gt 131072)) { Set-SafeError 'R3_DECRYPTED_CREDENTIAL_LENGTH_INVALID' }
    $plainText = [Text.Encoding]::UTF8.GetString($plainBytes)
    try { $credentialObject = $plainText | ConvertFrom-Json -ErrorAction Stop } catch { Set-SafeError 'R3_DECRYPTED_CREDENTIAL_NOT_JSON' }

    $schemaKeys = @($credentialObject.PSObject.Properties.Name | Sort-Object -Unique)
    $hasClientId = $schemaKeys -contains 'client_id'
    $hasClientSecret = $schemaKeys -contains 'client_secret'
    $hasRefreshToken = $schemaKeys -contains 'refresh_token'
    $hasScope = $schemaKeys -contains 'scope'
    $hasTokenUri = $schemaKeys -contains 'token_uri'

    if ($hasScope) { $scopeExact = ([string]$credentialObject.scope -eq $ExpectedScope) }
    if ($hasTokenUri) { $tokenUriExact = ([string]$credentialObject.token_uri -eq $ExpectedTokenUri) }

    if (-not $hasClientId) { Set-SafeError 'R3_SCHEMA_CLIENT_ID_MISSING' }
    if (-not $hasClientSecret) { Set-SafeError 'R3_SCHEMA_CLIENT_SECRET_MISSING' }
    if (-not $hasRefreshToken) { Set-SafeError 'R3_SCHEMA_REFRESH_TOKEN_MISSING' }
    if (-not $hasScope) { Set-SafeError 'R3_SCHEMA_SCOPE_MISSING' }
    if (-not $scopeExact) { Set-SafeError 'R3_SCHEMA_SCOPE_NOT_EXACT_DRIVE_FILE' }
    if (-not $hasTokenUri) { Set-SafeError 'R3_SCHEMA_TOKEN_URI_MISSING' }
    if (-not $tokenUriExact) { Set-SafeError 'R3_SCHEMA_TOKEN_URI_NOT_GOOGLE_OAUTH2' }

    $binding = [ordered]@{
        schema_version='1.1'; task_id=$TaskId; attempt_id=$AttemptId; result='PASS';
        r3_script_sha256=$ExpectedR3ScriptSha; r3_script_filename=[IO.Path]::GetFileName($scriptPath);
        r3_credential_sha256=$ExpectedCredentialSha; r3_credential_filename=[IO.Path]::GetFileName($CredentialPath);
        r3_receipt_sha256=$ExpectedR3ReceiptSha; r3_receipt_filename=[IO.Path]::GetFileName($receiptPath);
        envelope_schema_keys=$envelopeKeys; envelope_protection=$envelopeProtection; envelope_ciphertext_base64_present=$envelopeCiphertextBase64Present;
        dpapi_scope='CurrentUser'; dpapi_entropy_mode='NULL'; credential_decryption_performed=$credentialDecryptionPerformed;
        decrypted_schema_keys=$schemaKeys; has_client_id=$hasClientId; has_client_secret=$hasClientSecret; has_refresh_token=$hasRefreshToken;
        has_scope=$hasScope; scope_exact_drive_file=$scopeExact; has_token_uri=$hasTokenUri; token_uri_exact_google_oauth2=$tokenUriExact;
        script_has_protect=$scriptHasProtect; script_has_unprotect=$scriptHasUnprotect; script_has_current_user=$scriptHasCurrentUser;
        script_has_null_entropy=$scriptHasNullEntropy; script_has_envelope_ciphertext=$scriptHasEnvelopeCiphertext;
        script_has_from_base64=$scriptHasFromBase64; script_has_refresh_grant=$scriptHasRefreshGrant;
        secret_values_persisted_or_shared=$false; provider_call_count=0; drive_api_call_count=0; docs_api_call_count=0; browser_oauth_count=0;
        completed_utc=[DateTime]::UtcNow.ToString('o')
    }
    Write-JsonCreateNew -Path $BindingReceipt -Object $binding
    $resultState = 'PASS'
}
catch {
    if (-not $errorCode) { $errorCode = 'UNEXPECTED_LOCAL_FAILURE' }
    $resultState = 'FAILED'
}
finally {
    if ($plainBytes) { [Array]::Clear($plainBytes,0,$plainBytes.Length); $transientArraysCleared++ }
    if ($storedCipherBytes) { [Array]::Clear($storedCipherBytes,0,$storedCipherBytes.Length); $transientArraysCleared++ }
    if ($credentialFileBytes) { [Array]::Clear($credentialFileBytes,0,$credentialFileBytes.Length); $transientArraysCleared++ }
    $ciphertextText = $null
    $envelopeText = $null
    $plainText = $null
    $storedEnvelope = $null
    $credentialObject = $null
    [GC]::Collect(); [GC]::WaitForPendingFinalizers(); [GC]::Collect()
    $watch.Stop()
    $elapsedMs = [long]$watch.ElapsedMilliseconds
    $final = [ordered]@{
        schema_version='1.1'; task_id=$TaskId; attempt_id=$AttemptId; state=$resultState;
        task_active_start_utc=$startUtc; task_active_end_utc=[DateTime]::UtcNow.ToString('o');
        task_active_elapsed_ms=$elapsedMs; task_active_elapsed_hhmmss=(Format-ElapsedMs -ElapsedMs $elapsedMs);
        worker_active_elapsed_ms=0; worker_active_elapsed_hhmmss='00:00:00';
        provider_call_count=0; drive_api_call_count=0; docs_api_call_count=0; browser_oauth_interaction_count=0;
        google_credential_decryption_performed=$credentialDecryptionPerformed; google_credential_file_changed=$false;
        a0_a1_residue_touched=$false; envelope_schema_keys=$envelopeKeys; envelope_protection=$envelopeProtection;
        envelope_ciphertext_base64_present=$envelopeCiphertextBase64Present; dpapi_scope='CurrentUser'; dpapi_entropy_mode='NULL';
        decrypted_schema_keys=$schemaKeys; has_client_id=$hasClientId; has_client_secret=$hasClientSecret;
        has_refresh_token=$hasRefreshToken; has_scope=$hasScope; scope_exact_drive_file=$scopeExact;
        has_token_uri=$hasTokenUri; token_uri_exact_google_oauth2=$tokenUriExact;
        script_has_envelope_ciphertext=$scriptHasEnvelopeCiphertext; script_has_from_base64=$scriptHasFromBase64;
        script_has_refresh_grant=$scriptHasRefreshGrant; transient_arrays_cleared=$transientArraysCleared;
        secret_values_persisted_or_shared=$false; error_code=$errorCode; replay_authorized=$false
    }
    Write-JsonAtomic -Path $FinalReceipt -Object $final
}

Write-Host '======================================================================'
Write-Host 'AFQW RESULT | FRD-DRIVE-AFQW-R4-T2 | R3 CREDENTIAL BRIDGE DISCOVERY A1'
Write-Host '======================================================================'
Write-Host "TASK_ID=$TaskId"
Write-Host "ATTEMPT_ID=$AttemptId"
Write-Host "RESULT=$resultState"
Write-Host "R3_SCRIPT_SHA256=$ExpectedR3ScriptSha"
Write-Host "R3_CREDENTIAL_SHA256=$ExpectedCredentialSha"
Write-Host "R3_RECEIPT_SHA256=$ExpectedR3ReceiptSha"
Write-Host "ENVELOPE_SCHEMA_KEYS=$($envelopeKeys -join ',')"
Write-Host "ENVELOPE_PROTECTION=$envelopeProtection"
Write-Host "ENVELOPE_CIPHERTEXT_BASE64_PRESENT=$envelopeCiphertextBase64Present"
Write-Host 'DPAPI_SCOPE=CurrentUser'
Write-Host 'DPAPI_ENTROPY_MODE=NULL'
Write-Host "DECRYPTED_SCHEMA_KEYS=$($schemaKeys -join ',')"
Write-Host "HAS_CLIENT_ID=$hasClientId"
Write-Host "HAS_CLIENT_SECRET=$hasClientSecret"
Write-Host "HAS_REFRESH_TOKEN=$hasRefreshToken"
Write-Host "HAS_SCOPE=$hasScope"
Write-Host "SCOPE_EXACT_DRIVE_FILE=$scopeExact"
Write-Host "HAS_TOKEN_URI=$hasTokenUri"
Write-Host "TOKEN_URI_EXACT_GOOGLE_OAUTH2=$tokenUriExact"
Write-Host "SCRIPT_HAS_ENVELOPE_CIPHERTEXT=$scriptHasEnvelopeCiphertext"
Write-Host "SCRIPT_HAS_FROM_BASE64=$scriptHasFromBase64"
Write-Host "SCRIPT_HAS_REFRESH_GRANT=$scriptHasRefreshGrant"
Write-Host "GOOGLE_CREDENTIAL_DECRYPTION_PERFORMED=$credentialDecryptionPerformed"
Write-Host "TRANSIENT_ARRAYS_CLEARED=$transientArraysCleared"
Write-Host 'SECRET_VALUES_PERSISTED_OR_SHARED=False'
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
