{
  layer = "SMT";
  traceId = "FS-390-HDS-010-SDS-010-SMS-020";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-390-HDS-010-SDS-010-SMS-020-public-ipv4-shortcut-policy.md";
  titleSlug = "public-ipv4-shortcut-policy";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-390-HDS-010-SDS-010-SMS-020/intent.nix";
    miniSmtId = "FS-390-HDS-010-SDS-010-SMS-020";
    expectedRelationIds = [
      "FS-390-HDS-010-SDS-010-SMS-020__mini-verify"
      "FS-390-HDS-010-SDS-010-SMS-020__client-to-tenant-api"
      "FS-390-HDS-010-SDS-010-SMS-020__testnet-to-public-web"
    ];
    inventories = {
      clab = "GAMP/SMT/FS-390-HDS-010-SDS-010-SMS-020/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-390-HDS-010-SDS-010-SMS-020/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-390-HDS-010-SDS-010-SMS-020/inventory-test-clients.nix";
    };
    evidenceBoundary = "intent-source-to-forwarding-policy";
  };
  status = "OK";
  evidence = {
    observedResult = "fixture compiles explicit service/public-ingress public IPv4 shortcuts into NFM shortcutAuthorizations";
  };
}
