# FRD Ops Site — USCP

**Status:** CURRENT / CANONICAL REPOSITORY CHECKPOINT / SESSION CLOSED / AFQW v1.1 / R4-T3 SOURCE RECOVERY COMPLETE / A1 FEATURE MAP NEXT  
**Date:** 2026-09-29  
**Repository:** `faridfatollahi-cloud/frdops-site`  
**Domain:** `frdops.ir`

## Governance

- Sole canonical governance lane: **`FRD Ops Site — Governance`**, designated by the repository owner.
- Repository owner retains ultimate ownership authority.
- DMB, WIOS, PMW, TPD, Codex, Work-mode, scheduled tasks, Atria, and other lanes/workers have no independent governance authority over this repository or the FRD Drive Automation acceptance decision.
- External lanes/workers may read/propose, or execute explicitly authorized bounded work only.
- **This lane does not govern DMB.** DMB governance, DMB gate adjudication, DMB target/Control/migration decisions, final DMB cross-gate audit, and any DMB Production decision belong to **DMB Governance 3**.
- DMB's already-passed Gates may be used here only as the acceptance specification for the Drive/Docs/OAuth capabilities the permanent foundation must demonstrate.
- Standing interaction rule for this lane: when the owner asks a question or returns execution/test results, Governance answers/reviews that material and continues immediately to the next determinable step in the same response. Stop only for a genuine human authorization/permission gate, blocking ambiguity, or required owner-only action/information.

## Repository purpose

Public, project-neutral identity/compliance site for `frdops.ir` and the permanent personal Google Drive/Docs OAuth/API foundation named **FRD Drive Automation**. DMB, WIOS, and other projects may consume that foundation independently under their own project-level boundaries.

## Completed foundation stages

- **PDA-R1 — PASS / CLOSED**: neutral Google Cloud project, Drive API and Docs API enabled, External app, `drive.file` baseline.
- **PDA-R1B — PASS / CLOSED**: `frdops.ir` registered, verified and live over HTTPS with public app/privacy/terms routes.
- **PDA-R2 — PASS / CLOSED**: Google Auth Platform is **In production**, audience **External**.
- **PDA-R3 — PASS / CLOSED**: fresh post-Production offline authorization under `drive.file` only; DPAPI CurrentUser round-trip and unattended refresh proven. Accepted successful attempt: `PDA-R3-A1`, script SHA-256 `3CFAE9EA6B10F96270824431600F125778EEAFC154B02FEC61E5497D25DE9E79`.

## PDA-R4 — CURRENT / AFQW CORE DRIVE-DOCS-CAS QUALIFICATION PREPARED

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

Prepared candidate identity:
- script `PDA_R4_CORE_DRIVE_DOCS_CAS_A2.ps1`;
- candidate SHA-256 `A7283E4C775989D7F1AAD1FE90B1733796A78CE3D81335D84FAC038FF7D0B26C`.

The candidate remains preserved as engineering evidence but is no longer the preferred operator path. It must not be executed unless this governance lane explicitly reactivates it.

R4-T3 source recovery on 2026-09-29 found **zero** local files matching the A2 SHA-256 in the scanned authoritative roots. Governance therefore SHALL NOT reconstruct A2 by guesswork or claim that its source is locally retained. The A2 identity remains preserved/not executed.

Reason the human-run A2 path remains superseded: repetitive execution, evidence capture, deterministic continuation, and bounded engineering remediation are delegated through the formal AFQW worker pattern. Governance retains acceptance/adjudication.

## Atria delegated execution decision

The remaining permanent-foundation qualification uses the WIOS runtime pattern demonstrated in the WIOS Gemini/Antigravity qualification work, adapted locally as the formal **Atria ForgeLoop Qualification Workflow (AFQW)**.

### Credential identity

- display/semantic identity: `FRD Drive Qualification — Atria Exec 01`;
- machine credential identity: `FRD-DRIVE-QUAL-ATRIA-EXEC-01`;
- campaign/attempt identities remain separate from the credential identity;
- provider/model route is exact `Atria-Dawn-Preview` unless governance explicitly changes it after evidence review.

