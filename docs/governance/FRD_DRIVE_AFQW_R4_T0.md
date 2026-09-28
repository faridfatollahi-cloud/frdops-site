# FRD Drive AFQW R4-T0 — Harness Bootstrap & Zero-Provider Qualification

**Task ID:** `FRD-DRIVE-AFQW-R4-T0`  
**Workflow:** `Atria ForgeLoop Qualification Workflow (AFQW) v1.0`  
**State:** `CANDIDATE IMPLEMENTATION PERSISTED / NOT YET FROZEN / NOT AUTHORIZED`  
**Recorded:** 2026-09-28  
**Canonical governance lane:** `FRD Ops Site — Governance`

## Purpose

Build and validate the deterministic local AFQW controller/worker/timer harness that will run the remaining PDA-R4 permanent Drive/Docs foundation qualification. T0 is deliberately **zero-provider and zero-Drive**. It establishes the execution shell, replay fencing, evidence/state schema, timer semantics, credential-reference boundary, and PowerShell 7 operator ergonomics before any new Atria semantic work unit or Google Drive/Docs API mutation is authorized.

## Governing workflow

`docs/governance/ATRIA_FORGELOOP_QUALIFICATION_WORKFLOW.md`

The workflow controls whenever this task packet is silent. Any conflict returns to `FRD Ops Site — Governance`; the task may not reinterpret AFQW.

## Frozen candidate identities

These identities are prepared for the T0 implementation and become executable only after an exact script freeze:

- task: `FRD-DRIVE-AFQW-R4-T0`;
- main attempt candidate: `FRD-DRIVE-AFQW-R4-T0-A0`;
- worker: `FRD-DRIVE-QUAL-ATRIA-WORKER`;
- exact provider/model: `Atria-Dawn-Preview`;
- credential reference: `FRD-DRIVE-QUAL-ATRIA-EXEC-01`;
- worker PowerShell title: `FRD Ops Site — Governance | FRD Drive Automation | Atria ForgeLoop Worker`;
- timer PowerShell title: `FRD Ops Site — Governance | FRD Drive Automation | Atria ForgeLoop Task Timer`.

## Credential precondition already established

The accepted Atria credential import is followed by a dedicated transient-memory remediation result:

- remediation attempt: `FRD-DRIVE-QUAL-ATRIA-CRED-A1-MEMCLEAR-R0`;
- `ATRIA_IMPORT_A1_TRANSIENT_MEMORY_REMEDIATION=PASS`;
- `BSTR_ZERO_FREED=True`;
- `TRANSIENT_ARRAYS_CLEARED=6`;
- `SECURESTRING_REFERENCE_CLEARED=True`;
- `PROVIDER_CALL_PERFORMED=False`;
- `DRIVE_API_CALL_PERFORMED=False`;
- `CREDENTIAL_FILE_CHANGED=False`.

T0 must validate only the credential **reference/path contract and non-secret metadata needed for dispatch**. It must not decrypt the provider key and must not perform a provider call.

## Authoritative roots

Private credential/control plane:

