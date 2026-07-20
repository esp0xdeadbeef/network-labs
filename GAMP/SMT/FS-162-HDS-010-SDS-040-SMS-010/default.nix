{
  layer = "SMT";
  traceId = "FS-162-HDS-010-SDS-040-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-162-HDS-010-SDS-040-SMS-010-s-router-prod-comparable-projection.md";
  titleSlug = "s-router-prod-comparable-projection";
  source = {
    kind = "isolated-fs230-cpm";
    sourcePath = "GAMP/SMT/FS-162-HDS-010-SDS-040-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-162-HDS-010-SDS-040-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-162-HDS-010-SDS-040-SMS-010/inventory-nixos.nix";
      openconfig = "GAMP/SMT/FS-162-HDS-010-SDS-040-SMS-010/inventory-openconfig.nix";
      testClients = "GAMP/SMT/FS-162-HDS-010-SDS-040-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "construction-only";
  };
  status = "OK";
  evidence = {
    command = "bash tests/FS-162-HDS-010-SDS-040-SMS-010-s-router-prod-comparable-projection.sh";
    focusedTest = "network-renderer-openconfig/tests/FS-162-HDS-010-SDS-040-SMS-010-s-router-prod-comparable-projection.sh";
    rendererRevision = "9cff098bc2b9d6f9ae28ea5846eb7d128f530a2b";
    observedResult = "direct NixOS, CLAB, and OpenConfig CPM inputs share source identity, pinned compiler/CPM revisions, and the normalized FS-230 posture; CPM portability passes while complete OpenConfig instance-model coverage remains false";
  };
}
