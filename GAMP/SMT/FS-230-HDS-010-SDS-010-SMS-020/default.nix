{
  layer = "SMT";
  traceId = "FS-230-HDS-010-SDS-010-SMS-020";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-020-public-ingress-translation-binding.md";
  titleSlug = "public-ingress-translation-binding";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-020/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-020/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-020/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-020/inventory-test-clients.nix";
    };
    evidenceBoundary = "construction-only";
  };
  status = "OK";
  evidence = {
    command = "NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-fs230-hds010-sds010-sms020-public-ingress-translation-binding.sh";
    focusedTest = "tests/test-fs230-hds010-sds010-sms020-public-ingress-translation-binding.sh";
    observedResult = "PASS: every fixture row using translation binds explicit translationMode (napt), sourcePreservation (rewritten), and asymmetricRouting (false); seeded negatives SN1 (missing translationMode) and SN2 (hairpin without hairpinAuthorized) fail closed with correct diagnostics";
  };
}
