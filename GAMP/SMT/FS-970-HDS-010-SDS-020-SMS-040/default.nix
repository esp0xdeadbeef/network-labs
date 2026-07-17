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
    command = "FS970_ENROLLMENT_IDENTITY_FILE=<protected-file> FS970_ENROLLMENT_IPV6_FILE=<protected-file> network-codex-agent/scripts/smt-live-FS-970-HDS-010-SDS-020-SMS-040.sh";
    focusedTest = "network-codex-agent/tests/test-smt-live-FS-970-HDS-010-SDS-020-SMS-040.sh";
    observedResult = "SOPS runtime source, stable enrolled interface identity, predictable IPv4 and IPv6 leases, and public/build-template redaction all passed after a clean client rebuild";
  };
}
