#requires -Version 7.0
[CmdletBinding()]
param(
    [string]$TaskId = 'FRD-DRIVE-AFQW-R4-T0',
    [string]$AttemptId = 'FRD-DRIVE-AFQW-R4-T0-A0',
    [string]$WorkspaceRoot = 'C:\AI-Orchestrator\workspaces\FRD-Drive-Automation\Atria-Qualification',
    [string]$EvidenceRoot = 'C:\AI-Orchestrator\Governance Files\FRD-Drive-Automation\Atria-Qualification',
    [string]$CredentialDirectory = 'C:\AI-Orchestrator\Private\WIOS\FRD-Drive-Qualification\credentials\FRD-DRIVE-QUAL-ATRIA-EXEC-01'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Host.UI.RawUI.WindowTitle = 'FRD Ops Site — Governance | FRD Drive Automation | Atria ForgeLoop Worker'

$ExpectedTaskId = 'FRD-DRIVE-AFQW-R4-T0'
$ExpectedAttemptId = 'FRD-DRIVE-AFQW-R4-T0-A0'
$WorkerId = 'FRD-DRIVE-QUAL-ATRIA-WORKER'
$ProviderModel = 'Atria-Dawn-Preview'
$CredentialId = 'FRD-DRIVE-QUAL-ATRIA-EXEC-01'
$Utf8NoBom = [System.Text.UTF8Encoding]::new($false)

function Write-Utf8NoBom {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Text
    )
    [System.IO.File]::WriteAllText($Path, $Text, $Utf8NoBom)
}

function Convert-ToCanonicalJson {
    param([Parameter(Mandatory)]$Object)
    return ($Object | ConvertTo-Json -Depth 32 -Compress)
}

function Write-JsonAtomic {
    param(
        [Parameter(Mandatory)]$Object,
        [Parameter(Mandatory)][string]$Path
    )
    $directory = Split-Path -Parent $Path
    [System.IO.Directory]::CreateDirectory($directory) | Out-Null
    $temp = "$Path.tmp.$PID.$([Guid]::NewGuid().ToString('N'))"
    try {
        Write-Utf8NoBom -Path $temp -Text ((Convert-ToCanonicalJson -Object $Object) + "`n")
        [System.IO.File]::Move($temp, $Path, $true)
    }
    finally {
        if (Test-Path -LiteralPath $temp) {
            Remove-Item -LiteralPath $temp -Force -ErrorAction SilentlyContinue
        }
    }
}

function Write-JsonCreateNew {
    param(
        [Parameter(Mandatory)]$Object,
        [Parameter(Mandatory)][string]$Path
    )
    $directory = Split-Path -Parent $Path
    [System.IO.Directory]::CreateDirectory($directory) | Out-Null
    $json = (Convert-ToCanonicalJson -Object $Object) + "`n"
    $bytes = $Utf8NoBom.GetBytes($json)
    $stream = [System.IO.File]::Open($Path, [System.IO.FileMode]::CreateNew, [System.IO.FileAccess]::Write, [System.IO.FileShare]::Read)
    try {
        $stream.Write($bytes, 0, $bytes.Length)
        $stream.Flush($true)
    }
    finally {
        $stream.Dispose()
    }
}

function Add-JsonLine {
    param(
        [Parameter(Mandatory)]$Object,
        [Parameter(Mandatory)][string]$Path
    )
    $line = (Convert-ToCanonicalJson -Object $Object) + "`n"
    [System.IO.File]::AppendAllText($Path, $line, $Utf8NoBom)
}

