{
  layer = "SMT";
  traceId = "FS-010-HDS-010-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-010-HDS-010-SDS-010-SMS-010-accepted-source-set.md";
  titleSlug = "accepted-source-set";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-010-HDS-010-SDS-010-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-010-HDS-010-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-010-HDS-010-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-010-HDS-010-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "active-lab-mini-smt-runtime";
  };
  status = "OK";
  evidence = {
    command = "MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-010-HDS-010-SDS-010-SMS-010";
    focusedTest = "tests/test-active-lab-mini-smt-fs010-accepted-source-set.sh";
    liveScript = "../network-codex-agent/scripts/smt-live-FS-010-HDS-010-SDS-010-SMS-010.sh";
    observedResult = "2026-07-04: focused accepted-source-set construction passed; offline verifier was disabled; pinned s-router-nixos build passed; live script passed on s-router-nixos, s-router-clab, and s-router-test-clients with runtime target counts 5/5/0 and evidence under /tmp/s-router-live-smoke/FS-010-HDS-010-SDS-010-SMS-010/20260704T025858Z.";
  };
}
