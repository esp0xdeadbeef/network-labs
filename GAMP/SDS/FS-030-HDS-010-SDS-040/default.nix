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
  evidence = {
    observedResult = "2026-07-04 live NixOS and CLAB runtime surfaces consumed the same platform-independent row-local intent source with five runtime targets each and zero test-client runtime targets";
    evidenceDirs = [
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-040-SMS-010/20260704T053321Z"
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-040-SMS-010/20260704T053649Z"
      "/tmp/active-lab-mini-smt-runs/20260704T053642Z-2913672/FS-030-HDS-010-SDS-040-SMS-010"
    ];
  };
}
