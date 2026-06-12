// =====================================================================
// Access Control (DCL) : ZI_RE_ObjectAssignment
// Restricts the lease-unit / object-assignment data by company code.
// Auth object ZRE_CONT (fields BUKRS, ACTVT) — ACTVT '03' = Display.
// (+) Insert by [PERNR-REDACTED] dated 12.06.2026 for CR_123
// =====================================================================
@EndUserText.label: 'DCL - RE Object Assignment by company code'
@MappingRole: true
define role ZI_RE_OBJECTASSIGNMENT {
  grant select on ZI_RE_ObjectAssignment
    where ( CompanyCode ) = aspect pfcg_auth ( ZRE_CONT, BUKRS, ACTVT = '03' );
}
