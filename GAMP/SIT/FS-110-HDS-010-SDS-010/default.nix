{
  layer = "SIT";
  traceId = "FS-110-HDS-010-SDS-010";
  smsInputs = {
    "FS-110-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-110-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-110-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-110-HDS-010-SDS-010-SMS-010-deterministic-evaluation.md";
      role = "deterministic-evaluation";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    command = "MINI_SMT_OFFLINE_VERIFY=0 tests/run-active-lab-mini-smt.sh FS-110-HDS-010-SDS-010-SMS-010";
    observedResult = "FS-110-HDS-010-SDS-010-SMS-010 is construction-only deterministic evaluation evidence from network-codex-agent; no router runtime targets are created.";
  };
}
