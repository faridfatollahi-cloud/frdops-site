#requires -Version 7.0
[CmdletBinding()]
param(
    [string]$TaskId = 'FRD-DRIVE-AFQW-R4-T0',
    [string]$AttemptId = 'FRD-DRIVE-AFQW-R4-T0-A0',
    [string]$WorkspaceRoot = 'C:\AI-Orchestrator\workspaces\FRD-Drive-Automation\Atria-Qualification',
    [int]$PollMilliseconds = 500
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Host.UI.RawUI.WindowTitle = 'FRD Ops Site — Governance | FRD Drive Automation | Atria ForgeLoop Task Timer'

$ExpectedTaskId = 'FRD-DRIVE-AFQW-R4-T0'
$ExpectedAttemptId = 'FRD-DRIVE-AFQW-R4-T0-A0'

function Format-ElapsedMs {
    param([Parameter(Mandatory)][long]$ElapsedMs)
    if ($ElapsedMs -lt 0) { $ElapsedMs = 0 }
    $span = [TimeSpan]::FromMilliseconds($ElapsedMs)
    $hours = [int][Math]::Floor($span.TotalHours)
    return ('{0:D2}:{1:D2}:{2:D2}' -f $hours, $span.Minutes, $span.Seconds)
}

function Read-JsonFile {
    param([Parameter(Mandatory)][string]$Path)
    return (Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json)
}

if ($TaskId -ne $ExpectedTaskId) {
    throw "TASK_ID_MISMATCH: expected $ExpectedTaskId, observed $TaskId"
}
if ($AttemptId -ne $ExpectedAttemptId) {
    throw "ATTEMPT_ID_MISMATCH: expected $ExpectedAttemptId, observed $AttemptId"
}
if ($PollMilliseconds -lt 200) {
    throw 'PollMilliseconds must be at least 200.'
}

$taskStateRoot = Join-Path $WorkspaceRoot "tasks\$TaskId\$AttemptId"
$startMarker = Join-Path $taskStateRoot 'STARTED.json'
$finalReceipt = Join-Path $taskStateRoot 'FINAL.json'

Write-Host 'AFQW T0 Task Timer is observational only.'
Write-Host "Waiting for start marker: $startMarker"

while (-not (Test-Path -LiteralPath $startMarker -PathType Leaf)) {
    Start-Sleep -Milliseconds $PollMilliseconds
}

$start = Read-JsonFile -Path $startMarker
if (($start.task_id -ne $TaskId) -or ($start.attempt_id -ne $AttemptId) -or ($start.state -ne 'STARTED')) {
    throw 'START_MARKER_IDENTITY_OR_STATE_INVALID'
}

$startTicks = [long]$start.task_active_start_monotonic_ticks
$recordedFrequency = [long]$start.stopwatch_frequency
$currentFrequency = [long][Diagnostics.Stopwatch]::Frequency
if ($recordedFrequency -ne $currentFrequency) {
    throw "STOPWATCH_FREQUENCY_MISMATCH: recorded=$recordedFrequency current=$currentFrequency"
}

while ($true) {
    $terminal = $null
    if (Test-Path -LiteralPath $finalReceipt -PathType Leaf) {
        $terminal = Read-JsonFile -Path $finalReceipt
    }

    if ($null -ne $terminal) {
        $taskMs = [long]$terminal.task_active_elapsed_ms
        $workerMs = [long]$terminal.worker_active_elapsed_ms
        $phase = "TERMINAL/$($terminal.state)"
    }
    else {
        $nowTicks = [long][Diagnostics.Stopwatch]::GetTimestamp()
        if ($nowTicks -lt $startTicks) {
            throw 'MONOTONIC_CLOCK_REWIND_OR_REBOOT_DETECTED'
        }
        $taskMs = [long][Math]::Round((($nowTicks - $startTicks) * 1000.0) / $currentFrequency, 0, [MidpointRounding]::AwayFromZero)
        $workerMs = 0
        $phase = 'ACTIVE/ZERO-PROVIDER-SELFTEST'
    }

    Clear-Host
    Write-Host '======================================================================'
    Write-Host "AFQW TASK TIMER | $TaskId"
    Write-Host '======================================================================'
    Write-Host "ATTEMPT ID : $AttemptId"
    Write-Host "PHASE      : $phase"
    Write-Host "TASK ACTIVE: $(Format-ElapsedMs -ElapsedMs $taskMs)  ($taskMs ms)"
    Write-Host "WORKER ACTIVE: $(Format-ElapsedMs -ElapsedMs $workerMs)  ($workerMs ms)"
    Write-Host 'PROVIDER INTENT: 0 expected for T0'
    Write-Host 'MODE: OBSERVATIONAL / NO MUTATION AUTHORITY'
    Write-Host '======================================================================'

    if ($null -ne $terminal) {
        break
    }
    Start-Sleep -Milliseconds $PollMilliseconds
}

Write-Host ''
Write-Host 'Timer observed durable terminal receipt. No timer-side state was written.'
exit 0
