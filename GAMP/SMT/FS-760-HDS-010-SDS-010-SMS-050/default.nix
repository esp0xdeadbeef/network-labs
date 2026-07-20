{
  layer = "SMT";
  traceId = "FS-760-HDS-010-SDS-010-SMS-050";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-760-HDS-010-SDS-010-SMS-050-receiver-multicast-flooding-denial.md";
  titleSlug = "receiver-multicast-flooding-denial";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-760-HDS-010-SDS-010-SMS-050/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-760-HDS-010-SDS-010-SMS-050/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-760-HDS-010-SDS-010-SMS-050/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-760-HDS-010-SDS-010-SMS-050/inventory-test-clients.nix";
    };
    evidenceBoundary = "runtime";
  };
  status = "OK";
  evidence = {
    observedResult = "Focused SMS-050 construction test PASS (7/7 predicates, 2/2 seeded negatives active). Live mini-SMT runtime verified: s-router-nixos (192.168.1.17) artifacts OK, s-router-clab (192.168.1.19) artifacts OK. Both hosts carry mini-smt topology section in control-plane.json with 1 target each. Pinned nixos-shell build PASS.";
  };
}