### Credential location correction — authoritative

The earlier proposed `%LOCALAPPDATA%\WIOS\private\credentials\...` location is **superseded and forbidden for this lane**.

Authoritative private root:
- `C:\AI-Orchestrator\Private\WIOS\FRD-Drive-Qualification\credentials\FRD-DRIVE-QUAL-ATRIA-EXEC-01\`

Non-secret governance evidence root (Drive-shared):
- `C:\AI-Orchestrator\Governance Files\FRD-Drive-Automation\Atria-Qualification\`

Non-secret campaign workspace root (Drive-shared):
- `C:\AI-Orchestrator\workspaces\FRD-Drive-Automation\Atria-Qualification\`

Secret material, DPAPI ciphertext, decrypted values, raw private provider responses, or temporary plaintext must never be written under either Drive-shared root.

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

A0 is therefore **CONSUMED / SUPERSEDED / WRONG-ROOT RETAINMENT REMOVED**. It must not be reused.

### Credential import A1 — PASS / ACCEPTED

Fresh import attempt `FRD-DRIVE-QUAL-ATRIA-CRED-IMPORT-A1` at the authoritative private root is accepted as the retained Atria execution credential import.

Accepted sanitized credential evidence includes:
- DPAPI CurrentUser round-trip: `PASS`;
- credential directory ACL: current user SID + SYSTEM only: `PASS`;
- credential ciphertext SHA-256: `01C5306E6B1CCE4D2AEBA3E122E4EE3FA34D0B2CF2182EF6DCF4F9EA981B30F9`;
- private receipt SHA-256: `A0984A38393A99EBC8758480A227C47B01C9AE6F5D30129ADB1C5074BD58E114`;
- sanitized governance receipt SHA-256: `9547EF29F398AD300D0FFEC8958FD9BA6F65FAF4584F41856BDAF8562B91F645`.

Follow-up transient-memory remediation:
- attempt `FRD-DRIVE-QUAL-ATRIA-CRED-A1-MEMCLEAR-R0`;
- `ATRIA_IMPORT_A1_TRANSIENT_MEMORY_REMEDIATION=PASS`;
- `BSTR_ZERO_FREED=True`;
- `TRANSIENT_ARRAYS_CLEARED=6`;
- `SECURESTRING_REFERENCE_CLEARED=True`;
- `PROVIDER_CALL_PERFORMED=False`;
- `DRIVE_API_CALL_PERFORMED=False`;
- `CREDENTIAL_FILE_CHANGED=False`.

This closes the Atria credential-import bootstrap prerequisite for AFQW.

### Credential security contract

- API keys and OAuth secret/token values are never pasted into chat, Git, logs, task packets, receipts, command-line arguments, or synced storage;
- retained secret form is Windows DPAPI CurrentUser ciphertext in its authorized private plane;
- plaintext credential-file persistence is forbidden;
- ordinary worker/task packets contain credential identities/references, never secret values;
- runtime decryption is transient and only for the authorized dispatch boundary;
- only sanitized campaign evidence may be copied to `Governance Files` / `workspaces`.

## Atria ForgeLoop Qualification Workflow — ADOPTED

Canonical local workflow:
- file: `docs/governance/ATRIA_FORGELOOP_QUALIFICATION_WORKFLOW.md`;
- workflow ID: `AFQW`;
- current version: `1.1`;
- original creation commit: `9ff1ede783828710b30992943148843fa6dda27e`;
- v1.1 operator-UX tightening commit: `54490322f0083fcd2fc17dd5e504adc088989681`.

WIOS provenance reviewed read-only before adoption:
- authoritative Gemini/Antigravity USCP on `governance/runtime-fabric-live-qualification-draft`;
- non-authoritative Gemini workspace commit `c421d38ac143a00f065422d8b60908c035a27aaf`;
- operator interaction workflow and A2 context/findings contract from that workspace.

AFQW formally adopts for this repository:
- exact worker/provider/model/credential-reference binding;
- deterministic local controller authority over execution, replay fencing, evidence, budgets and terminal state;
- fresh/stateless Atria work units rehydrated from durable state;
- no-replay / `UNKNOWN` handling after provider intent uncertainty;
- bounded engineering remediation only inside an unchanged acceptance contract;
- dedicated PowerShell 7 worker and task-timer windows with explicit titles;
- whole-file parser gate + SHA-256 freeze + exact `pwsh -NoProfile -File` execution for consequential PowerShell;
- contiguous `RUN IN / ACTION / PURPOSE / EFFECT-RISK / ATTEMPT STATUS / RETURN` operator block;
- separate `TASK ACTIVE` and `WORKER ACTIVE` timing semantics;
- durable findings/evidence before `COMPLETE`;
- no silent context/evidence truncation;
- Governance-only final acceptance adjudication.

AFQW v1.1 additionally requires substantial execution/result-collector logic to be persisted as a `.ps1` wrapper and invoked with one command when interactive prompt echo would obscure the result. Future phases must return a compact contiguous result envelope instead of a long command/result transcript.

Default Atria context guard inherited from the validated Gemini A2 pattern remains: context ceiling `262144` tokens, input target `145000`, output reserve `50000`, request packet ceiling `120000` UTF-8 bytes, with STOP/repacketization rather than silent truncation.

### AFQW operator-window identity

Default titles:
- worker: `FRD Ops Site — Governance | FRD Drive Automation | Atria ForgeLoop Worker`;
- timer: `FRD Ops Site — Governance | FRD Drive Automation | Atria ForgeLoop Task Timer`.

### AFQW authority boundary

Atria may, only inside a frozen task envelope:
- perform zero-provider/local preflight;
- create/use only dedicated disposable qualification objects when the task explicitly authorizes mutations;
- gather receipts/hashes/readbacks;
- continue deterministic next steps;
- perform bounded engineering remediation to its own harness/test implementation when the acceptance contract is unchanged;
- stop and return a complete evidence package to this governance lane.

Atria may not:
- change OAuth scope or Google Auth Platform configuration;
- change acceptance semantics derived from the already-passed DMB Gates;
- waive/override a failed requirement;
- touch existing DMB/WIOS production or governance objects;
- touch PDA-R4 A0/A1 residue without a dedicated cleanup/reconciliation task;
- make a DMB governance decision;
- authorize DMB Production promotion;
- silently replay an uncertain semantic/provider identity;
- declare the final permanent-foundation fitness result on behalf of Governance.

Any acceptance-standard change, scope broadening, cross-project target need, unresolved ambiguity, exhausted frozen budget, evidence-integrity failure, or governance-sensitive decision must stop and return here.

## AFQW R4-T0 — PASS / CLOSED / A0 CONSUMED

Task packet:
- task ID: `FRD-DRIVE-AFQW-R4-T0`;
- main attempt: `FRD-DRIVE-AFQW-R4-T0-A0`;
- task file: `docs/governance/FRD_DRIVE_AFQW_R4_T0.md`;
- frozen script source point: `d75a6803861aa1561682cf292e10fbd0a1304570`;
- authorization commit: `6aaa4bffbb0badce74fe9318fabf9c2aa5100d69`;
- PASS-close task commit: `38b6890406311bd3490bcfe99e70c8ada91c0c2d`.

Frozen script hashes:
- Worker `BD7C6B55A1C3B6C629D154D7AAD25D4A171CB905A6D0682EA5809B85ABFD2C16`;
- TaskTimer `3F2F8193A1FBCB8ABA5590A40F8C7ECCBE6C84DB65C740107A945303034D45EC`;
- Launch `9A70505AEFCB038F13FC1E3FC21524127E0D1A159D7DB354972783C7AC65C17C`;
- Freeze `6D42E6649A4E2CE7F745CAB32F3E60D85AB570AD9CA39A9A6CE74DACA955996C`.

Accepted execution evidence:
- launch exit code `0`;
- durable STARTED, FINAL, EVENTS and evidence manifest present;
- final task state `PASS`;
- TASK ACTIVE `532 ms`;
- WORKER ACTIVE `0 ms`;
- provider/Drive/Docs/browser counts `0`;
- credential decryption `False`;
- credential file changed `False`;
- A0/A1 residue touched `False`;
- all T0 self-tests PASS.

Durable hashes:
- STARTED `12E952418FAE7B54663B8ADAF7BEA03100BA4334CABEDB8EA664D149812E6E00`;
- FINAL `F510E3E07DB9897FE483F1F094C9E429D65264F58E8E9EB26415B89145EC4433`;
- EVENTS `E0031366696A0598A5D716E179D729F936F9A3F8CB6BD2E20EA54CC01E1BEA8D`;
- EVIDENCE_MANIFEST `A13912DD25E227D8C3C960959C353B07CC43D2477ECD51FB89A93F983003F5C9`.

A0 is consumed and SHALL NOT be relaunched.

## AFQW R4-T1 — PASS / CLOSED / A0 CONSUMED

Task:
- task ID `FRD-DRIVE-AFQW-R4-T1`;
- name **Atria Dispatch Seal**;
- task file `docs/governance/FRD_DRIVE_AFQW_R4_T1.md`;
- task-attempt `FRD-DRIVE-AFQW-R4-T1-A0`;
- provider work-unit `FRD-DRIVE-AFQW-R4-T1-A0-ATRIA-W01`;
- PASS-close commit `3d6634495f733e810dc5b444aead60fc61dc96ef`.

Frozen delivered identities:
- Worker `8AB8E345940214FFF5E6E88B592C40442A0AC3D6CB78CCF42F7C0C3178B964D5`;
- TaskTimer `F66EBE3BF7B4C102F72A431D745834BA3243502538D2E56E9FA40A19EBDBFDBD`;
- Launcher `589EDBCAE4D7CCF4121AAFF28699B9F82E60CF251E6594DCD090CF2D2D832974`;
- Run wrapper `529DF8561D7E2B2A81036364882575CCAB164DDB2BAB885614C154FA5F529F56`.

Accepted execution evidence:
- `RESULT=PASS` with launch exit code `0`;
- START and FINAL durable receipts present;
- exact requested/observed model `Atria-Dawn-Preview`;
- HTTP `200`;
- TASK ACTIVE `8211 ms` / `00:00:08`;
- WORKER ACTIVE `7934 ms` / `00:00:07`;
- exactly `1` provider intent and `1` provider call;
- Drive/Docs/browser-OAuth counts `0`;
- Atria credential decryption occurred only at the authorized private dispatch boundary;
- credential file unchanged;
- PDA-R4 A0/A1 residue untouched;
- raw provider response shared `False` and private persistence `True`;
- terminal error empty.

Durable evidence hashes:
- response `D6F069C37567FF696953078F5BF0AB76066BEA2C56DCAB65DA9CDE323AD8CF36`;
- output text `45ECF1F4A5737FCC7D98C2AF61EA764E7AFF1A394826122C933B2B023A7FED91`;
- FINAL receipt `B8F8BBC0FACC1661EC1C135ED4BD8CDF06899BC0E49F3F8D8AF3C58617BC5AE6`;
- shared provider intent `29A9AB086004FF26109FA08712FCB8FE6278418974E380410DB2AAE74B0AD169`;
- shared provider result `539B961AD7B89E551ED0002877D7BD109622451A8C5A1C354A2A90A323BEA828`.

Adjudication: the exact Atria dispatch boundary is qualified for subsequent AFQW work under frozen authority. T1 does not itself establish Google Drive foundation fitness. A0 and its provider work-unit are consumed/no-replay.

## AFQW R4-T2 — PASS / CLOSED / A0+A1 CONSUMED

Task:
- task ID `FRD-DRIVE-AFQW-R4-T2`;
- name **R3 Credential Bridge Seal**;
- task file `docs/governance/FRD_DRIVE_AFQW_R4_T2.md`;
- PASS-close task commit `40aededd57cf4d6393c36c222804604031932884`.

A0 was consumed by a deterministic local harness error: it passed the entire outer `qual-oauth.dpapi` JSON envelope to DPAPI rather than Base64-decoding the envelope `ciphertext` field first. A0 performed zero provider/Drive/Docs/browser calls, did not complete credential decryption, changed no credential file, touched no PDA-R4 A0/A1 residue, and is no-replay.

A1 corrected only that envelope-handling defect under a fresh attempt identity and PASSed.

Accepted A1 evidence:
- `AFQW_T2_A1_FREEZE_RESULT=PASS`;
- Worker SHA-256 `88257D90011E99489B3795A445A8BA3C4E9C5B6B46080AE5DA40516429FED1D5`;
- exact R3 script SHA `3CFAE9EA6B10F96270824431600F125778EEAFC154B02FEC61E5497D25DE9E79`;
- exact credential-file SHA `8EEE8866414807131C9E0203362CAA72D0FC8EC5F02A5BE390CB2C456625B303`;
- exact R3 receipt SHA `FE7B95D06F3CA8322B29B362924877B62A3B9C3BCEE6C0B564845F5DBE094D1D`;
- envelope keys `ciphertext,protection,schema_version`;
- envelope protection `DPAPI-CurrentUser`;
- ciphertext Base64 present;
- DPAPI scope `CurrentUser`, entropy `NULL`;
- decrypted schema keys `attempt_id,client_id,client_secret,created_utc,refresh_token,schema_version,scope,token_uri`;
- exact `drive.file` scope;
- exact token URI `https://oauth2.googleapis.com/token`;
- script confirms envelope/Base64/refresh-grant mechanics;
- credential decrypt transient/local, `TRANSIENT_ARRAYS_CLEARED=3`;
- secret values persisted/shared `False`;
- provider/Drive/Docs/browser-OAuth counts `0`;
- credential unchanged;
- PDA-R4 A0/A1 residue untouched;
- binding receipt SHA `8F7F948D33B6E62FB8DB81E9D74878ECAB023BA1540876103ED99FDF40DD8314`;
- FINAL receipt SHA `8719D25C96E3A82E0DCCFEC011554FD042734E2BF2569BB930A28F0B20D99836`;
- replay authorization `False`.

