#requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Host.UI.RawUI.WindowTitle = 'FRD Ops Site — Governance | FRD Drive Automation | AFQW T3 Build + Freeze'

$SourcePath = 'C:\AI-Orchestrator\bootstrap\FRD-Drive-Automation\scripts\PDA_R4_CORE_DRIVE_DOCS_CAS_A1.ps1'
$ExpectedSourceSha = '12EEE3C68B9C80502BD48CA44B68C9618814D256E70452019188188E2D0B5C28'
$ExpectedA2ReferenceSha = 'A7283E4C775989D7F1AAD1FE90B1733796A78CE3D81335D84FAC038FF7D0B26C'
$PrivateSourceRoot = 'C:\AI-Orchestrator\Private\WIOS\FRD-Drive-Qualification\runtime-source\FRD-DRIVE-AFQW-R4-T3'
$WorkerPath = Join-Path $PrivateSourceRoot 'FRD_AFQW_R4_T3_A0_Worker.ps1'

function Replace-ExactOnce {
    param([string]$Text,[string]$Old,[string]$New,[string]$Label)
    $count = ([regex]::Matches($Text,[regex]::Escape($Old))).Count
    if ($count -ne 1) { throw "TRANSFORM_ANCHOR_$Label`_COUNT=$count" }
    return $Text.Replace($Old,$New)
}

if (-not (Test-Path -LiteralPath $SourcePath -PathType Leaf)) { throw 'A1_SOURCE_MISSING' }
$SourceSha = (Get-FileHash -LiteralPath $SourcePath -Algorithm SHA256).Hash
if ($SourceSha -ne $ExpectedSourceSha) { throw "A1_SOURCE_HASH_MISMATCH=$SourceSha" }
$text = [IO.File]::ReadAllText($SourcePath)

# Fresh task identity. Prior-A1 continuity is inserted later and is not rewritten.
$text = $text.Replace('PDA-R4-A1','FRD-DRIVE-AFQW-R4-T3-A0')

$oldPaths = @'
$PriorA0MarkerFile  = Join-Path $ReceiptDir 'PDA-R4-A0.started.json'
$PriorA0ReceiptFile = Join-Path $ReceiptDir 'PDA-R4-A0.json'

$AttemptMarkerFile = Join-Path $ReceiptDir 'FRD-DRIVE-AFQW-R4-T3-A0.started.json'
$ReceiptFile       = Join-Path $ReceiptDir 'FRD-DRIVE-AFQW-R4-T3-A0.json'
$BlobDownloadTemp  = Join-Path $ReceiptDir 'FRD-DRIVE-AFQW-R4-T3-A0-blob-readback.tmp'
'@
$newPaths = @'
$PriorA0MarkerFile  = Join-Path $ReceiptDir 'PDA-R4-A0.started.json'
$PriorA0ReceiptFile = Join-Path $ReceiptDir 'PDA-R4-A0.json'
$PriorA1MarkerFile  = Join-Path $ReceiptDir 'PDA-R4-A1.started.json'
$PriorA1ReceiptFile = Join-Path $ReceiptDir 'PDA-R4-A1.json'

$TaskId = 'FRD-DRIVE-AFQW-R4-T3'
$PrivateRoot = 'C:\AI-Orchestrator\Private\WIOS\FRD-Drive-Qualification\runtime\FRD-DRIVE-AFQW-R4-T3\FRD-DRIVE-AFQW-R4-T3-A0'
$StateRoot = 'C:\AI-Orchestrator\workspaces\FRD-Drive-Automation\Atria-Qualification\tasks\FRD-DRIVE-AFQW-R4-T3\FRD-DRIVE-AFQW-R4-T3-A0'
$EvidenceRoot = 'C:\AI-Orchestrator\Governance Files\FRD-Drive-Automation\Atria-Qualification\tasks\FRD-DRIVE-AFQW-R4-T3\FRD-DRIVE-AFQW-R4-T3-A0'
$IntentDir = Join-Path $PrivateRoot 'mutation-intents'
$CounterLedger = Join-Path $PrivateRoot 'COUNTERS.private.json'
$AmbiguityMarker = Join-Path $PrivateRoot 'AMBIGUITY.private.json'
$AttemptMarkerFile = Join-Path $StateRoot 'STARTED.json'
$ReceiptFile = Join-Path $PrivateRoot 'FINAL.private.json'
$SanitizedReceiptFile = Join-Path $EvidenceRoot 'RESULT.sanitized.json'
$FinalStateFile = Join-Path $StateRoot 'FINAL.json'
$BlobDownloadTemp = Join-Path $PrivateRoot 'blob-v1-current.tmp'
$BlobV2DownloadTemp = Join-Path $PrivateRoot 'blob-v2-current.tmp'
$BlobV1RevisionTemp = Join-Path $PrivateRoot 'blob-v1-revision.tmp'
$DocExportTemp = Join-Path $PrivateRoot 'doc-export.txt'
$T2BindingFile = 'C:\AI-Orchestrator\Governance Files\FRD-Drive-Automation\Atria-Qualification\tasks\FRD-DRIVE-AFQW-R4-T2\FRD-DRIVE-AFQW-R4-T2-A1\R3_BINDING_DISCOVERY_A1.sanitized.json'
$T2FinalFile = 'C:\AI-Orchestrator\workspaces\FRD-Drive-Automation\Atria-Qualification\tasks\FRD-DRIVE-AFQW-R4-T2\FRD-DRIVE-AFQW-R4-T2-A1\FINAL.json'
'@
$text = Replace-ExactOnce $text $oldPaths $newPaths 'PATHS'

