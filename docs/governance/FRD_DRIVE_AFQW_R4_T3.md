# FRD Drive Automation — AFQW R4-T3 — Core Drive/Docs/CAS Crucible

**Task ID:** `FRD-DRIVE-AFQW-R4-T3`  
**Task name:** `Core Drive/Docs/CAS Crucible`  
**Workflow:** `AFQW v1.1`  
**Status:** `DESIGN FROZEN / EXECUTABLE NOT YET FROZEN / EXTERNAL MUTATION AUTHORIZATION REQUIRED`  
**Canonical governance lane:** `FRD Ops Site — Governance`  
**Recorded:** 2026-09-28

## Purpose
R4-T3 is the first AFQW task authorized in design to exercise the permanent FRD Drive Automation Google foundation with fresh disposable qualification objects. It succeeds the closed R4-T2 credential-bridge task.

R4-T3 is limited to the permanent Drive/Docs/OAuth foundation. It does not enter DMB governance, does not touch DMB/WIOS production or governance objects, and does not adjudicate the final DMB cross-gate audit.

## Prerequisites — satisfied
- PDA-R3-A1 is PASS/CLOSED under exact `drive.file` scope.
- AFQW R4-T0 is PASS/CLOSED.
- AFQW R4-T1 Atria Dispatch Seal is PASS/CLOSED.
- AFQW R4-T2 R3 Credential Bridge Seal is PASS/CLOSED.
- Accepted R3 credential file SHA-256: `8EEE8866414807131C9E0203362CAA72D0FC8EC5F02A5BE390CB2C456625B303`.
- Accepted T2 binding receipt SHA-256: `8F7F948D33B6E62FB8DB81E9D74878ECAB023BA1540876103ED99FDF40DD8314`.
- Accepted T2 final receipt SHA-256: `8719D25C96E3A82E0DCCFEC011554FD042734E2BF2569BB930A28F0B20D99836`.

## Sealed credential contract
The Google controller must use exactly:

`qual-oauth.dpapi JSON envelope -> ciphertext -> Base64 decode -> DPAPI CurrentUser Unprotect(NULL entropy) -> UTF-8 credential JSON`

The decrypted schema must contain `client_id`, `client_secret`, `refresh_token`, exact `scope=https://www.googleapis.com/auth/drive.file`, and exact `token_uri=https://oauth2.googleapis.com/token`.

No browser grant, new OAuth consent, scope broadening, plaintext persistence, or alternate credential source is allowed.

## Fresh attempt lineage
The first executable attempt, once frozen and explicitly authorized, will use a fresh identity under:
- task `FRD-DRIVE-AFQW-R4-T3`;
- attempt lineage `FRD-DRIVE-AFQW-R4-T3-A0`;
- disposable namespace name beginning `AFQW-R4-T3-A0-` plus a fresh nonce/timestamp.

No prior PDA-R4 A0/A1 or AFQW T0/T1/T2 attempt identity may be reused.

## Atria role
Atria remains a bounded conductor/reviewer under the already-qualified exact route `Atria-Dawn-Preview`. It has no direct governance authority and no authority to broaden the task.

The deterministic local controller remains the sole authority for:
- Google request execution;
- provider/Google intent records;
- replay fencing;
- object IDs and recovery state;
- API budgets;
- durable evidence;
- terminal task state.

Atria is not permitted to receive Google OAuth secret/token values or private Drive content. Any Atria task packet must contain only sanitized acceptance criteria and non-secret evidence.

## R4-T3 core acceptance matrix
A PASS candidate must demonstrate all of the following within a fresh disposable namespace:

1. **Unattended refresh**
   - use the sealed R3 credential binding;
   - no browser/OAuth interaction;
   - no scope broadening;
   - credential file remains unchanged.

2. **Disposable namespace**
   - create one uniquely named Drive folder;
   - retain its exact object ID privately for reconciliation/recovery;
   - do not clean it up in the same attempt.

3. **Native Google Doc**
   - create one native Google Doc inside the exact disposable folder;
   - read it through Docs API and capture `revisionId`.

4. **CAS write 1**
   - perform a valid Docs `batchUpdate` guarded by `writeControl.requiredRevisionId`;
   - read back and verify the inserted marker;
   - verify the revision advanced.

