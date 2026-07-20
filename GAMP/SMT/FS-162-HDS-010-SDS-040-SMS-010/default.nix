{
  layer = "SMT";
  traceId = "FS-162-HDS-010-SDS-040-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-162-HDS-010-SDS-040-SMS-010-s-router-prod-comparable-projection.md";
  titleSlug = "s-router-prod-comparable-projection";
  source = {
    kind = "isolated-fs230-cpm";
    sourcePath = "GAMP/SMT/FS-162-HDS-010-SDS-040-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-162-HDS-010-SDS-040-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-162-HDS-010-SDS-040-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-162-HDS-010-SDS-040-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "construction-only";
  };
  status = "NOT OK";
  evidence = {
    command = "bash tests/FS-162-HDS-010-SDS-040-SMS-010-s-router-prod-comparable-projection.sh";
    focusedTest = "network-renderer-openconfig/tests/FS-162-HDS-010-SDS-040-SMS-010-s-router-prod-comparable-projection.sh";
    observedResult = "specification updated for the shared FS-230 CPM posture; owning construction test and mini-SMT registration are not implemented yet";
  };
}
