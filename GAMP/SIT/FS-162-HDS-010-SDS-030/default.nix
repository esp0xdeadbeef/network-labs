{
  layer = "SIT";
  traceId = "FS-162-HDS-010-SDS-030";
  smsInputs = {
    "FS-162-HDS-010-SDS-030-SMS-010" = {
      smtRow = ../../SMT/FS-162-HDS-010-SDS-030-SMS-010;
      sourcePath = "GAMP/SMT/FS-162-HDS-010-SDS-030-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-162-HDS-010-SDS-030-SMS-010-openconfig-cpm-interface-parsing-fail-closed.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
