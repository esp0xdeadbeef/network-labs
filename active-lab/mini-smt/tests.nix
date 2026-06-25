let
  commonTrace = "FS-166-HDS-010-SDS-010-SMS-900";
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
      traceId = "${commonTrace}__mini-pppoe-pairing";
      rendererTarget = null;
      script = "tests/test-active-lab-mini-smt-pppoe-pairing-only.sh";
      independent = true;
      aggregateOnly = false;
      scope = "compiler/NFM PPPoE pairing contract";
      maxRuntimeTargets = 1;
    };

    p2p-next-hop = {
      id = "p2p-next-hop";
      traceId = "${commonTrace}__mini-p2p-next-hop";
      rendererTarget = null;
      script = "tests/test-active-lab-mini-smt-p2p-next-hop-only.sh";
      independent = true;
      aggregateOnly = false;
      scope = "CPM point-to-point next-hop contract";
      maxRuntimeTargets = 1;
    };

    renderer-nixos = {
      id = "renderer-nixos";
      traceId = "${commonTrace}__active-lab-mini-runtime";
      rendererTarget = "nixos";
      script = "tests/test-active-lab-mini-smt-runtime-nixos-renderer-input.sh";
      independent = true;
      aggregateOnly = false;
      scope = "NixOS renderer materializes one runtime container from explicit CPM input";
      maxRuntimeTargets = 1;
    };

    renderer-nixos-clients = {
      id = "renderer-nixos-clients";
      traceId = "${commonTrace}__mini-renderer-nixos-clients";
      rendererTarget = "nixos-clients";
      script = "tests/test-active-lab-mini-smt-renderer-nixos-clients-only.sh";
      independent = true;
      aggregateOnly = false;
      scope = "NixOS clients renderer materializes one endpoint container from explicit CPM input";
      maxRuntimeTargets = 1;
    };

    renderer-clab = {
      id = "renderer-clab";
      traceId = "${commonTrace}__mini-renderer-clab";
      rendererTarget = "clab";
      script = "tests/test-active-lab-mini-smt-renderer-clab-only.sh";
      independent = true;
      aggregateOnly = false;
      scope = "containerlab renderer materializes one p2p lab edge from explicit CPM input";
      maxRuntimeTargets = 2;
    };

    renderer-wireguard = {
      id = "renderer-wireguard";
      traceId = "${commonTrace}__mini-renderer-wireguard";
      rendererTarget = "wireguard";
      script = "tests/test-active-lab-mini-smt-renderer-wireguard-only.sh";
      independent = true;
      aggregateOnly = false;
      scope = "WireGuard provider renderer materializes provider runtime module from explicit CPM input";
      maxRuntimeTargets = 1;
    };

    renderer-nebula = {
      id = "renderer-nebula";
      traceId = "${commonTrace}__mini-renderer-nebula";
      rendererTarget = "nebula";
      script = "tests/test-active-lab-mini-smt-renderer-nebula-only.sh";
      independent = true;
      aggregateOnly = false;
      scope = "Nebula renderer materializes one overlay with lighthouse/client nodes from explicit CPM input";
      maxRuntimeTargets = 2;
    };
  };
}