Sealed R3 bridge contract:
`qual-oauth.dpapi JSON envelope -> ciphertext -> Base64 decode -> DPAPI CurrentUser Unprotect(NULL entropy) -> UTF-8 credential JSON`.

The decrypted bundle provides `client_id`, `client_secret`, `refresh_token`, exact `drive.file` scope and exact Google OAuth token URI. No future AFQW stage may broaden scope, request a browser grant, persist plaintext credential material or substitute a different credential source without a new Governance decision.

## AFQW R4-T3 — DESIGN FROZEN / OWNER DESIGN AUTHORIZATION RECEIVED / SOURCE RECOVERY COMPLETE

Task:
- task ID `FRD-DRIVE-AFQW-R4-T3`;
- name **Core Drive/Docs/CAS Crucible**;
- task file `docs/governance/FRD_DRIVE_AFQW_R4_T3.md`;
- design-freeze commit `4d818970619041dcbe1e8bd1d7d6a7bd9d8fd14c`;
- owner design-level authorization recording commit `2d25f139820fcf7f8782946589234fc9d96e72a3`.

The repository owner explicitly authorized the R4-T3 disposable Drive/Docs mutation campaign at the design level. That authorization is limited to the frozen design envelope: one fresh disposable namespace, no pre-existing-object mutation, no cleanup, no scope broadening, no browser OAuth, and no DMB/WIOS/PDA-R4 A0/A1 object access.