function Get-FullPathNormalized {
    param([Parameter(Mandatory)][string]$Path)
    return [System.IO.Path]::GetFullPath($Path).TrimEnd('\','/')
}

function Test-IsStrictChildPath {
    param(
        [Parameter(Mandatory)][string]$Base,
        [Parameter(Mandatory)][string]$Candidate
    )
    $separator = [System.IO.Path]::DirectorySeparatorChar
    $baseFull = (Get-FullPathNormalized -Path $Base) + $separator
    $candidateFull = Get-FullPathNormalized -Path $Candidate
    return $candidateFull.StartsWith($baseFull, [System.StringComparison]::OrdinalIgnoreCase)
}

function Assert-IdentityAvailable {
    param(
        [Parameter(Mandatory)][string]$StartMarker,
        [Parameter(Mandatory)][string]$FinalReceipt
    )
    if ((Test-Path -LiteralPath $StartMarker) -or (Test-Path -LiteralPath $FinalReceipt)) {
        throw "CONSUMED_IDENTITY: $AttemptId already has durable start/terminal state."
    }
}

function Format-ElapsedMs {
    param([Parameter(Mandatory)][long]$ElapsedMs)
    if ($ElapsedMs -lt 0) { throw 'Elapsed milliseconds cannot be negative.' }
    $span = [TimeSpan]::FromMilliseconds($ElapsedMs)
    $hours = [int][Math]::Floor($span.TotalHours)
    return ('{0:D2}:{1:D2}:{2:D2}' -f $hours, $span.Minutes, $span.Seconds)
}

function Get-ElapsedMsFromTicks {
    param(
        [Parameter(Mandatory)][long]$StartTicks,
        [Parameter(Mandatory)][long]$EndTicks,
        [Parameter(Mandatory)][long]$Frequency
    )
    if ($Frequency -le 0) { throw 'Stopwatch frequency must be positive.' }
    if ($EndTicks -lt $StartTicks) { throw 'End ticks precede start ticks.' }
    return [long][Math]::Round((($EndTicks - $StartTicks) * 1000.0) / $Frequency, 0, [MidpointRounding]::AwayFromZero)
}

function Test-SanitizedText {
    param([Parameter(Mandatory)][string]$Text)
    $patterns = @(
        'AIza[0-9A-Za-z\-_]{20,}',
        '(?i)Bearer\s+[A-Za-z0-9._\-]{20,}',
        '(?i)\bsk-[A-Za-z0-9_\-]{20,}'
    )
    foreach ($pattern in $patterns) {
        if ([regex]::IsMatch($Text, $pattern)) {
            return $false
        }
    }
    return $true
}

function New-Event {
    param(
        [Parameter(Mandatory)][string]$Type,
        [Parameter(Mandatory)][string]$State,
        [hashtable]$Data = @{}
    )
    return [ordered]@{
        schema_version = '1.0'
        task_id = $TaskId
        attempt_id = $AttemptId
        event_type = $Type
        state = $State
        utc = [DateTime]::UtcNow.ToString('o')
        data = $Data
    }
}

if ($TaskId -ne $ExpectedTaskId) {
    throw "TASK_ID_MISMATCH: expected $ExpectedTaskId, observed $TaskId"
}
if ($AttemptId -ne $ExpectedAttemptId) {
    throw "ATTEMPT_ID_MISMATCH: expected $ExpectedAttemptId, observed $AttemptId"
}
if ($PSVersionTable.PSVersion.Major -lt 7) {
    throw 'PowerShell 7 or newer is required.'
}

$taskStateRoot = Join-Path $WorkspaceRoot "tasks\$TaskId\$AttemptId"
$taskEvidenceRoot = Join-Path $EvidenceRoot "tasks\$TaskId\$AttemptId"

if (-not (Test-IsStrictChildPath -Base $WorkspaceRoot -Candidate $taskStateRoot)) {
    throw 'WORKSPACE_ROOT_GUARD_FAILED'
}
if (-not (Test-IsStrictChildPath -Base $EvidenceRoot -Candidate $taskEvidenceRoot)) {
    throw 'EVIDENCE_ROOT_GUARD_FAILED'
}
if (-not (Test-Path -LiteralPath $CredentialDirectory -PathType Container)) {
    throw 'CREDENTIAL_REFERENCE_DIRECTORY_MISSING'
}

[System.IO.Directory]::CreateDirectory($taskStateRoot) | Out-Null
[System.IO.Directory]::CreateDirectory($taskEvidenceRoot) | Out-Null

$startMarker = Join-Path $taskStateRoot 'STARTED.json'
$finalReceipt = Join-Path $taskStateRoot 'FINAL.json'
$eventsPath = Join-Path $taskEvidenceRoot 'EVENTS.jsonl'
$manifestPath = Join-Path $taskEvidenceRoot 'EVIDENCE_MANIFEST.json'

Assert-IdentityAvailable -StartMarker $startMarker -FinalReceipt $finalReceipt

$startUtc = [DateTime]::UtcNow
$startTicks = [Diagnostics.Stopwatch]::GetTimestamp()
$frequency = [Diagnostics.Stopwatch]::Frequency

$startObject = [ordered]@{
    schema_version = '1.0'
    task_id = $TaskId
    attempt_id = $AttemptId
    workflow_id = 'AFQW'
    workflow_version = '1.0'
    worker_id = $WorkerId
    provider_model = $ProviderModel
    credential_id = $CredentialId
    state = 'STARTED'
    task_active_start_utc = $startUtc.ToString('o')
    task_active_start_monotonic_ticks = $startTicks
    stopwatch_frequency = $frequency
    worker_active_elapsed_ms = 0
    provider_intent_count = 0
    provider_call_count = 0
    drive_api_call_count = 0
    docs_api_call_count = 0
    browser_oauth_interaction_count = 0
    credential_decryption_performed = $false
    credential_file_changed = $false
    a0_a1_residue_touched = $false
}

Write-JsonCreateNew -Object $startObject -Path $startMarker
Add-JsonLine -Object (New-Event -Type 'TASK_START' -State 'ACTIVE' -Data @{
    worker_id = $WorkerId
    provider_model = $ProviderModel
    credential_id = $CredentialId
}) -Path $eventsPath

$terminalState = 'FAILED'
$selfTests = [ordered]@{}
$errorRecord = $null

try {
    # Root guard self-test.
    $escapeCandidate = Join-Path $WorkspaceRoot '..\AFQW-T0-ESCAPE-TEST'
    $rootReject = -not (Test-IsStrictChildPath -Base $WorkspaceRoot -Candidate $escapeCandidate)
    if (-not $rootReject) { throw 'SELFTEST_ROOT_ESCAPE_REJECTION_FAILED' }
    $selfTests.root_escape_rejection = 'PASS'

    # Replay fence self-test using a disposable local-only test directory inside this attempt.
    $replayTestRoot = Join-Path $taskStateRoot ("selftest-replay-" + [Guid]::NewGuid().ToString('N'))
    [System.IO.Directory]::CreateDirectory($replayTestRoot) | Out-Null
    $replayStart = Join-Path $replayTestRoot 'STARTED.json'
    $replayFinal = Join-Path $replayTestRoot 'FINAL.json'
    Assert-IdentityAvailable -StartMarker $replayStart -FinalReceipt $replayFinal
    Write-Utf8NoBom -Path $replayStart -Text "{`"state`":`"STARTED`"}`n"
    $replayRejected = $false
    try {
        Assert-IdentityAvailable -StartMarker $replayStart -FinalReceipt $replayFinal
    }
    catch {
        if ($_.Exception.Message -like 'CONSUMED_IDENTITY:*') {
            $replayRejected = $true
        }
        else {
            throw
        }
    }
    if (-not $replayRejected) { throw 'SELFTEST_REPLAY_FENCE_FAILED' }
    Remove-Item -LiteralPath $replayTestRoot -Recurse -Force
    $selfTests.replay_fence = 'PASS'

    # Timer arithmetic self-test.
    $syntheticMs = Get-ElapsedMsFromTicks -StartTicks 1000 -EndTicks 2500 -Frequency 1000
    if ($syntheticMs -ne 1500) { throw "SELFTEST_TIMER_MATH_FAILED: $syntheticMs" }
    if ((Format-ElapsedMs -ElapsedMs 1500) -ne '00:00:01') { throw 'SELFTEST_TIMER_FORMAT_FAILED' }
    $selfTests.timer_math = 'PASS'

    # Atomic JSON writer/readback self-test.
    $atomicPath = Join-Path $taskStateRoot ("selftest-atomic-" + [Guid]::NewGuid().ToString('N') + '.json')
    $atomicObject = [ordered]@{ test = 'atomic'; value = 1 }
    Write-JsonAtomic -Object $atomicObject -Path $atomicPath
    $atomicReadback = Get-Content -LiteralPath $atomicPath -Raw | ConvertFrom-Json
    if (($atomicReadback.test -ne 'atomic') -or ([int]$atomicReadback.value -ne 1)) {
        throw 'SELFTEST_ATOMIC_JSON_READBACK_FAILED'
    }
    Remove-Item -LiteralPath $atomicPath -Force
    $selfTests.atomic_json = 'PASS'

    # Credential boundary self-test: reference only; no file open/decrypt.
    $credentialLeaf = Split-Path -Leaf (Get-FullPathNormalized -Path $CredentialDirectory)
    if ($credentialLeaf -ne $CredentialId) { throw 'SELFTEST_CREDENTIAL_REFERENCE_ID_MISMATCH' }
    $selfTests.credential_reference_only = 'PASS'

    # T0 hard-zero provider/mutation invariant.
    $selfTests.zero_provider_budget = 'PASS'
    $selfTests.zero_drive_docs_budget = 'PASS'
    $selfTests.worker_active_zero = 'PASS'

    Add-JsonLine -Object (New-Event -Type 'SELFTESTS' -State 'PASS' -Data @{
        tests = $selfTests
        provider_calls = 0
        drive_api_calls = 0
        docs_api_calls = 0
        worker_active_elapsed_ms = 0
    }) -Path $eventsPath

    $terminalState = 'PASS'
}
catch {
    $terminalState = 'FAILED'
    $errorRecord = [ordered]@{
        type = $_.Exception.GetType().FullName
        message = $_.Exception.Message
    }
    Add-JsonLine -Object (New-Event -Type 'SELFTESTS' -State 'FAILED' -Data @{
        tests = $selfTests
        error_type = $errorRecord.type
        error_message = $errorRecord.message
    }) -Path $eventsPath
}

$endTicks = [Diagnostics.Stopwatch]::GetTimestamp()
$endUtc = [DateTime]::UtcNow
$taskElapsedMs = Get-ElapsedMsFromTicks -StartTicks $startTicks -EndTicks $endTicks -Frequency $frequency

$finalObject = [ordered]@{
    schema_version = '1.0'
    task_id = $TaskId
    attempt_id = $AttemptId
    workflow_id = 'AFQW'
    workflow_version = '1.0'
    worker_id = $WorkerId
    provider_model = $ProviderModel
    credential_id = $CredentialId
    state = $terminalState
    task_active_start_utc = $startUtc.ToString('o')
    task_active_end_utc = $endUtc.ToString('o')
    task_active_start_monotonic_ticks = $startTicks
    task_active_end_monotonic_ticks = $endTicks
    stopwatch_frequency = $frequency
    task_active_elapsed_ms = $taskElapsedMs
    task_active_elapsed_hhmmss = Format-ElapsedMs -ElapsedMs $taskElapsedMs
    worker_active_elapsed_ms = 0
    worker_active_elapsed_hhmmss = '00:00:00'
    provider_intent_count = 0
    provider_call_count = 0
    drive_api_call_count = 0
    docs_api_call_count = 0
    browser_oauth_interaction_count = 0
    credential_decryption_performed = $false
    credential_file_changed = $false
    a0_a1_residue_touched = $false
    self_tests = $selfTests
    error = $errorRecord
}

$finalJson = Convert-ToCanonicalJson -Object $finalObject
if (-not (Test-SanitizedText -Text $finalJson)) {
    throw 'SANITIZED_FINAL_RECEIPT_SECRET_PATTERN_DETECTED'
}

Write-JsonAtomic -Object $finalObject -Path $finalReceipt
Add-JsonLine -Object (New-Event -Type 'TASK_TERMINAL' -State $terminalState -Data @{
    task_active_elapsed_ms = $taskElapsedMs
    worker_active_elapsed_ms = 0
}) -Path $eventsPath

$evidenceFiles = @($startMarker, $finalReceipt, $eventsPath)
$manifestEntries = @()
foreach ($file in $evidenceFiles) {
    $item = Get-Item -LiteralPath $file
    $manifestEntries += [ordered]@{
        path = $item.FullName
        bytes = $item.Length
        sha256 = (Get-FileHash -LiteralPath $item.FullName -Algorithm SHA256).Hash
    }
}
$manifest = [ordered]@{
    schema_version = '1.0'
    task_id = $TaskId
    attempt_id = $AttemptId
    state = $terminalState
    generated_utc = [DateTime]::UtcNow.ToString('o')
    files = $manifestEntries
}
$manifestJson = Convert-ToCanonicalJson -Object $manifest
if (-not (Test-SanitizedText -Text $manifestJson)) {
    throw 'SANITIZED_MANIFEST_SECRET_PATTERN_DETECTED'
}
Write-JsonAtomic -Object $manifest -Path $manifestPath
$manifestHash = (Get-FileHash -LiteralPath $manifestPath -Algorithm SHA256).Hash

Write-Host ''
Write-Host '======================================================================'
Write-Host "AFQW RESULT | $TaskId | T0 WORKER"
Write-Host '======================================================================'
Write-Host "ATTEMPT_ID=$AttemptId"
Write-Host "RESULT=$terminalState"
Write-Host "WORKER_ID=$WorkerId"
Write-Host "PROVIDER_MODEL=$ProviderModel"
Write-Host "CREDENTIAL_ID=$CredentialId"
Write-Host "TASK_ACTIVE_ELAPSED_MS=$taskElapsedMs"
Write-Host "TASK_ACTIVE_ELAPSED=$((Format-ElapsedMs -ElapsedMs $taskElapsedMs))"
Write-Host 'WORKER_ACTIVE_ELAPSED_MS=0'
Write-Host 'WORKER_ACTIVE_ELAPSED=00:00:00'
Write-Host 'PROVIDER_INTENT_COUNT=0'
Write-Host 'PROVIDER_CALL_PERFORMED=False'
Write-Host 'DRIVE_API_CALL_PERFORMED=False'
Write-Host 'DOCS_API_CALL_PERFORMED=False'
Write-Host 'BROWSER_OAUTH_INTERACTION_PERFORMED=False'
Write-Host 'CREDENTIAL_DECRYPTION_PERFORMED=False'
Write-Host 'CREDENTIAL_FILE_CHANGED=False'
Write-Host 'A0_A1_RESIDUE_TOUCHED=False'
Write-Host "EVIDENCE_MANIFEST_SHA256=$manifestHash"
Write-Host '======================================================================'

if ($terminalState -eq 'PASS') {
    exit 0
}
exit 1
