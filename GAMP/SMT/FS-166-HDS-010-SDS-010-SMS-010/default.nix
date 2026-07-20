{
  layer = "SMT";
  traceId = "FS-166-HDS-010-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-166-HDS-010-SDS-010-SMS-010-controlled-skip-acknowledgement.md";
  evidenceBoundary = "construction-only";
  source = null;
  status = "OK";
  evidence = {
    owningRepos = [
      "network-compiler"
      "network-forwarding-model"
      "network-control-plane-model"
    ];
    observedResult = "PASS: compiler, NFM, and CPM each validated seven exact skip diagnostics and recovery assertions.";
  };
}
