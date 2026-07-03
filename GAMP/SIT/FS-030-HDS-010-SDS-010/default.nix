{
  layer = "SIT";
  traceId = "FS-030-HDS-010-SDS-010";
  smsInputs = {
    "FS-030-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-030-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-040/intent.nix";
      role = "sms-040-module";
      evidenceBoundary = "construction-only";
    };
    "FS-030-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-030-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-010-SMS-010-intent-authority-boundary.md";
      role = "row-local-mini-smt";
      evidenceBoundary = "row-local-mini-smt";
    };
    "FS-030-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-030-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-020/intent.nix";
      role = "row-local-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-030-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-030-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-030/intent.nix";
      role = "row-local-source-stub";
      evidenceBoundary = "source-stub-only";
    };
};
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-010-SMS-010";
    observedResult = "row-local mini-SMT registered; live closure requires locked active-lab artifacts on s-router-nixos, s-router-clab, and s-router-test-clients";
  };
}
