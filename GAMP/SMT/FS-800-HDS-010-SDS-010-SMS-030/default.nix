{
  layer = "SMT";
  traceId = "FS-800-HDS-010-SDS-010-SMS-030";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-010-SDS-010-SMS-030-provider-access-underlay-attachments.md";
  titleSlug = "provider-access-underlay-attachments";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-800-HDS-010-SDS-010-SMS-030/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-800-HDS-010-SDS-010-SMS-030/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-800-HDS-010-SDS-010-SMS-030/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-800-HDS-010-SDS-010-SMS-030/inventory-test-clients.nix";
    };
    evidenceBoundary = "runtime";
  };
  status = "OK";
  evidence = {
    command = "bash tests/FS-800-HDS-010-SDS-010-SMS-030.sh";
    focusedTest = "tests/FS-800-HDS-010-SDS-010-SMS-030.sh (network-codex-agent)";
    observedResult = "14/14 SMS construction predicates PASS. CPM artifacts on s-router-nixos and s-router-clab: validPathCount=1, invalidPathCount=0, 5 runtime targets, canonical stage path access->ds->policy->us->core.";
  };
}
