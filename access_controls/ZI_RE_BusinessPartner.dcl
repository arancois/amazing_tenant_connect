// =====================================================================
// Access Control (DCL) : ZI_RE_BusinessPartner
// BP master read restricted via standard BP role auth (B_BUPA_RLT).
// ACTVT '03' = Display.
// (+) Insert by [PERNR-REDACTED] dated 12.06.2026 for CR_123
// =====================================================================
@EndUserText.label: 'DCL - RE Business Partner display'
@MappingRole: true
define role ZI_RE_BUSINESSPARTNER {
  grant select on ZI_RE_BusinessPartner
    where aspect pfcg_auth ( B_BUPA_RLT, ACTVT = '03' );
}
