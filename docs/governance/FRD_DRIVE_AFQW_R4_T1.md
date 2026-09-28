# FRD Drive Automation — AFQW R4-T1 — Atria Dispatch Seal

**Task ID:** `FRD-DRIVE-AFQW-R4-T1`  
**Task name:** `Atria Dispatch Seal`  
**Workflow:** `AFQW v1.1`  
**Status:** `CANDIDATE PERSISTED / FREEZE REQUIRED / MAIN NOT YET AUTHORIZED`  
**Canonical governance lane:** `FRD Ops Site — Governance`  
**Recorded:** 2026-09-28

## Purpose
R4-T1 is the first provider-bearing AFQW successor after R4-T0 PASS. It qualifies the exact local Atria dispatch boundary before Atria is used for the Google Drive/Docs/CAS campaign.

This task is Atria-only. It performs no Google Drive API call, no Google Docs API call, no browser/OAuth action, no Google credential action, no repository mutation, and no access to retained PDA-R4 A0/A1 Drive residue.

A PASS establishes that the dedicated AFQW Atria credential reference can be resolved from the authoritative private DPAPI plane, one exact `Atria-Dawn-Preview` work unit can complete, provider-intent/no-replay semantics are durable, private provider response evidence remains private, and sanitized evidence/timing returns cleanly.

## Candidate identity
- task attempt: `FRD-DRIVE-AFQW-R4-T1-A0`;
- provider work unit: `FRD-DRIVE-AFQW-R4-T1-A0-ATRIA-W01`;
- worker: `FRD-DRIVE-QUAL-ATRIA-WORKER`;
- model: exact `Atria-Dawn-Preview`;
- endpoint: exact `https://api.atria-asi.ai/v1/responses`;
- credential identity: `FRD-DRIVE-QUAL-ATRIA-EXEC-01`;
- accepted credential ciphertext SHA-256: `01C5306E6B1CCE4D2AEBA3E122E4EE3FA34D0B2CF2182EF6DCF4F9EA981B30F9`;
- expected response marker: `AFQW_ATRIA_T1_OK`;
- Atria call budget: `1`;
- Drive API budget: `0`;
- Docs API budget: `0`;
- browser/OAuth budget: `0`.

## WIOS pattern mirrored
R4-T1 mirrors the latest reviewed WIOS Gemini/Antigravity methodology: deterministic controller authority; durable provider intent as the no-replay boundary; no automatic retry; post-intent uncertainty becomes `UNKNOWN`; private response bytes are persisted before COMPLETE; shared evidence is sanitized; TASK ACTIVE and WORKER ACTIVE remain separate; Atria work is fresh/stateless.

Reviewed WIOS references remain read-only:
- authoritative Gemini/Antigravity USCP commit `4177af7c76af855995e6d7c6aeee98dd81fd6c0c`;
- workspace commit `c421d38ac143a00f065422d8b60908c035a27aaf`;
- `OPERATOR_INTERACTION_WORKFLOW_20260928.md`;
- `AUTONOMOUS_CAMPAIGN_A2_CONTEXT_AND_FINDINGS_CONTRACT_20260927.md`;
- `docs/adr/0004-a3-provider-intent-and-account-identity.md`.

## Candidate script set
Payload source point: `7f07056d16be2c13aa34108720bd7b868dc70a6b`.

Files:
- `scripts/afqw/t1/FRD_AFQW_R4_T1_Worker.ps1`;
- `scripts/afqw/t1/FRD_AFQW_R4_T1_TaskTimer.ps1`;
- `scripts/afqw/t1/FRD_AFQW_R4_T1_Launch.ps1`;
- `scripts/afqw/t1/FRD_AFQW_R4_T1_Run.ps1`;
- `scripts/afqw/t1/FRD_AFQW_R4_T1_Freeze.ps1`.

Stage/freeze wrapper creation point: `b7090219703dc85bf659d060b4424e3024d5e62b`.
Stage/freeze wrapper SHA-256: `B23C001D6601537579D75629C36322EA53766456107F7A48C65896459ABF4BC8`.

No main execution is authorized until the local freeze returns `AFQW_T1_FREEZE_RESULT=PASS`, parser error count `0` for every executable candidate, and surface scan `PASS`.

## Storage boundary
Private credential/control state remains under `C:\AI-Orchestrator\Private\WIOS\FRD-Drive-Qualification\`.
Sanitized task state remains under `C:\AI-Orchestrator\workspaces\FRD-Drive-Automation\Atria-Qualification\`.
Sanitized governance evidence remains under `C:\AI-Orchestrator\Governance Files\FRD-Drive-Automation\Atria-Qualification\`.
Private provider response material must not be copied into either shared root.

## Timing and replay
- TASK ACTIVE covers the full Worker attempt.
- WORKER ACTIVE covers only the validated Atria provider lifecycle after durable provider intent.
- once `STARTED.json` exists, T1-A0 is consumed and must not be relaunched;
- once provider intent exists, provider work-unit W01 is consumed and must not be replayed;
- pre-intent deterministic failure returns FAILED;
- post-intent uncertainty returns UNKNOWN;
- PASS requires exactly one provider call, exact model, completed response, exact marker, private response persistence, zero Google/Drive/Docs/browser activity, unchanged credential file, and untouched PDA-R4 A0/A1 residue.

## Governance return
Return the freeze result to this lane. On Freeze PASS, this lane freezes the exact SHA-256 identities and may authorize one provider-bearing A0 execution. After terminal T1 evidence, Governance immediately proceeds to the next determinable AFQW stage; on PASS that successor is the actual PDA-R4 core Drive/Docs/CAS qualification task using disposable qualification objects.
