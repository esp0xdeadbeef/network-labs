{
  layer = "SMT";
  traceId = "FS-164-HDS-010-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-164-HDS-010-SDS-010-SMS-010-english-controlled-corpus.md";
  titleSlug = "english-controlled-corpus";
  evidenceBoundary = "construction-only";
  source = null;
  status = "OK";
  evidence = {
    owningRepo = "network-labs";
    constructionStatus = "OK";
    liveStatus = "NOT OK";
    maxRuntimeTargets = 0;
    command = "bash tests/FS-164-HDS-010-SDS-010-SMS-010.sh";
    observedResult = "The canonical validation-scheme language checker scans the controlled corpus and proves DOC-LANG-N1 through DOC-LANG-N5 with exact diagnostics, exit behavior, privacy-safe output, and recovery. This row has no runtime network target.";
  };
}
