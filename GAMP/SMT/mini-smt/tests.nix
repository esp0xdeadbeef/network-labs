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
      scope = "NFM decision reason diagnostics for reachability validation";
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
      scope = "CPM lane egress binding classification over the five-node access -> downstream-selector -> policy -> upstream-selector -> testnet path";
      maxRuntimeTargets = 5;
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
          "FS-540-HDS-010-SDS-010-SMS-020__mini-client-to-access-dns"
          "FS-540-HDS-010-SDS-010-SMS-020__mini-access-dns-service-to-testnet"
          "FS-540-HDS-010-SDS-010-SMS-020__mini-dns-client-to-testnet"
        ];
      };
      evidenceLevels = [
        "SMT"
        "SIT"
      ];
      rendererTarget = null;
      script = "tests/test-active-lab-mini-smt-dns-resolver-config-only.sh";
      liveSitScript = "tests/FS-540-HDS-010-SDS-010-SIT-live-recursive-dns.sh";
      independent = true;
      aggregateOnly = false;
      scope = "CPM per-interface DNS resolver configuration authority over the smallest requester-policy-resolver path";
      maxRuntimeTargets = 5;
    };

    internet-mode-verification = {
      id = "internet-mode-verification";
      traceId = "FS-380-HDS-020-SDS-010-SMS-050";
      rowDirectories = {
        SDS = ../../SDS/FS-380-HDS-020-SDS-010;
        SMS = ../../SMS/FS-380-HDS-020-SDS-010-SMS-050;
        SMT = ../FS-380-HDS-020-SDS-010-SMS-050;
        SIT = ../../SIT/FS-380-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-380-HDS-020-SDS-010-SMS-050/intent.nix;
        expectedRelationIds = [
          "FS-380-HDS-020-SDS-010-SMS-050__mini-client-to-emulated-isp"
        ];
      };
      evidenceLevels = [
        "SMT"
        "SIT"
      ];
      rendererTarget = null;
      script = "tests/test-active-lab-mini-smt-internet-mode-verification-only.sh";
      independent = true;
      aggregateOnly = false;
      scope = "SMT/SIT-only internet-mode emulated PPPoE provider with VLAN4/VLAN5 DHCP upstream verification; no skips, NAT, or VLAN2";
      maxRuntimeTargets = 2;
    };

    renderer-nixos = {
      id = "renderer-nixos";
      traceId = "${rendererTrace}__active-lab-mini-runtime";
      rowDirectories = {
        SDS = ../../SDS/FS-166-HDS-010-SDS-010;
        SMS = ../../SMS/FS-166-HDS-010-SDS-010-SMS-900;
        SMT = ../FS-166-HDS-010-SDS-010-SMS-900;
        SIT = ../../SIT/FS-166-HDS-010-SDS-010;
      };
      source = {
        kind = "renderer-input";
        cpm = ../FS-166-HDS-010-SDS-010-SMS-900/runtime-nixos-cpm.nix;
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
        SMT = ../FS-166-HDS-010-SDS-010-SMS-900;
        SIT = ../../SIT/FS-166-HDS-010-SDS-010;
      };
      source = {
        kind = "renderer-input";
        cpm = ../FS-166-HDS-010-SDS-010-SMS-900/runtime-nixos-p2p-cpm.nix;
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
        SMT = ../FS-166-HDS-010-SDS-010-SMS-900;
        SIT = ../../SIT/FS-166-HDS-010-SDS-010;
      };
      source = {
        kind = "renderer-input";
        cpm = ../FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-access-endpoint-cpm.nix;
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
        SMT = ../FS-166-HDS-010-SDS-010-SMS-900;
        SIT = ../../SIT/FS-166-HDS-010-SDS-010;
      };
      source = {
        kind = "renderer-input";
        cpm = ../FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-clab-cpm.nix;
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
        SMT = ../FS-166-HDS-010-SDS-010-SMS-900;
        SIT = ../../SIT/FS-166-HDS-010-SDS-010;
      };
      source = {
        kind = "renderer-input";
        cpm = ../FS-166-HDS-010-SDS-010-SMS-900/renderer-input/wireguard-provider-contract.nix;
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
        SMT = ../FS-166-HDS-010-SDS-010-SMS-900;
        SIT = ../../SIT/FS-166-HDS-010-SDS-010;
      };
      source = {
        kind = "renderer-input";
        cpm = ../FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-nebula-cpm.nix;
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
