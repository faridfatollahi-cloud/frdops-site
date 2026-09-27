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
- operator screenshot confirms GitHub Pages reports the site live at `https://faridfatollahi-cloud.github.io/frdops-site/`.

Current DNS state:
- registrar/IRNIC panel shows no authoritative nameservers configured yet;
- no custom-domain binding has been performed yet;
- DNS provider setup is therefore the immediate next step.

Planned remaining R1B sequence:
1. establish authoritative DNS for `frdops.ir`;
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

Configure authoritative DNS for `frdops.ir`, then perform GitHub Pages ownership/custom-domain setup, Search Console verification, HTTPS, and Auth Platform Branding. Do not change OAuth secrets or the existing DMB/WIOS repositories during this work.
