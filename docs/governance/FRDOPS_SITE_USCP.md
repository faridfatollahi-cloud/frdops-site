# FRD Ops Site — USCP

**Status:** CURRENT / CANONICAL REPOSITORY CHECKPOINT / ATRIA CREDENTIAL RE-IMPORT  
**Date:** 2026-09-28  
**Repository:** `faridfatollahi-cloud/frdops-site`  
**Domain:** `frdops.ir`

## Governance

- Sole canonical governance lane: **`FRD Ops Site — Governance`**, designated by the repository owner.
- Repository owner retains ultimate ownership authority.
- DMB, WIOS, PMW, TPD, Codex, Work-mode, scheduled tasks, Atria, and other lanes/workers have no independent governance authority over this repository or the FRD Drive Automation acceptance decision.
- External lanes/workers may read/propose, or execute explicitly authorized bounded work only.
- **This lane does not govern DMB.** DMB governance, DMB gate adjudication, DMB target/Control/migration decisions, final DMB cross-gate audit, and any DMB Production decision belong to **DMB Governance 3**.
- DMB's already-passed Gates may be used here only as the acceptance specification for the Drive/Docs/OAuth capabilities the permanent foundation must demonstrate.

## Repository purpose

Public, project-neutral identity/compliance site for `frdops.ir` and the permanent personal Google Drive/Docs OAuth/API foundation named **FRD Drive Automation**. DMB, WIOS, and other projects may consume that foundation independently under their own project-level boundaries.

## Completed foundation stages

- **PDA-R1 — PASS / CLOSED**: neutral Google Cloud project, Drive API and Docs API enabled, External app, `drive.file` baseline.
- **PDA-R1B — PASS / CLOSED**: `frdops.ir` registered, verified and live over HTTPS with public app/privacy/terms routes.
- **PDA-R2 — PASS / CLOSED**: Google Auth Platform is **In production**, audience **External**.
- **PDA-R3 — PASS / CLOSED**: fresh post-Production offline authorization under `drive.file` only; DPAPI CurrentUser round-trip and unattended refresh proven. Accepted successful attempt: `PDA-R3-A1`, script SHA-256 `3CFAE9EA6B10F96270824431600F125778EEAFC154B02FEC61E5497D25DE9E79`.

## PDA-R4 — CURRENT / ATRIA DELEGATION PREPARATION

Purpose: qualify the permanent FRD Drive Automation foundation against the Drive/Docs/OAuth behavior required by DMB's already-passed Gates, using disposable app-created qualification objects and without entering DMB governance.

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

### PDA-R4-A2 — PRESERVED / NOT EXECUTED / HUMAN-RUN PATH SUPERSEDED

Prepared candidate artifact:
- script `PDA_R4_CORE_DRIVE_DOCS_CAS_A2.ps1`;
- candidate SHA-256 `A7283E4C775989D7F1AAD1FE90B1733796A78CE3D81335D84FAC038FF7D0B26C`.

The candidate remains preserved as engineering evidence but is no longer the preferred operator path. It must not be executed unless this governance lane explicitly reactivates it.

Reason: repetitive execution, evidence capture, deterministic continuation, and bounded engineering remediation are now delegated to Atria through the WIOS runtime pattern. Governance retains acceptance/adjudication.

## Atria delegated execution decision

The remaining permanent-foundation qualification will use the **WIOS runtime pattern demonstrated in the WIOS multi-provider/Gemini qualification work**, with a dedicated Atria execution credential and a bounded qualification campaign.

### Credential identity

- display/semantic identity: `FRD Drive Qualification — Atria Exec 01`;
- machine credential identity: `FRD-DRIVE-QUAL-ATRIA-EXEC-01`;
- campaign/attempt identities remain separate from the credential identity;
- provider route remains exact Atria route unless governance explicitly changes it after evidence review.

### Credential location correction — authoritative

The earlier proposed `%LOCALAPPDATA%\WIOS\private\credentials\...` location is **superseded and forbidden for this lane**.

