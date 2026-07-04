{
  layer = "SIT";
  traceId = "FS-160-HDS-010-SDS-010";
  smsInputs = {
    "FS-160-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-160-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-160-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-160-HDS-010-SDS-010-SMS-010-portability-limitation-reporting.md";
      role = "portability-limitation-reporting";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    command = "MINI_SMT_OFFLINE_VERIFY=0 tests/run-active-lab-mini-smt.sh FS-160-HDS-010-SDS-010-SMS-010";
    observedResult = "FS-160-HDS-010-SDS-010-SMS-010 is construction-only portability limitation evidence from network-control-plane-model; no router runtime targets are created. Active-lab wrapper records live artifacts as context only.";
  };
}
