{
  layer = "SMT";
  traceId = "FS-166-HDS-010-SDS-010-SMS-904";
  smsRow = ../../SMS/FS-166-HDS-010-SDS-010-SMS-904;
  source = {
    kind = "renderer-input";
    sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-clab-cpm.nix";
    evidenceBoundary = "active-lab renderer-input mini SMT/SIT";
  };
  status = "OK";
  evidence.command = "tests/run-active-lab-mini-smt.sh FS-166-HDS-010-SDS-010-SMS-904";
  evidence.focusedTest = "tests/test-active-lab-mini-smt-renderer-clab-only.sh";
}
