# Atria ForgeLoop Qualification Workflow (AFQW)

**Workflow ID:** `AFQW`  
**Version:** `1.0`  
**Status:** `ACTIVE / GOVERNANCE-ADOPTED`  
**Repository:** `faridfatollahi-cloud/frdops-site`  
**Canonical governance lane:** `FRD Ops Site — Governance`  
**Initial application:** FRD Drive Automation permanent-foundation qualification  
**Recorded:** 2026-09-28

## 1. Purpose

**Atria ForgeLoop** is the formal bounded worker workflow for repetitive qualification engineering in FRD Drive Automation. It adapts the proven WIOS Gemini/Antigravity qualification pattern to this repository while preserving this repository's independent governance boundary.

The workflow exists to let a pinned Atria worker execute, inspect, document, and deterministically remediate an already-frozen qualification task without turning the semantic worker into Governance.

AFQW is not an autonomous authority. The canonical governance lane freezes the task, acceptance contract, worker identity, provider/model route, budgets, mutation boundary, evidence contract, and terminal decision space. The deterministic local controller owns execution, replay fencing, evidence integrity, budgets, timers, and terminal state. Atria is a bounded engineering/conductor/reviewer worker within that envelope.

## 2. Source pattern and provenance

AFQW is derived from the current WIOS Gemini/Antigravity qualification methodology, read-only from WIOS:

- authoritative WIOS lane USCP: `docs/governance/uscps/WIOS_GOOGLE_GEMINI_ANTIGRAVITY_WORKER_QUALIFICATION_USCP.md` on `governance/runtime-fabric-live-qualification-draft`;
- non-authoritative workspace lane: `lane/WIOS-LANE-GEMINI-ANTIGRAVITY-QUALIFICATION/workspace`;
- workspace reference commit reviewed for this workflow: `c421d38ac143a00f065422d8b60908c035a27aaf`;
- operator workflow note: `lanes/WIOS-LANE-GEMINI-ANTIGRAVITY-QUALIFICATION/notes/OPERATOR_INTERACTION_WORKFLOW_20260928.md`;
- autonomous campaign context/findings contract: `lanes/WIOS-LANE-GEMINI-ANTIGRAVITY-QUALIFICATION/notes/AUTONOMOUS_CAMPAIGN_A2_CONTEXT_AND_FINDINGS_CONTRACT_20260927.md`.

The WIOS source remains read-only and does not acquire authority over `frdops-site`. AFQW is a local governance adoption, not a mutation or promotion into WIOS.

## 3. Canonical execution topology

```text
FRD Ops Site — Governance
    |
    | freezes task / acceptance / authority / budgets / identities
    v
Deterministic local AFQW controller
    |
    +--> dedicated PowerShell 7 WORKER window
    |        |
    |        +-- bounded Atria work units
    |        +-- deterministic local qualification actions
    |        +-- bounded harness remediation
    |        +-- durable receipts/findings
    |
    +--> dedicated PowerShell 7 TASK TIMER/WATCHER window
             |
             +-- TASK ACTIVE
             +-- WORKER ACTIVE
             +-- phase / terminal-state observation
    |
    v
Sanitized evidence package + private raw state
    |
    v
FRD Ops Site — Governance
    |
    +-- PASS / FAIL / BLOCKED adjudication
```

The timer/watcher observes; it does not become an execution or governance authority.

## 4. Frozen worker binding

For the FRD Drive Automation qualification campaign:

- worker identity: `FRD-DRIVE-QUAL-ATRIA-WORKER`;
- provider/model route: exact `Atria-Dawn-Preview`;
- credential identity: `FRD-DRIVE-QUAL-ATRIA-EXEC-01`;
- private credential/control root: `C:\AI-Orchestrator\Private\WIOS\FRD-Drive-Qualification\`;
- non-secret governance/evidence root: `C:\AI-Orchestrator\Governance Files\FRD-Drive-Automation\Atria-Qualification\`;
- non-secret workspace/runtime root: `C:\AI-Orchestrator\workspaces\FRD-Drive-Automation\Atria-Qualification\`.

Secrets, DPAPI ciphertext, decrypted values, raw private provider responses, or temporary plaintext must never be copied into the Drive-shared governance/evidence or workspace roots unless the governing task explicitly defines a sanitized representation.

Credential resolution occurs only at the authorized provider-dispatch boundary. The worker/task packet receives the credential identity, never the raw key.

## 5. PowerShell 7 operator handling

Every consequential AFQW PowerShell operation follows these rules:

1. Use PowerShell 7 and identify the actual window/tab for the phase.
2. Set an explicit title where practical.
3. Keep the canonical operator block contiguous with no blank lines: `RUN IN / ACTION / PURPOSE / EFFECT-RISK / ATTEMPT STATUS / RETURN`.
4. Substantial or consequential PowerShell is saved as a `.ps1` file, whole-file parser-gated, SHA-256 frozen, then run through exact `pwsh -NoProfile -File` execution. Do not execute a consequential script before its freeze gate passes.
5. Short bounded read-only diagnostics may be pasted directly when the task contract permits it.
6. Input and result output are visibly separated inside the actual PowerShell window.
7. Consequential scripts print a conspicuous terminal result envelope such as `AFQW RESULT | <task> | <phase>`.
8. When a freeze gate and a conditionally authorized main command naturally belong together, Governance should provide both in one operator response; the main command remains conditional on explicit freeze PASS.
9. After results are returned, Governance proceeds directly to the next determinable step unless a human decision, authorization, safety/governance gate, or genuinely blocking ambiguity remains.

Default titles for this application:

- worker: `FRD Ops Site — Governance | FRD Drive Automation | Atria ForgeLoop Worker`;
- timer: `FRD Ops Site — Governance | FRD Drive Automation | Atria ForgeLoop Task Timer`.

## 6. Task identity, lifecycle, and replay fencing

Every AFQW task has a unique immutable task ID. Every provider/semantic work unit and every consequential qualification attempt beneath it also has a unique identity.

Canonical lifecycle:

`PREPARED -> FROZEN -> AUTHORIZED -> ACTIVE -> COMPLETE | FAILED | BLOCKED | UNKNOWN`

Rules:

- no semantic/provider work before the task is frozen and explicitly authorized;
- a provider-intent boundary consumes that semantic work-unit identity;
- uncertainty after provider intent is `UNKNOWN / NO REPLAY`, not an excuse to reuse the identity;
- a successor uses a fresh identity and must be justified by durable evidence;
- ambiguous external mutation outcomes require reconciliation before any action that could duplicate or conflict with them;
- `COMPLETE` is committed only after required response/evidence bytes have been durably persisted and validated;
- terminal console presentation is informative; durable receipts and ledgers control.

## 7. Deterministic controller vs. Atria worker

The deterministic controller exclusively owns:

- task and attempt identity allocation;
- preflight and freeze enforcement;
- replay fencing;
- provider/model pin verification where observable;
- mutation boundaries;
- semantic/provider budgets;
- evidence persistence and hashes;
- TASK ACTIVE / WORKER ACTIVE accounting;
- STOP/UNKNOWN enforcement;
- terminal controller state.

Atria may, only inside the frozen task envelope:

- inspect the qualification harness and sanitized evidence supplied to it;
- propose and perform bounded engineering repairs to its own task harness when the acceptance contract is unchanged;
- run authorized local deterministic tests;
- drive authorized qualification actions against dedicated disposable qualification objects;
- inspect results, identify defects, and choose the next deterministic remediation step within budget;
- produce structured findings, risks, follow-up requirements, and evidence references;
- stop and return the evidence package when the task reaches a terminal condition.

Atria may not:

- broaden OAuth scope beyond `https://www.googleapis.com/auth/drive.file`;
- change Google Auth Platform configuration;
- redefine or waive acceptance semantics;
- touch existing DMB, WIOS, or unrelated project objects;
- touch retained PDA-R4 A0/A1 residue unless a dedicated cleanup/reconciliation task explicitly authorizes it;
- make a DMB governance decision or authorize DMB Production;
- change its own provider/model binding or silently fall back;
- silently replay an uncertain or consumed semantic/provider identity;
- persist chain-of-thought/reasoning streams as decision-bearing evidence;
- declare `PERMANENT_DRIVE_FOUNDATION_FITNESS` on behalf of Governance.

Any acceptance change, scope broadening, cross-project target requirement, unresolved ambiguity, unsafe condition, exhausted budget, or governance-sensitive decision forces STOP and return to the canonical governance lane.

## 8. Stateless Atria and context-headroom contract

Atria calls are fresh and stateless. Provider conversation carry-over is never authority. Each work unit is rehydrated from fixed instructions plus the minimum durable state and exact evidence identities needed for that stage.

AFQW adopts the validated WIOS Atria operating guard as the default for `Atria-Dawn-Preview` unless a later task freezes a stricter bound:

- model context ceiling: `262144` tokens;
- configured input target: `145000` tokens;
- output reserve: `50000` tokens;
- request-packet ceiling: `120000` UTF-8 bytes.

If the packet cannot fit the frozen guard, the controller must split/repacketize from durable state or STOP. It must never silently truncate evidence.

## 9. Durable findings and evidence contract

