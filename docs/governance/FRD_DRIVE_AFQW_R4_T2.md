# FRD Drive Automation — AFQW R4-T2 — R3 Credential Bridge Seal

**Task ID:** `FRD-DRIVE-AFQW-R4-T2`  
**Task name:** `R3 Credential Bridge Seal`  
**Workflow:** `AFQW v1.1`  
**Status:** `CANDIDATE PERSISTED / CONDITIONALLY AUTHORIZED AFTER LOCAL FREEZE PASS`  
**Canonical governance lane:** `FRD Ops Site — Governance`  
**Recorded:** 2026-09-28

## Purpose
R4-T2 is the read-only local bridge between the already accepted `PDA-R3-A1` permanent Google credential and the upcoming AFQW core Drive/Docs/CAS campaign.

It exists because Governance will not guess the private R3 DPAPI serialization/decryption contract. T2 discovers and seals the exact existing local binding from frozen identities before any Google API mutation campaign is built.

T2 performs zero Atria calls, zero Google Drive calls, zero Google Docs calls, zero browser/OAuth actions, zero repository writes from the local worker, and zero changes to the Google credential. It may decrypt the already accepted R3 DPAPI credential transiently and locally only to identify JSON schema key names and verify exact `drive.file` scope; secret values are never persisted or printed.

## Frozen inputs
- accepted R3-A1 script SHA-256: `3CFAE9EA6B10F96270824431600F125778EEAFC154B02FEC61E5497D25DE9E79`;
- accepted R3 credential ciphertext SHA-256: `8EEE8866414807131C9E0203362CAA72D0FC8EC5F02A5BE390CB2C456625B303`;
- accepted R3 receipt SHA-256: `FE7B95D06F3CA8322B29B362924877B62A3B9C3BCEE6C0B564845F5DBE094D1D`;
- expected scope: exact `https://www.googleapis.com/auth/drive.file`;
- credential path: `C:\AI-Orchestrator\bootstrap\FRD-Drive-Automation\credentials\qual-oauth.dpapi`;
- scripts root: `C:\AI-Orchestrator\bootstrap\FRD-Drive-Automation\scripts`;
- receipts root: `C:\AI-Orchestrator\bootstrap\FRD-Drive-Automation\receipts`.

## Identity and budgets
- task attempt: `FRD-DRIVE-AFQW-R4-T2-A0`;
- Atria/provider budget: `0`;
- Drive API budget: `0`;
- Docs API budget: `0`;
- browser/OAuth budget: `0`;
- external mutation budget: `0`.

Once T2 `STARTED.json` exists, A0 is consumed and must not be replayed. A deterministic pre-start freeze failure does not consume A0.

## Candidate artifacts
- worker creation commit: `a024ada39304474e501713c2c5e0afa170c96cf1`;
- freeze/source commit: `ebbc552ee74b0daa97065a521b9076cad2c39d87`;
- combined stage/freeze/run wrapper commit: `06f313b1b91a31e1d8e56b7fc2a71966446c2695`;
- combined wrapper SHA-256: `0606B07C625EA996A5B49BB3A8764F0F48290E039AB2E485941893EB4E05618D`.

Files:
- `scripts/afqw/t2/FRD_AFQW_R4_T2_Worker.ps1`;
- `scripts/afqw/t2/FRD_AFQW_R4_T2_Freeze.ps1`;
- `scripts/afqw/t2/FRD_AFQW_R4_T2_StageFreezeRun.ps1`.

## Conditional authorization
Governance authorizes the T2 main attempt **only if** the locally delivered worker first returns:
- `AFQW_T2_FREEZE_RESULT=PASS`;
- `PARSER_ERROR_COUNT=0`;
- `ZERO_NETWORK_SURFACE_SCAN=PASS`;
- freeze script parser errors `0`;
- provider/Drive/Docs calls `False/0`;
- credential decryption during freeze `False`;
- main execution during freeze `False`.

The combined wrapper is allowed to execute T2-A0 immediately after that explicit local freeze PASS without a separate human approval turn. If the freeze fails, main execution is forbidden.

## Sanitized discovery contract
T2 may return only non-secret facts needed to build the core controller:
- exact matching script/credential/receipt hashes;
- R3 script filename and receipt filename, but not secret file contents;
- DPAPI CurrentUser presence;
- DPAPI entropy classification;
- decrypted JSON **key names only**;
- booleans for presence of `client_id`, `client_secret`, `refresh_token`, scope, and optional token endpoint field;
- exact-scope boolean for `drive.file`;
- static booleans that the R3 script contains refresh-grant and Google token-endpoint mechanics;
- task timing and final receipt hashes.

No OAuth client secret, refresh token, access token, client ID value, or raw decrypted JSON may be printed or written to shared storage.

## PASS criteria
T2 PASS requires:
1. exactly one local script matching the accepted R3-A1 script hash;
2. exact accepted R3 credential ciphertext hash;
3. exactly one local receipt matching the accepted R3 receipt hash;
4. DPAPI CurrentUser unprotect contract resolved;
5. transient local decrypt succeeds without persistence of plaintext;
6. decrypted schema contains `client_id`, `client_secret`, `refresh_token`, and `scope`;
7. scope is exactly `drive.file`;
8. zero provider/Drive/Docs/browser-OAuth calls;
9. credential file unchanged;
10. PDA-R4 A0/A1 residue untouched.

## Next stage
On T2 PASS, Governance will use the sealed binding descriptor to build/freeze the actual AFQW PDA-R4 core Drive/Docs/CAS campaign. That successor may perform unattended refresh and mutations only inside a fresh disposable qualification namespace. It will retain Atria as bounded conductor/reviewer and the deterministic controller as the sole execution/replay/evidence authority.
