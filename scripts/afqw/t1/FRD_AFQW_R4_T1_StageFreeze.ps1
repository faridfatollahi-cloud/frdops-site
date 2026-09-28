#requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$Host.UI.RawUI.WindowTitle = 'FRD Ops Site — Governance | FRD Drive Automation | Atria ForgeLoop T1 Stage + Freeze'
$SourceCommit = '7f07056d16be2c13aa34108720bd7b868dc70a6b'
$Root = 'C:\AI-Orchestrator\scripts\FRD-Drive-Automation\AFQW\T1'
$Base = "https://raw.githubusercontent.com/faridfatollahi-cloud/frdops-site/$SourceCommit/scripts/afqw/t1"
$Files = @(
    'FRD_AFQW_R4_T1_Worker.ps1',
    'FRD_AFQW_R4_T1_TaskTimer.ps1',
    'FRD_AFQW_R4_T1_Launch.ps1',
    'FRD_AFQW_R4_T1_Run.ps1',
    'FRD_AFQW_R4_T1_Freeze.ps1'
)
[IO.Directory]::CreateDirectory($Root) | Out-Null
foreach ($Name in $Files) {
    $Destination = Join-Path $Root $Name
    Invoke-WebRequest -Uri "$Base/$Name" -OutFile $Destination
}
$Freeze = Join-Path $Root 'FRD_AFQW_R4_T1_Freeze.ps1'
& pwsh -NoProfile -File $Freeze
exit $LASTEXITCODE
