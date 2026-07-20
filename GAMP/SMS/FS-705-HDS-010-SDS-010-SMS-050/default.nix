{
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-705-HDS-010-SDS-010-SMS-050-vlan4-upstream-inheritance.md";
  titleSlug = "vlan4-upstream-inheritance";
  purpose = "Canonical SMS mirror for VLAN4 upstream inheritance. SMT/SIT construction-only verification that VLAN 200+ access networks referencing vlan4 inherit VLAN4 as the selected profile upstream/provider surface.";
  layer = "SMS";
  traceId = "FS-705-HDS-010-SDS-010-SMS-050";
  parentSds = ../../SDS/FS-705-HDS-010-SDS-010;
  evidenceBoundary = "construction-only";
  owningRepo = "network-codex-agent";
  sourceInputs."FS-705-HDS-010-SDS-010-SMS-050-construction" = {
    traceId = "FS-705-HDS-010-SDS-010-SMS-050";
    kind = "construction-check";
    sourcePath = "GAMP/SMT/FS-705-HDS-010-SDS-010-SMS-050/intent.nix";
    maxRuntimeTargets = 0;
  };
  sealedNegatives = [
    "diagnostic.validation-profile-vlan4-upstream-not-inherited"
    "diagnostic.validation-profile-vlan4-row-local-access"
    "diagnostic.validation-profile-vlan4-override-missing"
    "diagnostic.validation-profile-upstream-ambiguous"
    "diagnostic.validation-profile-vlan4-inferred"
  ];
}
