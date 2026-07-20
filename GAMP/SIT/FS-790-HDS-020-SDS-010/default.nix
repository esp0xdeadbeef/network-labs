{
  layer = "SIT";
  traceId = "FS-790-HDS-020-SDS-010";
  smsInputs = {
    "FS-790-HDS-020-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-790-HDS-020-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-790-HDS-020-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-790-HDS-020-SDS-010-SMS-010-public-ingress-row-atomization.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
