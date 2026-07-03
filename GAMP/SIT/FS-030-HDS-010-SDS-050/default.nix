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
    observedResult = "2026-07-04 active-lab shutdown loop PASS for child SMS; NixOS/CLAB artifacts carry the five expected runtime targets and test-clients carries zero";
    liveEvidence = [
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-050-SMS-010/20260703T230438Z"
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-050-SMS-010/20260703T230541Z"
    ];
  };
}
