{
  layer = "SMT";
  traceId = "FS-030-HDS-010-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-010-SMS-010-intent-authority-boundary.md";
  titleSlug = "intent-authority-boundary";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "active-lab-mini-smt-runtime";
  };
  status = "OK";
  evidence = {
    observedResult = "2026-07-04: intent-authority construction passed; offline verifier was disabled; pinned s-router-nixos build passed; live script passed on s-router-nixos, s-router-clab, and s-router-test-clients with runtime target counts 5/5/0 and evidence under /tmp/s-router-live-smoke/FS-030-HDS-010-SDS-010-SMS-010/20260704T034222Z.";
  };
}
