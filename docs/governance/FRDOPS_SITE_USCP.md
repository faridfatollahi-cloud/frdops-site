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

### PDA-R1B — IN PROGRESS / BRANDING-READY PENDING HTTPS ENFORCEMENT CHECK

Completed:
- `frdops.ir` registered and active;
- public site repository initialized;
- GitHub Pages enabled from `main` / repository root;
- temporary Pages route live at `https://faridfatollahi-cloud.github.io/frdops-site/`;
- Cloudflare Free zone created and authoritative for `frdops.ir`;
- assigned authoritative nameservers: `arturo.ns.cloudflare.com` and `june.ns.cloudflare.com`;
- both nameservers submitted at IRNIC with no glue IPs;
- Cloudflare delegation status Active;
- GitHub personal-account Pages settings show `frdops.ir` as **Verified** after TXT challenge validation;
- repository-level custom domain set to `frdops.ir`;
- repository root `CNAME` exists with exact content `frdops.ir`;
- Cloudflare DNS contains the four GitHub Pages apex `A` records, all DNS-only: `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`;
- Cloudflare DNS contains `www` CNAME → `faridfatollahi-cloud.github.io`, DNS-only;
- GitHub verification TXT remains present;
- GitHub Pages reports **DNS check successful**;
- operator screenshot confirms Google Search Console Domain property ownership for `frdops.ir` is **Verified** using DNS/domain-name-provider verification;
- operator screenshots confirm all four intended public pages render correctly: FRD Infrastructure root, FRD Drive Automation application homepage, Privacy Policy, and Terms of Service;
- repository review confirms the application homepage describes functionality and `drive.file` scope and links to the Privacy Policy and Terms;
- repository review confirms the Privacy Policy discloses Google user data access, use, storage/retention, sharing/disclosure, security, and revocation/user-control behavior.

Current DNS/custom-domain/HTTPS state:
- GitHub ownership verification is complete;
- Search Console domain ownership verification is complete; retain the Google TXT record;
- repository-level custom-domain binding is present and DNS-valid;
- latest explicit GitHub Pages TLS evidence before the page-render screenshots showed certificate provisioning in progress; `Enforce HTTPS` has not yet been separately evidenced as enabled in this lane;
- DNSSEC remains intentionally off until the Pages/custom-domain/HTTPS path is stable.

Branding target URLs:
- Application homepage: `https://frdops.ir/drive-automation/`
- Privacy Policy: `https://frdops.ir/drive-automation/privacy/`
- Terms of Service: `https://frdops.ir/drive-automation/terms/`
- Authorized domain: `frdops.ir`
- App logo: intentionally omitted for now.

Planned remaining R1B sequence:
1. confirm GitHub Pages TLS certificate issuance is complete and enable `Enforce HTTPS` if not already enabled;
2. verify the final public HTTPS routes;
3. populate Google Auth Platform Branding with the exact URLs above and authorized domain `frdops.ir`;
4. save Branding and confirm the Audience page unblocks `Publish app`;
5. complete R1B and move to PDA-R2.

### PDA-R2 — BLOCKED ON R1B

Target: Auth Platform `Publish app` / `In production` after Branding prerequisites are complete.

### PDA-R3+ — NOT STARTED

Fresh Production-state offline authorization, refresh-token qualification, Drive/Docs operation qualification, durability/failure tests, then DMB-specific target qualification.

## Security invariants

- No OAuth/client secrets in this repository.
- No `Auth.json`/credential JSON.
- No access or refresh tokens.
- No private Drive content.
- No DMB/WIOS/private project runtime state.
- No fabricated Google verification or production-status claims.
- Public website and public policy text must describe the actual deployed behavior.

## Domain/site target

Current temporary public Pages route:
- `https://faridfatollahi-cloud.github.io/frdops-site/`

Expected final public routes:
- `https://frdops.ir/`
- `https://frdops.ir/drive-automation/`
- `https://frdops.ir/drive-automation/privacy/`
- `https://frdops.ir/drive-automation/terms/`

## Next logical action

Check `frdops-site` → Settings → Pages and confirm `Enforce HTTPS` is enabled/available. Then complete Google Auth Platform Branding using the exact app-specific HTTPS URLs and authorized domain `frdops.ir`. Do not alter the working GitHub `A`/`CNAME` records or remove either verification TXT record.