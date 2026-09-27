# FRD Ops Site — USCP

**Status:** CURRENT / CANONICAL REPOSITORY CHECKPOINT  
**Date:** 2026-09-27  
**Repository:** `faridfatollahi-cloud/frdops-site`  
**Domain:** `frdops.ir`

## Governance

- Sole canonical governance lane: **`FRD Ops Site — Governance`**, designated by the repository owner.
- Repository owner retains ultimate ownership authority.
- DMB, WIOS, PMW, TPD, Codex, Work-mode, scheduled tasks, and other lanes have no independent governance authority over this repository.
- External lanes may read/propose, or execute explicitly authorized bounded work only.

## Repository purpose

Public, project-neutral identity/compliance site for `frdops.ir` and the permanent personal Google Drive/Docs OAuth/API foundation named **FRD Drive Automation**. DMB, WIOS, and other projects may consume that foundation independently under their own project-level boundaries. This repository does not own their operational state.

## Completed foundation stages

### PDA-R1 — PASS / CLOSED

- Neutral Google Cloud project: `FRD Drive Automation`.
- Drive API and Docs API enabled.
- External Google Auth Platform application.
- Baseline scope: `https://www.googleapis.com/auth/drive.file` only.
- Qualification desktop OAuth client retained privately outside this repository.

### PDA-R1B — PASS / CLOSED

- `frdops.ir` registered, delegated through Cloudflare, verified for GitHub Pages and Google Search Console, and live over HTTPS.
- Public application, Privacy Policy, and Terms pages deployed.
- Google Auth Platform Branding configured with `frdops.ir` URLs and authorized domain.

### PDA-R2 — PASS / CLOSED

Operator evidence confirms Google Auth Platform publishing status **In production**, audience **External**.

### PDA-R3 — PASS / CLOSED

Fresh post-Production offline authorization succeeded under `drive.file` only.

Accepted evidence:
- successful attempt: `PDA-R3-A1`;
- script SHA-256: `3CFAE9EA6B10F96270824431600F125778EEAFC154B02FEC61E5497D25DE9E79`;
- qualification client-file SHA-256: `88C2C2DE34257CCECE9E944E084B81AB0E14DE76DA4D2957C781F674BC386EAF`;
- DPAPI credential ciphertext SHA-256: `8EEE8866414807131C9E0203362CAA72D0FC8EC5F02A5BE390CB2C456625B303`;
- sanitized receipt SHA-256: `FE7B95D06F3CA8322B29B362924877B62A3B9C3BCEE6C0B564845F5DBE094D1D`;
- DPAPI CurrentUser round-trip PASS;
- unattended refresh PASS;
- no Drive mutation during R3;
- no token or client-secret value exposed.

`PDA-R3-A0` remains consumed as a zero-provider precondition failure and must not be reused.

## PDA-R4 — CURRENT

Purpose: qualify the permanent Production OAuth foundation against required Drive/Docs primitives using only disposable app-created qualification objects. This is not DMB Production promotion and must not target existing DMB/WIOS objects.

### PDA-R4-A0 — CONSUMED / RUNTIME_FAILED / PARTIAL DISPOSABLE MUTATION

Frozen artifact:
- `PDA_R4_CORE_DRIVE_DOCS_CAS_A0.ps1`;
- parser gate `PARSER_ERROR_COUNT=0`;
- SHA-256 `A59D855C086C6E3FA71BE553F5618F3E765DEBCA06AB7ADAFC9738922772A790`.

Observed result:
- pre-provider validation PASS;
- accepted R3 credential and receipt hashes matched;
- local A0 start marker written, therefore A0 is consumed;
- unattended refresh succeeded;
- one disposable A0 qualification folder and one native Google Doc were created;
- execution failed locally before the first Docs read completed because PowerShell StrictMode parsed an unbraced variable immediately followed by a query-string `?` as part of the variable name;
- no CAS write, stale-CAS test, blob creation/upload, or final A0 receipt occurred.

A0 Drive residue is intentionally retained and must not be manually modified or deleted until dedicated reconciliation/cleanup.

### PDA-R4-A1 — FROZEN / AUTHORIZED FOR ONE EXECUTION

A1 is the fresh successor to A0 and does not reuse A0 identity or objects.

Frozen artifact:
- `PDA_R4_CORE_DRIVE_DOCS_CAS_A1.ps1`;
- whole-file parser gate: `PARSER_ERROR_COUNT=0`;
- frozen SHA-256: `12EEE3C68B9C80502BD48CA44B68C9618814D256E70452019188188E2D0B5C28`.

A1 requirements and authority:
- preserve the accepted R3 credential/hash bindings and `drive.file` scope;
- require the consumed A0 start marker and absence of an A0 final receipt;
- leave all A0 Drive residue untouched;
- create a brand-new disposable A1 qualification namespace;
- refresh authentication only, with no browser or new OAuth grant;
- qualify folder creation, native Doc creation and exact parent binding, successful Docs CAS write, stale-CAS HTTP 400 with no mutation, second valid CAS write, final readback, raw blob create/upload/download, exact parent binding, and byte-for-byte SHA-256 equality;
- keep private object IDs only in the local private receipt and expose only sanitized statuses/hashes;
- mutate only the new A1 qualification namespace and its app-created children; existing project objects remain out of scope.

Execution rule:
- execute exactly the frozen A1 once with PowerShell 7 `-NoProfile -File`;
- once A1 writes its attempt-start marker, `PDA-R4-A1` is consumed regardless of PASS/FAIL/BLOCKED;
- do not edit, rerun, or reuse A1 after that point.

### PDA-R4-A2+ — PLANNED AFTER CORE PASS

Planned follow-on qualification includes revision-history/readback, restart/recovery and ambiguous-outcome reconciliation, wrong-root/wrong-object/cross-project rejection, credential-revocation fail-closed behavior, Drive Desktop independence, dedicated residue cleanup, and then DMB-specific target qualification before any DMB final audit/promotion decision.

## Security invariants

- No OAuth/client secrets, credential JSON contents, access tokens, refresh tokens, or private Drive content in this repository.
- No DMB/WIOS private runtime state in this repository.
- Qualification mutations remain confined to disposable app-created objects until a later project-specific gate explicitly authorizes otherwise.

## Public routes

- `https://frdops.ir/`
- `https://frdops.ir/drive-automation/`
- `https://frdops.ir/drive-automation/privacy/`
- `https://frdops.ir/drive-automation/terms/`

## Next logical action

Execute the exact frozen `PDA_R4_CORE_DRIVE_DOCS_CAS_A1.ps1` once with PowerShell 7 `-NoProfile -File`. Do not touch A0 residue. Return the complete sanitized terminal result or sanitized error for governance reconciliation.