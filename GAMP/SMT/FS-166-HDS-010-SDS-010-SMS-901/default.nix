{
  layer = "SMT";
  traceId = "FS-166-HDS-010-SDS-010-SMS-901";
  smsRow = ../../SMS/FS-166-HDS-010-SDS-010-SMS-901;
  source = {
    kind = "renderer-input";
    sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/runtime-nixos-cpm.nix";
    evidenceBoundary = "active-lab renderer-input mini SMT/SIT";
  };
  status = "OK";
  evidence.command = "tests/run-active-lab-mini-smt.sh FS-166-HDS-010-SDS-010-SMS-901";
  evidence.focusedTest = "tests/test-active-lab-mini-smt-runtime-nixos-renderer-input.sh";
}
