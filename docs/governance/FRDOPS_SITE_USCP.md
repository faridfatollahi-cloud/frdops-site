# FRD Ops Site — USCP

**Status:** CURRENT / CANONICAL REPOSITORY CHECKPOINT  
**Date:** 2026-09-27  
**Repository:** `faridfatollahi-cloud/frdops-site`  
**Domain:** `frdops.ir`

## Governance

- Sole canonical governance lane: **`FRD Ops Site — Governance`** (the ChatGPT conversation designated by the repository owner).
- Repository owner retains ultimate ownership authority.
- DMB, WIOS, PMW, TPD, Codex, Work-mode, scheduled tasks, and other lanes have no independent governance authority over this repository.
- External lanes may read/propose, or execute explicitly authorized bounded work only.

## Repository purpose

Public, project-neutral identity/compliance site for `frdops.ir`.

First application:
- `FRD Drive Automation`
- intended as the permanent personal Google Drive/Docs OAuth/API foundation that DMB, WIOS, and other projects may consume independently under their own project-level boundaries.

This repository does not own or store those projects' operational state.

## Current OAuth program state

### PDA-R1 — PASS by operator attestation

- neutral Google Cloud project created: `FRD Drive Automation`;
- Google Drive API enabled;
- Google Docs API enabled;
- Google Auth Platform configured as External;
- baseline requested Drive scope: `https://www.googleapis.com/auth/drive.file`;
- qualification desktop OAuth client created;
- secret-bearing credential material retained privately by the owner and excluded from this repository.

### PDA-R1B — PASS / CLOSED

Completed:
- `frdops.ir` registered and active;
- public site repository initialized;
- GitHub Pages enabled from `main` / repository root;
- Cloudflare Free zone authoritative for `frdops.ir`;
- authoritative nameservers `arturo.ns.cloudflare.com` and `june.ns.cloudflare.com` delegated through IRNIC;
- GitHub personal-account Pages domain ownership for `frdops.ir` verified by DNS TXT challenge;
- repository-level custom domain bound to `frdops.ir`;
- repository root `CNAME` contains exact value `frdops.ir`;
- Cloudflare DNS contains the four GitHub Pages apex `A` records, DNS-only: `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`;
- Cloudflare DNS contains `www` CNAME → `faridfatollahi-cloud.github.io`, DNS-only;
- GitHub verification TXT retained;
- Google Search Console Domain property ownership for `frdops.ir` verified by DNS/domain-name-provider verification;
- Google Search Console verification TXT retained;
- operator screenshots confirm all four intended public HTTPS pages render correctly;
- GitHub Pages operator screenshot shows `Enforce HTTPS` enabled;
- Google Auth Platform Branding saved successfully with exact app-specific HTTPS URLs and authorized domain `frdops.ir`;
- Developer contact information is populated;
- App logo intentionally omitted.

Final Branding values:
- Application homepage: `https://frdops.ir/drive-automation/`
- Privacy Policy: `https://frdops.ir/drive-automation/privacy/`
- Terms of Service: `https://frdops.ir/drive-automation/terms/`
- Authorized domain: `frdops.ir`

### PDA-R2 — PASS / CLOSED

Operator screenshot on 2026-09-27 confirms:
- Google Auth Platform publishing status: **In production**;
- Audience: **External**;
- UI offers `Back to testing`, evidencing the Production transition completed.

### PDA-R3 — PASS / CLOSED

A fresh Production-state offline authorization was created for the qualification desktop OAuth client, restricted to `https://www.googleapis.com/auth/drive.file`, stored in private DPAPI CurrentUser-protected local credential storage, and proven capable of unattended refresh without exposing secret values.

#### PDA-R3-A0 — CONSUMED / PRECONDITION_FAILED / ZERO-PROVIDER

- script: `PDA_R3_PRODUCTION_OAUTH_BOOTSTRAP_A0.ps1`;
- parser gate: `PARSER_ERROR_COUNT=0`;
- SHA-256: `9F092CD5BC65C391C25D516CB046799F153BEF5C70DC125ED4C6DE992CB8EBA8`;
- failed locally because it assumed a normalized client-JSON basename;
- no provider interaction, token creation, credential persistence, or Drive mutation occurred.

#### PDA-R3-A1 — PASS / CONSUMED

- script: `PDA_R3_PRODUCTION_OAUTH_BOOTSTRAP_A1.ps1`;
- parser gate: `PARSER_ERROR_COUNT=0`;
- frozen SHA-256: `3CFAE9EA6B10F96270824431600F125778EEAFC154B02FEC61E5497D25DE9E79`;
- requested/granted scope exactly `https://www.googleapis.com/auth/drive.file`;
- `REFRESH_TOKEN_PRESENT=True`;
- `DPAPI_CURRENT_USER_ROUNDTRIP=PASS`;
- `UNATTENDED_REFRESH=PASS`;
- `DRIVE_MUTATION_PERFORMED=False`;
- qualification client JSON SHA-256: `88C2C2DE34257CCECE9E944E084B81AB0E14DE76DA4D2957C781F674BC386EAF`;
- credential ciphertext SHA-256: `8EEE8866414807131C9E0203362CAA72D0FC8EC5F02A5BE390CB2C456625B303`;
- sanitized local receipt SHA-256: `FE7B95D06F3CA8322B29B362924877B62A3B9C3BCEE6C0B564845F5DBE094D1D`;
- no access token, refresh token, client secret, authorization code, or credential plaintext was exposed.