$oldHashes = "$ExpectedAuthJsonSha256    = '88C2C2DE34257CCECE9E944E084B81AB0E14DE76DA4D2957C781F674BC386EAF'"
$newHashes = @'
$ExpectedAuthJsonSha256    = '88C2C2DE34257CCECE9E944E084B81AB0E14DE76DA4D2957C781F674BC386EAF'
$ExpectedT2BindingSha256   = '8F7F948D33B6E62FB8DB81E9D74878ECAB023BA1540876103ED99FDF40DD8314'
$ExpectedT2FinalSha256     = '8719D25C96E3A82E0DCCFEC011554FD042734E2BF2569BB930A28F0B20D99836'
$EngineeringSourceA1Sha256 = '12EEE3C68B9C80502BD48CA44B68C9618814D256E70452019188188E2D0B5C28'
$EngineeringReferenceA2Sha256 = 'A7283E4C775989D7F1AAD1FE90B1733796A78CE3D81335D84FAC038FF7D0B26C'
$MaxOAuthRefreshCalls = 1
$MaxDriveApiCalls = 20
$MaxDocsApiCalls = 14
$MaxMutationIntents = 9
$OAuthRefreshCallCount = 0
$DriveApiCallCount = 0
$DocsApiCallCount = 0
$MutationIntentCount = 0
'@
$text = Replace-ExactOnce $text $oldHashes $newHashes 'HASHES_BUDGETS'

$oldMk = 'New-Item -ItemType Directory -Force -Path $ReceiptDir | Out-Null'
$newMk = @'
New-Item -ItemType Directory -Force -Path $ReceiptDir | Out-Null
New-Item -ItemType Directory -Force -Path $PrivateRoot | Out-Null
New-Item -ItemType Directory -Force -Path $StateRoot | Out-Null
New-Item -ItemType Directory -Force -Path $EvidenceRoot | Out-Null
New-Item -ItemType Directory -Force -Path $IntentDir | Out-Null
'@
$text = Replace-ExactOnce $text $oldMk $newMk 'DIRECTORIES'

$oldTemp = @'
if (Test-Path -LiteralPath $BlobDownloadTemp) {
    throw 'Unexpected prior blob-readback temp file exists. Reconcile before proceeding.'
}
'@
$newTemp = @'
foreach ($TempPath in @($BlobDownloadTemp,$BlobV2DownloadTemp,$BlobV1RevisionTemp,$DocExportTemp,$CounterLedger,$AmbiguityMarker,$SanitizedReceiptFile,$FinalStateFile)) {
    if (Test-Path -LiteralPath $TempPath) {
        throw "Unexpected prior T3 runtime artifact exists: $TempPath"
    }
}
'@
$text = Replace-ExactOnce $text $oldTemp $newTemp 'TEMP_PREFLIGHT'

$oldA0Check = @'
if ([string]$PriorA0Marker.script_sha256 -ne 'A59D855C086C6E3FA71BE553F5618F3E765DEBCA06AB7ADAFC9738922772A790') {
    throw 'Consumed PDA-R4-A0 start-marker script hash mismatch.'
}
'@
$newA0Check = @'
if ([string]$PriorA0Marker.script_sha256 -ne 'A59D855C086C6E3FA71BE553F5618F3E765DEBCA06AB7ADAFC9738922772A790') {
    throw 'Consumed PDA-R4-A0 start-marker script hash mismatch.'
}

if (-not (Test-Path -LiteralPath $PriorA1MarkerFile -PathType Leaf)) {
    throw 'Consumed PDA-R4-A1 start marker is missing. Fail closed.'
}
if (Test-Path -LiteralPath $PriorA1ReceiptFile -PathType Leaf) {
    throw 'Unexpected PDA-R4-A1 final receipt exists. Reconcile before proceeding.'
}
$PriorA1Marker = Get-Content -LiteralPath $PriorA1MarkerFile -Raw | ConvertFrom-Json
if ([string]$PriorA1Marker.attempt_id -ne 'PDA-R4-A1') { throw 'Consumed PDA-R4-A1 start-marker identity mismatch.' }
if ([string]$PriorA1Marker.state -ne 'STARTED') { throw 'Consumed PDA-R4-A1 start-marker state mismatch.' }
if ([string]$PriorA1Marker.script_sha256 -ne '12EEE3C68B9C80502BD48CA44B68C9618814D256E70452019188188E2D0B5C28') {
    throw 'Consumed PDA-R4-A1 start-marker script hash mismatch.'
}
'@
$text = Replace-ExactOnce $text $oldA0Check $newA0Check 'A1_CONTINUITY'

