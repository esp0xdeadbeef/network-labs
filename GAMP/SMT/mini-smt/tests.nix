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
      rowDirectories = {
        SDS = ../../SDS/FS-800-HDS-030-SDS-030;
        SMS = ../../SMS/FS-800-HDS-030-SDS-030-SMS-010;
        SMT = ../FS-800-HDS-030-SDS-030-SMS-010;
        SIT = ../../SIT/FS-800-HDS-030-SDS-030;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-800-HDS-030-SDS-030-SMS-010/intent.nix;
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

    reachability-decision = {
      id = "reachability-decision";
      traceId = "FS-500-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-500-HDS-010-SDS-010;
        SMS = ../../SMS/FS-500-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-500-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-500-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-500-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [
          "FS-500-HDS-010-SDS-010-SMS-010__mini-allow-client-to-testnet"
        ];
      };
      evidenceLevels = [
        "SMT"
        "SIT"
      ];
      rendererTarget = null;
      script = "tests/test-active-lab-mini-smt-reachability-decision-only.sh";
      independent = true;
      aggregateOnly = false;
      scope = "NFM reachability decision result classification";
      maxRuntimeTargets = 2;
    };

    p2p-next-hop = {
      id = "p2p-next-hop";
      traceId = "FS-500-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-500-HDS-010-SDS-010;
        SMS = ../../SMS/FS-500-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-500-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-500-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-500-HDS-010-SDS-010-SMS-040/intent.nix;
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

    policy-router-relation-identity = {
      id = "policy-router-relation-identity";
      traceId = "FS-310-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-010-SDS-010;
        SMS = ../../SMS/FS-310-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-310-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-310-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [
          "FS-310-HDS-010-SDS-010-SMS-030__mini-allow-client-to-testnet"
        ];
      };
      evidenceLevels = [
        "SMT"
        "SIT"
      ];
      rendererTarget = null;
      script = "tests/test-active-lab-mini-smt-policy-router-relation-identity.sh";
      independent = true;
      aggregateOnly = false;
      scope = "CPM policy router relation identity preservation: one tenant-to-external allow relation through policy router";
      maxRuntimeTargets = 2;
    };

    lane-egress-binding = {
      id = "lane-egress-binding";
      traceId = "FS-370-HDS-010-SDS-010-SMS-050";
      rowDirectories = {
        SDS = ../../SDS/FS-370-HDS-010-SDS-010;
        SMS = ../../SMS/FS-370-HDS-010-SDS-010-SMS-050;
        SMT = ../FS-370-HDS-010-SDS-010-SMS-050;
        SIT = ../../SIT/FS-370-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-370-HDS-010-SDS-010-SMS-050/intent.nix;
        expectedRelationIds = [
          "FS-370-HDS-010-SDS-010-SMS-050__mini-client-to-testnet-uplink"
        ];
      };
      evidenceLevels = [
        "SMT"
        "SIT"
      ];
      rendererTarget = null;
      script = "tests/test-active-lab-mini-smt-lane-egress-binding-only.sh";
      independent = true;
      aggregateOnly = false;
      scope = "CPM lane egress binding: tenant client to external testnet uplink with correct lane kind and non-null uplink annotation";
      maxRuntimeTargets = 2;
    };

    provider-access-default-route = {
      id = "provider-access-default-route";
      traceId = "FS-800-HDS-010-SDS-020-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-800-HDS-010-SDS-020;
        SMS = ../../SMS/FS-800-HDS-010-SDS-020-SMS-040;
        SMT = ../FS-800-HDS-010-SDS-020-SMS-040;
        SIT = ../../SIT/FS-800-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-800-HDS-010-SDS-020-SMS-040/intent.nix;
        expectedRelationIds = [
          "FS-800-HDS-010-SDS-020-SMS-040__mini-provider-handoff-to-internet"
        ];
      };
      evidenceLevels = [
        "SMT"
        "SIT"
      ];
      rendererTarget = null;
      script = "tests/test-active-lab-mini-smt-provider-access-default-route.sh";
      independent = true;
      aggregateOnly = false;
      scope = "CPM provider-access fabric gateway routing contract";
      maxRuntimeTargets = 3;
    };

    decision-reason-diagnostic = {
      id = "decision-reason-diagnostic";
      traceId = "FS-500-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-500-HDS-010-SDS-010;
        SMS = ../../SMS/FS-500-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-500-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-500-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-500-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [
          "FS-500-HDS-010-SDS-010-SMS-030__mini-decision-reason-diagnostic"
        ];
      };
      evidenceLevels = [
        "SMT"
        "SIT"
      ];
      rendererTarget = null;
      script = "tests/test-active-lab-mini-smt-decision-reason-diagnostic-only.sh";
      independent = true;
      aggregateOnly = false;
      scope = "NFM traffic-path validation reason diagnostic: missing evidence, contract contradiction, valid-path classification";
      maxRuntimeTargets = 2;
    };

    dns-resolver-config = {
      id = "dns-resolver-config";
      traceId = "FS-540-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-540-HDS-010-SDS-010;
        SMS = ../../SMS/FS-540-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-540-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-540-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-540-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [
          "FS-540-HDS-010-SDS-010-SMS-020__mini-dns-client-to-testnet"
        ];
      };
      evidenceLevels = [
        "SMT"
        "SIT"
      ];
      rendererTarget = null;
      script = "tests/test-active-lab-mini-smt-dns-resolver-config-only.sh";
      independent = true;
      aggregateOnly = false;
      scope = "CPM per-interface DNS resolver configuration authority: dns.resolver4, dns.resolver6, dns.resolverSource emission";
      maxRuntimeTargets = 2;
    };

    renderer-nixos = {
      id = "renderer-nixos";
      traceId = "${rendererTrace}__active-lab-mini-runtime";
      rowDirectories = {
        SDS = ../../SDS/FS-166-HDS-010-SDS-010;
        SMS = ../../SMS/FS-166-HDS-010-SDS-010-SMS-900;
      };
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

    renderer-nixos-p2p = {
      id = "renderer-nixos-p2p";
      traceId = "${rendererTrace}__active-lab-mini-runtime-p2p";
      rowDirectories = {
        SDS = ../../SDS/FS-166-HDS-010-SDS-010;
        SMS = ../../SMS/FS-166-HDS-010-SDS-010-SMS-900;
      };
      source = {
        kind = "renderer-input";
        cpm = ./runtime-nixos-p2p-cpm.nix;
      };
      evidenceLevels = [
        "SMT"
        "SIT"
      ];
      rendererTarget = "nixos";
      script = "tests/test-active-lab-mini-smt-runtime-nixos-p2p-renderer-input.sh";
      independent = true;
      aggregateOnly = false;
      scope = "NixOS renderer materializes two p2p-linked runtime containers from explicit CPM input";
      maxRuntimeTargets = 2;
    };

    renderer-nixos-clients = {
      id = "renderer-nixos-clients";
      traceId = "${rendererTrace}__mini-renderer-nixos-clients";
      rowDirectories = {
        SDS = ../../SDS/FS-166-HDS-010-SDS-010;
        SMS = ../../SMS/FS-166-HDS-010-SDS-010-SMS-900;
      };
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
      rowDirectories = {
        SDS = ../../SDS/FS-166-HDS-010-SDS-010;
        SMS = ../../SMS/FS-166-HDS-010-SDS-010-SMS-900;
      };
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
      rowDirectories = {
        SDS = ../../SDS/FS-166-HDS-010-SDS-010;
        SMS = ../../SMS/FS-166-HDS-010-SDS-010-SMS-900;
      };
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
      rowDirectories = {
        SDS = ../../SDS/FS-166-HDS-010-SDS-010;
        SMS = ../../SMS/FS-166-HDS-010-SDS-010-SMS-900;
      };
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

    endpoint-harness-consumption = {
      id = "endpoint-harness-consumption";
      traceId = "FS-720-HDS-010-SDS-020-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-720-HDS-010-SDS-020;
        SMS = ../../SMS/FS-720-HDS-010-SDS-020-SMS-020;
        SMT = ../FS-720-HDS-010-SDS-020-SMS-020;
        SIT = ../../SIT/FS-720-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-720-HDS-010-SDS-020-SMS-020/intent.nix;
        expectedRelationIds = [
          "FS-720-HDS-010-SDS-020-SMS-020__mini-client-harness-consumption"
        ];
      };
      evidenceLevels = [
        "SMT"
        "SIT"
      ];
      rendererTarget = null;
      script = "tests/test-active-lab-mini-smt-endpoint-harness-consumption-only.sh";
      independent = true;
      aggregateOnly = false;
      scope = "s-router-test-clients endpoint harness consumption: validates endpoint fixtures from source-classified CPM contracts";
      maxRuntimeTargets = 3;
    };

    renderer-layout-preservation = {
      id = "renderer-layout-preservation";
      traceId = "FS-320-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-320-HDS-010-SDS-010;
        SMS = ../../SMS/FS-320-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-320-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-320-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-320-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [
          "FS-320-HDS-010-SDS-010-SMS-010__mini-client-to-testnet-allow"
          "FS-320-HDS-010-SDS-010-SMS-010__mini-mgmt-deny-internet"
        ];
      };
      evidenceLevels = [
        "SMT"
        "SIT"
      ];
      rendererTarget = null;
      script = "tests/test-active-lab-mini-smt-renderer-layout-preservation-only.sh";
      independent = true;
      aggregateOnly = false;
      scope = "renderer layout preservation: two-node co-located topology, access node hosts client+mgmt tenants with distinct allow/deny policy; verifies role identity and policy boundary preservation per SMS-010";
      maxRuntimeTargets = 2;
    };
  };
}
