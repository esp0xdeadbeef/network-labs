{
  layer = "SMT";
  traceId = "FS-230-HDS-010-SDS-010-SMS-040";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-040-s-router-prod-nebula-ipv6-ingress-compatibility.md";
  titleSlug = "s-router-prod-nebula-ipv6-ingress-compatibility";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    command = null;
    focusedTest = null;
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