The two-stage mutation gate remains in force: exact executable identities and finite API/mutation budgets must still be frozen before the owner authorizes that exact package for main execution.

Frozen design acceptance includes:
- unattended refresh through the sealed R3 bridge with no browser and exact `drive.file`;
- unique disposable folder;
- native Google Doc inside exact folder;
- Docs revision read;
- valid revision-guarded CAS write and readback;
- stale CAS must return HTTP `400` and must not mutate;
- second valid guarded CAS and readback;
- exact Drive parent metadata;
- native Doc textual export and revision metadata where supported;
- deterministic blob V1 upload/readback SHA equality;
- preserve/pin prior blob revision, upload V2, current SHA equality, revision advancement, and prior-revision byte readback equal to V1;
- exact object IDs private, shared evidence sanitized/object-ID hashes only;
- no cleanup in same attempt;
- PDA-R4 A0/A1 and DMB/WIOS objects untouched;
- durable mutation intent before every externally mutating Google request;
- transport ambiguity after mutation intent becomes `UNKNOWN / NO REPLAY`.

R4-T3 is core-capability qualification only. Later resilience qualification still must cover restart/recovery, ambiguous-outcome reconciliation, bounded idempotency, wrong-root/wrong-object rejection, safe revoked-credential fail-closed behavior, and Drive Desktop independence where applicable.

