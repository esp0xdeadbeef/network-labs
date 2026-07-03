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
    observedResult = "active-lab runner is registered; current live evidence is still required before marking OK";
  };
}
