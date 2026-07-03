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
  status = "PENDING LIVE REVALIDATION";
  evidence = {
    command = "bash ../network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-050-SMS-010.sh";
    focusedTest = "network-compiler/tests/test-FS-030-HDS-010-SDS-050-SMS-010.sh";
    observedResult = "mini-SMT registration exists; current construction proof is network-compiler commit 11afb39 PASS, but live artifact evidence is pending the active-lab shutdown loop";
  };
}
