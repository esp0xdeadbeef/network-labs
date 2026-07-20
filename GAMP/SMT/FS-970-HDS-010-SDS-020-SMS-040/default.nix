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
    observedResult = "On 2026-07-19, private enrollment followed by a second pushed-revision cold stage made real s-router-nixos/VLAN397 and s-router-clab/VLAN398 branches both pass exact SOPS runtime delivery, UDP 67/547 readiness, stable MAC/DUID/IAID/IID, predictable IPv4/IPv6 leases, zero extra global addresses, and public/build redaction on s-router-test-clients.";
  };
}
