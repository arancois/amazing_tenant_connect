// DCL : ZI_RE_Measurement — company-code restriction (F-02 fix)
// (+) Insert by [PERNR-REDACTED] dated 12.06.2026 for CR_123
@EndUserText.label: 'DCL - RE Measurement by company code'
@MappingRole: true
define role ZI_RE_MEASUREMENT {
  grant select on ZI_RE_Measurement
    where ( CompanyCode ) = aspect pfcg_auth ( ZRE_CONT, BUKRS, ACTVT = '03' );
}
