#requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Host.UI.RawUI.WindowTitle = 'FRD Ops Site — Governance | FRD Drive Automation | Atria ForgeLoop T1 Run | A0'
$TaskId = 'FRD-DRIVE-AFQW-R4-T1'
$AttemptId = 'FRD-DRIVE-AFQW-R4-T1-A0'
$ScriptRoot = 'C:\AI-Orchestrator\scripts\FRD-Drive-Automation\AFQW\T1'
$Launch = Join-Path $ScriptRoot 'FRD_AFQW_R4_T1_Launch.ps1'
$WorkspaceRoot = 'C:\AI-Orchestrator\workspaces\FRD-Drive-Automation\Atria-Qualification'
$EvidenceRoot = 'C:\AI-Orchestrator\Governance Files\FRD-Drive-Automation\Atria-Qualification'
$StateRoot = Join-Path $WorkspaceRoot "tasks\$TaskId\$AttemptId"
$TaskEvidenceRoot = Join-Path $EvidenceRoot "tasks\$TaskId\$AttemptId"
$StartMarker = Join-Path $StateRoot 'STARTED.json'
$FinalReceipt = Join-Path $StateRoot 'FINAL.json'
$SharedIntent = Join-Path $TaskEvidenceRoot 'PROVIDER_INTENT.sanitized.json'
$SharedProviderResult = Join-Path $TaskEvidenceRoot 'PROVIDER_RESULT.sanitized.json'
if (-not (Test-Path -LiteralPath $Launch -PathType Leaf)) { throw 'LAUNCH_SCRIPT_MISSING' }
if ((Test-Path -LiteralPath $StartMarker) -or (Test-Path -LiteralPath $FinalReceipt)) {
    throw 'T1_A0_ALREADY_CONSUMED_OR_TERMINAL_NO_REPLAY'
}
$launchOutput = & pwsh -NoProfile -File $Launch 2>&1
$launchExitCode = $LASTEXITCODE
if ($launchExitCode -ne 0) {
    Write-Host '======================================================================'
    Write-Host 'AFQW RESULT | FRD-DRIVE-AFQW-R4-T1 | LAUNCH FAILURE'
    Write-Host '======================================================================'
    Write-Host "ATTEMPT_ID=$AttemptId"
    Write-Host "LAUNCH_EXIT_CODE=$launchExitCode"
    Write-Host 'RESULT=FAILED_PRE_WORKER_OR_CONSUMED'
    Write-Host 'RELAUNCH_AUTHORIZED=False'
    Write-Host 'NEXT_ACTION=RETURN_RESULT_TO_GOVERNANCE'
    Write-Host '======================================================================'
    exit 10
}
$deadline = [DateTime]::UtcNow.AddMinutes(6)
while ((-not (Test-Path -LiteralPath $FinalReceipt -PathType Leaf)) -and ([DateTime]::UtcNow -lt $deadline)) {
    Start-Sleep -Milliseconds 500
}
Write-Host '======================================================================'
Write-Host 'AFQW RESULT | FRD-DRIVE-AFQW-R4-T1 | ATRIA DISPATCH SEAL'
Write-Host '======================================================================'
Write-Host "TASK_ID=$TaskId"
Write-Host "ATTEMPT_ID=$AttemptId"
Write-Host "LAUNCH_EXIT_CODE=$launchExitCode"
Write-Host "START_MARKER_PRESENT=$(Test-Path -LiteralPath $StartMarker)"
Write-Host "FINAL_RECEIPT_PRESENT=$(Test-Path -LiteralPath $FinalReceipt)"
if (-not (Test-Path -LiteralPath $FinalReceipt -PathType Leaf)) {
    Write-Host 'RESULT=UNKNOWN_OR_STILL_ACTIVE'
    Write-Host 'RELAUNCH_AUTHORIZED=False'
    Write-Host 'ACTION=DO_NOT_RERUN; RETURN_THIS_RESULT_TO_GOVERNANCE'
    Write-Host '======================================================================'
    exit 20
}
$final = Get-Content -LiteralPath $FinalReceipt -Raw | ConvertFrom-Json
Write-Host "RESULT=$($final.state)"
Write-Host "WORK_UNIT_ID=$($final.work_unit_id)"
Write-Host "WORKER_ID=$($final.worker_id)"
Write-Host "PROVIDER=$($final.provider)"
Write-Host "REQUESTED_MODEL=$($final.provider_model)"
Write-Host "OBSERVED_MODEL=$($final.observed_model)"
Write-Host "CREDENTIAL_ID=$($final.credential_id)"
Write-Host "HTTP_STATUS=$($final.http_status)"
Write-Host "TASK_ACTIVE_ELAPSED_MS=$($final.task_active_elapsed_ms)"
Write-Host "TASK_ACTIVE_ELAPSED=$($final.task_active_elapsed_hhmmss)"
Write-Host "WORKER_ACTIVE_ELAPSED_MS=$($final.worker_active_elapsed_ms)"
Write-Host "WORKER_ACTIVE_ELAPSED=$($final.worker_active_elapsed_hhmmss)"
Write-Host "PROVIDER_INTENT_COUNT=$($final.provider_intent_count)"
Write-Host "PROVIDER_CALL_COUNT=$($final.provider_call_count)"
Write-Host "DRIVE_API_CALL_COUNT=$($final.drive_api_call_count)"
Write-Host "DOCS_API_CALL_COUNT=$($final.docs_api_call_count)"
Write-Host "BROWSER_OAUTH_INTERACTION_COUNT=$($final.browser_oauth_interaction_count)"
Write-Host "CREDENTIAL_DECRYPTION_PERFORMED=$($final.credential_decryption_performed)"
Write-Host "CREDENTIAL_FILE_CHANGED=$($final.credential_file_changed)"
Write-Host "A0_A1_RESIDUE_TOUCHED=$($final.a0_a1_residue_touched)"
Write-Host "RAW_PROVIDER_RESPONSE_SHARED=$($final.raw_provider_response_shared)"
Write-Host "RAW_PROVIDER_RESPONSE_PERSISTED_PRIVATE=$($final.raw_provider_response_persisted_private)"
Write-Host "RESPONSE_SHA256=$($final.response_sha256)"
Write-Host "OUTPUT_TEXT_SHA256=$($final.output_text_sha256)"
Write-Host "ERROR_CODE=$($final.error_code)"
Write-Host "FINAL_RECEIPT_SHA256=$((Get-FileHash -LiteralPath $FinalReceipt -Algorithm SHA256).Hash)"
if (Test-Path -LiteralPath $SharedIntent -PathType Leaf) {
    Write-Host "SHARED_INTENT_SHA256=$((Get-FileHash -LiteralPath $SharedIntent -Algorithm SHA256).Hash)"
}
if (Test-Path -LiteralPath $SharedProviderResult -PathType Leaf) {
    Write-Host "SHARED_PROVIDER_RESULT_SHA256=$((Get-FileHash -LiteralPath $SharedProviderResult -Algorithm SHA256).Hash)"
}
Write-Host 'RELAUNCH_AUTHORIZED=False'
Write-Host 'NEXT_ACTION=RETURN_RESULT_TO_GOVERNANCE'
Write-Host '======================================================================'
if ($final.state -eq 'PASS') { exit 0 }
if ($final.state -eq 'UNKNOWN') { exit 20 }
exit 10
