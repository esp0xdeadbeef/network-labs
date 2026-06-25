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

  skippedReposForBoundary = builtins.mapAttrs
    (_: layers: builtins.filter (layer: layer != "intent-source" && layer != "renderer") layers)
    skippedForBoundary;

  warningForRepo = {
    network-compiler = "WARN_LAYER_ENTRY_SKIPS_NETWORK_COMPILER";
    network-forwarding-model = "WARN_LAYER_ENTRY_SKIPS_NFM";
    network-control-plane-model = "WARN_LAYER_ENTRY_SKIPS_CPM";
  };

  warningMapForBoundary =
    boundary:
    builtins.listToAttrs (
      map
        (repo: {
          name = repo;
          value = warningForRepo.${repo};
        })
        (skippedReposForBoundary.${boundary} or [ ])
    );

  repositoryPath = [
    "network-labs"
    "network-compiler"
    "network-forwarding-model"
    "network-control-plane-model"
  ];

  rendererTargets = {
    nixos = {
      rendererRepo = "network-renderer-nixos";
      materializer = "nixos-config";
      fixture = ./renderer-input/minimal-container-cpm.nix;
      expectedSurfaces = [ "container-config" "container-autostart" ];
    };
    nixos-clients = {
      rendererRepo = "network-renderer-access-endpoint-nixos";
      materializer = "nixos-client-container-config";
      fixture = ./renderer-input/minimal-access-endpoint-cpm.nix;
      expectedSurfaces = [ "endpoint-container-config" "endpoint-bridge" ];
    };
    clab = {
      rendererRepo = "network-renderer-containerlab-linux-backend";
      materializer = "containerlab-yaml";
      fixture = ./renderer-input/minimal-clab-cpm.nix;
      expectedSurfaces = [ "topology-nodes" "p2p-link-bridge" ];
    };
    wireguard = {
      rendererRepo = "network-renderer-wireguard";
      materializer = "wireguard-provider-runtime-module";
      fixture = ./renderer-input/wireguard-provider-contract.nix;
      expectedSurfaces = [ "provider-render-result" "provider-runtime-module" ];
    };
    nebula = {
      rendererRepo = "network-renderer-nebula";
      materializer = "nebula-runtime-plan";
      fixture = ./renderer-input/minimal-nebula-cpm.nix;
      expectedSurfaces = [ "runtime-plan" "relay-static-map" "unsafe-routes" ];
    };
  };
in
{
  meta = {
    contract = "active-lab layer-entry runtime POC";
    status = "poc";
    scope = "SMT/SIT construction helper only; not HAT/SAT approval";
    inherit traceId requiredPath rendererTargets;
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
      skippedRepos = skippedReposForBoundary.forwarding-model-input;
      downstreamPath = [
        "network-compiler"
        "network-forwarding-model"
        "network-control-plane-model"
      ];
      rendererTargets = [ ];
      suppliedArtifact = {
        kind = "synthetic-forwarding-model-input";
        fixture = ./forwarding-model-input/minimal-forwarding-site.nix;
      };
      expectedWarnings = [
        "WARN_LAYER_ENTRY_SKIPS_NETWORK_LABS_INTENT_SOURCE"
        "WARN_LAYER_ENTRY_SKIPS_NETWORK_COMPILER"
      ];
      expectedRepoWarnings = warningMapForBoundary "forwarding-model-input";
      passThroughRepos = skippedReposForBoundary.forwarding-model-input;
    };

    control-plane-input = {
      entryBoundary = "control-plane-input";
      skippedUpstreamLayers = skippedForBoundary.control-plane-input;
      skippedRepos = skippedReposForBoundary.control-plane-input;
      downstreamPath = [
        "network-compiler"
        "network-forwarding-model"
        "network-control-plane-model"
      ];
      rendererTargets = [ ];
      suppliedArtifact = {
        kind = "synthetic-control-plane-input";
        fixture = ./control-plane-input/minimal-forwarding-plus-realization.nix;
      };
      expectedWarnings = [
        "WARN_LAYER_ENTRY_SKIPS_NETWORK_LABS_INTENT_SOURCE"
        "WARN_LAYER_ENTRY_SKIPS_NETWORK_COMPILER"
        "WARN_LAYER_ENTRY_SKIPS_NFM"
      ];
      expectedRepoWarnings = warningMapForBoundary "control-plane-input";
      passThroughRepos = skippedReposForBoundary.control-plane-input;
    };

    renderer-input = {
      entryBoundary = "renderer-input";
      skippedUpstreamLayers = skippedForBoundary.renderer-input;
      skippedRepos = skippedReposForBoundary.renderer-input;
      downstreamPath = repositoryPath ++ [
        "network-renderer-nixos"
        "network-renderer-access-endpoint-nixos"
        "network-renderer-containerlab-linux-backend"
        "network-renderer-wireguard"
        "network-renderer-nebula"
      ];
      rendererTargets = builtins.attrNames rendererTargets;
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
      expectedRepoWarnings = warningMapForBoundary "renderer-input";
      passThroughRepos = skippedReposForBoundary.renderer-input;
      expectedPocChecks = [
        "containers-start-shape"
        "pppoe-client-server-pairing"
        "p2p-route-shape"
      ];
    };
  };

  skipDecisions = {
    skip-network-compiler = {
      entryBoundary = "forwarding-model-input";
      skippedRepos = [ "network-compiler" ];
      passThroughRepos = [ "network-compiler" ];
      downstreamPath = [
        "network-compiler"
        "network-forwarding-model"
        "network-control-plane-model"
      ];
      expectedRepoWarnings = warningMapForBoundary "forwarding-model-input";
    };

    skip-network-compiler-and-nfm = {
      entryBoundary = "control-plane-input";
      skippedRepos = [ "network-compiler" "network-forwarding-model" ];
      passThroughRepos = [ "network-compiler" "network-forwarding-model" ];
      downstreamPath = [
        "network-compiler"
        "network-forwarding-model"
        "network-control-plane-model"
      ];
      expectedRepoWarnings = warningMapForBoundary "control-plane-input";
    };

    skip-network-compiler-nfm-and-cpm = {
      entryBoundary = "renderer-input";
      skippedRepos = [
        "network-compiler"
        "network-forwarding-model"
        "network-control-plane-model"
      ];
      passThroughRepos = [
        "network-compiler"
        "network-forwarding-model"
        "network-control-plane-model"
      ];
      downstreamPath = repositoryPath ++ [
        "network-renderer-nixos"
        "network-renderer-access-endpoint-nixos"
        "network-renderer-containerlab-linux-backend"
        "network-renderer-wireguard"
        "network-renderer-nebula"
      ];
      rendererTargets = builtins.attrNames rendererTargets;
      expectedRepoWarnings = warningMapForBoundary "renderer-input";
    };
  };
}
