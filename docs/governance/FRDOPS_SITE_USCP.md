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
- App logo intentionally omitted;
- Google Auth Platform Audience page now exposes an enabled `Publish app` control.

Final Branding values:
- Application homepage: `https://frdops.ir/drive-automation/`
- Privacy Policy: `https://frdops.ir/drive-automation/privacy/`
- Terms of Service: `https://frdops.ir/drive-automation/terms/`
- Authorized domain: `frdops.ir`

Notes:
- GitHub Pages showed a transient `DNS Check in Progress` state in the final screenshot while the site remained live over HTTPS and `Enforce HTTPS` was enabled. Do not alter the working DNS records while GitHub re-checks.
- DNSSEC remains intentionally deferred until after the OAuth production transition and first stable post-publication checkpoint unless separately authorized.

### PDA-R2 — READY / CURRENT

Target: move Google Auth Platform publishing status from `Testing` to `In production` using the enabled `Publish app` control.

Important semantics:
- Publishing status is application/project-level and applies to the OAuth clients in this Google Auth Platform app.
- This transition is required to remove the Testing-mode seven-day authorization/refresh-token lifetime for scopes beyond basic profile/sign-in scopes.
- Publication does not itself create a refresh token and does not silently authorize any new Google account or project.
- Existing secret-bearing OAuth material remains private and outside this repository.

### PDA-R3+ — NOT STARTED

After R2 succeeds:
1. create a fresh Production-state offline authorization for the qualification client;
2. prove refresh-token acquisition and unattended access-token refresh without exposing token values;
3. qualify the required Drive/Docs operation set under `drive.file` only;
4. qualify restart/recovery/fail-closed behavior and project isolation;
5. only then perform DMB-specific target qualification before DMB final A–E audit/promotion decisions.

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

PDA-R2: in Google Auth Platform → Audience, use the enabled `Publish app` control and confirm the transition to `In production`. Do not generate or expose any Production refresh token until R2 is confirmed successful. Do not alter the working Cloudflare/GitHub Pages DNS records or remove either verification TXT record.