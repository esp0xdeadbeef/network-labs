{
  layer = "SMT";
  traceId = "FS-166-HDS-010-SDS-010-SMS-905";
  smsRow = ../../SMS/FS-166-HDS-010-SDS-010-SMS-905;
  source = {
    kind = "renderer-input";
    sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/wireguard-provider-contract.nix";
    evidenceBoundary = "active-lab renderer-input mini SMT/SIT";
  };
  status = "OK";
  evidence.command = "tests/run-active-lab-mini-smt.sh FS-166-HDS-010-SDS-010-SMS-905";
  evidence.focusedTest = "tests/test-active-lab-mini-smt-renderer-wireguard-only.sh";
}
