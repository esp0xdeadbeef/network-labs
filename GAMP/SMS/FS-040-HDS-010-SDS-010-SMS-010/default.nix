{
  layer = "SMS";
  traceId = "FS-040-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-040-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-040-HDS-010-SDS-010-SMS-010-public-inventory-boundary.md";
  titleSlug = "public-inventory-boundary";
  purpose = "Active-lab public-inventory boundary source and evidence template.";
  status = "OK";
  evidenceBoundary = "construction-plus-live-active-lab-artifact";
  sourceInputs = {
    "FS-040-HDS-010-SDS-010-SMS-010" = {
      traceId = "FS-040-HDS-010-SDS-010-SMS-010";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-040-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 5;
    };
  };
  evidence = {
    observedResult = "2026-07-04 PASS: public-inventory boundary construction wrapper, row-local source test, direct live verifier, active-lab runner, pinned builds, and runtime-debugger p2p/routes/runtime_signals";
    activeLabRun = "/tmp/active-lab-mini-smt-runs/20260704T062015Z-2938737/FS-040-HDS-010-SDS-010-SMS-010";
    liveEvidence = [
      "/tmp/s-router-live-smoke/FS-040-HDS-010-SDS-010-SMS-010/20260704T061645Z"
      "/tmp/s-router-live-smoke/FS-040-HDS-010-SDS-010-SMS-010/20260704T062022Z"
    ];
  };
}
