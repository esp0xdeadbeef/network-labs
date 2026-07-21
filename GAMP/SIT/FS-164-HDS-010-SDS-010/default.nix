{
  layer = "SIT";
  traceId = "FS-164-HDS-010-SDS-010";
  status = "NOT OK";
  smsInputs = {
    "FS-164-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-164-HDS-010-SDS-010-SMS-010;
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-164-HDS-010-SDS-010-SMS-010-english-controlled-corpus.md";
      role = "controlled-language-construction-handoff";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    observedResult = "The language checker has focused construction evidence only. No live network target exists and no SIT, HAT, or SAT promotion is claimed.";
  };
}
