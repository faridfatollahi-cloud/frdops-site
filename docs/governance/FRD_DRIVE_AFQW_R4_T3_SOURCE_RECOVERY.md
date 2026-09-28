# FRD Drive Automation — AFQW R4-T3 Source Recovery

**Task:** `FRD-DRIVE-AFQW-R4-T3 — Core Drive/Docs/CAS Crucible`  
**Status:** `SOURCE RECOVERY RECONCILED / EXACT A2 ARTIFACT RECOVERED FROM LIBRARY / A2 ENGINEERING REFERENCE`  
**Recorded:** 2026-09-29

## Local recovery execution

Read-only local source-recovery scanner result:
- scanner SHA-256: `46DBF6FF5BE6CB682C91C6E7E10757E6F4F0B7880DD149F4A7FF229AD9F582E7`;
- PowerShell files scanned: `263`;
- provider calls: `0`;
- Google API calls: `0`;
- credential decryption: `0`;
- T3 main execution: `False`;
- recovered source execution: `False`.

The scanner was intentionally limited to the frozen local roots. Its `MATCH_COUNT=0` for A2 meant only that A2 was absent from those local roots; it was not evidence that the preserved artifact no longer existed elsewhere.

## Exact source identities

### PDA-R4-A2 — exact artifact recovered from ChatGPT Library
- expected SHA-256: `A7283E4C775989D7F1AAD1FE90B1733796A78CE3D81335D84FAC038FF7D0B26C`;
- local-root scanner match count: `0`;
- persistent Library artifact name: `PDA_R4_CORE_DRIVE_DOCS_CAS_A2.ps1`;
- recovered Library byte length: `31744`;
- recovered Library SHA-256 independently verified: `A7283E4C775989D7F1AAD1FE90B1733796A78CE3D81335D84FAC038FF7D0B26C`.

A2 therefore remains **PRESERVED / NOT EXECUTED**, but its exact source is available as engineering evidence. It SHALL NOT be executed under the old `PDA-R4-A2` attempt identity. T3 may use the exact A2 source read-only as the preferred engineering reference for the fresh AFQW T3 identity.

Exact A2/A1 comparison establishes that A2 is a bounded successor to A1 rather than an unrelated rewrite. The principal A2 engineering delta includes:
- fresh `PDA-R4-A2` attempt/object/marker identity;
- explicit consumed-A1 marker validation while retaining A0 untouched;
- correction of the stale-CAS HTTP-status capture by using the returned `Invoke-WebRequest` response status instead of unsupported `-StatusCodeVariable`;
- otherwise preserving the established R3 refresh, folder/native-Doc creation, Docs CAS/readback, exact-parent and V1 blob byte-readback flow.

A2 does **not** contain the later T3-required Drive revision/export surfaces and therefore is an engineering reference, not an executable T3 candidate.

### PDA-R4-A1 — exact local implementation source
- exact local match count: `1`;
- path: `C:\AI-Orchestrator\bootstrap\FRD-Drive-Automation\scripts\PDA_R4_CORE_DRIVE_DOCS_CAS_A1.ps1`;
- SHA-256: `12EEE3C68B9C80502BD48CA44B68C9618814D256E70452019188188E2D0B5C28`;
- parser errors: `0`.

A1 remains consumed and SHALL NOT be rerun. Its local source is useful as the deterministic local build input because it is already present at an exact hash. The T3 builder may transform A1 using only deltas independently reconciled against the exact A2 reference plus the frozen T3 acceptance contract.

### PDA-R4-A0
- exact local match count: `1`;
- path: `C:\AI-Orchestrator\bootstrap\FRD-Drive-Automation\scripts\PDA_R4_CORE_DRIVE_DOCS_CAS_A0.ps1`;
- SHA-256: `A59D855C086C6E3FA71BE553F5618F3E765DEBCA06AB7ADAFC9738922772A790`;
- parser errors: `0`.

A0 remains consumed and is retained only as historical engineering evidence.

### PDA-R3-A1
- exact local match count: `1`;
- path: `C:\AI-Orchestrator\bootstrap\FRD-Drive-Automation\scripts\PDA_R3_PRODUCTION_OAUTH_BOOTSTRAP_A1.ps1`;
- SHA-256: `3CFAE9EA6B10F96270824431600F125778EEAFC154B02FEC61E5497D25DE9E79`;
- parser errors: `0`.

R3-A1 remains the accepted source of the sealed OAuth credential/refresh binding.

## A1 feature-map result

The zero-provider A1 feature map established:
- exact A1 source hash and parser gate PASS;
- `requiredRevisionId` / Docs CAS and stale-CAS flow present;
- exact-parent validation present;
- binary blob create/upload/current-download SHA flow present;
- stale implementation still contains the known unsupported `-StatusCodeVariable` defect;
- Drive revision surfaces absent;
- `keepForever` absent;
- native Google Doc export absent;
- no Google HTTP DELETE surface;
- local `Remove-Item` exists only for the temporary byte-readback file.

No provider/Google call, credential decrypt, source mutation or T3 execution occurred during the feature map.

## Engineering decision

The fresh T3 executable will **not** execute or rename the old A2 attempt. Instead:
1. exact local A1 is the deterministic machine-local source input;
2. exact Library A2 is the reconciled engineering reference for the already-tested stale-CAS correction and A1-continuity delta;
3. the T3 builder applies only bounded, explicit transformations under a fresh `FRD-DRIVE-AFQW-R4-T3-A0` identity;
4. T3 adds the frozen acceptance surfaces missing from A2: durable mutation-intent/replay fencing, private/shared AFQW evidence separation, native Doc export/revision evidence, binary V1/V2 revision pin/readback, finite API budgets and clean AFQW result collection;
5. the generated private T3 worker must pass a whole-file PS7 parser gate, exact SHA-256 freeze and static budget/surface gates before the exact-package owner authorization gate opens.

No old PDA-R4 attempt identity will be reused or executed.
