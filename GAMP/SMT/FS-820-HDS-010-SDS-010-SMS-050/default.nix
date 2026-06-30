{
  layer = "SMT";
  traceId = "FS-820-HDS-010-SDS-010-SMS-050";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-820-HDS-010-SDS-010-SMS-050-network-labs-sops-configuration-validation.md";
  titleSlug = "network-labs-sops-configuration-validation";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-050/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-050/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-050/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-050/inventory-test-clients.nix";
    };
    evidenceBoundary = "focused-construction-test";
  };
  status = "OK";
  evidence = {
    command = "NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-820-HDS-010-SDS-010-SMS-050.sh";
    focusedTest = "tests/FS-820-HDS-010-SDS-010-SMS-050.sh";
    observedResult = "PASS on 2026-06-30: focused CMC guard rejects network-labs sops.defaultSopsFile overrides, host-owned keys such as deadbeef-passwd, arbitrary unmodeled host-owned keys such as qqqqabc, and encrypted YAML payload ownership under active-lab/secrets. Positive fixture keeps lab-runtime secrets in owning row or fixture directories with per-secret sopsFile references.";
  };
}
