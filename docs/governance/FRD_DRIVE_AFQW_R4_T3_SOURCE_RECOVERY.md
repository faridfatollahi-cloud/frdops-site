# FRD Drive Automation — AFQW R4-T3 Source Recovery

**Task:** `FRD-DRIVE-AFQW-R4-T3 — Core Drive/Docs/CAS Crucible`  
**Status:** `SOURCE RECOVERY COMPLETE / A1 SELECTED AS ENGINEERING BASE`  
**Recorded:** 2026-09-29

## Recovery execution

Read-only source-recovery scanner result:
- scanner SHA-256: `46DBF6FF5BE6CB682C91C6E7E10757E6F4F0B7880DD149F4A7FF229AD9F582E7`;
- PowerShell files scanned: `263`;
- provider calls: `0`;
- Google API calls: `0`;
- credential decryption: `0`;
- T3 main execution: `False`;
- recovered source execution: `False`.

## Exact source matches

### PDA-R4-A2
- expected SHA-256: `A7283E4C775989D7F1AAD1FE90B1733796A78CE3D81335D84FAC038FF7D0B26C`;
- local match count: `0`.

A2 remains preserved by governance identity but its candidate source is not present in the scanned authoritative local roots. It remains **NOT EXECUTED** and is not reconstructed by guessing.

### PDA-R4-A1 — selected engineering base
- exact local match count: `1`;
- path: `C:\AI-Orchestrator\bootstrap\FRD-Drive-Automation\scripts\PDA_R4_CORE_DRIVE_DOCS_CAS_A1.ps1`;
- SHA-256: `12EEE3C68B9C80502BD48CA44B68C9618814D256E70452019188188E2D0B5C28`;
- parser errors: `0`.

A1 is therefore the strongest locally recovered R4 implementation source for T3 engineering. Its prior attempt remains consumed and SHALL NOT be rerun. Only its exact source may be used as engineering input to a fresh T3 identity.

### PDA-R4-A0
- exact local match count: `1`;
- path: `C:\AI-Orchestrator\bootstrap\FRD-Drive-Automation\scripts\PDA_R4_CORE_DRIVE_DOCS_CAS_A0.ps1`;
- SHA-256: `A59D855C086C6E3FA71BE553F5618F3E765DEBCA06AB7ADAFC9738922772A790`;
- parser errors: `0`.

A0 remains consumed and is retained only as historical engineering evidence.

### PDA-R3-A1
- exact local match count: `1`;
- path: `C:\AI-Orchestrator\bootstrap\FRD-Drive-Automation\scripts\PDA_R3_PRODUCTION_OAUTH_BOOTSTRAP_A1.ps1`;
- SHA-256: `3CFAE9EA6B10F96270824431600F125778EEAFC154B02FEC61E5497D25DE9E79`;
- parser errors: `0`.

R3-A1 remains the accepted source of the sealed OAuth credential/refresh binding.

## Engineering decision

T3 will not attempt to recreate the missing A2 source from memory. It will derive its private/local executable from the exact recovered A1 source plus the already adjudicated A1 corrections and the frozen T3 acceptance contract.

Before generating or freezing the T3 executable, Governance requires a zero-provider **A1 Feature Map** that identifies whether the recovered A1 already contains the required Docs CAS, stale-response handling, Drive export, blob upload/download, and Drive revision surfaces. This permits bounded modification rather than wholesale rewrite.

Feature-map scanner source commit: `3ef935fe7bb85c97fa91f23652d92179892fee7d`.

The feature-map step is read-only and has no authority to execute A1, decrypt credentials, call Atria/Google, or mutate Drive.
