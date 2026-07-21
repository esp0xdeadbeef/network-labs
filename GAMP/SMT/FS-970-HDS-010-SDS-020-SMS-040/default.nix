{
  layer = "SMT";
  traceId = "FS-970-HDS-010-SDS-020-SMS-040";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-970-HDS-010-SDS-020-SMS-040-runtime-secret-reservation-materialization.md";
  titleSlug = "runtime-secret-reservation-materialization";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-970-HDS-010-SDS-020-SMS-040/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-970-HDS-010-SDS-020-SMS-040/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-970-HDS-010-SDS-020-SMS-040/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-970-HDS-010-SDS-020-SMS-040/inventory-test-clients.nix";
    };
    evidenceBoundary = "live-protected-reservation";
  };
  status = "OK";
  evidence = {
    constructionStatus = "OK";
    liveStatus = "OK";
    observedResult = "On 2026-07-21, the expanded protected-source capability negative and the canonical live validator passed after a simultaneous cold stage of s-router-nixos, s-router-clab, and s-router-test-clients from the exact pushed lock. Both substrates preserved enrolled MAC, DUID, IAID, and IID identity, materialized protected reservations only at runtime, and assigned one predictable IPv4 and IPv6 address without a hotpatch or protected-value disclosure.";
  };
}
