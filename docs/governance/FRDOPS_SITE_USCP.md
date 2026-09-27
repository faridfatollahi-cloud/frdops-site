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
- repository-level custom domain set to `frdops.ir`;
- repository root `CNAME` exists with exact content `frdops.ir`;
- Cloudflare DNS contains the four GitHub Pages apex `A` records, all DNS-only: `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`;
- Cloudflare DNS contains `www` CNAME → `faridfatollahi-cloud.github.io`, DNS-only;
- GitHub verification TXT remains present;
- GitHub Pages now reports **DNS check successful**.

Current DNS/custom-domain/HTTPS state:
- GitHub ownership verification is complete;
- repository-level custom-domain binding is present and DNS-valid;
- GitHub TLS certificate provisioning has started; operator screenshot shows stage `1 of 3` / `Certificate Requested`;
- `Enforce HTTPS` is not yet available until certificate issuance completes;
- Google Search Console Domain property has not yet been verified;
- DNSSEC remains intentionally off until the Pages/custom-domain/HTTPS path is stable.

Planned remaining R1B sequence:
1. while GitHub provisions TLS, verify Google Search Console Domain property for `frdops.ir` using Google's DNS TXT challenge in Cloudflare;
2. keep the Google verification TXT after successful verification;
3. wait for GitHub Pages TLS certificate provisioning to complete;
4. enable `Enforce HTTPS` once available and verify the custom-domain site over HTTPS;
5. populate Google Auth Platform Branding URLs and authorized domain using the final HTTPS routes;
6. complete Branding prerequisites and unblock PDA-R2.

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

Verify `frdops.ir` as a Google Search Console Domain property using Google's exact DNS TXT challenge in Cloudflare while GitHub Pages TLS provisioning continues. Do not alter the working GitHub `A`/`CNAME` records or remove either verification TXT record. After certificate issuance completes, enable `Enforce HTTPS`, validate the final routes, then complete Google Auth Platform Branding.