{
  layer = "SMT";
  traceId = "FS-810-HDS-010-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-810-HDS-010-SDS-010-SMS-010-secret-material-declaration.md";
  titleSlug = "secret-material-declaration";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-810-HDS-010-SDS-010-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-810-HDS-010-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-810-HDS-010-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-810-HDS-010-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "runtime";
  };
  status = "OK";
  evidence = {
    observedResult = "Construction PASS: all SMS-010 predicates proven (MR1-MR2, CI1-CI3, EI1-EI2, FC1-FC3, CH1, SN1-SN3). Live SMT PASS: s-router-nixos 5 targets/35 hits, s-router-clab 5 targets/35 hits, s-router-test-clients 0 targets/1 hit. Evidence file: network-codex-agent/GAMP/SMT/FS-810-HDS-010-SDS-010-SMS-010-online-eval.txt";
  };
}
