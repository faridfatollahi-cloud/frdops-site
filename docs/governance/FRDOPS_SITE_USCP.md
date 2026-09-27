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
- operator screenshots confirm all four intended public HTTPS pages render correctly: FRD Infrastructure root, FRD Drive Automation application homepage, Privacy Policy, and Terms of Service;
- repository review confirms the application homepage describes functionality and `drive.file` scope and links to the Privacy Policy and Terms;
- repository review confirms the Privacy Policy discloses Google user data access, use, storage/retention, sharing/disclosure, security, and revocation/user-control behavior;
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
- UI now offers `Back to testing`, evidencing the production transition completed.

Semantics:
- the permanent Auth Platform application is no longer in Testing status;
- future OAuth clients created under this same application inherit the app/project Production publishing state;
- publication itself did not mint or expose any refresh token;
- no DMB/WIOS project state or Production task was modified by this transition.

### PDA-R3 — PASS / CLOSED

Goal achieved: a fresh Production-state offline authorization was created for the existing qualification desktop OAuth client, restricted to `https://www.googleapis.com/auth/drive.file`, stored in private DPAPI CurrentUser-protected local credential storage, and proven capable of unattended refresh without exposing secret values.

#### PDA-R3-A0 — CONSUMED / PRECONDITION_FAILED / ZERO-PROVIDER

Frozen local artifact:
- script identity: `PDA_R3_PRODUCTION_OAUTH_BOOTSTRAP_A0.ps1`;
- parser gate: `PARSER_ERROR_COUNT=0`;
- script SHA-256: `9F092CD5BC65C391C25D516CB046799F153BEF5C70DC125ED4C6DE992CB8EBA8`.

Observed result:
- A0 failed during local preflight because it assumed a normalized client-JSON basename;
- failure occurred before provider interaction, browser launch, authorization-code exchange, token creation, credential persistence, or Drive mutation;
- A0 remains consumed and must not be rerun.

#### PDA-R3-A1 — PASS / CONSUMED

Frozen local artifact:
- script identity: `PDA_R3_PRODUCTION_OAUTH_BOOTSTRAP_A1.ps1`;
- parser gate: `PARSER_ERROR_COUNT=0`;
- frozen script SHA-256: `3CFAE9EA6B10F96270824431600F125778EEAFC154B02FEC61E5497D25DE9E79`.

Sanitized operator-returned evidence:
- `PRE_PROVIDER_VALIDATION=PASS`;
- requested scope exactly `https://www.googleapis.com/auth/drive.file`;
- granted scope exactly `https://www.googleapis.com/auth/drive.file`;
- `REFRESH_TOKEN_PRESENT=True`;
- `DPAPI_CURRENT_USER_ROUNDTRIP=PASS`;
- `UNATTENDED_REFRESH=PASS`;
- `DRIVE_MUTATION_PERFORMED=False`;
- qualification client JSON SHA-256: `88C2C2DE34257CCECE9E944E084B81AB0E14DE76DA4D2957C781F674BC386EAF`;
- credential ciphertext file SHA-256: `8EEE8866414807131C9E0203362CAA72D0FC8EC5F02A5BE390CB2C456625B303`;
- sanitized local receipt SHA-256: `FE7B95D06F3CA8322B29B362924877B62A3B9C3BCEE6C0B564845F5DBE094D1D`;
- `ACCESS_TOKEN_EXPOSED=False`;
- `REFRESH_TOKEN_EXPOSED=False`.

R3 acceptance:
- authorization occurred after the confirmed R2 Production transition;
- only `drive.file` was requested and granted;
- refresh credential exists and survives DPAPI CurrentUser round-trip;
- one noninteractive access-token refresh succeeded;
- no Drive mutation occurred during R3;
- no client secret, authorization code, access token, refresh token, or credential plaintext is recorded in this public repository.

### PDA-R4 — CURRENT / A0 FROZEN + AUTHORIZED

Purpose: qualify the permanent Production OAuth foundation against the actual Drive/Docs primitives required by downstream projects, using only a disposable qualification namespace and the already-proven `drive.file` grant.

R4 is not a DMB Production promotion and must not target existing DMB/WIOS project objects.

#### PDA-R4-A0 — FROZEN / AUTHORIZED FOR ONE EXECUTION

Acceptance matrix:
1. decrypt the existing DPAPI credential and obtain an access token by refresh only; no interactive browser authorization;
2. create one uniquely named disposable qualification folder through Drive API and capture its exact ID;
3. create one native Google Doc inside that exact folder using Drive API with MIME type `application/vnd.google-apps.document`;
4. read the document using Docs API and capture its `revisionId`;
5. perform a Docs `documents.batchUpdate` using `writeControl.requiredRevisionId` and verify the intended marker by readback;
6. reuse the now-stale pre-write revision ID in a second guarded write and require a fail-closed HTTP 400 result with no unintended mutation;
7. refresh the current document/revision state, perform one valid guarded update with the new revision ID, and verify final readback;
8. verify Drive metadata for the created document, including exact parent/root binding;
9. create, upload, and read back one small raw/blob file inside the same disposable qualification folder and require byte-for-byte SHA-256 equality;
10. emit only sanitized IDs/hashes/status evidence and a private local receipt; never print tokens or client-secret material;
11. retain the qualification namespace for the next R4 revision/history stage.

Frozen local artifact:
- script identity: `PDA_R4_CORE_DRIVE_DOCS_CAS_A0.ps1`;
- whole-file parser gate: `PARSER_ERROR_COUNT=0`;
- frozen script SHA-256: `A59D855C086C6E3FA71BE553F5618F3E765DEBCA06AB7ADAFC9738922772A790`.

Execution authority:
- execute exactly the parser-clean, hash-frozen A0 once with PowerShell 7 `-NoProfile -File`;
- the script is pinned to the accepted R3 credential ciphertext hash, R3 receipt hash, R3 script hash, and qualification-client-file hash;
- it must obtain authentication by refresh only and must not open a browser or mint a new OAuth grant;
- Drive mutations are authorized only for the newly created disposable `PDA-R4-A0` qualification namespace and its app-created children;
- existing DMB/WIOS/project objects remain strictly out of scope;
- when execution reaches its local attempt-start marker, `PDA-R4-A0` is consumed regardless of PASS/FAIL/BLOCKED outcome;
- do not edit, rerun, or reuse A0 after that point; return the sanitized terminal output/error for governance reconciliation.

Rationale:
- `drive.file` is accepted by both Drive API and Docs API for the required document methods;
- Docs API `writeControl.requiredRevisionId` supplies the fail-closed compare-and-set primitive needed for Control-style guarded writes: a stale required revision must not be processed and returns HTTP 400;
- revision-history/export qualification for earlier content versions remains a separate R4 substage so it can be tested deterministically without conflating it with CAS semantics.

#### PDA-R4-A1+ — PLANNED AFTER A0

Subject to A0 PASS:
- blob revision creation/list/get and deterministic earlier-revision readback;
- Google Workspace document revision metadata/export qualification where stable and applicable;
- restart/recovery and ambiguous-outcome reconciliation;
- wrong-root / wrong-object / cross-project target rejection;
- credential-revocation/fail-closed behavior using a separately governed method that does not destroy the accepted R3 evidence unexpectedly;
- Drive Desktop independence checks;
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

Execute the exact hash-frozen `PDA_R4_CORE_DRIVE_DOCS_CAS_A0.ps1` once with PowerShell 7 `-NoProfile -File`. Do not manually create or modify Drive objects before the run. After the A0 attempt-start marker is written, do not rerun A0; return the complete sanitized terminal result or sanitized error for governance review.