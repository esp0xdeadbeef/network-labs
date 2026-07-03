{
  layer = "SIT";
  traceId = "FS-030-HDS-010-SDS-050";
  smsInputs = {
    "FS-030-HDS-010-SDS-050-SMS-010" = {
      smtRow = ../../SMT/FS-030-HDS-010-SDS-050-SMS-010;
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-050-SMS-010-core-role-boundary.md";
      role = "intent-source-mini-smt";
      evidenceBoundary = "construction-plus-live-artifact";
    };
  };
  evidence = {
    command = "bash ../network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-050-SMS-010.sh";
    observedResult = "mini-SMT registration exists and construction evidence is current; integrated live artifact evidence is pending the active-lab shutdown loop";
  };
}
