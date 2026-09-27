# FRD Ops Site — USCP

**Status:** CURRENT / SESSION CLOSED / R1B WAITING ON DOMAIN ACTIVATION  
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

### PDA-R1B — IN PROGRESS / EXTERNAL WAIT

- `frdops.ir` registered;
- registrar/IRNIC activation pending at session close;
- public site repository initialized and governed;
- GitHub Pages enabled from `main` / repository root;
- operator screenshot confirms GitHub Pages reports the site live at `https://faridfatollahi-cloud.github.io/frdops-site/`;
- custom domain intentionally not bound while `frdops.ir` activation/DNS remains pending;
- next after domain activation: DNS ownership verification, GitHub Pages custom-domain binding, HTTPS, Google Search Console verification, Branding URLs.

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

## Session close checkpoint — 2026-09-27

- Repository write access for the ChatGPT GitHub integration was repaired by adding `frdops-site` to the installed GitHub App's selected repositories.
- Canonical governance, security boundary, agent instructions, site skeleton, OAuth homepage, privacy policy, terms page, and static styling are committed on `main`.
- GitHub Pages is live from `main` / root at the temporary GitHub Pages URL above.
- `frdops.ir` remains the intended final domain and is still awaiting registrar/IRNIC activation at closeout.
- No custom-domain DNS records, Search Console verification, Auth Platform publication, Production-state refresh token, or DMB/WIOS OAuth migration has been performed yet.
- No DMB or WIOS repository/state was modified in this session.

## Resume point

When work resumes, first check whether `frdops.ir` is active and exposes DNS management. If active, continue PDA-R1B in this order:

1. establish the required DNS/ownership verification records;
2. verify domain ownership for GitHub Pages and Google Search Console as applicable;
3. bind `frdops.ir` to GitHub Pages and validate HTTPS;
4. complete Google Auth Platform Branding with the final public URLs;
5. only then advance PDA-R2 to `Publish app` / `In production`.

Do not broaden OAuth scopes, expose secrets, or alter DMB/WIOS production state as part of R1B.
