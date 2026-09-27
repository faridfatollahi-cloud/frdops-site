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

### PDA-R1B — IN PROGRESS

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
- repository-level custom domain has now been set to `frdops.ir`;
- repository root `CNAME` exists with exact content `frdops.ir`.

Current DNS/custom-domain state:
- GitHub account-level ownership verification is complete;
- verification TXT must remain in Cloudflare DNS;
- repository-level custom-domain binding is present;
- GitHub currently reports DNS check unsuccessful / `NotServedByPagesError` because the apex/alternate DNS records do not yet resolve to GitHub Pages;
- apex GitHub Pages `A` records and `www` CNAME are the immediate missing configuration;
- Google Search Console Domain property has not yet been verified;
- DNSSEC remains intentionally off until the Pages/custom-domain/HTTPS path is stable.

Planned remaining R1B sequence:
1. in Cloudflare DNS add apex GitHub Pages `A` records, initially DNS-only: `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`;
2. add `www` CNAME → `faridfatollahi-cloud.github.io`, initially DNS-only;
3. wait for DNS propagation and use GitHub Pages `Check again` until the custom-domain check passes;
4. verify Google Search Console Domain property using Google's DNS TXT challenge;
5. verify GitHub Pages HTTPS/certificate and enable Enforce HTTPS;
6. populate Google Auth Platform Branding URLs and authorized domain.

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

Add the exact GitHub Pages apex `A` records and `www` CNAME in Cloudflare DNS with proxying disabled initially, retain the GitHub verification TXT record, then re-run the GitHub Pages DNS check after propagation.