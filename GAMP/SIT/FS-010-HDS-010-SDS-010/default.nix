{
  layer = "SIT";
  traceId = "FS-010-HDS-010-SDS-010";
  smsInputs = {
    "FS-010-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-010-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-010-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-010-HDS-010-SDS-010-SMS-010-accepted-source-set.md";
      role = "accepted-source-set-active-lab-runtime";
      evidenceBoundary = "active-lab-mini-smt-runtime";
    };
  };
  evidence = {
    observedResult = "2026-07-04: integrated active-lab runtime artifacts carried full trace FS-010-HDS-010-SDS-010-SMS-010 on s-router-nixos, s-router-clab, and s-router-test-clients. Router hosts exposed five bounded runtime targets each; test-clients exposed the trace with zero router runtime targets.";
  };
}
