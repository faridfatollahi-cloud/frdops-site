#requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Host.UI.RawUI.WindowTitle = 'FRD Ops Site — Governance | FRD Drive Automation | AFQW T3 Source Recovery'

$Targets = [ordered]@{
    'PDA-R4-A2' = 'A7283E4C775989D7F1AAD1FE90B1733796A78CE3D81335D84FAC038FF7D0B26C'
    'PDA-R4-A1' = '12EEE3C68B9C80502BD48CA44B68C96188188E2D0B5C28'
    'PDA-R4-A0' = 'A59D855C086C6E3FA71BE553F5618F3E765DEBCA06AB7ADAFC9738922772A790'
    'PDA-R3-A1' = '3CFAE9EA6B10F96270824431600F125778EEAFC154B02FEC61E5497D25DE9E79'
}

# Correct the A1 target in one place so an accidental typo cannot broaden matching.
$Targets['PDA-R4-A1'] = '12EEE3C68B9C80502BD48CA44B68C9618814D256E70452019188188E2D0B5C28'

$Roots = @(
    'C:\AI-Orchestrator\scripts',
    'C:\AI-Orchestrator\bootstrap\FRD-Drive-Automation\scripts',
    'C:\AI-Orchestrator\Private\WIOS\FRD-Drive-Qualification',
    'C:\AI-Orchestrator\workspaces\FRD-Drive-Automation'
)

$Seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
$Matches = [System.Collections.Generic.List[object]]::new()
$Scanned = 0

foreach ($Root in $Roots) {
    if (-not (Test-Path -LiteralPath $Root -PathType Container)) { continue }
    foreach ($File in Get-ChildItem -LiteralPath $Root -File -Recurse -Filter '*.ps1' -ErrorAction SilentlyContinue) {
        if (-not $Seen.Add($File.FullName)) { continue }
        $Scanned++
        try {
            $Hash = (Get-FileHash -LiteralPath $File.FullName -Algorithm SHA256 -ErrorAction Stop).Hash
        }
        catch {
            continue
        }
        foreach ($Entry in $Targets.GetEnumerator()) {
            if ($Hash -eq $Entry.Value) {
                $Tokens = $null
                $Errors = $null
                [System.Management.Automation.Language.Parser]::ParseFile($File.FullName,[ref]$Tokens,[ref]$Errors) | Out-Null
                $Matches.Add([pscustomobject]@{
                    Identity = $Entry.Key
                    Path = $File.FullName
                    Sha256 = $Hash
                    ParserErrorCount = $Errors.Count
                })
            }
        }
    }
}

Write-Host '======================================================================'
Write-Host 'AFQW RESULT | FRD-DRIVE-AFQW-R4-T3 | SOURCE RECOVERY'
Write-Host '======================================================================'
Write-Host "SOURCE_RECOVERY_SCRIPT_SHA256=$((Get-FileHash -LiteralPath $PSCommandPath -Algorithm SHA256).Hash)"
Write-Host "PS1_FILES_SCANNED=$Scanned"
foreach ($Entry in $Targets.GetEnumerator()) {
    $Found = @($Matches | Where-Object Identity -eq $Entry.Key)
    Write-Host "IDENTITY=$($Entry.Key)"
    Write-Host "EXPECTED_SHA256=$($Entry.Value)"
    Write-Host "MATCH_COUNT=$($Found.Count)"
    foreach ($M in $Found) {
        Write-Host "PATH=$($M.Path)"
        Write-Host "SHA256=$($M.Sha256)"
        Write-Host "PARSER_ERROR_COUNT=$($M.ParserErrorCount)"
    }
    Write-Host '----------------------------------------------------------------------'
}
Write-Host 'PROVIDER_CALL_PERFORMED=False'
Write-Host 'GOOGLE_API_CALL_PERFORMED=False'
Write-Host 'CREDENTIAL_DECRYPTION_PERFORMED=False'
Write-Host 'MAIN_T3_EXECUTION_PERFORMED=False'
Write-Host 'RECOVERED_SCRIPT_EXECUTION_PERFORMED=False'
Write-Host '======================================================================'
