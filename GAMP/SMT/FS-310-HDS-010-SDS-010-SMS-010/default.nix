{
  layer = "SMT";
  traceId = "FS-310-HDS-010-SDS-010-SMS-010";
  evidenceBoundary = "construction-only";
  source = null;
  evidence = {
    owningRepo = "network-renderer-*";
    coordinator = true;
    childTraces = [
      "FS-310-HDS-010-SDS-010-SMS-020"
      "FS-310-HDS-010-SDS-010-SMS-030"
      "FS-310-HDS-010-SDS-010-SMS-040"
      "FS-310-HDS-020-SDS-010-SMS-200"
    ];
    smtRow = "GAMP/SMT/README.md (network-codex-agent)";
    status = "NOT OK";
    scope = "Coordinator that routes renderer policy-boundary checks to child SMS rows; parent closure requires all applicable children OK";
  };
}
