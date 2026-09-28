#requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$Host.UI.RawUI.WindowTitle = 'FRD Ops Site — Governance | FRD Drive Automation | Atria ForgeLoop T2 R3 Bridge Seal'

$SourceCommit = 'ebbc552ee74b0daa97065a521b9076cad2c39d87'
$Root = 'C:\AI-Orchestrator\scripts\FRD-Drive-Automation\AFQW\T2'
$Base = "https://raw.githubusercontent.com/faridfatollahi-cloud/frdops-site/$SourceCommit/scripts/afqw/t2"
$Worker = Join-Path $Root 'FRD_AFQW_R4_T2_Worker.ps1'
$Freeze = Join-Path $Root 'FRD_AFQW_R4_T2_Freeze.ps1'
$StateRoot = 'C:\AI-Orchestrator\workspaces\FRD-Drive-Automation\Atria-Qualification\tasks\FRD-DRIVE-AFQW-R4-T2\FRD-DRIVE-AFQW-R4-T2-A0'
$StartMarker = Join-Path $StateRoot 'STARTED.json'
$FinalReceipt = Join-Path $StateRoot 'FINAL.json'

if ((Test-Path -LiteralPath $StartMarker) -or (Test-Path -LiteralPath $FinalReceipt)) {
    throw 'T2_A0_ALREADY_CONSUMED_OR_TERMINAL_NO_REPLAY'
}

[IO.Directory]::CreateDirectory($Root) | Out-Null
Invoke-WebRequest -Uri "$Base/FRD_AFQW_R4_T2_Worker.ps1" -OutFile $Worker
Invoke-WebRequest -Uri "$Base/FRD_AFQW_R4_T2_Freeze.ps1" -OutFile $Freeze

$freezeOutput = @(& pwsh -NoProfile -File $Freeze 2>&1)
$freezeExit = $LASTEXITCODE
$freezeOutput | ForEach-Object { Write-Host $_ }
if ($freezeExit -ne 0 -or -not (($freezeOutput -join "`n") -match 'AFQW_T2_FREEZE_RESULT=PASS')) {
    Write-Host 'T2_CONDITIONAL_MAIN_EXECUTION=NOT_AUTHORIZED_BY_FREEZE'
    exit 10
}

Write-Host ''
Write-Host 'T2_CONDITIONAL_MAIN_EXECUTION=AUTHORIZED_BY_FREEZE_PASS'
Write-Host 'T2_A0_REPLAY_RULE=ONCE_STARTED_DO_NOT_RERUN'
Write-Host ''

& pwsh -NoProfile -File $Worker
exit $LASTEXITCODE
