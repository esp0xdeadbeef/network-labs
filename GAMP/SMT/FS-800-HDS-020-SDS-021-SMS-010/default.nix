{
  layer = "SMT";
  traceId = "FS-800-HDS-020-SDS-021-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-020-SDS-021-SMS-010-hat-emulated-test-secret-materialization.md";
  titleSlug = "hat-emulated-test-secret-materialization";
  source = {
    kind = "hat-source-contract";
    sourcePath = "GAMP/SMT/FS-800-HDS-020-SDS-021-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-800-HDS-020-SDS-021-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-800-HDS-020-SDS-021-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-800-HDS-020-SDS-021-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "focused-SMT";
  };
  status = "OK";
  evidence = {
    command = "bash tests/FS-800-HDS-020-SDS-021-SMS-010-hat-emulated-test-secret-materialization.sh";
    focusedTest = "tests/FS-800-HDS-020-SDS-021-SMS-010-hat-emulated-test-secret-materialization.sh";
    observedResult = "focused HAT source construction test verifies non-production PPPoE test-secret declarations, root-only runtime paths, selected fixture scoping, protected-inventory non-promotion, and seeded negatives";
  };
}
