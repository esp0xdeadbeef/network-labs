{
  layer = "SMT";
  traceId = "FS-270-HDS-010-SDS-010-SMS-020";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-270-HDS-010-SDS-010-SMS-020-client-tenant-policy-transit.md";
  titleSlug = "client-tenant-policy-transit";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-270-HDS-010-SDS-010-SMS-020/intent.nix";
    inventories = {
      nixos = "GAMP/SMT/FS-270-HDS-010-SDS-010-SMS-020/inventory-nixos.nix";
      clab = "GAMP/SMT/FS-270-HDS-010-SDS-010-SMS-020/inventory-clab.nix";
      testClients = "GAMP/SMT/FS-270-HDS-010-SDS-010-SMS-020/inventory-test-clients.nix";
      testClientIntent = "GAMP/SMT/FS-270-HDS-010-SDS-010-SMS-020/intent-test-clients.nix";
    };
    expectedRelationIds = [
      "FS-270-HDS-010-SDS-010-SMS-020__deny-reverse-new-flow"
      "FS-270-HDS-010-SDS-010-SMS-020__source-to-destination-icmp"
      "FS-270-HDS-010-SDS-010-SMS-020__source-to-test-uplink"
    ];
    evidenceBoundary = "isolated-dual-substrate-access-service-policy-state-owner-with-complete-site-spine";
  };
  status = "OK";
  evidence = {
    observedResult = "Cold-staged exact pushed pins on s-router-nixos, s-router-clab, and s-router-test-clients passed. NixOS and CLAB both carried IPv4 and IPv6 forward traffic through the same policy-state owner, allowed only stateful return, denied independently initiated reverse flows, exposed no forward shortcut, and did not inherit unrelated public egress. VLAN 2 and production networks were not used; the validator performed no runtime mutation.";
  };
}
