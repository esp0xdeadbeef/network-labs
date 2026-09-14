{
  layer = "SMT";
  traceId = "FS-481-HDS-010-SDS-010-SMS-010";
  miniSmtId = "FS-481-HDS-010-SDS-010-SMS-010";
  runtimeHosts = [ ];
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-481-HDS-010-SDS-010-SMS-010__multi-family-client-egress"
      "FS-481-HDS-010-SDS-010-SMS-010__ordered-client-egress"
    ];
  };
  evidence = {
    maxRuntimeTargets = 0;
    scope = "construction-only: boundary selection shape normalization for a multi-member egress boundary whose eligible members differ per address family, plus an ordered boundary whose member list is its priority order; isolated synthetic members, no production VLAN, no runtime lifecycle";
    observedResult = "PENDING: the atom has a source row and a declared boundary shape. The construction entrypoint tests/lib/FS-481-HDS-010-SDS-010-SMS-010 must prove the per-family member split and the preserved order before this row can report a result.";
  };
}
