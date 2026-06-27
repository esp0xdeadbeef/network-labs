{
  layer = "SIT";
  traceId = "FS-985-HDS-010-SDS-010";
  smsInputs = {
    "FS-985-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-985-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-985-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-985-HDS-010-SDS-010-SMS-010-flake-input-unpinned.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-985-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-985-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-985-HDS-010-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-985-HDS-010-SDS-010-SMS-020-repo-local-test-boundary.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
