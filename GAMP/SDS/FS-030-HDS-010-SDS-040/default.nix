{
  layer = "SDS";
  traceId = "FS-030-HDS-010-SDS-040";
  purpose = "Platform-independence row-local mini-SMT grouping.";
  smsInputs = {
    "FS-030-HDS-010-SDS-040-SMS-010" = {
      smsRow = ../../SMS/FS-030-HDS-010-SDS-040-SMS-010;
      miniSmtIds = [ "FS-030-HDS-010-SDS-040-SMS-010" ];
      inputKinds = [
        "intent-source"
        "compiler-construction-test"
        "active-lab-runtime"
      ];
      evidenceBoundary = "row-local-mini-smt";
    };
  };
  templateTests = [
    "tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-040-SMS-010"
    "network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-040-SMS-010.sh"
    "network-compiler/tests/test-FS-030-HDS-010-SDS-040-SMS-010.sh"
  ];
}