### R4-T3 source recovery — COMPLETE

Read-only scanner result:
- scanner execution SHA-256 `46DBF6FF5BE6CB682C91C6E7E10757E6F4F0B7880DD149F4A7FF229AD9F582E7`;
- `263` PowerShell files scanned;
- provider calls `0`;
- Google API calls `0`;
- credential decryption `False`;
- main T3 execution `False`;
- recovered-script execution `False`.

Exact matches:
- PDA-R4-A2 `A7283E4C775989D7F1AAD1FE90B1733796A78CE3D81335D84FAC038FF7D0B26C`: match count `0`;
- PDA-R4-A1 `12EEE3C68B9C80502BD48CA44B68C9618814D256E70452019188188E2D0B5C28`: exactly one match at `C:\AI-Orchestrator\bootstrap\FRD-Drive-Automation\scripts\PDA_R4_CORE_DRIVE_DOCS_CAS_A1.ps1`, parser errors `0`;
- PDA-R4-A0 `A59D855C086C6E3FA71BE553F5618F3E765DEBCA06AB7ADAFC9738922772A790`: exactly one match at `C:\AI-Orchestrator\bootstrap\FRD-Drive-Automation\scripts\PDA_R4_CORE_DRIVE_DOCS_CAS_A0.ps1`, parser errors `0`;
- PDA-R3-A1 `3CFAE9EA6B10F96270824431600F125778EEAFC154B02FEC61E5497D25DE9E79`: exactly one match at `C:\AI-Orchestrator\bootstrap\FRD-Drive-Automation\scripts\PDA_R3_PRODUCTION_OAUTH_BOOTSTRAP_A1.ps1`, parser errors `0`.

