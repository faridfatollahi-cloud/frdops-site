# FRD Ops Site — USCP

**Status:** CURRENT / CANONICAL REPOSITORY CHECKPOINT / SESSION CLOSED  
**Date:** 2026-09-27  
**Repository:** `faridfatollahi-cloud/frdops-site`  
**Domain:** `frdops.ir`

## Governance

- Sole canonical governance lane: **`FRD Ops Site — Governance`**, designated by the repository owner.
- Repository owner retains ultimate ownership authority.
- DMB, WIOS, PMW, TPD, Codex, Work-mode, scheduled tasks, and other lanes have no independent governance authority over this repository.
- External lanes may read/propose, or execute explicitly authorized bounded work only.

## Repository purpose

Public, project-neutral identity/compliance site for `frdops.ir` and the permanent personal Google Drive/Docs OAuth/API foundation named **FRD Drive Automation**. DMB, WIOS, and other projects may consume that foundation independently under their own project-level boundaries.

## Completed foundation stages

- **PDA-R1 — PASS / CLOSED**: neutral Google Cloud project, Drive API and Docs API enabled, External app, `drive.file` baseline.
- **PDA-R1B — PASS / CLOSED**: `frdops.ir` registered, verified and live over HTTPS with public app/privacy/terms routes.
- **PDA-R2 — PASS / CLOSED**: Google Auth Platform is **In production**, audience **External**.
- **PDA-R3 — PASS / CLOSED**: fresh post-Production offline authorization under `drive.file` only; DPAPI CurrentUser round-trip and unattended refresh proven. Accepted successful attempt: `PDA-R3-A1`, script SHA-256 `3CFAE9EA6B10F96270824431600F125778EEAFC154B02FEC61E5497D25DE9E79`.

## PDA-R4 — CURRENT / SESSION PAUSED

Purpose: qualify required Drive/Docs primitives using only disposable app-created qualification objects. This is not DMB Production promotion and must not target existing DMB/WIOS objects.

### PDA-R4-A0 — CONSUMED / RUNTIME_FAILED / PARTIAL DISPOSABLE MUTATION

Frozen artifact:
- script `PDA_R4_CORE_DRIVE_DOCS_CAS_A0.ps1`;
- parser gate `PARSER_ERROR_COUNT=0`;
- SHA-256 `A59D855C086C6E3FA71BE553F5618F3E765DEBCA06AB7ADAFC9738922772A790`.

Observed state:
- preflight and refresh succeeded;
- one disposable A0 folder and one native Google Doc were created;
- local PowerShell string interpolation failed before the first Docs read completed;
- no CAS write, stale-CAS test, blob operation, or final A0 receipt occurred;
- A0 residue is retained and must not be manually changed before dedicated cleanup.

### PDA-R4-A1 — CONSUMED / RUNTIME_FAILED / PARTIAL DISPOSABLE MUTATION

Frozen artifact:
- script `PDA_R4_CORE_DRIVE_DOCS_CAS_A1.ps1`;
- parser gate `PARSER_ERROR_COUNT=0`;
- SHA-256 `12EEE3C68B9C80502BD48CA44B68C9618814D256E70452019188188E2D0B5C28`.

Observed state:
- preflight and refresh succeeded;
- consumed A0 marker verified and A0 objects remained untouched;
- one fresh disposable A1 folder and one native Google Doc were created;
- initial Docs read succeeded;
- first revision-guarded CAS write succeeded and was read back;
- local PowerShell parameter binding then failed at the stale-CAS probe because `Invoke-WebRequest -StatusCodeVariable` is not supported;
- therefore the stale-CAS request was not sent, CAS write 2 was not attempted, no blob was created, and no final A1 receipt exists;
- A1 is consumed and must not be rerun.

A0/A1 residue is intentionally retained for later dedicated reconciliation/cleanup.

### PDA-R4-A2 — PREPARED / NOT YET FROZEN

Candidate artifact:
- script `PDA_R4_CORE_DRIVE_DOCS_CAS_A2.ps1`;
- candidate SHA-256 `A7283E4C775989D7F1AAD1FE90B1733796A78CE3D81335D84FAC038FF7D0B26C`.

A2 requirements:
- preserve the accepted R3 bindings and `drive.file` scope;
- require consumed A0 and A1 start markers and absence of their final receipts;
- leave all A0/A1 Drive residue untouched;
- create a brand-new disposable A2 qualification namespace;
- capture the stale-CAS HTTP status from the returned `Invoke-WebRequest` response object's `.StatusCode` while using `-SkipHttpErrorCheck`;
- retain the full core acceptance matrix: folder create, native Doc create and exact parent binding, valid CAS write, stale-CAS HTTP 400 with no mutation, second valid CAS write, final readback, blob create/upload/download, exact parent binding, and byte-for-byte SHA-256 equality.

A2 must receive a whole-file PowerShell parser gate and operator-side SHA-256 match before execution authority is granted.

## DMB Gate A–E audit dependency

The **final/acceptance DMB Gate A–E cross-gate audit should wait** until this lane finishes the permanent Drive/OAuth qualification path needed by DMB.

Reason:
- R3 has proven durable Production-state OAuth and refresh under `drive.file`, but R4 operation qualification is still incomplete;
- core Drive/Docs/CAS behavior has not yet reached a complete PASS;
- revision/history, recovery/fail-closed, isolation/wrong-target checks, and DMB-specific target qualification remain outstanding after core R4;
- therefore running the final DMB A–E acceptance audit now would evaluate DMB before its intended permanent transport/credential foundation and target behavior are fully qualified.

Permitted parallel work:
- a **read-only preliminary/pre-audit** may be run in the DMB lane if useful for identifying documentary or historical inconsistencies;
- such a pre-audit must be explicitly labeled non-final/non-acceptance and must not close Gate acceptance, authorize Production promotion, or substitute for the later final A–E audit.

Final DMB audit order remains:
1. complete FRD Drive Automation R4 qualification;
2. complete DMB-specific target/Control/CAS/migration qualification against the accepted permanent foundation;
3. then run the final DMB Gates A–E cross-gate audit;
4. only after that may any separate Production-promotion decision be considered.

## Security invariants

- No private authorization material or private Drive content in this repository.
- No DMB/WIOS private runtime state in this repository.
- Qualification mutations remain confined to disposable app-created objects until a later project-specific gate explicitly authorizes otherwise.

## Public routes

- `https://frdops.ir/`
- `https://frdops.ir/drive-automation/`
- `https://frdops.ir/drive-automation/privacy/`
- `https://frdops.ir/drive-automation/terms/`

## Resume point

Session closed on 2026-09-27 with **PDA-R4-A2 prepared but not parser/hash-frozen or executed**.

When resuming:
1. place/use `PDA_R4_CORE_DRIVE_DOCS_CAS_A2.ps1` from the prepared artifact;
2. perform only the whole-file PowerShell parser gate and SHA-256 check;
3. expected candidate SHA-256 is `A7283E4C775989D7F1AAD1FE90B1733796A78CE3D81335D84FAC038FF7D0B26C`;
4. do not rerun A0/A1;
5. do not manually touch A0/A1 Drive residue;
6. do not execute A2 until its parser-clean exact hash is frozen and explicitly authorized.
