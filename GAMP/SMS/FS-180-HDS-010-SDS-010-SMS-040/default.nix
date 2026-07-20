{
  layer = "SMS";
  traceId = "FS-180-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-180-HDS-010-SDS-010;
  purpose = "Bidirectional nft Rule Generation From Return Behavior (construction-only with live HAT re-verify pending).";
  evidenceBoundary = "split";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-180-HDS-010-SDS-010-SMS-040";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-180-HDS-010-SDS-010-SMS-040/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
