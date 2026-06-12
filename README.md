# amazing_tenant_connect

**CR_123 — RE Contract Outbound API (OData V4)**

Read-only OData V4 API that exposes SAP RE-FX (Flexible Real Estate) contract
data and its related master/transaction data to a third-party consumer.
Derived from the functional spec *CR_123 — Extract RE Contract* (re-implemented
as a service API instead of the original FTP file extract).

## Architecture

Read-only data exposure → **CDS view entities + Service Definition + Service
Binding (OData V4 – Web API)**. No RAP behaviour definition: the requirement is
extract-only, so a managed/unmanaged BO would be over-engineering.

```
VICNCN / JEST / VIBPOBJREL / BUT000 / VIBDRO / VIBDOBJASS / VIBDMEAS / VIBDBE / T001
        │  (interface views ZI_RE_*)
        ▼
   ZI_RE_Contract (root) ─ assoc ─► ZI_RE_BPRelation ─► ZI_RE_BusinessPartner
        │                                ZI_RE_RentalObject ─► ZI_RE_Measurement
        │                                ZI_RE_BusinessEntity / ZI_RE_Company
        ▼  (projection views ZC_RE_*)
   ZAPI_RE_CONTRACT (service definition) ─► ZAPI_RE_CONTRACT_O4 (OData V4 Web API)
```

## Platform note

OData V4 + CDS view entities + service bindings require **S/4HANA (on-prem
2020+) or ABAP Cloud**. The FS references ECC 6, which only supports OData V2
via SEGW. This build assumes an S/4HANA target; if the target is genuinely
ECC 6 it must be re-built as OData V2 / SEGW.

## Objects

| Type | Name | Folder |
|------|------|--------|
| Service Binding (OData V4 Web API) | ZAPI_RE_CONTRACT_O4 | service_bindings/ |
| Service Definition | ZAPI_RE_CONTRACT | service_definitions/ |
| CDS projection views (7) | ZC_RE_* | cds/ |
| CDS interface views (7) | ZI_RE_* | cds/ |
| Access controls (5) | ZI_RE_*.dcl | access_controls/ |
| ABAP Unit tests | ZTEST_RE_CONTRACT_CDS | tests/ |
| Code review workbook | code_review_checklist.xlsx | code_review/ |

## Exposed entity sets

`Contract`, `BPRelation`, `BusinessPartner`, `RentalObject`, `Measurement`,
`Company`, `BusinessEntity`.

Key derivations (FS §2.5): `DeletionStatus` = 'D' when system status I0076 is
active else 'A'; `SalesCollectInd` = 'Y' when SRRELEVANT = 'X' else 'N'.

## Code review

Verdict: **APPROVED** after fixes (initial review was HOLD on 1 blocker).
7 findings raised and resolved — see `code_review/code_review_checklist.xlsx`
(F-01 substring dump guard, F-02 access control on child entity sets, F-03
clean-core Tier-3 documentation, F-04 test coverage, F-05 VDM annotation).

## Transport / activation

Workbench transport (R). Landscape DEV → QAS → PRD. Prerequisite: create auth
object **ZRE_CONT** (fields BUKRS, ACTVT) in SU21.

Activation order: data elements/domains → interface views → projection views →
access controls → service definition → service binding, then **activate +
publish** the binding (Local Service Endpoint).

RITM / CR: **CR_123**
