#requires -Version 7.0
[CmdletBinding()]
param(
    [string]$TaskId = 'FRD-DRIVE-AFQW-R4-T0',
    [string]$AttemptId = 'FRD-DRIVE-AFQW-R4-T0-A0',
    [string]$WorkspaceRoot = 'C:\AI-Orchestrator\workspaces\FRD-Drive-Automation\Atria-Qualification'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Host.UI.RawUI.WindowTitle = 'FRD Ops Site — Governance | FRD Drive Automation | Atria ForgeLoop Launcher'

$ExpectedTaskId = 'FRD-DRIVE-AFQW-R4-T0'
$ExpectedAttemptId = 'FRD-DRIVE-AFQW-R4-T0-A0'
$ExpectedWorkerSha256 = 'BD7C6B55A1C3B6C629D154D7AAD25D4A171CB905A6D0682EA5809B85ABFD2C16'
$ExpectedTimerSha256 = '3F2F8193A1FBCB8ABA5590A40F8C7ECCBE6C84DB65C740107A945303034D45EC'

function Assert-FileSha256 {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$ExpectedSha256
    )
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "REQUIRED_SCRIPT_MISSING: $Path"
    }
    $actual = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
    if ($actual -ne $ExpectedSha256) {
        throw "SCRIPT_HASH_MISMATCH: $Path expected=$ExpectedSha256 actual=$actual"
    }
}

function Quote-ProcessArgument {
    param([Parameter(Mandatory)][string]$Value)
    return '"' + $Value.Replace('"', '\"') + '"'
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

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$workerScript = Join-Path $scriptRoot 'FRD_AFQW_R4_T0_Worker.ps1'
$timerScript = Join-Path $scriptRoot 'FRD_AFQW_R4_T0_TaskTimer.ps1'

Assert-FileSha256 -Path $workerScript -ExpectedSha256 $ExpectedWorkerSha256
Assert-FileSha256 -Path $timerScript -ExpectedSha256 $ExpectedTimerSha256

$taskStateRoot = Join-Path $WorkspaceRoot "tasks\$TaskId\$AttemptId"
$startMarker = Join-Path $taskStateRoot 'STARTED.json'
$finalReceipt = Join-Path $taskStateRoot 'FINAL.json'

if ((Test-Path -LiteralPath $startMarker) -or (Test-Path -LiteralPath $finalReceipt)) {
    throw "CONSUMED_IDENTITY: $AttemptId already has durable start/terminal state. Do not relaunch."
}

$timerArguments = @(
    '-NoProfile',
    '-File',
    (Quote-ProcessArgument -Value $timerScript),
    '-TaskId',
    (Quote-ProcessArgument -Value $TaskId),
    '-AttemptId',
    (Quote-ProcessArgument -Value $AttemptId)
)

$workerArguments = @(
    '-NoProfile',
    '-File',
    (Quote-ProcessArgument -Value $workerScript),
    '-TaskId',
    (Quote-ProcessArgument -Value $TaskId),
    '-AttemptId',
    (Quote-ProcessArgument -Value $AttemptId)
)

$timerProcess = Start-Process -FilePath 'pwsh.exe' -ArgumentList $timerArguments -PassThru
Start-Sleep -Milliseconds 600
$workerProcess = Start-Process -FilePath 'pwsh.exe' -ArgumentList $workerArguments -PassThru

Write-Host ''
Write-Host '======================================================================'
Write-Host "AFQW RESULT | $TaskId | T0 LAUNCHER"
Write-Host '======================================================================'
Write-Host "ATTEMPT_ID=$AttemptId"
Write-Host 'LAUNCH_RESULT=PASS'
Write-Host "WORKER_SCRIPT_SHA256=$ExpectedWorkerSha256"
Write-Host "TIMER_SCRIPT_SHA256=$ExpectedTimerSha256"
Write-Host "TIMER_PROCESS_ID=$($timerProcess.Id)"
Write-Host "WORKER_PROCESS_ID=$($workerProcess.Id)"
Write-Host 'PROVIDER_CALL_PERFORMED=False'
Write-Host 'DRIVE_API_CALL_PERFORMED=False'
Write-Host 'DOCS_API_CALL_PERFORMED=False'
Write-Host 'NOTE=Worker writes the durable T0 start marker; once written, the attempt identity is consumed.'
Write-Host '======================================================================'
