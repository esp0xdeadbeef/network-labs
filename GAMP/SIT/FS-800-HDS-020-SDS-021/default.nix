{
  layer = "SIT";
  traceId = "FS-800-HDS-020-SDS-021";
  smsInputs = {
    "FS-800-HDS-020-SDS-021-SMS-010" = {
      smtRow = ../../SMT/FS-800-HDS-020-SDS-021-SMS-010;
      sourcePath = "GAMP/SMT/FS-800-HDS-020-SDS-021-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-020-SDS-021-SMS-010-hat-emulated-test-secret-materialization.md";
      role = "hat-emulated-test-secret-materialization";
      evidenceBoundary = "source-contract-plus-live-active-lab-sit";
    };
  };
  evidence = {
    observedResult = "OK live on 2026-06-29: source SMT verifies host-specific active-lab SOPS routing, live s-router-nixos can decrypt sops-s-router-nixos.yaml, and bash tests/FS-800-HDS-020-SDS-021-SIT-live-secret-presence.sh s-router-nixos passes with both /run/secrets/hat-pppoe-username and /run/secrets/hat-pppoe-password present under root-only boundary";
  };
}