AFQW treats model context as disposable working memory. Durable validated state controls.

Each Atria work unit records, at minimum:

- task/work-unit/attempt identity;
- requested action and resulting action;
- terminal state;
- requested and observed model identity where observable;
- important findings;
- remaining risks;
- evidence references and hashes;
- fact vs. inference classification for material findings;
- uncertainty and contradictions;
- required follow-up;
- explicit supersession links when a later finding replaces an earlier one;
- timing boundaries and worker-active duration when a provider call occurred.

For multi-work-unit tasks, findings are append-only. History is not destructively rewritten. A later synthesis must operate from durable records, not provider chat history. When the task is large enough to require synthesis, a fresh completeness/falsification pass should explicitly ask what the first synthesis missed.

Private raw provider responses/states remain in the Private plane. Sanitized documented evidence goes to the approved shared evidence/workspace plane. Provider response bytes are durably cached before `COMPLETE` is committed.

## 10. Timing contract

AFQW keeps two timing classes separate:

1. **TASK ACTIVE** — the complete elapsed duration of the top-level governed task from controller start to terminal task state.
2. **WORKER ACTIVE** — cumulative validated provider/worker lifecycle intervals only.

Worker-active accounting begins only at a durable provider-intent/lifecycle boundary and ends at the corresponding durable terminal boundary. Local parsing, hashing, file preparation, deterministic controller work, operator think time, stalls before intent, and ordinary wall-clock waiting outside a validated worker lifecycle are not mislabeled as WORKER ACTIVE.

The dedicated timer/watcher may present a HUD or live counters, but durable timer receipts remain authoritative. Presentation corruption or terminal resizing must not alter the recorded timing evidence.

## 11. Remediation-loop rule

The `ForgeLoop` in AFQW is intentionally bounded:

`observe -> classify -> repair locally -> parser/hash/freeze -> retry with fresh identity -> verify -> persist`

The loop is allowed only when the failure is an implementation defect inside the task's mutable harness surface and the frozen acceptance contract remains unchanged.

The loop stops immediately when:

- the next action would change acceptance semantics or OAuth scope;
- the next action would touch an unauthorized object/root;
- provider outcome is ambiguous and unreconciled;
- a consumed identity would need to be replayed;
- a frozen budget is exhausted;
- the failure surface changes into a governance/architecture decision;
- evidence cannot be persisted safely or completely.

Governance should not waste operator turns on filler. Within the frozen envelope, deterministic continuation is preferred over repeated manual approval prompts.

## 12. FRD Drive qualification acceptance envelope

AFQW initially serves PDA-R4. Unless a later frozen task narrows the stage, the permanent-foundation qualification is working toward evidence for:

1. existing DPAPI credential decrypt + unattended refresh only, without browser/new grant;
2. unique disposable qualification namespace creation;
3. native Google Doc creation in the exact authorized parent;
4. Docs read and `revisionId` capture;
5. valid revision-guarded write and readback;
6. stale revision-guarded write rejection without mutation;
7. subsequent valid guarded update and verification;
8. Drive metadata exact parent binding;
9. raw/blob create/upload/readback with byte SHA-256 equality;
10. sanitized outputs + private authoritative receipt/evidence;
11. retained qualification namespace for governed follow-on/reconciliation;
12. later revision/recovery/failure-mode and project-boundary qualification as separately frozen tasks.

PDA-R4 A0 and A1 remain consumed and must not be rerun. Their residue is outside ordinary AFQW mutation authority.

## 13. Task-packet minimum fields

Every AFQW task packet must freeze at least:

- task ID and version;
- purpose and governing acceptance requirement;
- worker/provider/model/credential identities;
- mutable and immutable surfaces;
- allowed local/provider/Drive actions;
- forbidden actions;
- semantic/provider and mutation budgets;
- preflight requirements;
- exact input/evidence identities where available;
- parser/hash/freeze requirements for consequential scripts;
- replay/UNKNOWN rules;
- timer boundaries;
- durable evidence/receipt locations;
- terminal states and STOP conditions;
- next-governance return contract.

A task packet is not executable merely because it exists. It must independently reach `FROZEN / AUTHORIZED` under this repository's canonical Governance.

## 14. Governance return and final decision

AFQW returns evidence; it does not make the repository's final acceptance decision.

For FRD Drive Automation, Governance alone adjudicates:

`PERMANENT_DRIVE_FOUNDATION_FITNESS = PASS | FAIL | BLOCKED`

That decision does not adjudicate DMB Gates A-E and does not authorize DMB Production. DMB Governance 3 remains the authority for DMB-specific reconciliation, final cross-gate audit, and Production decisions.
