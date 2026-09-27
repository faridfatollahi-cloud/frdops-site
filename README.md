# FRD Ops Site

Public identity and OAuth-compliance site for `frdops.ir`.

## Canonical governance

The sole canonical governance lane for this repository is the ChatGPT conversation designated **`FRD Ops Site — Governance`** by the repository owner.

No DMB, WIOS, PMW, TPD, Codex, Work-mode, scheduled-task, or other project/execution lane has independent governance authority over this repository. Such lanes may read the repository and may perform bounded implementation work only when explicitly authorized by `FRD Ops Site — Governance` or by the repository owner.

See [`GOVERNANCE.md`](GOVERNANCE.md) and [`docs/governance/FRDOPS_SITE_USCP.md`](docs/governance/FRDOPS_SITE_USCP.md).

## Purpose

This repository hosts the public web presence used for:

- the neutral `frdops.ir` infrastructure identity;
- the `FRD Drive Automation` OAuth application homepage;
- its privacy policy and terms of service;
- domain-based Google OAuth branding/verification support.

It is **not** an operational data store, credential store, DMB state store, WIOS state store, or cross-project control plane.

## Security boundary

Never commit OAuth client secrets, `Auth.json`, refresh/access tokens, private Drive content, project runtime state, or other credentials/secrets to this repository.

## Public routes

- `/` — FRD Infrastructure
- `/drive-automation/` — FRD Drive Automation
- `/drive-automation/privacy/` — Privacy Policy
- `/drive-automation/terms/` — Terms of Service
