{
  layer = "SMT";
  traceId = "FS-030-HDS-010-SDS-050-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-050-SMS-010-core-role-boundary.md";
  evidenceBoundary = "construction-plus-live-artifact";
  titleSlug = "core-role-boundary";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/intent.nix";
    expectedRelationIds = [ "FS-030-HDS-010-SDS-050-SMS-010__mini-verify" ];
    inventories = {
      clab = "GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/inventory-test-clients.nix";
    };
  };
  status = "OK";
  evidence = {
    command = "bash ../network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-050-SMS-010.sh";
    focusedTest = "network-compiler/tests/test-FS-030-HDS-010-SDS-050-SMS-010.sh";
    observedResult = "2026-07-04 active-lab shutdown loop PASS; construction PASS; NixOS and CLAB artifacts expose five expected runtime targets; test-clients exposes zero runtime targets";
    liveEvidence = [
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-050-SMS-010/20260703T230438Z"
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-050-SMS-010/20260703T230541Z"
    ];
  };
}
