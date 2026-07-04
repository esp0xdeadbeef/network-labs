{
  layer = "SIT";
  traceId = "FS-040-HDS-010-SDS-010";
  smsInputs = {
    "FS-040-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-040-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-040-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-040-HDS-010-SDS-010-SMS-010-public-inventory-boundary.md";
      role = "active-lab-smt-input";
      evidenceBoundary = "construction-plus-live-active-lab-artifact";
    };
  };
  evidence = {
    command = "network-codex-agent/scripts/smt-live-FS-040-HDS-010-SDS-010-SMS-010.sh";
    observedResult = "2026-07-04 full s-router-nixos rebuild loop passed active-lab post-reboot checks for FS-040-HDS-010-SDS-010-SMS-010 across s-router-nixos, s-router-clab, and s-router-test-clients";
  };
}
