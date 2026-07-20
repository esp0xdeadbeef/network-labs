{
  layer = "SMT";
  traceId = "FS-985-HDS-010-SDS-010-SMS-020";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-985-HDS-010-SDS-010-SMS-020-repo-local-test-boundary.md";
  titleSlug = "repo-local-test-boundary";
  source = {
    kind = "construction-only";
    evidenceBoundary = "construction-only";
  };
  status = "OK";
  evidence = {
    observedResult = "All SMS predicates proven: P1 CPM #compile-and-build zero hits, P2 CLAB #generate-clab zero hits, P3 NixOS #render-dry zero hits, P4 broad downstream path scan zero hits in network-labs/tests/. Seeded negatives N1/N2/N3 detect with file:line and recover to PASS; P4 broad-scan negative detects and recovers. Test wired into tests/test.sh runner.";
  };
}
