#requires -Version 7.0
[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Host.UI.RawUI.WindowTitle = 'FRD Ops Site — Governance | FRD Drive Automation | Atria ForgeLoop T0 Freeze Gate'

$TaskId = 'FRD-DRIVE-AFQW-R4-T0'
$AttemptId = 'FRD-DRIVE-AFQW-R4-T0-A0'
$ExpectedHashes = [ordered]@{
    'FRD_AFQW_R4_T0_Worker.ps1' = 'BD7C6B55A1C3B6C629D154D7AAD25D4A171CB905A6D0682EA5809B85ABFD2C16'
    'FRD_AFQW_R4_T0_TaskTimer.ps1' = '3F2F8193A1FBCB8ABA5590A40F8C7ECCBE6C84DB65C740107A945303034D45EC'
    'FRD_AFQW_R4_T0_Launch.ps1' = '9A70505AEFCB038F13FC1E3FC21524127E0D1A159D7DB354972783C7AC65C17C'
}

function Get-ParserErrorCount {
    param([Parameter(Mandatory)][string]$Path)
    $tokens = $null
    $errors = $null
    [System.Management.Automation.Language.Parser]::ParseFile(
        $Path,
        [ref]$tokens,
        [ref]$errors
    ) | Out-Null
    return [int]$errors.Count
}

function Assert-NoForbiddenNetworkSurface {
    param([Parameter(Mandatory)][string]$Path)
    $text = [System.IO.File]::ReadAllText($Path)
    $forbidden = @(
        'Invoke-WebRequest',
        'Invoke-RestMethod',
        'System.Net.Http',
        'HttpClient',
        'drive.googleapis.com',
        'docs.googleapis.com',
        'generativelanguage.googleapis.com'
    )
    foreach ($needle in $forbidden) {
        if ($text.IndexOf($needle, [System.StringComparison]::OrdinalIgnoreCase) -ge 0) {
            throw "FORBIDDEN_NETWORK_SURFACE: file=$Path token=$needle"
        }
    }
}

try {
    if ($PSVersionTable.PSVersion.Major -lt 7) {
        throw 'PowerShell 7 or newer is required.'
    }

    $scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
    $files = @()

    foreach ($name in $ExpectedHashes.Keys) {
        $path = Join-Path $scriptRoot $name
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
            throw "REQUIRED_SCRIPT_MISSING: $path"
        }

        $parserErrors = Get-ParserErrorCount -Path $path
        if ($parserErrors -ne 0) {
            throw "PARSER_GATE_FAILED: file=$name errors=$parserErrors"
        }

        $actualHash = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash
        $expectedHash = [string]$ExpectedHashes[$name]
        if ($actualHash -ne $expectedHash) {
            throw "SCRIPT_HASH_MISMATCH: file=$name expected=$expectedHash actual=$actualHash"
        }

        Assert-NoForbiddenNetworkSurface -Path $path

        $files += [ordered]@{
            file = $name
            parser_error_count = $parserErrors
            sha256 = $actualHash
            network_surface_scan = 'PASS'
        }
    }

    $selfParserErrors = Get-ParserErrorCount -Path $MyInvocation.MyCommand.Path
    if ($selfParserErrors -ne 0) {
        throw "FREEZE_SCRIPT_PARSER_GATE_FAILED: errors=$selfParserErrors"
    }

    Write-Host ''
    Write-Host '======================================================================'
    Write-Host "AFQW RESULT | $TaskId | T0 FREEZE GATE"
    Write-Host '======================================================================'
    Write-Host "ATTEMPT_ID=$AttemptId"
    Write-Host 'AFQW_T0_FREEZE_RESULT=PASS'
    foreach ($entry in $files) {
        Write-Host "FILE=$($entry.file) | PARSER_ERROR_COUNT=$($entry.parser_error_count) | SHA256=$($entry.sha256) | NETWORK_SURFACE_SCAN=$($entry.network_surface_scan)"
    }
    Write-Host "FREEZE_SCRIPT_PARSER_ERROR_COUNT=$selfParserErrors"
    Write-Host 'PROVIDER_CALL_PERFORMED=False'
    Write-Host 'DRIVE_API_CALL_PERFORMED=False'
    Write-Host 'DOCS_API_CALL_PERFORMED=False'
    Write-Host 'CREDENTIAL_DECRYPTION_PERFORMED=False'
    Write-Host 'MAIN_EXECUTION_PERFORMED=False'
    Write-Host '======================================================================'
    exit 0
}
catch {
    Write-Host ''
    Write-Host '======================================================================'
    Write-Host "AFQW RESULT | $TaskId | T0 FREEZE GATE"
    Write-Host '======================================================================'
    Write-Host "ATTEMPT_ID=$AttemptId"
    Write-Host 'AFQW_T0_FREEZE_RESULT=FAIL'
    Write-Host "ERROR_TYPE=$($_.Exception.GetType().FullName)"
    Write-Host "ERROR_MESSAGE=$($_.Exception.Message)"
    Write-Host 'PROVIDER_CALL_PERFORMED=False'
    Write-Host 'DRIVE_API_CALL_PERFORMED=False'
    Write-Host 'DOCS_API_CALL_PERFORMED=False'
    Write-Host 'CREDENTIAL_DECRYPTION_PERFORMED=False'
    Write-Host 'MAIN_EXECUTION_PERFORMED=False'
    Write-Host '======================================================================'
    exit 1
}
