{
  layer = "SMS";
  traceId = "FS-030-HDS-010-SDS-050-SMS-010";
  parentSds = ../../SDS/FS-030-HDS-010-SDS-050;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-050-SMS-010-core-role-boundary.md";
  titleSlug = "core-role-boundary";
  purpose = "Core role boundary mini-SMT source and construction evidence template.";
  status = "OK";
  evidenceBoundary = "construction-plus-live-artifact";
  sourceInputs = {
    "FS-030-HDS-010-SDS-050-SMS-010" = {
      traceId = "FS-030-HDS-010-SDS-050-SMS-010";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/intent.nix";
      maxRuntimeTargets = 5;
    };
    "canonical-source-stub" = {
      traceId = "FS-030-HDS-010-SDS-050-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
  evidence = {
    observedResult = "2026-07-04 PASS: construction test, NCA live wrapper unit test, row-local source test, direct live verifier, active-lab runner, and runtime-debugger p2p/routes/runtime_signals for the focused row";
    liveEvidence = [
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-050-SMS-010/20260704T055541Z"
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-050-SMS-010/20260704T055923Z"
    ];
    activeLabRun = "/tmp/active-lab-mini-smt-runs/20260704T055916Z-2927018/FS-030-HDS-010-SDS-050-SMS-010";
  };
}
