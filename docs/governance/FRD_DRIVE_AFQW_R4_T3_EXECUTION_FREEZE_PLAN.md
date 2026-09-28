# FRD Drive Automation — AFQW R4-T3 Executable Freeze Plan

**Task:** `FRD-DRIVE-AFQW-R4-T3 — Core Drive/Docs/CAS Crucible`  
**Attempt lineage:** `FRD-DRIVE-AFQW-R4-T3-A0`  
**Workflow:** `AFQW v1.1`  
**State:** `OWNER DESIGN-GATE AUTHORIZED / EXECUTABLE SOURCE RECOVERY + LOCAL FREEZE NEXT`  
**Recorded:** 2026-09-28

## Owner authorization
The repository owner explicitly authorized the disposable Google Drive/Docs mutation campaign at the design gate. Per the frozen R4-T3 two-stage human gate, exact executable/hash/API-budget authorization remains required after local executable freeze.

## Executable handling
The secret-bearing runtime executable is treated as **private runtime material**, not public project content. Public GitHub governance retains only the acceptance contract, sanitized executable identities/hashes, finite budgets, and adjudication state. No OAuth secret/token values, DPAPI ciphertext, access tokens, private Drive content, or exact disposable object IDs belong in this repository.

## Source recovery precedence
Before generating new core logic, Governance must attempt to recover the already prepared PDA-R4 controller artifacts by exact SHA-256 from local private/operator storage:

1. preserved `PDA_R4_CORE_DRIVE_DOCS_CAS_A2.ps1` — `A7283E4C775989D7F1AAD1FE90B1733796A78CE3D81335D84FAC038FF7D0B26C`;
2. consumed `PDA_R4_CORE_DRIVE_DOCS_CAS_A1.ps1` — `12EEE3C68B9C80502BD48CA44B68C9618814D256E70452019188188E2D0B5C28`;
3. consumed `PDA_R4_CORE_DRIVE_DOCS_CAS_A0.ps1` — `A59D855C086C6E3FA71BE553F5618F3E765DEBCA06AB7ADAFC9738922772A790`;
4. accepted `PDA-R3-A1` credential/refresh script — `3CFAE9EA6B10F96270824431600F125778EEAFC154B02FEC61E5497D25DE9E79`.

Recovered A0/A1 scripts are engineering source only and SHALL NOT be executed under their consumed identities. A2 remains unexecuted and also SHALL NOT be executed directly unless Governance explicitly reactivates it. Recovered code may be used only to build the fresh AFQW T3 controller under a new frozen identity.

## Candidate finite budgets to be frozen
The local executable freeze must expose the exact final values. Current design target:

- Atria review calls: `<= 1`;
- OAuth refresh calls: `1`;
- browser OAuth interactions: `0`;
- Drive API calls: finite exact sequence, target `14` for core path;
- Docs API calls: finite exact sequence, target `7` for core path;
- Google mutation-intent records: one before every mutation, target `9`;
- cleanup/delete calls: `0`.

These targets are not main-execution authority until local parser/hash/surface freeze returns PASS and Governance records the exact delivered identities.

## Local freeze requirements
The executable package must pass, before main authorization:

- PowerShell 7 whole-file parser error count `0` for every consequential `.ps1`;
- SHA-256 identity for every executable file;
- exact task/attempt identity check;
- exact R3 credential SHA and T2 binding/final receipt continuity hashes;
- exact `drive.file` scope and Google token endpoint binding;
- exact Atria model/route identity if an Atria work unit is present;
- no browser OAuth path;
- no cleanup/delete path;
- no automatic semantic/provider/Google mutation retry;
- durable intent before each externally mutating Google request;
- private exact object-ID retention and shared object-ID hashing only;
- explicit TASK ACTIVE / WORKER ACTIVE timing separation;
- zero main execution during freeze.

## Next operation
Run a bounded zero-provider/local source-recovery scan for the four exact historical hashes above. Return only sanitized file paths, hashes, parser counts, and match classifications. No recovered script is executed by the discovery operation.
