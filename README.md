# amazing_tenant_connect

**CR_123 — RE Contract Outbound API (OData V4)**

Read-only OData V4 API that exposes SAP RE-FX (Flexible Real Estate) contract
data and its related master/transaction data to a third-party consumer.
Derived from the functional spec *CR_123 — Extract RE Contract* (re-implemented
as a service API instead of the original FTP file extract).

## Architecture

Read-only data exposure → **CDS view entities + Service Definition + Service
Binding (OData V4 – Web API)**. No RAP behaviour definition: the requirement is
extract-only, so a managed/unmanaged BO would be over-engineering. Because the
sources are SQL-expressible, the views use `as select from` and SADL handles the
query runtime — no custom query class is required.

```
RE-FX tables (VICNCN, JEST, VIBPOBJREL, BUT000, VIBDRO, VIBDOBJASS, VIBDMEAS,
VIBDBE, TIV1B, T001) + DD07T (domain text)
        │  interface views ZI_RE_*
        ▼
   ZI_RE_Contract (root) ── associations ──► BPRelation ─► BusinessPartner
        │                                    RentalObject ─► Measurement, PartOfBuilding
        │                                    BusinessEntity, Company
        │                                    ObjectAssignment, LeasePerform
        │                                    ContractClass, ContractCategory
        ▼  projection views ZC_RE_*
   ZAPI_RE_CONTRACT (service definition) ─► OData V4 Service Binding (Web API)
```

## Platform

Target confirmed: **S/4HANA on-premise**. OData V4 + CDS view entities + service
bindings are fully supported.

## Exposed entity sets (13)

`Contract`, `BPRelation`, `BusinessPartner`, `RentalObject`, `Measurement`,
`Company`, `BusinessEntity`, `ObjectAssignment` (Lease Unit), `PartOfBuilding`
(Location), `LeasePerform`, `ContractClass`, `ContractCategory`, `ContractTheme`.

This completes the full FS data scope (the 12 legacy extract datasets) as one
canonical service; consumers shape responses via `$select` / `$expand` / `$filter`
rather than the legacy VIVO/ARC vs CRS file formats.

Key derivations (FS §2.5): `DeletionStatus` = 'D' when system status I0076 is
active else 'A'; `SalesCollectInd` = 'Y' when SRRELEVANT = 'X' else 'N'.
Reference text (PartOfBuilding, Class, Category, Theme) is filtered to English.

## Objects

| Type | Name | Folder |
|------|------|--------|
| Service Binding (OData V4 Web API) | ZAPI_RE_CONTRACT_O4 | service_bindings/ |
| Service Definition | ZAPI_RE_CONTRACT (13 entity sets) | service_definitions/ |
| CDS projection views (13) | ZC_RE_* | cds/ |
| CDS interface views (13) | ZI_RE_* | cds/ |
| Access controls (7) | ZI_RE_*.dcl | access_controls/ |
| ABAP Unit tests | ZTEST_RE_CONTRACT_CDS, ZTEST_RE_EXT_CDS | tests/ |
| Code review workbook | code_review_checklist.xlsx | code_review/ |

## Code review

Latest pass verdict: **APPROVE WITH NOTES** (no BLOCKER/CRITICAL). See
`code_review/code_review_checklist.xlsx` (Cover, Findings, Object Inventory,
Test Coverage, Transport Checklist).

Open confirm-items before activation:
- **F-02** — `ZI_RE_ContractTheme` uses placeholder domain `ZRECNTHEME`. The FS
  reads `ZRECNCAT` for both Category and Theme (likely an FS error). Confirm the
  correct theme domain with the functional team and adjust `DOMNAME`.
- **F-06** — `ZI_RE_PartOfBuilding` assumes TIV1B key/fields BUKRS/SWENR/SGEBT/
  SPRAS. Verify in SE11.
- **F-03** — DD07T (domain text) and RE-FX tables are read directly (Tier-3).
  Accepted and documented; swap to released APIs if/when available.

## Transport / activation

Workbench transport (R). Landscape DEV → QAS → PRD. Prerequisite: create auth
object **ZRE_CONT** (fields BUKRS, ACTVT) in SU21 and build the PFCG role.

Activation order: domains/data elements → interface views → projection views →
access controls → service definition → service binding, then **activate +
publish** the binding (Local Service Endpoint). External exposure (API
Management gateway, OAuth service user, rate limiting) is an ops/Basis task.

RITM / CR: **CR_123**
