{
  layer = "SIT";
  traceId = "FS-800-HDS-010-SDS-013";
  smsInputs = {
    "FS-800-HDS-010-SDS-013-SMS-020" = {
      smtRow = ../../SMT/FS-800-HDS-010-SDS-013-SMS-020;
      sourcePath = "GAMP/SMT/FS-800-HDS-010-SDS-013-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-010-SDS-013-SMS-020-cpm-provider-handoff-fabric-egress.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
