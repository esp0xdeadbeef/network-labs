{
  layer = "SMT";
  traceId = "FS-390-HDS-010-SDS-010-SMS-030";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-390-HDS-010-SDS-010-SMS-030-broad-wan-public-ipv4-denial.md";
  titleSlug = "broad-wan-public-ipv4-denial";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-390-HDS-010-SDS-010-SMS-030/intent.nix";
    miniSmtId = "FS-390-HDS-010-SDS-010-SMS-030";
    expectedRelationIds = [
      "FS-390-HDS-010-SDS-010-SMS-030__mini-verify"
      "FS-390-HDS-010-SDS-010-SMS-030__client-to-tenant-service-public-via-broad-wan"
      "FS-390-HDS-010-SDS-010-SMS-030__client-to-public-ingress-via-broad-wan"
      "FS-390-HDS-010-SDS-010-SMS-030__tenant-service-exposure-allow"
      "FS-390-HDS-010-SDS-010-SMS-030__public-web-public-ingress-exposure-allow"
    ];
    inventories = {
      clab = "GAMP/SMT/FS-390-HDS-010-SDS-010-SMS-030/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-390-HDS-010-SDS-010-SMS-030/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-390-HDS-010-SDS-010-SMS-030/inventory-test-clients.nix";
    };
    evidenceBoundary = "intent-source-to-forwarding-policy";
  };
  status = "OK";
  evidence = {
    observedResult = "fixture compiles broad WAN attempts to model-owned public IPv4 into NFM broadWanDenials";
  };
}
