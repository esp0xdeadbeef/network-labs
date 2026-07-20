{
  layer = "SIT";
  traceId = "FS-970-HDS-010-SDS-020";
  smsInputs = {
    "FS-970-HDS-010-SDS-020-SMS-010" = {
      smtRow = ../../SMT/FS-970-HDS-010-SDS-020-SMS-010;
      sourcePath = "GAMP/SMT/FS-970-HDS-010-SDS-020-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-970-HDS-010-SDS-020-SMS-010-reservation-identity-source-boundary.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-970-HDS-010-SDS-020-SMS-020" = {
      smtRow = ../../SMT/FS-970-HDS-010-SDS-020-SMS-020;
      sourcePath = "GAMP/SMT/FS-970-HDS-010-SDS-020-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-970-HDS-010-SDS-020-SMS-020-non-public-reservation-identity-source.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-970-HDS-010-SDS-020-SMS-030" = {
      smtRow = ../../SMT/FS-970-HDS-010-SDS-020-SMS-030;
      sourcePath = "GAMP/SMT/FS-970-HDS-010-SDS-020-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-970-HDS-010-SDS-020-SMS-030-reservation-identity-source-diagnostics.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-970-HDS-010-SDS-020-SMS-040" = {
      smtRow = ../../SMT/FS-970-HDS-010-SDS-020-SMS-040;
      sourcePath = "GAMP/SMT/FS-970-HDS-010-SDS-020-SMS-040/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-970-HDS-010-SDS-020-SMS-040-runtime-secret-reservation-materialization.md";
      role = "protected-reservation-runtime-materialization";
      evidenceBoundary = "isolated-dual-substrate-live-protected-reservation";
    };
  };
  evidence = {
    observedResult = "2026-07-19 PASS after an exact pushed-revision cold stage: all three guests were observed offline and returned with new boot IDs and guest closures; real NixOS/VLAN397 and CLAB/VLAN398 clients reproduced privately enrolled MAC/DUID/IAID/IID values and obtained exact predictable IPv4/IPv6 reservations with runtime-only SOPS materialization and redacted public/build surfaces. No production VLAN or address was used; sibling SMS inputs retain their construction boundaries.";
  };
}
