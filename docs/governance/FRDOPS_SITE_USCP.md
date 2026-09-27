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
- Cloudflare nameserver check completed;
- operator screenshot on 2026-09-27 confirms Cloudflare now recognizes the delegation and reports the domain protected/Active.

Current DNS state:
- Cloudflare is now authoritative for `frdops.ir`;
- no apex/`www` GitHub Pages records have been added yet;
- no GitHub Pages custom-domain binding has been performed yet;
- GitHub account-level domain ownership verification has not yet been performed;
- DNSSEC remains intentionally off until the GitHub Pages/custom-domain/HTTPS path is stable.

Planned remaining R1B sequence:
1. verify `frdops.ir` ownership in GitHub account-level Pages settings using GitHub's generated DNS TXT challenge;
2. bind `frdops.ir` as the `frdops-site` GitHub Pages custom domain;
3. configure apex and `www` DNS records in Cloudflare for GitHub Pages, initially DNS-only;
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

Perform GitHub account-level Pages domain ownership verification for `frdops.ir`: GitHub Profile Settings → Pages → Add a domain → `frdops.ir`; copy the exact generated TXT challenge into Cloudflare DNS; retain the TXT record after successful verification. Do not invent the TXT value and do not yet add apex/`www` GitHub Pages records until ownership verification is complete.
