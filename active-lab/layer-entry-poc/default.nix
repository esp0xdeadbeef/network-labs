let
  traceId = "FS-166-HDS-010-SDS-010-SMS-900__allow-client-to-testnet-host-isp";

  requiredPath = [
    "network-labs"
    "network-compiler"
    "network-forwarding-model"
    "network-control-plane-model"
    "network-renderer-nixos"
    "nixos-runtime"
  ];

  skippedForBoundary = {
    intent-source = [ ];
    compiler-output = [ "intent-source" ];
    forwarding-model-input = [ "intent-source" "network-compiler" ];
    control-plane-input = [
      "intent-source"
      "network-compiler"
      "network-forwarding-model"
    ];
    renderer-input = [
      "intent-source"
      "network-compiler"
      "network-forwarding-model"
      "network-control-plane-model"
    ];
  };
in
{
  meta = {
    contract = "active-lab layer-entry runtime POC";
    status = "poc";
    scope = "SMT/SIT construction helper only; not HAT/SAT approval";
    inherit traceId requiredPath;
  };

  source = {
    intent = ../intent.nix;
    inventoryNixos = ../inventory-nixos.nix;
    selector = "s-router-nixos";
  };

  boundaryInputs = {
    intent-source = {
      entryBoundary = "intent-source";
      skippedUpstreamLayers = skippedForBoundary.intent-source;
      downstreamPath = requiredPath;
      suppliedArtifact = {
        kind = "active-lab-intent-and-inventory";
        intent = ../intent.nix;
        inventory = ../inventory-nixos.nix;
      };
      expectedPocChecks = [
        "containers-start-shape"
        "pppoe-client-server-pairing"
        "p2p-route-shape"
      ];
    };

    compiler-output = {
      entryBoundary = "compiler-output";
      skippedUpstreamLayers = skippedForBoundary.compiler-output;
      downstreamPath = [
        "network-forwarding-model"
        "network-control-plane-model"
        "network-renderer-nixos"
      ];
      suppliedArtifact = {
        kind = "synthetic-compiler-output";
        fixture = ./compiler-output/minimal-site.nix;
      };
      expectedWarnings = [ "WARN_LAYER_ENTRY_SKIPS_NETWORK_LABS_INTENT_SOURCE" ];
    };

    forwarding-model-input = {
      entryBoundary = "forwarding-model-input";
      skippedUpstreamLayers = skippedForBoundary.forwarding-model-input;
      downstreamPath = [
        "network-forwarding-model"
        "network-control-plane-model"
        "network-renderer-nixos"
      ];
      suppliedArtifact = {
        kind = "synthetic-forwarding-model-input";
        fixture = ./forwarding-model-input/minimal-forwarding-site.nix;
      };
      expectedWarnings = [
        "WARN_LAYER_ENTRY_SKIPS_NETWORK_LABS_INTENT_SOURCE"
        "WARN_LAYER_ENTRY_SKIPS_NETWORK_COMPILER"
      ];
    };

    control-plane-input = {
      entryBoundary = "control-plane-input";
      skippedUpstreamLayers = skippedForBoundary.control-plane-input;
      downstreamPath = [
        "network-control-plane-model"
        "network-renderer-nixos"
      ];
      suppliedArtifact = {
        kind = "synthetic-control-plane-input";
        fixture = ./control-plane-input/minimal-forwarding-plus-realization.nix;
      };
      expectedWarnings = [
        "WARN_LAYER_ENTRY_SKIPS_NETWORK_LABS_INTENT_SOURCE"
        "WARN_LAYER_ENTRY_SKIPS_NETWORK_COMPILER"
        "WARN_LAYER_ENTRY_SKIPS_NFM"
      ];
    };

    renderer-input = {
      entryBoundary = "renderer-input";
      skippedUpstreamLayers = skippedForBoundary.renderer-input;
      downstreamPath = [ "network-renderer-nixos" "nixos-materializer" ];
      suppliedArtifact = {
        kind = "network-labs-owned-cpm-input";
        fixture = ./renderer-input/minimal-container-cpm.nix;
        contract = ./renderer-input/cpm-input-contract.nix;
      };
      expectedWarnings = [
        "WARN_LAYER_ENTRY_SKIPS_NETWORK_LABS_INTENT_SOURCE"
        "WARN_LAYER_ENTRY_SKIPS_NETWORK_COMPILER"
        "WARN_LAYER_ENTRY_SKIPS_NFM"
        "WARN_LAYER_ENTRY_SKIPS_CPM"
      ];
      expectedPocChecks = [
        "containers-start-shape"
        "pppoe-client-server-pairing"
        "p2p-route-shape"
      ];
    };
  };
}
