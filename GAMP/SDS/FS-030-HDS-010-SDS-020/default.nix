{
  layer = "SDS";
  traceId = "FS-030-HDS-010-SDS-020";
  purpose = "Active-lab mini-SMT source for compiler stage-topology enforcement.";
  smsInputs = {
    "FS-030-HDS-010-SDS-020-SMS-010" = {
      smsRow = ../../SMS/FS-030-HDS-010-SDS-020-SMS-010;
      miniSmtIds = [ "FS-030-HDS-010-SDS-020-SMS-010" ];
      inputKinds = [
        "intent-source"
        "compiler-construction-test"
        "active-lab-runtime"
      ];
      evidenceBoundary = "row-local-mini-smt";
    };
  };
}