5. **Stale CAS failure semantics**
   - reuse the stale pre-write revision;
   - expected result is HTTP `400`;
   - verify the stale marker did not appear;
   - verify the current revision did not advance because of the rejected stale write.

6. **CAS write 2**
   - perform a second valid guarded write against the fresh revision;
   - read back and verify both valid markers;
   - verify revision advancement.

7. **Drive parent authority**
   - Drive metadata must show the Doc has exactly the disposable folder as its parent.

8. **Native Doc export / revision evidence**
   - export the Doc to a stable textual representation and verify both valid markers;
   - collect Drive revision metadata where the API exposes it reliably; absence of unsupported native historical byte download is not itself a failure.

9. **Binary blob integrity**
   - create one blob file inside the exact disposable folder;
   - upload deterministic V1 bytes;
   - download current bytes and prove SHA-256 equality.

10. **Blob revision semantics**
    - identify the V1 blob revision;
    - retain/pin it where required by Drive semantics;
    - upload deterministic V2 bytes;
    - verify current V2 download SHA-256 equality;
    - list revisions and verify the head advanced;
    - read back the V1 revision deterministically and prove its SHA-256 equals the original V1 bytes.

11. **Evidence and isolation**
    - exact object IDs are retained only in the private qualification runtime;
    - shared Governance/Workspace evidence contains only sanitized fields and object-ID hashes;
    - no secret/token/client-secret values are persisted or shared;
    - PDA-R4 A0/A1 residue is untouched;
    - DMB/WIOS objects are untouched;
    - no cleanup is performed in this attempt.

## Intent / ambiguity / replay contract
Every externally mutating Google request must have a durable mutation-intent record before send.

- A known HTTP response may be adjudicated deterministically against the frozen expectation.
- A transport failure after a durable mutation intent is an `UNKNOWN` outcome for that operation/attempt; the same semantic mutation must not be silently replayed.
- Unique namespace/object naming and private exact-ID retention are mandatory so a later recovery task can reconcile an ambiguous outcome read-only before any successor mutation.
- No automatic semantic retry is permitted.

The same no-replay rule applies to any Atria provider work-unit identity used by R4-T3.

## Timing contract
- `TASK ACTIVE` = durable R4-T3 attempt start through terminal task receipt.
- `WORKER ACTIVE` = validated Atria provider lifecycle only; it is not controller/Google wall time.
- Google controller activity must not be mislabeled as Atria WORKER ACTIVE.
- the task timer is observational; durable receipts are authoritative.

## API / mutation budgets
The executable freeze must declare finite budgets before authorization. The design ceiling is:
- Atria semantic calls: at most `1` pre-execution review work unit for A0;
- OAuth refresh: `1`;
- browser OAuth: `0`;
- Drive API calls: bounded to the exact frozen operation sequence;
- Docs API calls: bounded to the exact frozen operation sequence;
- cleanup/delete calls: `0`.

Any budget exhaustion is terminal and returns to Governance.

## Stop conditions
Stop and return to Governance without broadening if any of the following occurs:
- exact R3/T2 continuity hash mismatch;
- scope or token endpoint mismatch;
- Atria model/route mismatch or ambiguous provider outcome;
- Google mutation transport ambiguity;
- stale CAS does not return the frozen expected semantics;
- exact-parent check fails;
- byte/revision integrity fails;
- cross-project or non-disposable object is required;
- a new browser grant or broader scope appears necessary;
- evidence integrity is uncertain.

## Follow-on stages
R4-T3 is the **core capability** stage only. PASS does not yet by itself establish terminal `PERMANENT_DRIVE_FOUNDATION_FITNESS=PASS`.

A later AFQW resilience stage must still cover the remaining frozen matrix such as restart/recovery, ambiguous-outcome reconciliation, bounded idempotency, wrong-root/wrong-object rejection, credential-revocation/fail-closed behavior using a safe governed method, and Drive Desktop independence where applicable.

## Human authorization gate
R4-T3 is the first upcoming stage that will intentionally create and mutate new Google Drive/Docs objects. Therefore executable-script freeze may be prepared without external mutation, but **main R4-T3 execution requires explicit owner authorization after the exact executable hashes and mutation/API budgets are frozen**.
