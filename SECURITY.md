# Security Policy

This is a public static-site repository. It must never contain operational credentials or private project data.

## Never disclose here

Do not commit or paste into this repository, issues, pull requests, or public discussions:

- OAuth client secrets;
- `Auth.json` or equivalent credential files;
- access tokens or refresh tokens;
- private Google Drive files/content;
- private DMB/WIOS/other project state;
- API keys, passwords, session secrets, or recovery material.

If secret material is accidentally exposed, treat it as compromised and rotate/revoke it through the relevant provider before any further use.

## Scope

Security changes to OAuth/public-policy claims, domain identity, or repository governance require review by the canonical `FRD Ops Site — Governance` lane or explicit repository-owner authorization.
