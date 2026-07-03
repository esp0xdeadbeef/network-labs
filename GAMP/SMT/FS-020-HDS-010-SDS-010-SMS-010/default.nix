{
  layer = "SMT";
  traceId = "FS-020-HDS-010-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-020-HDS-010-SDS-010-SMS-010-source-class-assignment.md";
  titleSlug = "source-class-assignment";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-020-HDS-010-SDS-010-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-020-HDS-010-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-020-HDS-010-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-020-HDS-010-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "row-local-mini-smt";
  };
  status = "ACTIVE";
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-020-HDS-010-SDS-010-SMS-010";
    focusedTest = "../network-codex-agent/scripts/smt-live-FS-020-HDS-010-SDS-010-SMS-010.sh";
    observedResult = "row-local mini-SMT registered; live closure requires the locked active-lab full loop on s-router-nixos, s-router-clab, and s-router-test-clients";
  };
}
