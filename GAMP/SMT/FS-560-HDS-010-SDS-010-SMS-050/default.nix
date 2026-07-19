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
    kind = "cross-repo-construction-candidate";
    inherit intent inventoryNixos inventoryClab inventoryTestClients;
    evidenceBoundary = "construction-only";
  };
  status = "NOT OK";
  evidence = {
    command = "NETWORK_REPO_DIRECT_TEST_OK=1 tests/FS-560-HDS-010-SDS-010-SMS-050-native-protected-name-publication.sh";
    focusedTest = "tests/FS-560-HDS-010-SDS-010-SMS-050-native-protected-name-publication.sh";
    observedResult = "native cross-repo construction passes; fresh three-host cold stage and live unknown-name no-fallback evidence remain open";
  };
}
