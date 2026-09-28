#requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Host.UI.RawUI.WindowTitle = 'FRD Ops Site — Governance | FRD Drive Automation | Atria ForgeLoop T1 Task Timer | A0'
$StateRoot = 'C:\AI-Orchestrator\workspaces\FRD-Drive-Automation\Atria-Qualification\tasks\FRD-DRIVE-AFQW-R4-T1\FRD-DRIVE-AFQW-R4-T1-A0'
$StartMarker = Join-Path $StateRoot 'STARTED.json'
$FinalReceipt = Join-Path $StateRoot 'FINAL.json'
$Deadline = [DateTime]::UtcNow.AddMinutes(10)
$StartedUtc = $null
function Format-Elapsed {
    param([Parameter(Mandatory)][TimeSpan]$Elapsed)
    $hours = [int][Math]::Floor($Elapsed.TotalHours)
    return ('{0:D2}:{1:D2}:{2:D2}' -f $hours, $Elapsed.Minutes, $Elapsed.Seconds)
}
while ([DateTime]::UtcNow -lt $Deadline) {
    if (Test-Path -LiteralPath $FinalReceipt -PathType Leaf) {
        $final = Get-Content -LiteralPath $FinalReceipt -Raw | ConvertFrom-Json
        Clear-Host
        Write-Host 'FRD Ops Site — Governance | FRD Drive Automation'
        Write-Host 'AFQW T1 — Atria Dispatch Seal'
        Write-Host ''
        Write-Host ('STATE          : ' + $final.state)
        Write-Host ('TASK ACTIVE    : ' + $final.task_active_elapsed_hhmmss)
        Write-Host ('WORKER ACTIVE  : ' + $final.worker_active_elapsed_hhmmss)
        Write-Host ('PROVIDER CALLS : ' + $final.provider_call_count)
        Start-Sleep -Seconds 2
        exit 0
    }
    if (($null -eq $StartedUtc) -and (Test-Path -LiteralPath $StartMarker -PathType Leaf)) {
        $started = Get-Content -LiteralPath $StartMarker -Raw | ConvertFrom-Json
        $StartedUtc = [DateTime]::Parse([string]$started.task_active_start_utc).ToUniversalTime()
    }
    Clear-Host
    Write-Host 'FRD Ops Site — Governance | FRD Drive Automation'
    Write-Host 'AFQW T1 — Atria Dispatch Seal'
    Write-Host ''
    if ($null -eq $StartedUtc) {
        Write-Host 'STATE          : WAITING FOR WORKER START'
        Write-Host 'TASK ACTIVE    : --:--:--'
        Write-Host 'WORKER ACTIVE  : durable provider lifecycle receipt controls'
    } else {
        Write-Host 'STATE          : ACTIVE'
        Write-Host ('TASK ACTIVE    : ' + (Format-Elapsed -Elapsed ([DateTime]::UtcNow - $StartedUtc)))
        Write-Host 'WORKER ACTIVE  : durable provider lifecycle receipt controls'
    }
    Start-Sleep -Milliseconds 500
}
Clear-Host
Write-Host 'AFQW T1 TIMER DEADLINE REACHED'
exit 2