### PDA-R4 — CURRENT / A0 CONSUMED RUNTIME_FAILED / A1 PREPARED

Purpose: qualify the permanent Production OAuth foundation against the actual Drive/Docs primitives required by downstream projects, using only disposable app-created qualification objects and the already-proven `drive.file` grant.

R4 is not a DMB Production promotion and must not target existing DMB/WIOS project objects.

#### PDA-R4-A0 — CONSUMED / RUNTIME_FAILED / PARTIAL DISPOSABLE MUTATION

Frozen artifact:
- script: `PDA_R4_CORE_DRIVE_DOCS_CAS_A0.ps1`;
- parser gate: `PARSER_ERROR_COUNT=0`;
- frozen SHA-256: `A59D855C086C6E3FA71BE553F5618F3E765DEBCA06AB7ADAFC9738922772A790`.

Observed execution evidence:
- `PRE_PROVIDER_VALIDATION=PASS`;
- requested scope remained exactly `https://www.googleapis.com/auth/drive.file`;
- accepted R3 credential hash match: PASS;
- accepted R3 receipt hash match: PASS;
- local A0 start marker was written, therefore A0 is consumed and must not be rerun;
- execution then reached the first Docs API read call and failed locally under StrictMode because an expandable-string URL used `$encodedId?includeTabsContent=true`, which PowerShell interpreted as a variable named `$encodedId?includeTabsContent` rather than the intended `$encodedId` followed by a query string.

Provider/mutation reconciliation from deterministic script order:
- unattended OAuth refresh completed before the failure;
- one fresh disposable A0 qualification folder was created through Drive API;
- one fresh native Google Doc was created inside that A0 folder;
- failure occurred before the first Docs document read completed;
- no CAS write was attempted;
- no stale-CAS test was attempted;
- no raw/blob object was created or uploaded;
- no final A0 receipt was written;
- the A0 folder/doc residue is intentionally retained and must not be manually modified or deleted until a dedicated reconciliation/cleanup step records it.

Root-cause audit found the same expandable-string boundary defect at four URL sites where a variable was immediately followed by `?`, plus one defensive correction where a variable was immediately followed by `::`. A1 corrects the whole defect class, not only the first observed line.

#### PDA-R4-A1 — PREPARED / NOT YET FROZEN

A1 is a fresh successor and must not reuse A0 identity or objects.

Candidate artifact:
- script: `PDA_R4_CORE_DRIVE_DOCS_CAS_A1.ps1`;
- candidate SHA-256 before operator-side parser/hash confirmation: `12EEE3C68B9C80502BD48CA44B68C9618814D256E70452019188188E2D0B5C28`.

A1 properties:
- preserves the accepted R3 credential/hash bindings and `drive.file` scope;
- requires the consumed A0 local start marker and absence of an A0 final receipt;
- explicitly leaves A0 Drive residue untouched;
- creates a brand-new A1 disposable qualification namespace;
- fixes all identified PowerShell variable/query-string boundary defects using explicit subexpressions;
- retains the same intended acceptance matrix: refresh-only auth, folder creation, native Doc creation and exact parent binding, successful Docs CAS write, stale-CAS HTTP 400 with no mutation, second valid CAS write, final readback, raw blob create/upload/download, exact parent binding, and byte-for-byte SHA-256 equality;
- keeps private object IDs only in the local private receipt and prints only sanitized hashes/statuses.

A1 must receive a whole-file PowerShell parser gate and operator-side SHA-256 match before any provider execution is authorized.

#### PDA-R4-A2+ — PLANNED AFTER CORE PASS

Subject to a core R4 PASS:
- blob revision creation/list/get and deterministic earlier-revision readback;
- Google Workspace document revision metadata/export qualification where stable and applicable;
- restart/recovery and ambiguous-outcome reconciliation;
- wrong-root / wrong-object / cross-project target rejection;
- credential-revocation/fail-closed behavior using a separately governed method;
- Drive Desktop independence checks;
- dedicated reconciliation/cleanup of consumed qualification residue;
- then DMB-specific target qualification before the final DMB A–E audit/promotion decision.

## Security invariants

- No OAuth/client secrets in this repository.
- No credential JSON contents.
- No access or refresh tokens.
- No private Drive content.
- No DMB/WIOS/private project runtime state.
- No fabricated Google verification or production-status claims.
- Public website and public policy text must describe the actual deployed behavior.
- Qualification mutations must be confined to disposable app-created objects until a later project-specific promotion gate explicitly authorizes otherwise.

## Final public routes

- `https://frdops.ir/`
- `https://frdops.ir/drive-automation/`
- `https://frdops.ir/drive-automation/privacy/`
- `https://frdops.ir/drive-automation/terms/`

## Next logical action

Place `PDA_R4_CORE_DRIVE_DOCS_CAS_A1.ps1` in the private FRD Drive Automation scripts directory and perform only the whole-file PowerShell parser gate plus SHA-256 check. Do not rerun A0, do not execute A1 before its hash is frozen, and do not manually touch the A0 Drive residue.