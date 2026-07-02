{
  layer = "SMS";
  traceId = "FS-310-HDS-040-SDS-010-SMS-150";
  parentSds = ../../SDS/FS-310-HDS-040-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-040-SDS-010-SMS-150-cpm-platform-abstention.md";
  titleSlug = "cpm-platform-abstention";
  purpose = "Canonical SMS mirror with active mini-SMT runtime wrapper.";
  evidenceBoundary = "active mini-SMT runtime wrapper plus owning CPM construction proof";
  sourceInputs = {
    "FS-310-HDS-040-SDS-010-SMS-150" = {
      traceId = "FS-310-HDS-040-SDS-010-SMS-150";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-150/intent.nix";
      test = "../network-codex-agent/scripts/smt-live-FS-310-HDS-040-SDS-010-SMS-150.sh";
      maxRuntimeTargets = 5;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
    "../network-codex-agent/scripts/smt-live-FS-310-HDS-040-SDS-010-SMS-150.sh"
  ];
}
