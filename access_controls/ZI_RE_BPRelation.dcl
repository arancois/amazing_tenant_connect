// DCL : ZI_RE_BPRelation — inherits the contract's authorization (F-02 fix)
// BP relation carries no company code; it inherits the restriction of the
// owning contract via the _Contract parent association.
// (+) Insert by [PERNR-REDACTED] dated 12.06.2026 for CR_123
@EndUserText.label: 'DCL - RE BP Relation (inherited)'
@MappingRole: true
define role ZI_RE_BPRELATION {
  grant select on ZI_RE_BPRelation
    where inheriting conditions from entity ZI_RE_Contract;
}
