{
  layer = "SIT";
  traceId = "FS-500-HDS-010-SDS-010";
  smsInputs = {
    "FS-500-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-500-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-010/intent.nix";
      role = "reachability-decision-result";
    };

    "FS-500-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-500-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-040/intent.nix";
      role = "p2p-next-hop-pairing";
    };
    "FS-500-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-500-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-020/intent.nix";
      role = "row-local-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-500-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-500-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-030/intent.nix";
      role = "row-local-source-stub";
      evidenceBoundary = "source-stub-only";
    };
};
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh reachability-decision decision-reason-diagnostic p2p-next-hop";
    sourcePaths = [
      "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-010/intent.nix"
      "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-040/intent.nix"
    ];
    observedResult = "focused mini runner verifies the SDS with multiple row-local SMS inputs without full HAT/SAT deployment";
  };
}
