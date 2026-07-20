{
  layer = "SMT";
  traceId = "FS-720-HDS-030-SDS-010-SMS-041";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-720-HDS-030-SDS-010-SMS-041-ae-fail-closed-contract.md";
  titleSlug = "ae-fail-closed-contract";
  source = {
    kind = "network-labs-active-lab-source-fixture";
    sourcePath = "GAMP/SMT/FS-720-HDS-030-SDS-010-SMS-041/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-720-HDS-030-SDS-010-SMS-041/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-720-HDS-030-SDS-010-SMS-041/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-720-HDS-030-SDS-010-SMS-041/inventory-test-clients.nix";
    };
    evidenceBoundary = "active-lab-source-fixture-only";
  };
  status = "OK";
  evidence = {
    observedResult = "active-lab HAT source inventories expose explicit tenant attach.bridge fields for CLAB/NixOS core tenant surfaces and provider handoff surfaces before the CLAB renderer fail-closed bridge-field contract is exercised; source fixture evidence only, not live HAT/SAT session proof";
  };
}
