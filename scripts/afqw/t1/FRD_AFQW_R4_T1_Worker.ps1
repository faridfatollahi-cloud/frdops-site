#requires -Version 7.0
[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Host.UI.RawUI.WindowTitle = 'FRD Ops Site — Governance | FRD Drive Automation | Atria ForgeLoop T1 Worker | A0'

$TaskId = 'FRD-DRIVE-AFQW-R4-T1'
$AttemptId = 'FRD-DRIVE-AFQW-R4-T1-A0'
$WorkUnitId = 'FRD-DRIVE-AFQW-R4-T1-A0-ATRIA-W01'
$WorkerId = 'FRD-DRIVE-QUAL-ATRIA-WORKER'
$Provider = 'atria'
$ProviderModel = 'Atria-Dawn-Preview'
$ProviderEndpoint = 'https://api.atria-asi.ai/v1/responses'
$CredentialId = 'FRD-DRIVE-QUAL-ATRIA-EXEC-01'
$ExpectedCipherSha256 = '01C5306E6B1CCE4D2AEBA3E122E4EE3FA34D0B2CF2182EF6DCF4F9EA981B30F9'
$ExpectedSentinel = 'AFQW_ATRIA_T1_OK'
$EntropyLabelExpected = 'WIOS-DPAPI|FRD-DRIVE-QUAL-ATRIA-EXEC-01|v1'
$Utf8NoBom = [Text.UTF8Encoding]::new($false)

$CredentialDir = 'C:\AI-Orchestrator\Private\WIOS\FRD-Drive-Qualification\credentials\FRD-DRIVE-QUAL-ATRIA-EXEC-01'
$CredentialMeta = Join-Path $CredentialDir 'credential.json'
$CredentialCipher = Join-Path $CredentialDir 'secret.dpapi'
$PrivateRoot = 'C:\AI-Orchestrator\Private\WIOS\FRD-Drive-Qualification\runtime\FRD-DRIVE-AFQW-R4-T1\FRD-DRIVE-AFQW-R4-T1-A0'
$WorkspaceRoot = 'C:\AI-Orchestrator\workspaces\FRD-Drive-Automation\Atria-Qualification\tasks\FRD-DRIVE-AFQW-R4-T1\FRD-DRIVE-AFQW-R4-T1-A0'
$EvidenceRoot = 'C:\AI-Orchestrator\Governance Files\FRD-Drive-Automation\Atria-Qualification\tasks\FRD-DRIVE-AFQW-R4-T1\FRD-DRIVE-AFQW-R4-T1-A0'

$StartMarker = Join-Path $WorkspaceRoot 'STARTED.json'
$FinalReceipt = Join-Path $WorkspaceRoot 'FINAL.json'
$PrivateIntent = Join-Path $PrivateRoot 'PROVIDER_INTENT.private.json'
$PrivateRawResponse = Join-Path $PrivateRoot 'ATRIA_RESPONSE.raw.json'
$PrivateProviderReceipt = Join-Path $PrivateRoot 'PROVIDER_RESULT.private.json'
$SharedIntent = Join-Path $EvidenceRoot 'PROVIDER_INTENT.sanitized.json'
$SharedProviderResult = Join-Path $EvidenceRoot 'PROVIDER_RESULT.sanitized.json'

function Convert-ToJsonLine {
    param([Parameter(Mandatory)]$Object)
    return (($Object | ConvertTo-Json -Depth 20 -Compress) + "`n")
}

function Write-JsonCreateNew {
    param(
        [Parameter(Mandatory)]$Object,
        [Parameter(Mandatory)][string]$Path
    )
    $directory = Split-Path -Parent $Path
    [IO.Directory]::CreateDirectory($directory) | Out-Null
    $json = Convert-ToJsonLine -Object $Object
    $bytes = $Utf8NoBom.GetBytes($json)
    $stream = [IO.File]::Open($Path, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::Read)
    try {
        $stream.Write($bytes, 0, $bytes.Length)
        $stream.Flush($true)
    }
    finally {
        $stream.Dispose()
    }
}

function Write-JsonAtomic {
    param(
        [Parameter(Mandatory)]$Object,
        [Parameter(Mandatory)][string]$Path
    )
    $directory = Split-Path -Parent $Path
    [IO.Directory]::CreateDirectory($directory) | Out-Null
    $temp = "$Path.tmp.$PID.$([Guid]::NewGuid().ToString('N'))"
    try {
        [IO.File]::WriteAllText($temp, (Convert-ToJsonLine -Object $Object), $Utf8NoBom)
        [IO.File]::Move($temp, $Path, $true)
    }
    finally {
        if (Test-Path -LiteralPath $temp) {
            Remove-Item -LiteralPath $temp -Force -ErrorAction SilentlyContinue
        }
    }
}

function Write-BytesAtomic {
    param(
        [Parameter(Mandatory)][byte[]]$Bytes,
        [Parameter(Mandatory)][string]$Path
    )
    $directory = Split-Path -Parent $Path
    [IO.Directory]::CreateDirectory($directory) | Out-Null
    $temp = "$Path.tmp.$PID.$([Guid]::NewGuid().ToString('N'))"
    try {
        [IO.File]::WriteAllBytes($temp, $Bytes)
        [IO.File]::Move($temp, $Path, $true)
    }
    finally {
        if (Test-Path -LiteralPath $temp) {
            Remove-Item -LiteralPath $temp -Force -ErrorAction SilentlyContinue
        }
    }
}

function Get-BytesSha256 {
    param([Parameter(Mandatory)][byte[]]$Bytes)
    $sha = [Security.Cryptography.SHA256]::Create()
    try {
        return ([BitConverter]::ToString($sha.ComputeHash($Bytes))).Replace('-', '')
    }
    finally {
        $sha.Dispose()
    }
}

function Format-ElapsedMs {
    param([Parameter(Mandatory)][long]$ElapsedMs)
    $span = [TimeSpan]::FromMilliseconds($ElapsedMs)
    $hours = [int][Math]::Floor($span.TotalHours)
    return ('{0:D2}:{1:D2}:{2:D2}' -f $hours, $span.Minutes, $span.Seconds)
}

function Get-UtcIso {
    return [DateTime]::UtcNow.ToString('o')
}

if ((Test-Path -LiteralPath $StartMarker) -or (Test-Path -LiteralPath $FinalReceipt)) {
    throw 'T1_A0_ALREADY_CONSUMED_OR_TERMINAL_NO_REPLAY'
}

[IO.Directory]::CreateDirectory($PrivateRoot) | Out-Null
[IO.Directory]::CreateDirectory($WorkspaceRoot) | Out-Null
[IO.Directory]::CreateDirectory($EvidenceRoot) | Out-Null

$taskWatch = [Diagnostics.Stopwatch]::StartNew()
$workerWatch = [Diagnostics.Stopwatch]::new()
$providerIntentCount = 0
$providerCallCount = 0
$credentialDecryptionPerformed = $false
$rawResponsePersisted = $false
$observedModel = $null
$httpStatus = $null
$responseSha256 = $null
$outputTextSha256 = $null
$failureCode = $null
$finalState = 'FAILED'
$secretBytes = $null
$secret = $null
$entropyBytes = $null
$rawResponseBytes = $null
$httpClient = $null
$request = $null
$response = $null

$startedUtc = Get-UtcIso
Write-JsonCreateNew -Path $StartMarker -Object ([ordered]@{
    schema_version = '1.0'
    task_id = $TaskId
    attempt_id = $AttemptId
    work_unit_id = $WorkUnitId
    worker_id = $WorkerId
    provider = $Provider
    provider_model = $ProviderModel
    credential_id = $CredentialId
    state = 'STARTED'
    task_active_start_utc = $startedUtc
    provider_budget = 1
    drive_api_budget = 0
    docs_api_budget = 0
    browser_oauth_budget = 0
})

try {
    if (-not (Test-Path -LiteralPath $CredentialMeta -PathType Leaf)) {
        $failureCode = 'CREDENTIAL_METADATA_MISSING'
        throw $failureCode
    }
    if (-not (Test-Path -LiteralPath $CredentialCipher -PathType Leaf)) {
        $failureCode = 'CREDENTIAL_CIPHERTEXT_MISSING'
        throw $failureCode
    }

    $meta = Get-Content -LiteralPath $CredentialMeta -Raw | ConvertFrom-Json
    if ($meta.credential_id -ne $CredentialId) {
        $failureCode = 'CREDENTIAL_IDENTITY_MISMATCH'
        throw $failureCode
    }
    if ($meta.protection -ne 'DPAPI-CurrentUser') {
        $failureCode = 'CREDENTIAL_PROTECTION_MISMATCH'
        throw $failureCode
    }
    if ($meta.entropy_label -ne $EntropyLabelExpected) {
        $failureCode = 'CREDENTIAL_ENTROPY_LABEL_MISMATCH'
        throw $failureCode
    }
    if ($meta.cipher_file -ne 'secret.dpapi') {
        $failureCode = 'CREDENTIAL_CIPHER_FILE_MISMATCH'
        throw $failureCode
    }

    $cipherSha256 = (Get-FileHash -LiteralPath $CredentialCipher -Algorithm SHA256).Hash
    if ($cipherSha256 -ne $ExpectedCipherSha256) {
        $failureCode = 'CREDENTIAL_CIPHERTEXT_HASH_MISMATCH'
        throw $failureCode
    }

    Add-Type -AssemblyName System.Security.Cryptography.ProtectedData -ErrorAction SilentlyContinue
    Add-Type -AssemblyName System.Net.Http -ErrorAction Stop

    $cipherBytes = [IO.File]::ReadAllBytes($CredentialCipher)
    $entropyBytes = [Text.Encoding]::UTF8.GetBytes($EntropyLabelExpected)
    $secretBytes = [Security.Cryptography.ProtectedData]::Unprotect(
        $cipherBytes,
        $entropyBytes,
        [Security.Cryptography.DataProtectionScope]::CurrentUser
    )
    $credentialDecryptionPerformed = $true

    if (($secretBytes.Length -le 0) -or ($secretBytes.Length -gt 16384)) {
        $failureCode = 'CREDENTIAL_DECRYPTED_LENGTH_INVALID'
        throw $failureCode
    }

    $secret = [Text.Encoding]::UTF8.GetString($secretBytes)
    if ([string]::IsNullOrWhiteSpace($secret) -or $secret.Contains("`r") -or $secret.Contains("`n")) {
        $failureCode = 'CREDENTIAL_DECRYPTED_CONTENT_INVALID'
        throw $failureCode
    }

    $prompt = @'
You are the bounded Atria worker for a provider-binding canary in FRD Drive Automation.
This work unit has no Google Drive, Google Docs, browser OAuth, repository, or filesystem mutation authority.
Return exactly the following single line and nothing else:
AFQW_ATRIA_T1_OK
'@

    $bodyObject = [ordered]@{
        model = $ProviderModel
        input = $prompt
        max_output_tokens = 64
        stream = $false
    }
    $bodyJson = $bodyObject | ConvertTo-Json -Depth 10 -Compress
    $bodyBytes = [Text.Encoding]::UTF8.GetBytes($bodyJson)
    $requestSha256 = Get-BytesSha256 -Bytes $bodyBytes

    $intentUtc = Get-UtcIso
    Write-JsonCreateNew -Path $PrivateIntent -Object ([ordered]@{
        schema_version = '1.0'
        task_id = $TaskId
        attempt_id = $AttemptId
        work_unit_id = $WorkUnitId
        provider = $Provider
        requested_model = $ProviderModel
        endpoint = $ProviderEndpoint
        credential_id = $CredentialId
        request_sha256 = $requestSha256
        provider_intent_utc = $intentUtc
        uncertainty_boundary = 'NO_REPLAY_AFTER_DURABLE_INTENT'
    })
    Write-JsonCreateNew -Path $SharedIntent -Object ([ordered]@{
        schema_version = '1.0'
        task_id = $TaskId
        attempt_id = $AttemptId
        work_unit_id = $WorkUnitId
        provider = $Provider
        requested_model = $ProviderModel
        endpoint = $ProviderEndpoint
        credential_id = $CredentialId
        request_sha256 = $requestSha256
        provider_intent_utc = $intentUtc
        secret_included = $false
    })

    $providerIntentCount = 1
    $workerWatch.Start()

    $handler = [Net.Http.HttpClientHandler]::new()
    $httpClient = [Net.Http.HttpClient]::new($handler)
    $httpClient.Timeout = [TimeSpan]::FromSeconds(300)
    $request = [Net.Http.HttpRequestMessage]::new([Net.Http.HttpMethod]::Post, $ProviderEndpoint)
    $request.Headers.Authorization = [Net.Http.Headers.AuthenticationHeaderValue]::new('Bearer', $secret)
    $request.Headers.Accept.Add([Net.Http.Headers.MediaTypeWithQualityHeaderValue]::new('application/json'))
    $request.Content = [Net.Http.StringContent]::new($bodyJson, [Text.Encoding]::UTF8, 'application/json')

    $providerCallCount = 1
    try {
        $response = $httpClient.SendAsync($request).GetAwaiter().GetResult()
        $httpStatus = [int]$response.StatusCode
        $rawResponseBytes = $response.Content.ReadAsByteArrayAsync().GetAwaiter().GetResult()
    }
    catch {
        $failureCode = 'ATRIA_TRANSPORT_OR_SEND_UNCERTAIN'
        throw $failureCode
    }

    Write-BytesAtomic -Path $PrivateRawResponse -Bytes $rawResponseBytes
    $rawResponsePersisted = $true
    $responseSha256 = Get-BytesSha256 -Bytes $rawResponseBytes

    if (($httpStatus -lt 200) -or ($httpStatus -ge 300)) {
        $failureCode = 'ATRIA_HTTP_STATUS_UNCERTAIN_' + $httpStatus
        throw $failureCode
    }

    try {
        $payloadText = [Text.Encoding]::UTF8.GetString($rawResponseBytes)
        $payload = $payloadText | ConvertFrom-Json
    }
    catch {
        $failureCode = 'ATRIA_RESPONSE_NOT_VALID_JSON'
        throw $failureCode
    }

    if ($payload.status -ne 'completed') {
        $failureCode = 'ATRIA_RESPONSE_NOT_COMPLETED'
        throw $failureCode
    }

    $observedModel = [string]$payload.model
    if ([string]::IsNullOrWhiteSpace($observedModel) -or ($observedModel -ne $ProviderModel)) {
        $failureCode = 'ATRIA_MODEL_IDENTITY_DRIFT'
        throw $failureCode
    }

    $pieces = [Collections.Generic.List[string]]::new()
    foreach ($item in @($payload.output)) {
        if (($null -eq $item) -or ($item.type -ne 'message')) { continue }
        foreach ($part in @($item.content)) {
            if ($null -eq $part) { continue }
            if ((($part.type -eq 'output_text') -or ($part.type -eq 'text')) -and ($part.text -is [string])) {
                [void]$pieces.Add([string]$part.text)
            }
        }
    }

    if ($pieces.Count -eq 0) {
        $failureCode = 'ATRIA_RESPONSE_TEXT_MISSING'
        throw $failureCode
    }

    $outputText = ($pieces -join "`n").Trim()
    $outputTextBytes = [Text.Encoding]::UTF8.GetBytes($outputText)
    $outputTextSha256 = Get-BytesSha256 -Bytes $outputTextBytes
    if ($outputText -ne $ExpectedSentinel) {
        $failureCode = 'ATRIA_CANARY_SENTINEL_MISMATCH'
        throw $failureCode
    }

    if ($workerWatch.IsRunning) { $workerWatch.Stop() }
    $workerActiveMs = [long]$workerWatch.ElapsedMilliseconds

    Write-JsonCreateNew -Path $PrivateProviderReceipt -Object ([ordered]@{
        schema_version = '1.0'
        task_id = $TaskId
        attempt_id = $AttemptId
        work_unit_id = $WorkUnitId
        terminal_state = 'COMPLETE'
        provider = $Provider
        requested_model = $ProviderModel
        observed_model = $observedModel
        endpoint = $ProviderEndpoint
        http_status = $httpStatus
        response_sha256 = $responseSha256
        output_text_sha256 = $outputTextSha256
        sentinel_match = $true
        raw_response_persisted_before_complete = $rawResponsePersisted
        worker_active_elapsed_ms = $workerActiveMs
        worker_active_elapsed_hhmmss = Format-ElapsedMs -ElapsedMs $workerActiveMs
        terminal_utc = Get-UtcIso
    })

    Write-JsonCreateNew -Path $SharedProviderResult -Object ([ordered]@{
        schema_version = '1.0'
        task_id = $TaskId
        attempt_id = $AttemptId
        work_unit_id = $WorkUnitId
        terminal_state = 'COMPLETE'
        provider = $Provider
        requested_model = $ProviderModel
        observed_model = $observedModel
        endpoint = $ProviderEndpoint
        http_status = $httpStatus
        response_sha256 = $responseSha256
        output_text_sha256 = $outputTextSha256
        sentinel_match = $true
        raw_response_shared = $false
        worker_active_elapsed_ms = $workerActiveMs
        terminal_utc = Get-UtcIso
    })

    $finalState = 'PASS'
}
catch {
    if ($workerWatch.IsRunning) { $workerWatch.Stop() }
    if (-not $failureCode) {
        if ($providerIntentCount -gt 0) {
            $failureCode = 'POST_INTENT_UNCLASSIFIED_UNCERTAINTY'
        }
        else {
            $failureCode = 'PRE_INTENT_LOCAL_FAILURE'
        }
    }
    if ($providerIntentCount -gt 0) {
        $finalState = 'UNKNOWN'
    }
    else {
        $finalState = 'FAILED'
    }
}
finally {
    $taskWatch.Stop()

    if ($null -ne $request) { $request.Dispose() }
    if ($null -ne $response) { $response.Dispose() }
    if ($null -ne $httpClient) { $httpClient.Dispose() }

    if ($secretBytes) { [Array]::Clear($secretBytes, 0, $secretBytes.Length) }
    if ($entropyBytes) { [Array]::Clear($entropyBytes, 0, $entropyBytes.Length) }
    if ($rawResponseBytes) { [Array]::Clear($rawResponseBytes, 0, $rawResponseBytes.Length) }
    $secret = $null
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
    [GC]::Collect()

    $taskActiveMs = [long]$taskWatch.ElapsedMilliseconds
    $workerActiveMsFinal = [long]$workerWatch.ElapsedMilliseconds

    if (-not (Test-Path -LiteralPath $FinalReceipt)) {
        Write-JsonAtomic -Path $FinalReceipt -Object ([ordered]@{
            schema_version = '1.0'
            task_id = $TaskId
            attempt_id = $AttemptId
            work_unit_id = $WorkUnitId
            state = $finalState
            worker_id = $WorkerId
            provider = $Provider
            provider_model = $ProviderModel
            observed_model = $observedModel
            credential_id = $CredentialId
            task_active_start_utc = $startedUtc
            task_active_end_utc = Get-UtcIso
            task_active_elapsed_ms = $taskActiveMs
            task_active_elapsed_hhmmss = Format-ElapsedMs -ElapsedMs $taskActiveMs
            worker_active_elapsed_ms = $workerActiveMsFinal
            worker_active_elapsed_hhmmss = Format-ElapsedMs -ElapsedMs $workerActiveMsFinal
            provider_intent_count = $providerIntentCount
            provider_call_count = $providerCallCount
            drive_api_call_count = 0
            docs_api_call_count = 0
            browser_oauth_interaction_count = 0
            credential_decryption_performed = $credentialDecryptionPerformed
            credential_file_changed = $false
            a0_a1_residue_touched = $false
            raw_provider_response_shared = $false
            raw_provider_response_persisted_private = $rawResponsePersisted
            http_status = $httpStatus
            response_sha256 = $responseSha256
            output_text_sha256 = $outputTextSha256
            error_code = $failureCode
            replay_authorized = $false
            completed_utc = Get-UtcIso
        })
    }
}

if ($finalState -eq 'PASS') { exit 0 }
if ($finalState -eq 'UNKNOWN') { exit 20 }
exit 10
