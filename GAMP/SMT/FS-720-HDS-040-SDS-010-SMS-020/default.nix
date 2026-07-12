{
  layer = "SMT";
  traceId = "FS-720-HDS-040-SDS-010-SMS-020";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-720-HDS-040-SDS-010-SMS-020-clab-client-origin-runtime-probes.md";
  titleSlug = "clab-client-origin-runtime-probes";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-720-HDS-040-SDS-010-SMS-020/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-720-HDS-040-SDS-010-SMS-020/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-720-HDS-040-SDS-010-SMS-020/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-720-HDS-040-SDS-010-SMS-020/inventory-test-clients.nix";
    };
    evidenceBoundary = "construction-only";
  };
  status = "NOT OK";
  evidence = {
    command = null;
    focusedTest = "tests/test-fs720-hds040-sds010-sms020-clab-client-origin-probes.sh";
    observedResult = "canonical SMS mirrored from network-codex-agent; construction test registered below";
  };
}