Authoritative private root:
- `C:\AI-Orchestrator\Private\WIOS\FRD-Drive-Qualification\credentials\FRD-DRIVE-QUAL-ATRIA-EXEC-01\`

Non-secret governance evidence root (Drive-shared):
- `C:\AI-Orchestrator\Governance Files\FRD-Drive-Automation\Atria-Qualification\`

Non-secret campaign workspace root (Drive-shared):
- `C:\AI-Orchestrator\workspaces\FRD-Drive-Automation\Atria-Qualification\`

Secret material, DPAPI ciphertext, decrypted values, or temporary plaintext must never be written under either Drive-shared root.

### Credential import A0 reconciliation

Attempt `FRD-DRIVE-QUAL-ATRIA-CRED-IMPORT-A0` used the superseded `%LOCALAPPDATA%` root. The sanitized terminal completion was not captured, so A0 is not accepted as the canonical retained credential import.

Subsequent exact-path reconciliation established:
- wrong-root final credential directory existed before cleanup;
- wrong-root staging directory did not exist;
- wrong-root failed-import directory did not exist;
- the exact final credential directory was deleted successfully;
- all three exact A0 wrong-root targets were absent after cleanup;
- `WRONG_ROOT_RECONCILIATION_RESULT=PASS`;
- `WRONG_ROOT_CREDENTIAL_RETAINED=False`;
- provider calls `False` and Drive mutations `False` during cleanup.

A0 is therefore **CONSUMED / SUPERSEDED / WRONG-ROOT RETAINMENT REMOVED**. It must not be reused. A fresh import uses attempt identity `FRD-DRIVE-QUAL-ATRIA-CRED-IMPORT-A1` at the authoritative private root.

### Credential security contract

- API key is entered only through a local secure prompt; it is never pasted into chat, Git, logs, task packets, receipts, command-line arguments, or synced storage;
- retained form is Windows **DPAPI CurrentUser** ciphertext under the authoritative private WIOS root above;
- private credential directory is ACL-restricted to the current user SID and SYSTEM;
- import uses staging, validation, atomic promotion, and sanitized receipt/evidence;
- plaintext credential file persistence is forbidden;
- ordinary provider/runtime artifacts contain only credential identity/reference, never the key;
- runtime decryption is transient and only for the authorized provider dispatch boundary;
- only sanitized import/campaign evidence may be copied to `Governance Files` / `workspaces`;
- sanitized evidence must affirm no plaintext-file, command-line, Git/Drive, or ordinary-log exposure.

### Operator-window identity

PowerShell 7 operator windows used for this lane must set an explicit title beginning with:

`FRD Ops Site — Governance | FRD Drive Automation`

so the operator can visually distinguish this lane from WIOS/DMB and other concurrent shells.

### Atria authority boundary

Atria may:
- execute the frozen qualification campaign;
- perform zero-provider/local preflight;
- create/use only dedicated disposable qualification objects;
- gather receipts/hashes/readbacks;
- continue deterministic next steps;
- perform bounded engineering remediation to the harness/test implementation when the acceptance contract itself is unchanged;
- stop and return a complete evidence package to this governance lane.

Atria may not:
- change OAuth scope or Google Auth Platform configuration;
- change acceptance semantics derived from the already-passed DMB Gates;
- waive/override a failed requirement;
- touch existing DMB/WIOS production or governance objects;
- make a DMB governance decision;
- authorize DMB Production promotion;
- silently replay an uncertain semantic/provider attempt identity.

Any acceptance-standard change, scope broadening, cross-project target need, unresolved ambiguity, or governance-sensitive decision must stop and return here.

## Permanent-foundation acceptance target

This lane's terminal decision is narrowly:

`PERMANENT_DRIVE_FOUNDATION_FITNESS = PASS | FAIL | BLOCKED`

PASS means the permanent Production OAuth/Drive/Docs foundation has demonstrated the operations and failure properties required by the already-passed DMB Gates using authorized qualification objects.

It does **not** mean `DMB Gates A–E PASS`, does not adjudicate DMB, and does not authorize DMB Production. Those decisions belong exclusively to **DMB Governance 3**.

## Security invariants

- No private authorization material or private Drive content in this repository.
- No DMB/WIOS private runtime state in this repository.
- Qualification mutations remain confined to disposable app-created objects unless a later project-specific authority explicitly authorizes otherwise.
- A0/A1 Drive qualification residue remains untouched until a dedicated cleanup/reconciliation action is separately authorized.

## Public routes

- `https://frdops.ir/`
- `https://frdops.ir/drive-automation/`
- `https://frdops.ir/drive-automation/privacy/`
- `https://frdops.ir/drive-automation/terms/`

## Resume point

Current state on 2026-09-28:
1. wrong-root Atria credential retainment has been reconciled and removed;
2. `FRD-DRIVE-QUAL-ATRIA-CRED-IMPORT-A0` is consumed/superseded and must not be reused;
3. next action is fresh secure import `FRD-DRIVE-QUAL-ATRIA-CRED-IMPORT-A1` into `C:\AI-Orchestrator\Private\WIOS\FRD-Drive-Qualification\credentials\FRD-DRIVE-QUAL-ATRIA-EXEC-01\` using DPAPI CurrentUser + exact-directory ACL + atomic promotion;
4. sanitized import evidence may be written under `C:\AI-Orchestrator\Governance Files\FRD-Drive-Automation\Atria-Qualification\`; secrets may not;
5. after accepted A1 import, freeze the Atria Permanent Drive Qualification Campaign contract and runtime binding under the non-secret workspace root;
6. run zero-provider/local preflight before any semantic/provider call;
7. only after preflight PASS may the first campaign attempt be authorized;
8. PDA-R4 A0/A1 must not be rerun and A2 remains preserved/unexecuted unless explicitly reactivated;
9. after campaign completion, this lane adjudicates only `PERMANENT_DRIVE_FOUNDATION_FITNESS` and hands the evidence boundary to DMB Governance 3.
