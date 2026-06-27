{
  layer = "SIT";
  traceId = "FS-310-HDS-030-SDS-010";
  smsInputs = {
    "FS-310-HDS-030-SDS-010-SMS-080" = {
      smtRow = ../../SMT/FS-310-HDS-030-SDS-010-SMS-080;
      sourcePath = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-080/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-030-SDS-010-SMS-080-renderer-shell-fallback-error-propagation.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-030-SDS-010-SMS-090" = {
      smtRow = ../../SMT/FS-310-HDS-030-SDS-010-SMS-090;
      sourcePath = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-090/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-030-SDS-010-SMS-090-renderer-check-bypass-prevention.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-030-SDS-010-SMS-110" = {
      smtRow = ../../SMT/FS-310-HDS-030-SDS-010-SMS-110;
      sourcePath = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-110/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-030-SDS-010-SMS-110-renderer-fail-closed-contract.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-030-SDS-010-SMS-111" = {
      smtRow = ../../SMT/FS-310-HDS-030-SDS-010-SMS-111;
      sourcePath = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-111/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-030-SDS-010-SMS-111-nixos-fail-closed-contract.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-030-SDS-010-SMS-112" = {
      smtRow = ../../SMT/FS-310-HDS-030-SDS-010-SMS-112;
      sourcePath = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-112/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-030-SDS-010-SMS-112-clab-fail-closed-contract.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