Governance decision:
- the missing A2 source will not be reconstructed from memory;
- exact recovered A1 is the selected T3 engineering base;
- A1 remains consumed and SHALL NOT be executed again;
- A1 source may only be analyzed/derived under fresh T3 identities;
- A0 remains historical engineering evidence only;
- R3-A1 remains the authoritative source for the sealed OAuth credential/refresh binding.

Persisted source-recovery record:
- `docs/governance/FRD_DRIVE_AFQW_R4_T3_SOURCE_RECOVERY.md`;
- record commit `a8902fb7673f1903eddde4f079c01df9c6e110a7`.

### R4-T3 A1 Feature Map — PREPARED / NOT RUN

Purpose: inspect the exact recovered A1 source and determine which T3 capabilities are already implemented so the T3 executable can be produced by the smallest bounded transformation rather than a wholesale rewrite.

Feature-map scanner:
- `scripts/afqw/t3/FRD_AFQW_R4_T3_A1FeatureMap.ps1`;
- source commit `3ef935fe7bb85c97fa91f23652d92179892fee7d`.

The Feature Map is read-only. It has no authority to execute A1, decrypt credentials, call Atria/Google, modify the source, or start/consume `FRD-DRIVE-AFQW-R4-T3-A0`.

## Permanent-foundation acceptance target

