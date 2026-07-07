{
  layer = "SMT";
  traceId = "FS-705-HDS-010-SDS-010-SMS-020";
  evidenceBoundary = "construction-only";
  source = null;
  evidence = {
    owningRepo = "network-codex-agent";
    focusedTest = "tests/FS-705-HDS-010-SDS-010-SMS-020-active-lab-shim-output-boundary.sh";
    smtRow = "GAMP/SMT/README.md FS-705-HDS-010-SDS-010-SMS-020";
    status = "OK";
    scope = "Active-lab shim output boundary: network-labs/active-lab/ is the only supported downstream-facing active lab source tree, its files are shims/imports/profile selectors over canonical source, no embedded JSON payloads, no generated forwarding models as source, no repeated renderer inventory, no expanded profile default copies across current-lab inventory files, and provenance metadata is present via mkSource.";
    sealedNegatives = [
      "diagnostic.parallel-active-lab-entrypoint"
      "diagnostic.active-lab-json-payload-in-nix"
      "diagnostic.active-lab-generated-output-as-source"
      "diagnostic.active-lab-repeated-renderer-inventory"
      "diagnostic.active-lab-expanded-profile-default"
      "diagnostic.active-lab-provenance-missing"
    ];
  };
}
