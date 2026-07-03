{
  layer = "SMT";
  traceId = "FS-030-HDS-010-SDS-030-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-030-SMS-010-overlay-underlay-separation.md";
  titleSlug = "overlay-underlay-separation";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-030-HDS-010-SDS-030-SMS-010__overlay-payload"
      "FS-030-HDS-010-SDS-030-SMS-010__overlay-underlay"
      "FS-030-HDS-010-SDS-030-SMS-010__underlay-access-egress"
    ];
  };
  status = "OK";
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh --source FS-030-HDS-010-SDS-030-SMS-010";
    owningRepo = "network-compiler";
    focusedTest = "tests/test-FS-030-HDS-010-SDS-030-SMS-010.sh";
    maxRuntimeTargets = 6;
    observedResult = "compiler overlay-underlay construction test passes and row-local mini-SMT artifacts are expected on nixos/clab with zero test-client runtime targets";
    smtRow = "GAMP/SMT/README.md row for FS-030-HDS-010-SDS-030-SMS-010";
    scope = "Compiler overlay-underlay separation: enforces distinct policy relations with separate p2pIsolationKey per overlay leg, requires explicit underlayAccess declarations, emits forbidsCoreToCoreP2P and overlay/peer-site identity";
  };
}
