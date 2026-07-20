{
  layer = "SMT";
  traceId = "FS-705-HDS-010-SDS-010-SMS-050";
  evidenceBoundary = "construction-only";
  source = null;
  evidence = {
    owningRepo = "network-codex-agent";
    smtRow = "GAMP/SMT/README.md FS-705-HDS-010-SDS-010-SMS-050";
    status = "NOT OK";
    scope = "VLAN4 upstream inheritance: SMT/SIT construction-only verification that VLAN 200+ access networks referencing vlan4 inherit VLAN4 as the selected profile upstream/provider surface. Row-local overrides must be explicit. Rejects row-local VLAN4 access misuse, undeclared overrides, ambiguous upstreams, and inferred VLAN4 behavior. Five seeded negatives: VLAN4 not inherited, row-local access misuse, undeclared override, ambiguous upstream, inferred VLAN4 behavior.";
    sealedNegatives = [
      "diagnostic.validation-profile-vlan4-upstream-not-inherited"
      "diagnostic.validation-profile-vlan4-row-local-access"
      "diagnostic.validation-profile-vlan4-override-missing"
      "diagnostic.validation-profile-upstream-ambiguous"
      "diagnostic.validation-profile-vlan4-inferred"
    ];
  };
}
