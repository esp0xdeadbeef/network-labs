{
  layer = "SIT";
  traceId = "FS-120-HDS-010-SDS-010";
  smsInputs = {
    "FS-120-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-120-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-120-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-120-HDS-010-SDS-010-SMS-010-deterministic-diagnostics.md";
      role = "deterministic-diagnostics";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    command = "MINI_SMT_OFFLINE_VERIFY=0 tests/run-active-lab-mini-smt.sh FS-120-HDS-010-SDS-010-SMS-010";
    observedResult = "FS-120-HDS-010-SDS-010-SMS-010 is construction-only deterministic diagnostics evidence from network-codex-agent; no router runtime targets are created.";
  };
}
