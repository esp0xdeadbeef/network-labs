{
  layer = "SMS";
  traceId = "FS-540-HDS-010-SDS-010-SMS-035";
  parentSds = ../../SDS/FS-540-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-540-HDS-010-SDS-010-SMS-035-renderer-dns-nft-materialization.md";
  titleSlug = "renderer-dns-nft-materialization";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-540-HDS-010-SDS-010-SMS-035";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-035/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