`C:\AI-Orchestrator\Private\WIOS\FRD-Drive-Qualification\`

Sanitized governance/evidence plane:

`C:\AI-Orchestrator\Governance Files\FRD-Drive-Automation\Atria-Qualification\`

Sanitized campaign workspace/runtime plane:

`C:\AI-Orchestrator\workspaces\FRD-Drive-Automation\Atria-Qualification\`

T0 may create only non-secret AFQW task state/evidence under the approved shared roots. It may read only the minimum non-secret private metadata required to prove that the frozen credential identity is addressable without decrypting it.

## T0 provider and mutation budgets

- Atria/provider semantic calls: **0**;
- Google Drive API calls: **0**;
- Google Docs API calls: **0**;
- browser/OAuth interactions: **0**;
- Drive object mutations: **0**;
- changes to PDA-R4 A0/A1 residue: **0**;
- changes to the credential file: **0**.

Any such event is an immediate T0 failure and STOP.

## Required local harness surfaces

The implementation must produce a bounded local harness containing, at minimum:

1. **controller/worker launcher** — creates/validates task runtime state, opens the dedicated worker PS7 window, enforces exact identity, and refuses provider dispatch in T0;
2. **worker shell** — loads the frozen task packet/runtime binding, validates allowed roots, emits deterministic phase/state evidence, and never decrypts the credential in T0;
3. **task timer/watcher** — separate PS7 process/window that reads durable task state, presents TASK ACTIVE and WORKER ACTIVE separately, and has no authority to mutate qualification objects or provider state;
4. **state/replay fence** — immutable task/attempt identity handling with terminal/UNKNOWN protection;
5. **timing ledger** — TASK ACTIVE full task duration plus WORKER ACTIVE intervals; T0 must prove WORKER ACTIVE stays exactly zero because no provider lifecycle begins;
6. **sanitized evidence writer** — atomic/durable task receipt and evidence manifest under the approved shared root;
7. **terminal result envelope** — conspicuous `AFQW RESULT | FRD-DRIVE-AFQW-R4-T0 | <phase>` output;
8. **zero-provider self-tests** — deterministic tests for success, blocked/invalid-root rejection, duplicate/consumed task rejection, timer parsing, terminal receipt integrity, and no-secret output scanning.

## Candidate implementation persisted in GitHub

Immutable candidate source point containing the full T0 script set:

- commit `d75a6803861aa1561682cf292e10fbd0a1304570`.

Candidate files and expected UTF-8/LF SHA-256 identities:

- `scripts/afqw/t0/FRD_AFQW_R4_T0_Worker.ps1` — `BD7C6B55A1C3B6C629D154D7AAD25D4A171CB905A6D0682EA5809B85ABFD2C16`;
- `scripts/afqw/t0/FRD_AFQW_R4_T0_TaskTimer.ps1` — `3F2F8193A1FBCB8ABA5590A40F8C7ECCBE6C84DB65C740107A945303034D45EC`;
- `scripts/afqw/t0/FRD_AFQW_R4_T0_Launch.ps1` — `9A70505AEFCB038F13FC1E3FC21524127E0D1A159D7DB354972783C7AC65C17C`;
- `scripts/afqw/t0/FRD_AFQW_R4_T0_Freeze.ps1` — `6D42E6649A4E2CE7F745CAB32F3E60D85AB570AD9CA39A9A6CE74DACA955996C`.

These are **candidate identities**, not yet accepted local delivered-file identities. The operator machine must stage the exact commit-pinned bytes, run the PowerShell 7 parser/hash gate locally, and return the result before Governance freezes/authorizes `FRD-DRIVE-AFQW-R4-T0-A0`.

The freeze candidate verifies the Worker/TaskTimer/Launch parser gates, exact hashes, and absence of a forbidden network surface. The freeze script itself must also be independently parser-gated and SHA-256 matched before it is run.

## PowerShell freeze requirements

Before any T0 main execution:

- all consequential `.ps1` files must pass the PowerShell parser with zero errors;
- exact SHA-256 identities must be recorded;
- the dedicated T0 freeze/preflight script must verify the expected files and hashes;
- freeze/preflight must itself be parser-gated and SHA-256 frozen;
- execution must use PowerShell 7 `-NoProfile -File`;
- no T0 artifact may contain an API key, OAuth refresh/access token, DPAPI plaintext, or raw private provider response.

The canonical six-field operator block is mandatory for the eventual launch instruction.

## T0 timer acceptance

T0 must demonstrate, from durable receipts rather than terminal appearance alone:

- `TASK_ACTIVE_START_UTC` and `TASK_ACTIVE_END_UTC` exist and are ordered;
- monotonic task elapsed milliseconds are non-negative and agree with the displayed `HH:MM:SS` representation within the implementation's declared rounding rule;
- `WORKER_ACTIVE_ELAPSED_MS=0`;
- no provider-intent event exists;
- timer/watcher restart or refresh does not reset authoritative elapsed state;
- timer presentation cannot mutate task/controller state.

A visible HUD is optional presentation. Receipt correctness is mandatory.

## T0 replay and terminal rules

T0 itself is a governed consequential execution identity. Once its main local start marker is durably written, that exact main-attempt identity is consumed regardless of PASS/FAIL/BLOCKED. A corrected successor must use a fresh identity.

No local defect may be hidden by overwriting an earlier terminal receipt. Additive successor evidence is required.

## T0 PASS criteria

T0 may be adjudicated PASS only when all of the following are proven:

- all parser/hash/freeze gates pass;
- exact task/worker/model/credential-reference bindings are present in durable state;
- provider/Drive/Docs/browser call counts are zero;
- no credential decryption occurs;
- WORKER ACTIVE is zero and TASK ACTIVE is valid;
- shared artifacts contain no secret material;
- replay fencing rejects reuse of a consumed/terminal identity;
- timer/watcher is observational only;
- sanitized final receipt + evidence manifest are durably written and hashable;
- no PDA-R4 A0/A1 residue or unrelated project object is touched.

## T0 terminal states

`PASS | FAIL | BLOCKED | UNKNOWN`

`UNKNOWN` is reserved for an ambiguity in a consequential external/local state transition that cannot be safely reconstructed; it is not a generic substitute for ordinary test failure.

## What T0 does not authorize

Even after T0 PASS, this packet does not itself authorize an Atria provider call or Google API mutation. Governance must freeze/authorize the first provider-bearing AFQW task separately using a fresh task identity.

Expected successor after T0 PASS: a provider-bearing PDA-R4 core Drive/Docs/CAS task that imports the existing R4 acceptance envelope while preserving the A0/A1 residue non-touch rule.

## Next governance action

Stage the exact commit-pinned T0 script set on the operator machine, run the local parser/hash gate on all four files, then run the T0 freeze gate only if those delivered-file identities match the candidate values above. Do **not** run the T0 launcher/main attempt yet. Return the local gate/freeze result to Governance for final A0 authorization.
