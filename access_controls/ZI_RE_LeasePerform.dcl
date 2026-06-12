// =====================================================================
// Access Control (DCL) : ZI_RE_LeasePerform
// Restricts lease-perform data by company code.
// Auth object ZRE_CONT (fields BUKRS, ACTVT) — ACTVT '03' = Display.
// (+) Insert by [PERNR-REDACTED] dated 12.06.2026 for CR_123
// =====================================================================
@EndUserText.label: 'DCL - RE Lease Perform by company code'
@MappingRole: true
define role ZI_RE_LEASEPERFORM {
  grant select on ZI_RE_LeasePerform
    where ( CompanyCode ) = aspect pfcg_auth ( ZRE_CONT, BUKRS, ACTVT = '03' );
}
