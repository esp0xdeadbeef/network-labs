{
  layer = "SMT";
  traceId = "FS-260-HDS-010-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-260-HDS-010-SDS-010-SMS-010-default-site-fabric-chain.md";
  titleSlug = "default-site-fabric-chain";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-260-HDS-010-SDS-010-SMS-010/intent.nix";
    inventories = {
      nixos = "GAMP/SMT/FS-260-HDS-010-SDS-010-SMS-010/inventory-nixos.nix";
      clab = "GAMP/SMT/FS-260-HDS-010-SDS-010-SMS-010/inventory-clab.nix";
      testClients = "GAMP/SMT/FS-260-HDS-010-SDS-010-SMS-010/inventory-test-clients.nix";
      testClientIntent = "GAMP/SMT/FS-260-HDS-010-SDS-010-SMS-010/intent-test-clients.nix";
    };
    evidenceBoundary = "isolated-dual-substrate-policy-required-access-return";
  };
  status = "NOT OK";
  evidence = {
    command = "pending cold-stage live verifier on s-router-nixos, s-router-clab, and s-router-test-clients";
    observedResult = "Construction source is defined; live dual-substrate stateful-return and reverse-new-flow denial remain to be executed.";
  };
}
