{
  layer = "SMT";
  traceId = "FS-230-HDS-010-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-010-public-ingress-return-translation.md";
  titleSlug = "public-ingress-return-translation";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "OK";
  evidence = {
    observedResult = "PASS: all 6 fixture rows validated, SN1 (MISSING_RETURN_BEHAVIOR) and SN2 (HAIRPIN_RETURN_NOT_MODELED) seeded negatives pass, live wrapper 0 targets on both hosts";
  };
}
