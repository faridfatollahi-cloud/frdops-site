# FRD Ops Site Governance

## 1. Canonical authority

The repository owner has designated one canonical governance lane for this repository:

**`FRD Ops Site — Governance`**

This ChatGPT conversation is the sole standing governance lane for `faridfatollahi-cloud/frdops-site` unless the repository owner explicitly supersedes that designation.

The repository owner retains ultimate account/repository ownership authority.

## 2. Other lanes

DMB, WIOS, PMW, TPD, Codex, Work-mode, scheduled tasks, automation runners, and any future project or execution lane are **non-governing consumers/executors** with respect to this repository.

They may:
- read public repository material;
- propose changes;
- perform explicitly bounded implementation tasks when authorized.

They may not, without explicit authorization from `FRD Ops Site — Governance` or the repository owner:
- redefine repository purpose or architecture;
- change governance rules;
- alter OAuth/public-policy claims;
- introduce secrets or private operational state;
- repurpose the domain for another project;
- silently treat this repository as belonging to DMB, WIOS, or another project.

## 3. Repository role

`frdops-site` is public identity/compliance infrastructure for `frdops.ir` and its applications. Its first application is `FRD Drive Automation`.

The repository is deliberately **project-neutral**. DMB, WIOS, and other projects may consume the same permanent OAuth/API foundation, but none owns this repository or domain by implication.

## 4. Allowed content

Allowed:
- static public website content;
- OAuth application descriptions;
- privacy/terms/security disclosures;
- domain/DNS/public-site documentation;
- compact governance/current-state records;
- non-secret deployment configuration appropriate for a public repository.

Forbidden:
- OAuth client secrets;
- `Auth.json` or equivalent secret-bearing credential files;
- access tokens or refresh tokens;
- private Google Drive content;
- DMB/WIOS/other project runtime state;
- private receipts, credentials, or operational secrets;
- fabricated verification or compliance claims.

## 5. Change discipline

Material changes to OAuth claims, privacy/terms language, domain identity, governance, or cross-project authority require governance review before adoption.

Implementation-only changes may be delegated, but the executing lane must preserve these governance boundaries and return evidence of what changed.

## 6. Authority precedence

For this repository only:

1. explicit current instruction from the repository owner;
2. current decisions of `FRD Ops Site — Governance`;
3. `docs/governance/FRDOPS_SITE_USCP.md` current-state checkpoint;
4. this governance document;
5. implementation/site files.

No external project USCP silently overrides this repository's governance.
