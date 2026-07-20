{
  layer = "SIT";
  traceId = "FS-780-HDS-010-SDS-020";
  smsInputs = {
    "FS-780-HDS-010-SDS-020-SMS-010" = {
      smtRow = ../../SMT/FS-780-HDS-010-SDS-020-SMS-010;
      sourcePath = "GAMP/SMT/FS-780-HDS-010-SDS-020-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-780-HDS-010-SDS-020-SMS-010-equivalence-atom-contract.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-780-HDS-010-SDS-020-SMS-020" = {
      smtRow = ../../SMT/FS-780-HDS-010-SDS-020-SMS-020;
      sourcePath = "GAMP/SMT/FS-780-HDS-010-SDS-020-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-780-HDS-010-SDS-020-SMS-020-equivalence-limitation-binding.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
