let
  rendererTrace = "FS-166-HDS-010-SDS-010-SMS-900";
in
{
  meta = {
    contract = "active-lab mini SMT independent test manifest";
    rule = "Each mini SMT row has one focused script and can be run without an aggregate renderer POC.";
    aggregateScripts = [
      "tests/test-active-lab-layer-entry-construction-cycles.sh"
      "tests/test-active-lab-layer-entry-renderer-input-poc.sh"
    ];
  };

  tests = {
    pppoe-pairing = {
      id = "pppoe-pairing";
      traceId = "FS-800-HDS-030-SDS-030-SMS-010";
      source = {
        kind = "intent-source";
        intent = ./intents/pppoe-pairing/intent.nix;
        expectedRelationIds = [
          "FS-800-HDS-030-SDS-030-SMS-010__mini-pppoe-client-to-provider"
        ];
      };
      evidenceLevels = [
        "SMT"
        "SIT"
      ];
      rendererTarget = null;
      script = "tests/test-active-lab-mini-smt-pppoe-pairing-only.sh";
      independent = true;
      aggregateOnly = false;
      scope = "compiler/NFM PPPoE pairing contract";
      maxRuntimeTargets = 2;
    };

    p2p-next-hop = {
      id = "p2p-next-hop";
      traceId = "FS-500-HDS-010-SDS-010-SMS-040";
      source = {
        kind = "intent-source";
        intent = ./intents/p2p-next-hop/intent.nix;
        expectedRelationIds = [
          "FS-500-HDS-010-SDS-010-SMS-040__mini-p2p-route-to-peer"
        ];
      };
      evidenceLevels = [
        "SMT"
        "SIT"
      ];
      rendererTarget = null;
      script = "tests/test-active-lab-mini-smt-p2p-next-hop-only.sh";
      independent = true;
      aggregateOnly = false;
      scope = "CPM point-to-point next-hop contract";
      maxRuntimeTargets = 2;
    };

    renderer-nixos = {
      id = "renderer-nixos";
      traceId = "${rendererTrace}__active-lab-mini-runtime";
      source = {
        kind = "renderer-input";
        cpm = ./runtime-nixos-cpm.nix;
      };
      evidenceLevels = [
        "SMT"
        "SIT"
      ];
      rendererTarget = "nixos";
      script = "tests/test-active-lab-mini-smt-runtime-nixos-renderer-input.sh";
      independent = true;
      aggregateOnly = false;
      scope = "NixOS renderer materializes one runtime container from explicit CPM input";
      maxRuntimeTargets = 1;
    };

    renderer-nixos-clients = {
      id = "renderer-nixos-clients";
      traceId = "${rendererTrace}__mini-renderer-nixos-clients";
      source = {
        kind = "renderer-input";
        cpm = ../layer-entry-poc/renderer-input/minimal-access-endpoint-cpm.nix;
      };
      evidenceLevels = [
        "SMT"
        "SIT"
      ];
      rendererTarget = "nixos-clients";
      script = "tests/test-active-lab-mini-smt-renderer-nixos-clients-only.sh";
      independent = true;
      aggregateOnly = false;
      scope = "NixOS clients renderer materializes one endpoint container from explicit CPM input";
      maxRuntimeTargets = 1;
    };

    renderer-clab = {
      id = "renderer-clab";
      traceId = "${rendererTrace}__mini-renderer-clab";
      source = {
        kind = "renderer-input";
        cpm = ../layer-entry-poc/renderer-input/minimal-clab-cpm.nix;
      };
      evidenceLevels = [
        "SMT"
        "SIT"
      ];
      rendererTarget = "clab";
      script = "tests/test-active-lab-mini-smt-renderer-clab-only.sh";
      independent = true;
      aggregateOnly = false;
      scope = "containerlab renderer materializes one p2p lab edge from explicit CPM input";
      maxRuntimeTargets = 2;
    };

    renderer-wireguard = {
      id = "renderer-wireguard";
      traceId = "${rendererTrace}__mini-renderer-wireguard";
      source = {
        kind = "renderer-input";
        cpm = ../layer-entry-poc/renderer-input/wireguard-provider-contract.nix;
      };
      evidenceLevels = [
        "SMT"
        "SIT"
      ];
      rendererTarget = "wireguard";
      script = "tests/test-active-lab-mini-smt-renderer-wireguard-only.sh";
      independent = true;
      aggregateOnly = false;
      scope = "WireGuard provider renderer materializes provider runtime module from explicit CPM input";
      maxRuntimeTargets = 1;
    };

    renderer-nebula = {
      id = "renderer-nebula";
      traceId = "${rendererTrace}__mini-renderer-nebula";
      source = {
        kind = "renderer-input";
        cpm = ../layer-entry-poc/renderer-input/minimal-nebula-cpm.nix;
      };
      evidenceLevels = [
        "SMT"
        "SIT"
      ];
      rendererTarget = "nebula";
      script = "tests/test-active-lab-mini-smt-renderer-nebula-only.sh";
      independent = true;
      aggregateOnly = false;
      scope = "Nebula renderer materializes one overlay with lighthouse/client nodes from explicit CPM input";
      maxRuntimeTargets = 2;
    };
  };
}
