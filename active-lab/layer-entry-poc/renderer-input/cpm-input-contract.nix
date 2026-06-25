{
  pocKind = "synthetic-renderer-input";
  schema = "network-labs.layer-entry-poc.renderer-input.v1";
  note = "Contract slot for tests that skip compiler, NFM, and CPM and feed the downstream renderer/NixOS materialization path directly.";
  rendererTargets = [
    "nixos"
    "clab"
    "wireguard"
    "nebula"
  ];
  requiredCpmSurfaces = [
    "runtimeTargets"
    "container placement"
    "PPPoE client/server services"
    "p2p runtime interfaces"
    "routes"
    "firewall policy"
    "DNS policy"
  ];
}
