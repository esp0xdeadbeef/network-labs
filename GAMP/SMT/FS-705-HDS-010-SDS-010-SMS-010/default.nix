{
  layer = "SMT";
  traceId = "FS-705-HDS-010-SDS-010-SMS-010";
  evidenceBoundary = "construction-only";
  source = null;
  evidence = {
    owningRepo = "network-codex-agent";
    focusedTest = "tests/FS-705-HDS-010-SDS-010-SMS-010-lab-profile-selection-metadata.sh";
    smtRow = "GAMP/SMT/README.md FS-705-HDS-010-SDS-010-SMS-010";
    status = "OK";
    scope = "Lab profile selection metadata: named profile records declare logical layout, default core/provider choice, supported renderer/host targets, required inventory classes, and allowed override fields. Shared profile defaults (managementVlan2, inventory stubs), shared management reachability, reusable inventory/client classes, and profile-default inheritance ledgers verified across 4 profile types. Five seeded negatives exercise: missing profile default, ambiguous default layout, repeated default payload, unapproved override field, and row-source-repeats-profile-default rejection.";
    sealedNegatives = [
      "diagnostic.profile-default-missing"
      "diagnostic.profile-default-ambiguous"
      "diagnostic.row-source-repeats-profile-default"
      "diagnostic.profile-override-not-allowed"
      "diagnostic.row-source-repeats-shared-default"
    ];
  };
}
