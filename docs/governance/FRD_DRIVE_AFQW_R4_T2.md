# FRD Drive Automation — AFQW R4-T2 — R3 Credential Bridge Seal

**Task ID:** `FRD-DRIVE-AFQW-R4-T2`  
**Task name:** `R3 Credential Bridge Seal`  
**Workflow:** `AFQW v1.1`  
**Status:** `A0 CONSUMED / DETERMINISTIC LOCAL FAILURE / A1 CONDITIONALLY AUTHORIZED`  
**Canonical governance lane:** `FRD Ops Site — Governance`  
**Recorded:** 2026-09-28

## Purpose
R4-T2 is the read-only local bridge between the already accepted `PDA-R3-A1` permanent Google credential and the upcoming AFQW core Drive/Docs/CAS campaign.

It exists because Governance will not guess the private R3 DPAPI serialization/decryption contract. T2 discovers and seals the exact existing local binding from frozen identities before any Google API mutation campaign is built.

T2 performs zero Atria calls, zero Google Drive calls, zero Google Docs calls, zero browser/OAuth actions, zero repository writes from the local worker, and zero changes to the Google credential. It may decrypt the already accepted R3 DPAPI credential transiently and locally only to identify JSON schema key names and verify exact `drive.file` scope; secret values are never persisted or printed.

## Frozen inputs
- accepted R3-A1 script SHA-256: `3CFAE9EA6B10F96270824431600F125778EEAFC154B02FEC61E5497D25DE9E79`;
- accepted R3 credential file SHA-256: `8EEE8866414807131C9E0203362CAA72D0FC8EC5F02A5BE390CB2C456625B303`;
- accepted R3 receipt SHA-256: `FE7B95D06F3CA8322B29B362924877B62A3B9C3BCEE6C0B564845F5DBE094D1D`;
- expected scope: exact `https://www.googleapis.com/auth/drive.file`;
- credential path: `C:\AI-Orchestrator\bootstrap\FRD-Drive-Automation\credentials\qual-oauth.dpapi`;
- scripts root: `C:\AI-Orchestrator\bootstrap\FRD-Drive-Automation\scripts`;
- receipts root: `C:\AI-Orchestrator\bootstrap\FRD-Drive-Automation\receipts`.

## R4-T2-A0 — CONSUMED / FAILED / NO REPLAY

Attempt `FRD-DRIVE-AFQW-R4-T2-A0` passed its local Freeze gate and therefore became authorized and consumed when `STARTED.json` was created.

Observed terminal evidence:
- Freeze `PASS`, worker parser errors `0`, zero-network surface scan `PASS`;
- exact R3 script, credential-file and receipt hashes matched the frozen inputs;
- provider/Drive/Docs/browser-OAuth counts all `0`;
- Google credential file unchanged;
- PDA-R4 A0/A1 residue untouched;
- final receipt SHA-256 `C4A172F966934D08FC0E9EE218554454576749AABD553EAE11189D9AC05607A1`;
- `RELAUNCH_AUTHORIZED=False`.

Failure cause is deterministic and local: A0 correctly inferred `DPAPI CurrentUser` with null entropy from the accepted R3 script, but then incorrectly passed the **entire `qual-oauth.dpapi` file bytes** to `ProtectedData.Unprotect`. The accepted R3 serialization is an outer JSON envelope. The DPAPI ciphertext is stored as Base64 in its `ciphertext` field. The correct R3 read path is therefore:

`read envelope JSON -> extract ciphertext -> Base64 decode -> DPAPI CurrentUser Unprotect(null entropy) -> UTF-8 JSON credential bundle`.

A0 failed before Google credential decryption completed and before any network/provider/Drive/Docs operation. A0 is consumed and SHALL NOT be rerun.

## Accepted R3 serialization contract used by A1
The already accepted PDA-R3-A1 implementation stores `qual-oauth.dpapi` as a JSON envelope containing at least:
- `schema_version`;
- `protection = DPAPI-CurrentUser`;
- `ciphertext = Base64(DPAPI ciphertext bytes)`.