This lane's terminal decision is narrowly:

`PERMANENT_DRIVE_FOUNDATION_FITNESS = PASS | FAIL | BLOCKED`

PASS means the permanent Production OAuth/Drive/Docs foundation has demonstrated the operations and failure properties required by the already-passed DMB Gates using authorized qualification objects.

It does **not** mean `DMB Gates A–E PASS`, does not adjudicate DMB, and does not authorize DMB Production. Those decisions belong exclusively to **DMB Governance 3**.

## Security invariants

- No private authorization material or private Drive content in this repository.
- No DMB/WIOS private runtime state in this repository.
- Qualification mutations remain confined to disposable app-created objects unless a later project-specific authority explicitly authorizes otherwise.
- PDA-R4 A0/A1 Drive qualification residue remains untouched until a dedicated cleanup/reconciliation action is separately authorized.

## Public routes

- `https://frdops.ir/`
- `https://frdops.ir/drive-automation/`
- `https://frdops.ir/drive-automation/privacy/`
- `https://frdops.ir/drive-automation/terms/`

## Session-close checkpoint / resume point

Session closed on 2026-09-29 because the current chat context is full. Continue in a new successor chat using this USCP as the canonical handoff.

Authoritative resume state:
1. Atria credential import A1 and transient-memory remediation are PASS/accepted at the authoritative private root.
2. **AFQW v1.1** is the formal worker workflow; use clean file-based wrappers, explicit PS7 lane titles, separate TASK ACTIVE / WORKER ACTIVE timing, durable intent/no-replay boundaries, and sanitized evidence.
3. R4-T0 is PASS/CLOSED; T0-A0 consumed/no-replay.
4. R4-T1 **Atria Dispatch Seal** is PASS/CLOSED; the exact `Atria-Dawn-Preview` dispatch boundary is qualified; T1-A0/W01 consumed/no-replay.
5. R4-T2 **R3 Credential Bridge Seal** is PASS/CLOSED; A0 is consumed failed/no-replay, A1 is consumed PASS/no-replay; the exact Google envelope/Base64/DPAPI CurrentUser/null-entropy/refresh binding is sealed.
6. R4-T3 **Core Drive/Docs/CAS Crucible** design is frozen. Owner design-level authorization for the disposable mutation campaign has been received, but exact executable/hash/API-budget authorization is still pending after executable freeze.
7. R4-T3 source recovery is complete: A2 source was not found; exact parser-clean A1 was recovered and is the selected engineering base; exact A0 and R3-A1 were also found. No recovered consumed script may be rerun.
8. **Immediate next action in the successor chat:** run/review the prepared zero-provider `FRD_AFQW_R4_T3_A1FeatureMap.ps1` scanner from commit `3ef935fe7bb85c97fa91f23652d92179892fee7d` against the exact recovered A1 source. This does not start or consume T3-A0.
9. After Feature Map review, continue immediately to the smallest bounded T3 executable construction, then parser/hash/API-budget freeze. Only after exact package freeze does the remaining owner authorization gate for main R4-T3 execution apply.
10. Main `FRD-DRIVE-AFQW-R4-T3-A0` has **NOT STARTED / NOT CONSUMED**. No fresh R4-T3 Google objects have been created or mutated yet.
11. PDA-R4 A0/A1 must not be rerun; their existing residue remains untouched. Preserved human-run A2 remains unexecuted and locally absent by exact hash unless separately recovered later.
12. After R4-T3 core PASS, continue to the later AFQW resilience stage before any terminal `PERMANENT_DRIVE_FOUNDATION_FITNESS` adjudication.
13. After core + resilience qualification, this lane adjudicates only `PERMANENT_DRIVE_FOUNDATION_FITNESS` and hands the evidence boundary to **DMB Governance 3**. DMB-specific qualification, final DMB Gates A–E audit, and DMB Production decisions remain exclusively there.
14. Standing interaction rule remains: review/answer returned results first and then continue to the next determinable step in the same response unless a true human gate, blocking ambiguity, or owner-only action requires stopping.
