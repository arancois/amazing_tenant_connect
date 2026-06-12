// =====================================================================
// Access Control (DCL) : ZI_RE_Contract
// Restricts the outbound RE contract API by company code.
// Auth object ZRE_CONT (fields BUKRS, ACTVT) — create in SU21.
// ACTVT '03' = Display (the API is read-only).
// (+) Insert by [PERNR-REDACTED] dated 12.06.2026 for CR_123
// =====================================================================
@EndUserText.label: 'DCL - RE Contract by company code'
@MappingRole: true
define role ZI_RE_CONTRACT {
  grant select on ZI_RE_Contract
    where ( CompanyCode ) = aspect pfcg_auth ( ZRE_CONT, BUKRS, ACTVT = '03' );
}