The decrypted JSON bundle contains the credential schema needed by the refresh controller, including:
- `client_id`;
- `client_secret`;
- `refresh_token`;
- `token_uri`;
- `scope`;
plus non-secret bookkeeping fields.

The accepted cryptographic contract is null-entropy `ProtectedData.Protect(..., CurrentUser)` and `ProtectedData.Unprotect(..., CurrentUser)` after Base64 decoding the envelope ciphertext.

## R4-T2-A1 — CANDIDATE / CONDITIONALLY AUTHORIZED

Fresh attempt identity: `FRD-DRIVE-AFQW-R4-T2-A1`.

A1 preserves the T2 acceptance contract and changes only the faulty local envelope handling. It performs no provider or Google network call and no external mutation.

Frozen candidate artifacts:
- A1 Worker creation commit: `865e6defd0821853d1f8ae9317ffc446dc53ac54`;
- A1 Worker SHA-256: `88257D90011E99489B3795A445A8BA3C4E9C5B6B46080AE5DA40516429FED1D5`;
- A1 Freeze/source commit: `8863bbe7f040fbb93ebe256589b4ccff17d0c970`;
- A1 Freeze SHA-256: `E495016EC784F661D7E4D9219902F3F3ACF344644FCC7B2F4B224D3DD76649C5`;
- A1 combined Stage/Freeze/Run wrapper commit: `be9a81c374202cae2a8d978420b8d7226fd4563e`;
- A1 combined wrapper SHA-256: `4087E315603045ADCA1DF28C6889D5DB3680B5423D94605EE35353498B62123E`.

Files:
- `scripts/afqw/t2/FRD_AFQW_R4_T2_A1_Worker.ps1`;
- `scripts/afqw/t2/FRD_AFQW_R4_T2_A1_Freeze.ps1`;
- `scripts/afqw/t2/FRD_AFQW_R4_T2_A1_StageFreezeRun.ps1`.

## A1 conditional authorization
Governance authorizes A1 main execution **only if** the locally delivered A1 worker first returns:
- `AFQW_T2_A1_FREEZE_RESULT=PASS`;
- parser errors `0`;
- exact Worker SHA identity gate `PASS`;
- zero-network surface scan `PASS`;
- provider/Drive/Docs calls `False/0`;
- credential decryption during Freeze `False`;
- main execution during Freeze `False`.

The combined wrapper may execute A1 immediately after that explicit local Freeze PASS without another approval turn. If Freeze fails, A1 main execution is forbidden.

Once A1 `STARTED.json` exists, A1 is consumed and SHALL NOT be relaunched.

## A1 PASS criteria
A1 PASS requires:
1. exactly one local script matching the accepted R3-A1 script hash;
2. exact accepted R3 credential-file hash;
3. exactly one local receipt matching the accepted R3 receipt hash;
4. accepted outer envelope is valid JSON and reports `protection=DPAPI-CurrentUser`;
5. envelope `ciphertext` exists and Base64-decodes;
6. null-entropy DPAPI CurrentUser unprotect succeeds transiently;
7. decrypted schema contains `client_id`, `client_secret`, `refresh_token`, `scope`, and `token_uri`;
8. scope is exactly `https://www.googleapis.com/auth/drive.file`;
9. token URI is exactly `https://oauth2.googleapis.com/token`;
10. accepted R3 script statically confirms envelope/Base64/refresh-grant mechanics;
11. no secret values are persisted to shared evidence or printed;
12. zero provider/Drive/Docs/browser-OAuth calls;
13. credential file unchanged;
14. PDA-R4 A0/A1 residue untouched.

## Next stage
On A1 PASS, Governance will use the sealed binding descriptor to build/freeze the actual AFQW PDA-R4 core Drive/Docs/CAS campaign. That successor may perform unattended refresh and mutations only inside a fresh disposable qualification namespace. It will retain Atria as bounded conductor/reviewer and the deterministic controller as the sole execution/replay/evidence authority.
