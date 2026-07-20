{
  layer = "SMT";
  traceId = "FS-981-HDS-010-SDS-010-SMS-020";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-981-HDS-010-SDS-010-SMS-020-file-reachability-index.md";
  titleSlug = "file-reachability-index";
  source = {
    kind = "construction-only";
    evidenceBoundary = "construction-only";
  };
  status = "OK";
  evidence = {
    observedResult = "All SMS predicates proven: N1 orphan module→UNRESOLVED, R1 add caller→active-implementation, N2 unreachable test helper→UNRESOLVED, R2 add test caller→active-test-helper, P1 well-connected→active-implementation. Test wired into tests/test.sh.";
  };
}
