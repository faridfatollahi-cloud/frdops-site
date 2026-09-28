#requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Host.UI.RawUI.WindowTitle = 'FRD Ops Site — Governance | FRD Drive Automation | Atria ForgeLoop T1 Launcher | A0'
$ScriptRoot = 'C:\AI-Orchestrator\scripts\FRD-Drive-Automation\AFQW\T1'
$Worker = Join-Path $ScriptRoot 'FRD_AFQW_R4_T1_Worker.ps1'
$Timer = Join-Path $ScriptRoot 'FRD_AFQW_R4_T1_TaskTimer.ps1'
$StateRoot = 'C:\AI-Orchestrator\workspaces\FRD-Drive-Automation\Atria-Qualification\tasks\FRD-DRIVE-AFQW-R4-T1\FRD-DRIVE-AFQW-R4-T1-A0'
$StartMarker = Join-Path $StateRoot 'STARTED.json'
$FinalReceipt = Join-Path $StateRoot 'FINAL.json'
if (-not (Test-Path -LiteralPath $Worker -PathType Leaf)) { throw 'WORKER_SCRIPT_MISSING' }
if (-not (Test-Path -LiteralPath $Timer -PathType Leaf)) { throw 'TIMER_SCRIPT_MISSING' }
if ((Test-Path -LiteralPath $StartMarker) -or (Test-Path -LiteralPath $FinalReceipt)) {
    throw 'T1_A0_ALREADY_CONSUMED_OR_TERMINAL_NO_REPLAY'
}
$TimerProcess = Start-Process -FilePath 'pwsh' -ArgumentList @('-NoProfile','-File',$Timer) -PassThru
Start-Sleep -Milliseconds 250
$WorkerProcess = Start-Process -FilePath 'pwsh' -ArgumentList @('-NoProfile','-File',$Worker) -PassThru
[ordered]@{
    launch_result = 'PASS'
    timer_process_id = $TimerProcess.Id
    worker_process_id = $WorkerProcess.Id
} | ConvertTo-Json -Compress
exit 0
