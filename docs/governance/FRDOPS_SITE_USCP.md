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
- `frdops.ir` registered;
- operator screenshots on 2026-09-27 confirm the domain is approved/active;
- public site repository initialized;
- GitHub Pages enabled from `main` / repository root;
- operator screenshot confirms GitHub Pages reports the site live at `https://faridfatollahi-cloud.github.io/frdops-site/`;
- Cloudflare Free zone created for `frdops.ir`;
- assigned authoritative nameservers: `arturo.ns.cloudflare.com` and `june.ns.cloudflare.com`;
- operator screenshot confirms both nameservers were submitted successfully at IRNIC with no glue IPs;
- operator used Cloudflare's nameserver-check action after IRNIC submission.

Current DNS state:
- Cloudflare currently reports `Waiting for your registrar to propagate your new nameservers` and is checking delegation periodically;
- Cloudflare's UI states this typically takes 1–2 hours and may take up to 24 hours depending on the registrar;
- no apex/`www` GitHub Pages records have been added yet;
- no custom-domain binding has been performed yet;
- DNSSEC remains intentionally off during delegation transition.

Planned remaining R1B sequence:
1. wait for Cloudflare zone status to become Active;
2. verify ownership for GitHub Pages;
3. bind `frdops.ir` as the GitHub Pages custom domain;
4. configure apex and `www` DNS records for GitHub Pages;
5. verify Google Search Console Domain property;
6. enable/verify HTTPS;
7. populate Google Auth Platform Branding URLs and authorized domain.

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

Wait for Cloudflare to detect the IRNIC delegation and mark `frdops.ir` Active. Do not change DNS records, OAuth secrets, or the existing DMB/WIOS repositories while delegation is pending. Once Active, proceed with GitHub Pages ownership/custom-domain DNS, Search Console verification, HTTPS, and Auth Platform Branding.
