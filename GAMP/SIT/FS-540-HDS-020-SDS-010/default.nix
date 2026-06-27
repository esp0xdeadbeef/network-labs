{
  layer = "SIT";
  traceId = "FS-540-HDS-020-SDS-010";
  smsInputs = {
    "FS-540-HDS-020-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-540-HDS-020-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-540-HDS-020-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-540-HDS-020-SDS-010-SMS-010-clab-recursive-dns-requester-fixture.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
