{
  layer = "SMS";
  traceId = "FS-350-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-350-HDS-010-SDS-010;
  purpose = "Overlay participant ledger: segment overlay node IPAM by overlay identity, emit one participant-address ledger per overlay, reject cross-ledger assignments (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-350-HDS-010-SDS-010-SMS-030";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-350-HDS-010-SDS-010-SMS-030/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