$oldR3End = @'
if ([bool]$R3Receipt.refresh_token_exposed) {
    throw 'R3 receipt indicates refresh-token exposure.'
}
'@
$newR3End = @'
if ([bool]$R3Receipt.refresh_token_exposed) {
    throw 'R3 receipt indicates refresh-token exposure.'
}
if (-not (Test-Path -LiteralPath $T2BindingFile -PathType Leaf)) { throw 'Accepted T2 binding receipt missing.' }
if (-not (Test-Path -LiteralPath $T2FinalFile -PathType Leaf)) { throw 'Accepted T2 final receipt missing.' }
if ((Get-FileHash -LiteralPath $T2BindingFile -Algorithm SHA256).Hash -ne $ExpectedT2BindingSha256) { throw 'T2 binding receipt hash mismatch.' }
if ((Get-FileHash -LiteralPath $T2FinalFile -Algorithm SHA256).Hash -ne $ExpectedT2FinalSha256) { throw 'T2 final receipt hash mismatch.' }
$T2Binding = Get-Content -LiteralPath $T2BindingFile -Raw | ConvertFrom-Json
if ([string]$T2Binding.result -ne 'PASS') { throw 'T2 binding does not record PASS.' }
if (-not [bool]$T2Binding.scope_exact_drive_file) { throw 'T2 scope seal is not exact drive.file.' }
if (-not [bool]$T2Binding.token_uri_exact_google_oauth2) { throw 'T2 token endpoint seal mismatch.' }
'@
$text = Replace-ExactOnce $text $oldR3End $newR3End 'T2_CONTINUITY'

$oldToken = @'
if ([string]::IsNullOrWhiteSpace([string]$Credential.token_uri)) {
    throw 'Decrypted credential token_uri is missing.'
}
'@
$newToken = @'
if ([string]::IsNullOrWhiteSpace([string]$Credential.token_uri)) {
    throw 'Decrypted credential token_uri is missing.'
}
if ([string]$Credential.token_uri -ne 'https://oauth2.googleapis.com/token') {
    throw 'Decrypted credential token_uri does not match sealed Google OAuth2 endpoint.'
}
'@
$text = Replace-ExactOnce $text $oldToken $newToken 'TOKEN_URI'

# Route all network I/O through deterministic counters / mutation-intent fencing.
$text = $text.Replace('Invoke-RestMethod','Invoke-AFQWRestMethod')
$text = $text.Replace('Invoke-WebRequest','Invoke-AFQWWebRequest')

$networkHelpers = @'
function Write-AFQWCounterLedger {
    $ledger = [ordered]@{
        oauth_refresh_calls = $script:OAuthRefreshCallCount
        drive_api_calls = $script:DriveApiCallCount
        docs_api_calls = $script:DocsApiCallCount
        mutation_intents = $script:MutationIntentCount
        max_oauth_refresh_calls = $MaxOAuthRefreshCalls
        max_drive_api_calls = $MaxDriveApiCalls
        max_docs_api_calls = $MaxDocsApiCalls
        max_mutation_intents = $MaxMutationIntents
    }
    [IO.File]::WriteAllText($CounterLedger,($ledger | ConvertTo-Json -Depth 5),[Text.UTF8Encoding]::new($false))
}

function Get-AFQWBodySha256 {
    param([object]$Body)
    if ($null -eq $Body) { return $null }
    if ($Body -is [byte[]]) { return Get-BytesSha256 -Bytes $Body }
    $serialized = if ($Body -is [string]) { [string]$Body } else { $Body | ConvertTo-Json -Depth 30 -Compress }
    return Get-StringSha256 -Value $serialized
}

function Write-AFQWMutationIntent {
    param([string]$Method,[string]$Uri,[object]$Body)
    $script:MutationIntentCount++
    if ($script:MutationIntentCount -gt $MaxMutationIntents) { throw 'T3_MUTATION_INTENT_BUDGET_EXHAUSTED' }
    $intent = [ordered]@{
        schema_version = 1
        task_id = $TaskId
        attempt_id = $AttemptId
        sequence = $script:MutationIntentCount
        method = $Method
        uri = $Uri
        body_sha256 = Get-AFQWBodySha256 -Body $Body
        intent_utc = [DateTime]::UtcNow.ToString('o')
        uncertainty_boundary = 'NO_SAME_SEMANTIC_REPLAY_AFTER_SEND'
    }
    $intentPath = Join-Path $IntentDir ('{0:D2}.json' -f $script:MutationIntentCount)
    if (Test-Path -LiteralPath $intentPath) { throw 'T3_MUTATION_INTENT_IDENTITY_COLLISION' }
    [IO.File]::WriteAllText($intentPath,($intent | ConvertTo-Json -Depth 8),[Text.UTF8Encoding]::new($false))
    Write-AFQWCounterLedger
}

function Write-AFQWAmbiguity {
    param([string]$Method,[string]$Uri)
    $item = [ordered]@{ task_id=$TaskId; attempt_id=$AttemptId; method=$Method; uri=$Uri; state='UNKNOWN'; observed_utc=[DateTime]::UtcNow.ToString('o') }
    [IO.File]::WriteAllText($AmbiguityMarker,($item | ConvertTo-Json -Depth 5),[Text.UTF8Encoding]::new($false))
}

