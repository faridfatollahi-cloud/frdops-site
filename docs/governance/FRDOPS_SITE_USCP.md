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

### PDA-R3 — CURRENT / PREPARED / NOT YET EXECUTED

Goal: create a fresh Production-state offline authorization for the existing qualification desktop OAuth client and prove unattended token refresh without exposing secret values.

Preparation evidence:
- operator attests the downloaded qualification-client `Auth.json` has been moved from its download location into a dedicated private, non-Drive-synced local bootstrap subtree reserved for FRD Drive Automation;
- the public repository records no client JSON contents, tokens, client secret, or private local credential values;
- the permanent OAuth bootstrap will use a dedicated subtree rather than reuse historical Drive API experiment directories.

Required properties:
1. authorization must occur after the confirmed R2 Production transition;
2. requested Drive scope remains only `https://www.googleapis.com/auth/drive.file`;
3. request offline access so a refresh token is returned;
4. credential/token material remains only in private local credential storage and is never committed to this repository, placed in Drive, or pasted into chat;
5. return only sanitized evidence such as scope, presence/absence of a refresh token, HTTP/result status, and timestamps;
6. prove at least one access-token refresh from the stored refresh token without interactive consent;
7. preserve the qualification client as qualification infrastructure until later governance decides whether to mint final per-project Production clients.

### PDA-R4+ — NOT STARTED

After R3 passes:
1. qualify the required Drive/Docs operation set under `drive.file` only using a disposable non-Production Drive namespace;
2. qualify restart/recovery/fail-closed behavior and project isolation;
3. only then perform DMB-specific target qualification before DMB final A–E audit/promotion decisions.

## Security invariants

- No OAuth/client secrets in this repository.
- No `Auth.json`/credential JSON.
- No access or refresh tokens.
- No private Drive content.
- No DMB/WIOS/private project runtime state.
- No fabricated Google verification or production-status claims.
- Public website and public policy text must describe the actual deployed behavior.

## Final public routes

- `https://frdops.ir/`
- `https://frdops.ir/drive-automation/`
- `https://frdops.ir/drive-automation/privacy/`
- `https://frdops.ir/drive-automation/terms/`

## Next logical action

PDA-R3: execute a parser-gated local Production OAuth bootstrap from the dedicated private FRD Drive Automation subtree, requesting only `drive.file`, storing the resulting refresh credential in DPAPI CurrentUser-protected local storage, then perform one sanitized unattended refresh proof. Do not yet perform Drive mutations or create final DMB/WIOS Production OAuth clients.