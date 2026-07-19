let
  intent = import ./intent.nix;
  inventoryNixos = import ./inventory-nixos.nix;
  inventoryClab = import ./inventory-clab.nix;
  inventoryTestClients = import ./inventory-test-clients.nix;
in
{
  layer = "SMT";
  traceId = "FS-560-HDS-010-SDS-010-SMS-050";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-560-HDS-010-SDS-010-SMS-050-protected-reservation-name-materialization.md";
  titleSlug = "protected-reservation-name-materialization";
  source = {
    kind = "intent-source";
    inherit
      intent
      inventoryNixos
      inventoryClab
      inventoryTestClients
      ;
    evidenceBoundary = "live-protected-name-publication";
  };
  runtimeHosts = [
    "s-router-nixos"
    "s-router-clab"
    "s-router-test-clients"
  ];
  status = "NOT OK";
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-560-HDS-010-SDS-010-SMS-050";
    constructionCommand = "NETWORK_REPO_DIRECT_TEST_OK=1 tests/FS-560-HDS-010-SDS-010-SMS-050-native-protected-name-publication.sh";
    focusedTest = "tests/FS-560-HDS-010-SDS-010-SMS-050-native-protected-name-publication.sh";
    liveProbe = "network-codex-agent/scripts/smt-live-FS-560-HDS-010-SDS-010-SMS-050.sh";
    observedResult = "native cross-repo construction and real isolated row wiring pass; fresh three-host cold stage and live NixOS/CLAB unknown-name no-fallback evidence remain open";
  };
}