function Register-AFQWCall {
    param([string]$Method,[string]$Uri,[object]$Body)
    $isDrive = $Uri -match '^https://(www\.googleapis\.com/(upload/)?drive/|www\.googleapis\.com/drive/)'
    $isDocs = $Uri -match '^https://docs\.googleapis\.com/'
    $isOAuth = $Uri -eq 'https://oauth2.googleapis.com/token'
    if ($isDrive) {
        $script:DriveApiCallCount++
        if ($script:DriveApiCallCount -gt $MaxDriveApiCalls) { throw 'T3_DRIVE_API_BUDGET_EXHAUSTED' }
    }
    if ($isDocs) {
        $script:DocsApiCallCount++
        if ($script:DocsApiCallCount -gt $MaxDocsApiCalls) { throw 'T3_DOCS_API_BUDGET_EXHAUSTED' }
    }
    if ($isOAuth) {
        $script:OAuthRefreshCallCount++
        if ($script:OAuthRefreshCallCount -gt $MaxOAuthRefreshCalls) { throw 'T3_OAUTH_REFRESH_BUDGET_EXHAUSTED' }
    }
    $isMutation = (($isDrive -or $isDocs) -and $Method -in @('POST','PATCH','DELETE'))
    if ($isMutation) { Write-AFQWMutationIntent -Method $Method -Uri $Uri -Body $Body }
    Write-AFQWCounterLedger
    return $isMutation
}

function Get-AFQWHttpStatusFromError {
    param($ErrorRecord)
    try {
        if ($ErrorRecord.Exception.Response -and $ErrorRecord.Exception.Response.StatusCode) { return [int]$ErrorRecord.Exception.Response.StatusCode }
    } catch {}
    return $null
}

function Invoke-AFQWRestMethod {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Method,[Parameter(Mandatory)][string]$Uri,[hashtable]$Headers,[string]$ContentType,[object]$Body)
    $methodUpper = $Method.ToUpperInvariant()
    $isMutation = Register-AFQWCall -Method $methodUpper -Uri $Uri -Body $Body
    $p = @{ Method=$methodUpper; Uri=$Uri }
    if ($PSBoundParameters.ContainsKey('Headers')) { $p.Headers=$Headers }
    if ($PSBoundParameters.ContainsKey('ContentType')) { $p.ContentType=$ContentType }
    if ($PSBoundParameters.ContainsKey('Body')) { $p.Body=$Body }
    try { return Microsoft.PowerShell.Utility\Invoke-RestMethod @p }
    catch {
        $status = Get-AFQWHttpStatusFromError -ErrorRecord $_
        if ($isMutation -and $null -eq $status) { Write-AFQWAmbiguity -Method $methodUpper -Uri $Uri }
        throw
    }
}

function Invoke-AFQWWebRequest {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Method,[Parameter(Mandatory)][string]$Uri,[hashtable]$Headers,[string]$ContentType,[object]$Body,[string]$OutFile,[switch]$SkipHttpErrorCheck)
    $methodUpper = $Method.ToUpperInvariant()
    $isMutation = Register-AFQWCall -Method $methodUpper -Uri $Uri -Body $Body
    $p = @{ Method=$methodUpper; Uri=$Uri }
    if ($PSBoundParameters.ContainsKey('Headers')) { $p.Headers=$Headers }
    if ($PSBoundParameters.ContainsKey('ContentType')) { $p.ContentType=$ContentType }
    if ($PSBoundParameters.ContainsKey('Body')) { $p.Body=$Body }
    if ($PSBoundParameters.ContainsKey('OutFile')) { $p.OutFile=$OutFile }
    if ($SkipHttpErrorCheck) { $p.SkipHttpErrorCheck=$true }
    try { return Microsoft.PowerShell.Utility\Invoke-WebRequest @p }
    catch {
        $status = Get-AFQWHttpStatusFromError -ErrorRecord $_
        if ($isMutation -and $null -eq $status) { Write-AFQWAmbiguity -Method $methodUpper -Uri $Uri }
        throw
    }
}

'@
$text = Replace-ExactOnce $text 'function Invoke-GoogleJson {' ($networkHelpers + 'function Invoke-GoogleJson {') 'NETWORK_HELPERS'

# Apply the already-adjudicated A2 stale-status correction.
$oldStale = @'
$StaleStatus = $null

