{
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-705-HDS-010-SDS-010-SMS-050-vlan4-upstream-inheritance.md";
  titleSlug = "vlan4-upstream-inheritance";
  purpose = "Canonical SMS mirror for VLAN4 upstream inheritance. SMT/SIT construction-only verification that VLAN 200+ access networks referencing vlan4 inherit VLAN4 as the selected profile upstream/provider surface.";
  layer = "SMS";
  traceId = "FS-705-HDS-010-SDS-010-SMS-050";
  evidenceBoundary = "construction-only";
  owningRepo = "network-codex-agent";
  focusedTest = "tests/FS-705-HDS-010-SDS-010-SMS-050-vlan4-upstream-inheritance.sh";
  sealedNegatives = [
    "diagnostic.validation-profile-vlan4-upstream-not-inherited"
    "diagnostic.validation-profile-vlan4-row-local-access"
    "diagnostic.validation-profile-vlan4-override-missing"
    "diagnostic.validation-profile-upstream-ambiguous"
    "diagnostic.validation-profile-vlan4-inferred"
  ];
}
