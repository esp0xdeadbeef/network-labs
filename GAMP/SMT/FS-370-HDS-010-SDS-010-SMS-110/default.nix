{
  layer = "SMT";
  traceId = "FS-370-HDS-010-SDS-010-SMS-110";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-370-HDS-010-SDS-010-SMS-110-clab-linux-forwarding-materialization.md";
  titleSlug = "clab-linux-forwarding-materialization";
  evidenceBoundary = "split";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [ "FS-370-HDS-010-SDS-010-SMS-110__mini-verify" ];
    inventories = {
      clab = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-110/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-110/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-110/inventory-test-clients.nix";
    };
  };
  status = "OK";
  evidence = {
    owningRepo = "network-renderer-containerlab-linux-backend";
    activeLabContext = "tests/run-active-lab-mini-smt.sh FS-370-HDS-010-SDS-010-SMS-110";
    smtRow = "GAMP/SMT/README.md row 230";
    status = "OK";
    verifiedAt = "network-renderer-containerlab-linux-backend local HEAD 716266f plus working tree (2026-07-02)";
    maxRuntimeTargets = 3;
    scope = "CLAB/Linux FS-370 forwarding materialization: renderer emits and validates nft forward rules, static/default routes, policy rules, and forwarding sysctls with six active seeded diagnostics. Active-lab context currently reports host artifact context and does not promote runtime packet acceptance.";
  };
}