try {
    $null = Invoke-AFQWWebRequest `
        -Method POST `
        -Uri $BatchUri `
        -Headers $Headers `
        -ContentType 'application/json; charset=utf-8' `
        -Body $StaleBody `
        -SkipHttpErrorCheck `
        -StatusCodeVariable StaleStatus
}
catch {
    throw 'Stale-CAS transport call failed before an HTTP status could be evaluated.'
}
'@
$newStale = @'
$StaleStatus = $null
$StaleResponse = $null

try {
    $StaleResponse = Invoke-AFQWWebRequest `
        -Method POST `
        -Uri $BatchUri `
        -Headers $Headers `
        -ContentType 'application/json; charset=utf-8' `
        -Body $StaleBody `
        -SkipHttpErrorCheck
    $StaleStatus = [int]$StaleResponse.StatusCode
}
catch {
    throw 'Stale-CAS transport call failed before an HTTP status could be evaluated.'
}
'@
$text = Replace-ExactOnce $text $oldStale $newStale 'STALE_STATUS'

$extension = @'
# ============================================================================
# T3 EXTENSIONS — NATIVE EXPORT / REVISION EVIDENCE / BLOB V1+V2 REVISIONS
# ============================================================================

$DocExportUri = "https://www.googleapis.com/drive/v3/files/$($EncodedDocumentId)/export?mimeType=text%2Fplain"
Invoke-AFQWWebRequest -Method GET -Uri $DocExportUri -Headers $Headers -OutFile $DocExportTemp | Out-Null
$DocExportText = [IO.File]::ReadAllText($DocExportTemp)
if (-not $DocExportText.Contains($Marker1,[StringComparison]::Ordinal)) { throw 'Exported native Doc is missing CAS marker 1.' }
if (-not $DocExportText.Contains($Marker2,[StringComparison]::Ordinal)) { throw 'Exported native Doc is missing CAS marker 2.' }
if ($DocExportText.Contains($StaleMarker,[StringComparison]::Ordinal)) { throw 'Exported native Doc contains rejected stale marker.' }
$DocExportSha256 = (Get-FileHash -LiteralPath $DocExportTemp -Algorithm SHA256).Hash
Remove-Item -LiteralPath $DocExportTemp -Force

$DocRevisionsUri = "https://www.googleapis.com/drive/v3/files/$($EncodedDocumentId)/revisions?fields=revisions(id,keepForever,modifiedTime,mimeType,size)"
$DocRevisionResponse = Invoke-AFQWRestMethod -Method GET -Uri $DocRevisionsUri -Headers $Headers
$DocRevisionItems = @($DocRevisionResponse.revisions)
if ($DocRevisionItems.Count -lt 1) { throw 'Native Doc Drive revision metadata list is empty.' }
$DocRevisionIds = @($DocRevisionItems | ForEach-Object { [string]$_.id })
$DocRevisionIdsSha256 = Get-StringSha256 -Value ($DocRevisionIds -join '|')

$BlobRevisionsUri = "https://www.googleapis.com/drive/v3/files/$($EncodedBlobId)/revisions?fields=revisions(id,keepForever,modifiedTime,mimeType,size)"
$BlobRevisionsV1 = Invoke-AFQWRestMethod -Method GET -Uri $BlobRevisionsUri -Headers $Headers
$BlobRevisionItemsV1 = @($BlobRevisionsV1.revisions)
if ($BlobRevisionItemsV1.Count -lt 1) { throw 'Blob V1 revision list is empty.' }
$BlobV1Revision = $BlobRevisionItemsV1[-1]
$BlobV1RevisionId = [string]$BlobV1Revision.id
if ([string]::IsNullOrWhiteSpace($BlobV1RevisionId)) { throw 'Blob V1 revision ID missing.' }
$BlobV1RevisionIdSha256 = Get-StringSha256 -Value $BlobV1RevisionId
$EncodedBlobV1RevisionId = [Uri]::EscapeDataString($BlobV1RevisionId)
$PinUri = "https://www.googleapis.com/drive/v3/files/$($EncodedBlobId)/revisions/$($EncodedBlobV1RevisionId)?fields=id,keepForever"
$PinBody = ConvertTo-CompactJson ([ordered]@{ keepForever = $true })
$PinnedV1 = Invoke-AFQWRestMethod -Method PATCH -Uri $PinUri -Headers $Headers -ContentType 'application/json; charset=utf-8' -Body $PinBody
if (-not [bool]$PinnedV1.keepForever) { throw 'Blob V1 revision was not retained with keepForever.' }

$BlobPayloadV2Text = "FRD-DRIVE-AFQW-R4-T3-A0-BLOB-V2::$($RunNonce)::$($UtcStamp)"
$BlobPayloadV2Bytes = [Text.Encoding]::UTF8.GetBytes($BlobPayloadV2Text)
$BlobV2UploadSha256 = Get-BytesSha256 -Bytes $BlobPayloadV2Bytes
$BlobV2UploadResponse = Invoke-AFQWRestMethod -Method PATCH -Uri $BlobUploadUri -Headers $Headers -ContentType 'application/octet-stream' -Body $BlobPayloadV2Bytes

Invoke-AFQWWebRequest -Method GET -Uri "https://www.googleapis.com/drive/v3/files/$($EncodedBlobId)?alt=media" -Headers $Headers -OutFile $BlobV2DownloadTemp | Out-Null
$BlobV2DownloadSha256 = (Get-FileHash -LiteralPath $BlobV2DownloadTemp -Algorithm SHA256).Hash
if ($BlobV2DownloadSha256 -ne $BlobV2UploadSha256) { throw 'Blob V2 current byte readback SHA-256 mismatch.' }
Remove-Item -LiteralPath $BlobV2DownloadTemp -Force

$BlobRevisionsV2 = Invoke-AFQWRestMethod -Method GET -Uri $BlobRevisionsUri -Headers $Headers
$BlobRevisionItemsV2 = @($BlobRevisionsV2.revisions)
if ($BlobRevisionItemsV2.Count -lt 2) { throw 'Blob revision history did not retain at least V1 and V2.' }
$BlobHeadRevisionId = [string]$BlobRevisionItemsV2[-1].id
if ([string]::IsNullOrWhiteSpace($BlobHeadRevisionId)) { throw 'Blob V2 head revision ID missing.' }
if ($BlobHeadRevisionId -eq $BlobV1RevisionId) { throw 'Blob revision head did not advance after V2 upload.' }
$BlobHeadRevisionIdSha256 = Get-StringSha256 -Value $BlobHeadRevisionId
$RetainedV1 = @($BlobRevisionItemsV2 | Where-Object { [string]$_.id -eq $BlobV1RevisionId })
if ($RetainedV1.Count -ne 1) { throw 'Pinned Blob V1 revision is not deterministically present after V2 upload.' }
if (-not [bool]$RetainedV1[0].keepForever) { throw 'Blob V1 revision lost keepForever retention.' }

$BlobV1RevisionDownloadUri = "https://www.googleapis.com/drive/v3/files/$($EncodedBlobId)/revisions/$($EncodedBlobV1RevisionId)?alt=media"
Invoke-AFQWWebRequest -Method GET -Uri $BlobV1RevisionDownloadUri -Headers $Headers -OutFile $BlobV1RevisionTemp | Out-Null
$BlobV1RevisionDownloadSha256 = (Get-FileHash -LiteralPath $BlobV1RevisionTemp -Algorithm SHA256).Hash
if ($BlobV1RevisionDownloadSha256 -ne $BlobUploadSha256) { throw 'Historical Blob V1 revision byte SHA-256 mismatch.' }
Remove-Item -LiteralPath $BlobV1RevisionTemp -Force
'@
$text = Replace-ExactOnce $text '# ============================================================================`r`n# PRIVATE LOCAL RECEIPT — OBJECT IDs RETAINED FOR FRD-DRIVE-AFQW-R4-T3-A0' ($extension + "`r`n# ============================================================================`r`n# PRIVATE LOCAL RECEIPT — OBJECT IDs RETAINED FOR FRD-DRIVE-AFQW-R4-T3-A0") 'T3_EXTENSION'

$text = Replace-ExactOnce $text "    prior_a0_consumed_marker          = 'PASS'`r`n    prior_a0_objects_touched          = `$false" "    prior_a0_consumed_marker          = 'PASS'`r`n    prior_a1_consumed_marker          = 'PASS'`r`n    prior_a0_objects_touched          = `$false`r`n    prior_a1_objects_touched          = `$false" 'RECEIPT_PRIOR_A1'
$text = Replace-ExactOnce $text "    stale_marker                     = `$StaleMarker" "    stale_marker                     = `$StaleMarker`r`n    doc_export_sha256                 = `$DocExportSha256`r`n    doc_drive_revision_count          = `$DocRevisionItems.Count`r`n    doc_drive_revision_ids_sha256     = `$DocRevisionIdsSha256" 'RECEIPT_DOC_EXT'
$text = Replace-ExactOnce $text "    blob_byte_length                 = `$BlobPayloadBytes.Length" "    blob_byte_length                 = `$BlobPayloadBytes.Length`r`n    blob_v1_revision_id               = `$BlobV1RevisionId`r`n    blob_v1_revision_id_sha256        = `$BlobV1RevisionIdSha256`r`n    blob_v2_upload_sha256             = `$BlobV2UploadSha256`r`n    blob_v2_download_sha256           = `$BlobV2DownloadSha256`r`n    blob_head_revision_id             = `$BlobHeadRevisionId`r`n    blob_head_revision_id_sha256      = `$BlobHeadRevisionIdSha256`r`n    blob_v1_revision_download_sha256  = `$BlobV1RevisionDownloadSha256`r`n    blob_revision_count_after_v2      = `$BlobRevisionItemsV2.Count" 'RECEIPT_BLOB_EXT'
$text = Replace-ExactOnce $text "    token_refresh                    = 'PASS'" "    token_refresh                    = 'PASS'`r`n    oauth_refresh_call_count          = `$OAuthRefreshCallCount`r`n    drive_api_call_count              = `$DriveApiCallCount`r`n    docs_api_call_count               = `$DocsApiCallCount`r`n    mutation_intent_count             = `$MutationIntentCount`r`n    engineering_source_a1_sha256      = `$EngineeringSourceA1Sha256`r`n    engineering_reference_a2_sha256  = `$EngineeringReferenceA2Sha256" 'RECEIPT_COUNTS'

$text = $text.Replace("if (`$BlobPayloadBytes) {`r`n    [Array]::Clear(`r`n        `$BlobPayloadBytes,`r`n        0,`r`n        `$BlobPayloadBytes.Length`r`n    )`r`n}","if (`$BlobPayloadBytes) { [Array]::Clear(`$BlobPayloadBytes,0,`$BlobPayloadBytes.Length) }`r`nif (`$BlobPayloadV2Bytes) { [Array]::Clear(`$BlobPayloadV2Bytes,0,`$BlobPayloadV2Bytes.Length) }")

$tailMarker = '# ============================================================================`r`n# SANITIZED OUTPUT ONLY`r`n# ============================================================================'
$tailIndex = $text.IndexOf($tailMarker)
if ($tailIndex -lt 0) { throw 'TRANSFORM_ANCHOR_OUTPUT_TAIL_NOT_FOUND' }
$text = $text.Substring(0,$tailIndex) + @'
# ============================================================================
# SANITIZED SHARED RECEIPT + CLEAN RESULT ENVELOPE
# ============================================================================

$TaskElapsedMs = [long]([DateTime]::UtcNow - $StartedUtc).TotalMilliseconds
$SanitizedReceipt = [ordered]@{
    schema_version = 1
    task_id = $TaskId
    attempt_id = $AttemptId
    result = 'PASS'
    task_active_elapsed_ms = $TaskElapsedMs
    worker_active_elapsed_ms = 0
    requested_scope = $Scope
    token_refresh = 'PASS'
    folder_id_sha256 = $FolderIdSha256
    document_id_sha256 = $DocumentIdSha256
    blob_id_sha256 = $BlobIdSha256
    doc_export_sha256 = $DocExportSha256
    doc_drive_revision_count = $DocRevisionItems.Count
    doc_drive_revision_ids_sha256 = $DocRevisionIdsSha256
    blob_v1_sha256 = $BlobUploadSha256
    blob_v1_revision_id_sha256 = $BlobV1RevisionIdSha256
    blob_v2_sha256 = $BlobV2UploadSha256
    blob_v2_download_sha256 = $BlobV2DownloadSha256
    blob_head_revision_id_sha256 = $BlobHeadRevisionIdSha256
    blob_v1_revision_download_sha256 = $BlobV1RevisionDownloadSha256
    blob_revision_count_after_v2 = $BlobRevisionItemsV2.Count
    stale_cas_http_status = 400
    oauth_refresh_call_count = $OAuthRefreshCallCount
    drive_api_call_count = $DriveApiCallCount
    docs_api_call_count = $DocsApiCallCount
    mutation_intent_count = $MutationIntentCount
    browser_oauth_interaction_count = 0
    provider_call_count = 0
    cleanup_delete_call_count = 0
    credential_file_changed = $false
    prior_a0_objects_touched = $false
    prior_a1_objects_touched = $false
    qualification_namespace_retained = $true
    exact_object_ids_shared = $false
    secrets_shared = $false
    private_receipt_sha256 = $ReceiptSha256
    engineering_source_a1_sha256 = $EngineeringSourceA1Sha256
    engineering_reference_a2_sha256 = $EngineeringReferenceA2Sha256
}
[IO.File]::WriteAllText($SanitizedReceiptFile,($SanitizedReceipt | ConvertTo-Json -Depth 10),[Text.UTF8Encoding]::new($false))
$SanitizedReceiptSha256 = (Get-FileHash -LiteralPath $SanitizedReceiptFile -Algorithm SHA256).Hash
$FinalState = $SanitizedReceipt.Clone()
$FinalState['sanitized_receipt_sha256'] = $SanitizedReceiptSha256
[IO.File]::WriteAllText($FinalStateFile,($FinalState | ConvertTo-Json -Depth 10),[Text.UTF8Encoding]::new($false))
$FinalStateSha256 = (Get-FileHash -LiteralPath $FinalStateFile -Algorithm SHA256).Hash

Write-Host '======================================================================'
Write-Host 'AFQW RESULT | FRD-DRIVE-AFQW-R4-T3 | CORE DRIVE/DOCS/CAS CRUCIBLE'
Write-Host '======================================================================'
Write-Host "TASK_ID=$TaskId"
Write-Host "ATTEMPT_ID=$AttemptId"
Write-Host 'RESULT=PASS'
Write-Host 'TOKEN_REFRESH=PASS'
Write-Host 'DOC_CAS_WRITE_1=PASS'
Write-Host 'DOC_STALE_CAS_HTTP_STATUS=400'
Write-Host 'DOC_STALE_CAS_REJECTED=PASS'
Write-Host 'DOC_CAS_WRITE_2=PASS'
Write-Host 'DOC_EXPORT_MARKERS=PASS'
Write-Host 'DOC_DRIVE_REVISION_METADATA=PASS'
Write-Host 'BLOB_V1_CURRENT_SHA=PASS'
Write-Host 'BLOB_V1_REVISION_PIN=PASS'
Write-Host 'BLOB_V2_CURRENT_SHA=PASS'
Write-Host 'BLOB_V1_HISTORICAL_REVISION_SHA=PASS'
Write-Host "OAUTH_REFRESH_CALL_COUNT=$OAuthRefreshCallCount"
Write-Host "DRIVE_API_CALL_COUNT=$DriveApiCallCount"
Write-Host "DOCS_API_CALL_COUNT=$DocsApiCallCount"
Write-Host "MUTATION_INTENT_COUNT=$MutationIntentCount"
Write-Host 'PROVIDER_CALL_COUNT=0'
Write-Host 'BROWSER_OAUTH_INTERACTION_COUNT=0'
Write-Host 'CLEANUP_DELETE_CALL_COUNT=0'
Write-Host "TASK_ACTIVE_ELAPSED_MS=$TaskElapsedMs"
Write-Host 'WORKER_ACTIVE_ELAPSED_MS=0'
Write-Host "FOLDER_ID_SHA256=$FolderIdSha256"
Write-Host "DOCUMENT_ID_SHA256=$DocumentIdSha256"
Write-Host "BLOB_ID_SHA256=$BlobIdSha256"
Write-Host "PRIVATE_RECEIPT_SHA256=$ReceiptSha256"
Write-Host "SANITIZED_RECEIPT_SHA256=$SanitizedReceiptSha256"
Write-Host "FINAL_STATE_SHA256=$FinalStateSha256"
Write-Host 'PRIOR_A0_OBJECTS_TOUCHED=False'
Write-Host 'PRIOR_A1_OBJECTS_TOUCHED=False'
Write-Host 'QUALIFICATION_NAMESPACE_RETAINED=True'
Write-Host 'EXACT_OBJECT_IDS_SHARED=False'
Write-Host 'SECRETS_SHARED=False'
Write-Host 'RELAUNCH_AUTHORIZED=False'
Write-Host '======================================================================'
'@

New-Item -ItemType Directory -Force -Path $PrivateSourceRoot | Out-Null
if (Test-Path -LiteralPath $WorkerPath) { throw 'T3_PRIVATE_WORKER_ALREADY_EXISTS_RECONCILE_BEFORE_REBUILD' }
[IO.File]::WriteAllText($WorkerPath,$text,[Text.UTF8Encoding]::new($false))

$Tokens = $null
$Errors = $null
[Management.Automation.Language.Parser]::ParseFile($WorkerPath,[ref]$Tokens,[ref]$Errors) | Out-Null
$WorkerSha = (Get-FileHash -LiteralPath $WorkerPath -Algorithm SHA256).Hash
$WorkerText = [IO.File]::ReadAllText($WorkerPath)

$Checks = [ordered]@{
    A1_SOURCE_SHA_MATCH = ($SourceSha -eq $ExpectedSourceSha)
    PARSER_ZERO = ($Errors.Count -eq 0)
    FRESH_T3_IDENTITY = $WorkerText.Contains('FRD-DRIVE-AFQW-R4-T3-A0')
    OLD_CURRENT_A1_IDENTITY_ABSENT = (-not $WorkerText.Contains("`$AttemptId = 'PDA-R4-A1'"))
    STALE_STATUS_VARIABLE_ABSENT = (-not $WorkerText.Contains('-StatusCodeVariable'))
    A2_STALE_RESPONSE_PATTERN_PRESENT = $WorkerText.Contains('$StaleStatus = [int]$StaleResponse.StatusCode')
    MUTATION_INTENT_PRESENT = $WorkerText.Contains('Write-AFQWMutationIntent')
    DOC_EXPORT_PRESENT = $WorkerText.Contains('/export?mimeType=text%2Fplain')
    DRIVE_REVISIONS_PRESENT = $WorkerText.Contains('/revisions?fields=revisions')
    KEEP_FOREVER_PRESENT = $WorkerText.Contains('keepForever = $true')
    BLOB_V2_PRESENT = $WorkerText.Contains('BLOB-V2')
    HISTORICAL_REVISION_MEDIA_PRESENT = $WorkerText.Contains('/revisions/$($EncodedBlobV1RevisionId)?alt=media')
    HTTP_DELETE_ABSENT = (-not ($WorkerText -match '(?i)-Method\s+DELETE'))
    EXACT_SCOPE_PRESENT = $WorkerText.Contains('https://www.googleapis.com/auth/drive.file')
    EXACT_TOKEN_URI_PRESENT = $WorkerText.Contains('https://oauth2.googleapis.com/token')
    T2_BINDING_HASH_PRESENT = $WorkerText.Contains('8F7F948D33B6E62FB8DB81E9D74878ECAB023BA1540876103ED99FDF40DD8314')
}
$FreezePass = (($Checks.Values | Where-Object { -not $_ }).Count -eq 0)

Write-Host '======================================================================'
Write-Host 'AFQW RESULT | FRD-DRIVE-AFQW-R4-T3 | PRIVATE WORKER BUILD + FREEZE'
Write-Host '======================================================================'
Write-Host 'TASK_ID=FRD-DRIVE-AFQW-R4-T3'
Write-Host 'ATTEMPT_ID=FRD-DRIVE-AFQW-R4-T3-A0'
Write-Host "BUILD_FREEZE_RESULT=$(if($FreezePass){'PASS'}else{'FAIL'})"
Write-Host "ENGINEERING_SOURCE_A1_SHA256=$SourceSha"
Write-Host "ENGINEERING_REFERENCE_A2_SHA256=$ExpectedA2ReferenceSha"
Write-Host "PRIVATE_WORKER_PATH=$WorkerPath"
Write-Host "PRIVATE_WORKER_SHA256=$WorkerSha"
Write-Host "PARSER_ERROR_COUNT=$($Errors.Count)"
foreach ($Entry in $Checks.GetEnumerator()) { Write-Host "$($Entry.Key)=$($Entry.Value)" }
Write-Host '----------------------------------------------------------------------'
Write-Host "OAUTH_REFRESH_BUDGET=$MaxOAuthRefreshCalls"
Write-Host "DRIVE_API_BUDGET=$MaxDriveApiCalls"
Write-Host "DOCS_API_BUDGET=$MaxDocsApiCalls"
Write-Host "MUTATION_INTENT_BUDGET=$MaxMutationIntents"
Write-Host 'ATRIA_MAIN_PROVIDER_BUDGET=0'
Write-Host 'ATRIA_PREFLIGHT_REVIEW_BUDGET=1'
Write-Host 'BROWSER_OAUTH_BUDGET=0'
Write-Host 'GOOGLE_DELETE_BUDGET=0'
Write-Host 'MAIN_EXECUTION_PERFORMED=False'
Write-Host 'GOOGLE_API_CALL_PERFORMED=False'
Write-Host 'PROVIDER_CALL_PERFORMED=False'
Write-Host 'CREDENTIAL_DECRYPTION_PERFORMED=False'
Write-Host 'NEXT_ACTION=RETURN_FREEZE_RESULT_TO_GOVERNANCE'
Write-Host '======================================================================'
if (-not $FreezePass) { exit 10 }
exit 0
