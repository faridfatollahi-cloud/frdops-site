#requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Host.UI.RawUI.WindowTitle = 'FRD Ops Site — Governance | FRD Drive Automation | AFQW T3 A1 Feature Map'

$Path = 'C:\AI-Orchestrator\bootstrap\FRD-Drive-Automation\scripts\PDA_R4_CORE_DRIVE_DOCS_CAS_A1.ps1'
$ExpectedSha = '12EEE3C68B9C80502BD48CA44B68C9618814D256E70452019188188E2D0B5C28'

if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { throw 'A1_SOURCE_MISSING' }
$ActualSha = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
if ($ActualSha -ne $ExpectedSha) { throw "A1_SOURCE_HASH_MISMATCH=$ActualSha" }

$Tokens = $null
$Errors = $null
$Ast = [System.Management.Automation.Language.Parser]::ParseFile($Path,[ref]$Tokens,[ref]$Errors)
$Text = [IO.File]::ReadAllText($Path)
$Lines = [IO.File]::ReadAllLines($Path)

function Count-Pattern([string]$Pattern) {
    return ([regex]::Matches($Text,$Pattern,[Text.RegularExpressions.RegexOptions]::IgnoreCase)).Count
}

function Line-Numbers([string]$Pattern) {
    $out = [System.Collections.Generic.List[int]]::new()
    for ($i=0; $i -lt $Lines.Length; $i++) {
        if ($Lines[$i] -match $Pattern) { [void]$out.Add($i+1) }
    }
    return @($out)
}

$FunctionNames = @(
    $Ast.FindAll({ param($n) $n -is [System.Management.Automation.Language.FunctionDefinitionAst] },$true) |
    ForEach-Object { $_.Name } |
    Sort-Object -Unique
)

$UrlLiterals = @(
    [regex]::Matches($Text,'https://[^''"\s)]+') |
    ForEach-Object { $_.Value.TrimEnd(',', ';') } |
    Where-Object { $_ -match '(?i)googleapis\.com|google\.com' } |
    Sort-Object -Unique
)

$Patterns = [ordered]@{
    STATUS_CODE_VARIABLE = '-StatusCodeVariable'
    SKIP_HTTP_ERROR_CHECK = '-SkipHttpErrorCheck'
    REQUIRED_REVISION_ID = 'requiredRevisionId'
    BATCH_UPDATE = 'batchUpdate'
    DOCS_REVISION_ID = 'revisionId'
    DRIVE_REVISIONS = '/revisions|revisions\?'
    KEEP_FOREVER = 'keepForever'
    ALT_MEDIA = 'alt=media'
    DRIVE_EXPORT = '/export|files/.+export'
    UPLOAD_TYPE = 'uploadType'
    MULTIPART_UPLOAD = 'multipart/related|upload/drive/v3/files'
    FILES_CREATE = 'drive/v3/files'
    DOCS_API = 'docs.googleapis.com'
    DRIVE_API = 'www.googleapis.com/drive|googleapis.com/upload/drive'
    DELETE_HTTP_METHOD = '(?i)(-Method\s+Delete|HttpMethod]::Delete|"DELETE"|''DELETE'')'
    REMOVE_ITEM = 'Remove-Item'
    STALE_MARKER = '(?i)stale'
    PARENT = '(?i)parents'
    SHA256 = '(?i)SHA256|Get-FileHash|ComputeHash'
}

Write-Host '======================================================================'
Write-Host 'AFQW RESULT | FRD-DRIVE-AFQW-R4-T3 | A1 FEATURE MAP'
Write-Host '======================================================================'
Write-Host "A1_SOURCE_SHA256=$ActualSha"
Write-Host "PARSER_ERROR_COUNT=$($Errors.Count)"
Write-Host "LINE_COUNT=$($Lines.Length)"
Write-Host "FUNCTIONS=$($FunctionNames -join ',')"
Write-Host "GOOGLE_URL_LITERALS=$($UrlLiterals -join ' ; ')"
Write-Host '----------------------------------------------------------------------'
foreach ($Entry in $Patterns.GetEnumerator()) {
    $count = Count-Pattern $Entry.Value
    $ln = @(Line-Numbers $Entry.Value)
    Write-Host "$($Entry.Key)_COUNT=$count"
    Write-Host "$($Entry.Key)_LINES=$($ln -join ',')"
}
Write-Host '----------------------------------------------------------------------'
Write-Host 'PROVIDER_CALL_PERFORMED=False'
Write-Host 'GOOGLE_API_CALL_PERFORMED=False'
Write-Host 'CREDENTIAL_DECRYPTION_PERFORMED=False'
Write-Host 'SOURCE_MUTATION_PERFORMED=False'
Write-Host 'MAIN_T3_EXECUTION_PERFORMED=False'
Write-Host '======================================================================'
