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
    "FS-800-HDS-030-SDS-030-SMS-010" = {
      id = "FS-800-HDS-030-SDS-030-SMS-010";
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
      scope = "compiler/NFM PPPoE pairing contract over the five-node access -> downstream-selector -> policy -> upstream-selector -> pppoe-provider path";
      maxRuntimeTargets = 5;
    };

    "FS-800-HDS-010-SDS-020-SMS-040" = {
      id = "FS-800-HDS-010-SDS-020-SMS-040";
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
      script = "tests/FS-800-HDS-010-SDS-020-SMS-040-provider-access-default-route.sh";
      independent = true;
      aggregateOnly = false;
      scope = "provider-access default route selection over the smallest canonical policy path plus PPPoE-side core";
      maxRuntimeTargets = 6;
    };

    "FS-500-HDS-010-SDS-010-SMS-010" = {
      id = "FS-500-HDS-010-SDS-010-SMS-010";
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
      maxRuntimeTargets = 5;
    };

    "FS-500-HDS-010-SDS-010-SMS-030" = {
      id = "FS-500-HDS-010-SDS-010-SMS-030";
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
      scope = "NFM decision reason diagnostics over the five-node client -> downstream-selector -> policy -> upstream-selector -> testnet path";
      maxRuntimeTargets = 5;
    };

    "FS-500-HDS-010-SDS-010-SMS-040" = {
      id = "FS-500-HDS-010-SDS-010-SMS-040";
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
      scope = "CPM point-to-point next-hop contract over the five-node router-a -> downstream-selector -> policy -> upstream-selector -> router-b path";
      maxRuntimeTargets = 5;
    };

    "FS-370-HDS-010-SDS-010-SMS-050" = {
      id = "FS-370-HDS-010-SDS-010-SMS-050";
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

    "FS-540-HDS-010-SDS-010-SMS-020" = {
      id = "FS-540-HDS-010-SDS-010-SMS-020";
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

    "FS-380-HDS-020-SDS-010-SMS-050" = {
      id = "FS-380-HDS-020-SDS-010-SMS-050";
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

    "FS-380-HDS-020-SDS-010-SMS-120" = {
      id = "FS-380-HDS-020-SDS-010-SMS-120";
      traceId = "FS-380-HDS-020-SDS-010-SMS-120";
      rowDirectories = {
        SDS = ../../SDS/FS-380-HDS-020-SDS-010;
        SMS = ../../SMS/FS-380-HDS-020-SDS-010-SMS-120;
        SMT = ../FS-380-HDS-020-SDS-010-SMS-120;
        SIT = ../../SIT/FS-380-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-380-HDS-020-SDS-010-SMS-120/intent.nix;
        expectedRelationIds = [
          "FS-380-HDS-020-SDS-010-SMS-120__prod-like-client-to-access-dns"
          "FS-380-HDS-020-SDS-010-SMS-120__prod-like-access-dns-to-vlan4"
          "FS-380-HDS-020-SDS-010-SMS-120__prod-like-client-to-vlan4-internet"
        ];
      };
      evidenceLevels = [
        "SMT"
        "SIT"
      ];
      rendererTarget = null;
      script = "tests/FS-380-HDS-020-SDS-010-SMS-120-prod-like-vlan4-client-egress.sh";
      independent = true;
      aggregateOnly = false;
      scope = "SMT/SIT-only prod-like IPv4 client egress and access DNS recursion over access-vlan2 -> downstream-selector -> policy -> upstream-selector -> core with real s-router-test-clients endpoint and VLAN4 NAT upstream";
      maxRuntimeTargets = 5;
    };

    "FS-540-HDS-010-SDS-010-SMS-045" = {
      id = "FS-540-HDS-010-SDS-010-SMS-045";
      traceId = "FS-540-HDS-010-SDS-010-SMS-045";
      rowDirectories = {
        SDS = ../../SDS/FS-540-HDS-010-SDS-010;
        SMS = ../../SMS/FS-540-HDS-010-SDS-010-SMS-045;
        SMT = ../FS-540-HDS-010-SDS-010-SMS-045;
        SIT = ../../SIT/FS-540-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-540-HDS-010-SDS-010-SMS-045/intent.nix;
        expectedRelationIds = [
          "FS-540-HDS-010-SDS-010-SMS-045__prod-like-client-to-access-dns"
          "FS-540-HDS-010-SDS-010-SMS-045__prod-like-access-dns-to-vlan4"
          "FS-540-HDS-010-SDS-010-SMS-045__prod-like-client-to-vlan4-internet"
        ];
      };
      evidenceLevels = [
        "SMT"
        "SIT"
      ];
      rendererTarget = null;
      script = "tests/FS-540-HDS-010-SDS-010-SMS-045-prod-like-access-recursive-dns.sh";
      liveScript = "../network-codex-agent/scripts/smt-live-FS-540-HDS-010-SDS-010-SMS-045.sh";
      independent = true;
      aggregateOnly = false;
      scope = "SMT/SIT-only prod-like recursive DNS over access-vlan2 -> downstream-selector -> policy -> upstream-selector -> core with real s-router-test-clients endpoints and VLAN4 upstream";
      maxRuntimeTargets = 5;
    };

    "FS-166-HDS-010-SDS-010-SMS-901" = {
      id = "FS-166-HDS-010-SDS-010-SMS-901";
      traceId = "FS-166-HDS-010-SDS-010-SMS-901";
      rowDirectories = {
        SDS = ../../SDS/FS-166-HDS-010-SDS-010;
        SMS = ../../SMS/FS-166-HDS-010-SDS-010-SMS-901;
        SMT = ../FS-166-HDS-010-SDS-010-SMS-901;
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

    "FS-166-HDS-010-SDS-010-SMS-902" = {
      id = "FS-166-HDS-010-SDS-010-SMS-902";
      traceId = "FS-166-HDS-010-SDS-010-SMS-902";
      rowDirectories = {
        SDS = ../../SDS/FS-166-HDS-010-SDS-010;
        SMS = ../../SMS/FS-166-HDS-010-SDS-010-SMS-902;
        SMT = ../FS-166-HDS-010-SDS-010-SMS-902;
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

    "FS-166-HDS-010-SDS-010-SMS-903" = {
      id = "FS-166-HDS-010-SDS-010-SMS-903";
      traceId = "FS-166-HDS-010-SDS-010-SMS-903";
      rowDirectories = {
        SDS = ../../SDS/FS-166-HDS-010-SDS-010;
        SMS = ../../SMS/FS-166-HDS-010-SDS-010-SMS-903;
        SMT = ../FS-166-HDS-010-SDS-010-SMS-903;
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

    "FS-166-HDS-010-SDS-010-SMS-904" = {
      id = "FS-166-HDS-010-SDS-010-SMS-904";
      traceId = "FS-166-HDS-010-SDS-010-SMS-904";
      rowDirectories = {
        SDS = ../../SDS/FS-166-HDS-010-SDS-010;
        SMS = ../../SMS/FS-166-HDS-010-SDS-010-SMS-904;
        SMT = ../FS-166-HDS-010-SDS-010-SMS-904;
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

    "FS-166-HDS-010-SDS-010-SMS-905" = {
      id = "FS-166-HDS-010-SDS-010-SMS-905";
      traceId = "FS-166-HDS-010-SDS-010-SMS-905";
      rowDirectories = {
        SDS = ../../SDS/FS-166-HDS-010-SDS-010;
        SMS = ../../SMS/FS-166-HDS-010-SDS-010-SMS-905;
        SMT = ../FS-166-HDS-010-SDS-010-SMS-905;
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

    "FS-470-HDS-010-SDS-010-SMS-010" = {
      id = "FS-470-HDS-010-SDS-010-SMS-010";
      traceId = "FS-470-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-470-HDS-010-SDS-010;
        SMS = ../../SMS/FS-470-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-470-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-470-HDS-010-SDS-010;
      };
      source = {
        kind = "renderer-input";
        cpm = ../FS-470-HDS-010-SDS-010-SMS-010/renderer-input/wireguard-remote-egress-cpm.nix;
      };
      evidenceLevels = [
        "SMT"
        "SIT"
      ];
      rendererTarget = "wireguard";
      script = "tests/test-active-lab-mini-smt-wireguard-remote-egress-only.sh";
      independent = true;
      aggregateOnly = false;
      scope = "WireGuard renderer hostModule imports provider runtime from explicit CPM providerContracts.wireguard output";
      maxRuntimeTargets = 1;
    };

    "FS-166-HDS-010-SDS-010-SMS-906" = {
      id = "FS-166-HDS-010-SDS-010-SMS-906";
      traceId = "FS-166-HDS-010-SDS-010-SMS-906";
      rowDirectories = {
        SDS = ../../SDS/FS-166-HDS-010-SDS-010;
        SMS = ../../SMS/FS-166-HDS-010-SDS-010-SMS-906;
        SMT = ../FS-166-HDS-010-SDS-010-SMS-906;
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

    "FS-310-HDS-010-SDS-010-SMS-030" = {
      id = "FS-310-HDS-010-SDS-010-SMS-030";
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
      script = "tests/test-fs310-hds010-sds010-sms030-policy-router-relation-identity-row-local.sh";
      liveScript = "../network-codex-agent/scripts/fs310-active-lab-policy-router-identity-runtime-check.sh";
      independent = true;
      aggregateOnly = false;
      scope = "Policy router relation identity preservation over two-node tenant-client to external-testnet path";
      maxRuntimeTargets = 2;
    };

    "FS-010-HDS-010-SDS-010-SMS-010" = {
      id = "FS-010-HDS-010-SDS-010-SMS-010";
      traceId = "FS-010-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-010-HDS-010-SDS-010;
        SMS = ../../SMS/FS-010-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-010-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-010-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-010-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [
          "FS-010-HDS-010-SDS-010-SMS-010__mini-verify"
        ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "tests/test-active-lab-mini-smt-fs010-accepted-source-set.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-010 accepted-source-set verification";
      maxRuntimeTargets = 5;
    };

    "FS-020-HDS-010-SDS-010-SMS-010" = {
      id = "FS-020-HDS-010-SDS-010-SMS-010";
      traceId = "FS-020-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-020-HDS-010-SDS-010;
        SMS = ../../SMS/FS-020-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-020-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-020-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-020-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-020-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-020-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-020-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-030-HDS-010-SDS-010-SMS-010" = {
      id = "FS-030-HDS-010-SDS-010-SMS-010";
      traceId = "FS-030-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-030-HDS-010-SDS-010;
        SMS = ../../SMS/FS-030-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-030-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-030-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-030-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-030-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-030-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-030-HDS-010-SDS-010-SMS-030" = {
      id = "FS-030-HDS-010-SDS-010-SMS-030";
      traceId = "FS-030-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-030-HDS-010-SDS-010;
        SMS = ../../SMS/FS-030-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-030-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-030-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-030-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-030-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-030-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-030-HDS-010-SDS-020-SMS-010" = {
      id = "FS-030-HDS-010-SDS-020-SMS-010";
      traceId = "FS-030-HDS-010-SDS-020-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-030-HDS-010-SDS-020;
        SMS = ../../SMS/FS-030-HDS-010-SDS-020-SMS-010;
        SMT = ../FS-030-HDS-010-SDS-020-SMS-010;
        SIT = ../../SIT/FS-030-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-030-HDS-010-SDS-020-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-030-HDS-010-SDS-020-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-020-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-030-HDS-010-SDS-020-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-030-HDS-010-SDS-030-SMS-010" = {
      id = "FS-030-HDS-010-SDS-030-SMS-010";
      traceId = "FS-030-HDS-010-SDS-030-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-030-HDS-010-SDS-030;
        SMS = ../../SMS/FS-030-HDS-010-SDS-030-SMS-010;
        SMT = ../FS-030-HDS-010-SDS-030-SMS-010;
        SIT = ../../SIT/FS-030-HDS-010-SDS-030;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-030-HDS-010-SDS-030-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-030-HDS-010-SDS-030-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-030-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-030-HDS-010-SDS-030-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-030-HDS-010-SDS-040-SMS-010" = {
      id = "FS-030-HDS-010-SDS-040-SMS-010";
      traceId = "FS-030-HDS-010-SDS-040-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-030-HDS-010-SDS-040;
        SMS = ../../SMS/FS-030-HDS-010-SDS-040-SMS-010;
        SMT = ../FS-030-HDS-010-SDS-040-SMS-010;
        SIT = ../../SIT/FS-030-HDS-010-SDS-040;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-030-HDS-010-SDS-040-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-030-HDS-010-SDS-040-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-040-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-030-HDS-010-SDS-040-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-030-HDS-010-SDS-050-SMS-010" = {
      id = "FS-030-HDS-010-SDS-050-SMS-010";
      traceId = "FS-030-HDS-010-SDS-050-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-030-HDS-010-SDS-050;
        SMS = ../../SMS/FS-030-HDS-010-SDS-050-SMS-010;
        SMT = ../FS-030-HDS-010-SDS-050-SMS-010;
        SIT = ../../SIT/FS-030-HDS-010-SDS-050;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-030-HDS-010-SDS-050-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-030-HDS-010-SDS-050-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-050-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-030-HDS-010-SDS-050-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-040-HDS-010-SDS-010-SMS-010" = {
      id = "FS-040-HDS-010-SDS-010-SMS-010";
      traceId = "FS-040-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-040-HDS-010-SDS-010;
        SMS = ../../SMS/FS-040-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-040-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-040-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-040-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-040-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-040-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-040-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-060-HDS-010-SDS-010-SMS-010" = {
      id = "FS-060-HDS-010-SDS-010-SMS-010";
      traceId = "FS-060-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-060-HDS-010-SDS-010;
        SMS = ../../SMS/FS-060-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-060-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-060-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-060-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-060-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-060-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-060-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-070-HDS-010-SDS-010-SMS-010" = {
      id = "FS-070-HDS-010-SDS-010-SMS-010";
      traceId = "FS-070-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-070-HDS-010-SDS-010;
        SMS = ../../SMS/FS-070-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-070-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-070-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-070-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-070-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-070-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-070-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-080-HDS-010-SDS-010-SMS-010" = {
      id = "FS-080-HDS-010-SDS-010-SMS-010";
      traceId = "FS-080-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-080-HDS-010-SDS-010;
        SMS = ../../SMS/FS-080-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-080-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-080-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-080-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-080-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-080-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-080-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-090-HDS-010-SDS-010-SMS-010" = {
      id = "FS-090-HDS-010-SDS-010-SMS-010";
      traceId = "FS-090-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-090-HDS-010-SDS-010;
        SMS = ../../SMS/FS-090-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-090-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-090-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-090-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-090-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-090-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-090-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-100-HDS-010-SDS-010-SMS-010" = {
      id = "FS-100-HDS-010-SDS-010-SMS-010";
      traceId = "FS-100-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-100-HDS-010-SDS-010;
        SMS = ../../SMS/FS-100-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-100-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-100-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-100-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-100-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-100-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-100-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-100-HDS-010-SDS-010-SMS-020" = {
      id = "FS-100-HDS-010-SDS-010-SMS-020";
      traceId = "FS-100-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-100-HDS-010-SDS-010;
        SMS = ../../SMS/FS-100-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-100-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-100-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-100-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-100-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-100-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-100-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-100-HDS-010-SDS-010-SMS-030" = {
      id = "FS-100-HDS-010-SDS-010-SMS-030";
      traceId = "FS-100-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-100-HDS-010-SDS-010;
        SMS = ../../SMS/FS-100-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-100-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-100-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-100-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-100-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-100-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-100-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-100-HDS-010-SDS-010-SMS-050" = {
      id = "FS-100-HDS-010-SDS-010-SMS-050";
      traceId = "FS-100-HDS-010-SDS-010-SMS-050";
      rowDirectories = {
        SDS = ../../SDS/FS-100-HDS-010-SDS-010;
        SMS = ../../SMS/FS-100-HDS-010-SDS-010-SMS-050;
        SMT = ../FS-100-HDS-010-SDS-010-SMS-050;
        SIT = ../../SIT/FS-100-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-100-HDS-010-SDS-010-SMS-050/intent.nix;
        expectedRelationIds = [ "FS-100-HDS-010-SDS-010-SMS-050__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-100-HDS-010-SDS-010-SMS-050.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-100-HDS-010-SDS-010-SMS-050 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-110-HDS-010-SDS-010-SMS-010" = {
      id = "FS-110-HDS-010-SDS-010-SMS-010";
      traceId = "FS-110-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-110-HDS-010-SDS-010;
        SMS = ../../SMS/FS-110-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-110-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-110-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-110-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-110-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-110-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-110-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-120-HDS-010-SDS-010-SMS-010" = {
      id = "FS-120-HDS-010-SDS-010-SMS-010";
      traceId = "FS-120-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-120-HDS-010-SDS-010;
        SMS = ../../SMS/FS-120-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-120-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-120-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-120-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-120-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-120-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-120-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-130-HDS-010-SDS-010-SMS-010" = {
      id = "FS-130-HDS-010-SDS-010-SMS-010";
      traceId = "FS-130-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-130-HDS-010-SDS-010;
        SMS = ../../SMS/FS-130-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-130-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-130-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-130-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-130-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-130-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-130-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-140-HDS-010-SDS-010-SMS-010" = {
      id = "FS-140-HDS-010-SDS-010-SMS-010";
      traceId = "FS-140-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-140-HDS-010-SDS-010;
        SMS = ../../SMS/FS-140-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-140-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-140-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-140-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-140-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-140-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-140-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-150-HDS-010-SDS-010-SMS-010" = {
      id = "FS-150-HDS-010-SDS-010-SMS-010";
      traceId = "FS-150-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-150-HDS-010-SDS-010;
        SMS = ../../SMS/FS-150-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-150-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-150-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-150-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-150-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-150-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-150-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-150-HDS-010-SDS-020-SMS-010" = {
      id = "FS-150-HDS-010-SDS-020-SMS-010";
      traceId = "FS-150-HDS-010-SDS-020-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-150-HDS-010-SDS-020;
        SMS = ../../SMS/FS-150-HDS-010-SDS-020-SMS-010;
        SMT = ../FS-150-HDS-010-SDS-020-SMS-010;
        SIT = ../../SIT/FS-150-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-150-HDS-010-SDS-020-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-150-HDS-010-SDS-020-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-150-HDS-010-SDS-020-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-150-HDS-010-SDS-020-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-160-HDS-010-SDS-010-SMS-010" = {
      id = "FS-160-HDS-010-SDS-010-SMS-010";
      traceId = "FS-160-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-160-HDS-010-SDS-010;
        SMS = ../../SMS/FS-160-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-160-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-160-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-160-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-160-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-160-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-160-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-165-HDS-010-SDS-010-SMS-020" = {
      id = "FS-165-HDS-010-SDS-010-SMS-020";
      traceId = "FS-165-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-165-HDS-010-SDS-010;
        SMS = ../../SMS/FS-165-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-165-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-165-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-165-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-165-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-165-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-165-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-165-HDS-010-SDS-010-SMS-030" = {
      id = "FS-165-HDS-010-SDS-010-SMS-030";
      traceId = "FS-165-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-165-HDS-010-SDS-010;
        SMS = ../../SMS/FS-165-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-165-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-165-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-165-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-165-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-165-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-165-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-166-HDS-010-SDS-010-SMS-900" = {
      id = "FS-166-HDS-010-SDS-010-SMS-900";
      traceId = "FS-166-HDS-010-SDS-010-SMS-900";
      rowDirectories = {
        SDS = ../../SDS/FS-166-HDS-010-SDS-010;
        SMS = ../../SMS/FS-166-HDS-010-SDS-010-SMS-900;
        SMT = ../FS-166-HDS-010-SDS-010-SMS-900;
        SIT = ../../SIT/FS-166-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-166-HDS-010-SDS-010-SMS-900/intent.nix;
        expectedRelationIds = [ "FS-166-HDS-010-SDS-010-SMS-900__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-166-HDS-010-SDS-010-SMS-900.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-166-HDS-010-SDS-010-SMS-900 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-170-HDS-010-SDS-010-SMS-010" = {
      id = "FS-170-HDS-010-SDS-010-SMS-010";
      traceId = "FS-170-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-170-HDS-010-SDS-010;
        SMS = ../../SMS/FS-170-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-170-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-170-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-170-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-170-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-170-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-170-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-170-HDS-010-SDS-010-SMS-020" = {
      id = "FS-170-HDS-010-SDS-010-SMS-020";
      traceId = "FS-170-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-170-HDS-010-SDS-010;
        SMS = ../../SMS/FS-170-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-170-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-170-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-170-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-170-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-170-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-170-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-170-HDS-010-SDS-010-SMS-030" = {
      id = "FS-170-HDS-010-SDS-010-SMS-030";
      traceId = "FS-170-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-170-HDS-010-SDS-010;
        SMS = ../../SMS/FS-170-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-170-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-170-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-170-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-170-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-170-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-170-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-180-HDS-010-SDS-010-SMS-010" = {
      id = "FS-180-HDS-010-SDS-010-SMS-010";
      traceId = "FS-180-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-180-HDS-010-SDS-010;
        SMS = ../../SMS/FS-180-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-180-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-180-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-180-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-180-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-180-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-180-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-180-HDS-010-SDS-010-SMS-020" = {
      id = "FS-180-HDS-010-SDS-010-SMS-020";
      traceId = "FS-180-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-180-HDS-010-SDS-010;
        SMS = ../../SMS/FS-180-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-180-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-180-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-180-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-180-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-180-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-180-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-180-HDS-010-SDS-010-SMS-030" = {
      id = "FS-180-HDS-010-SDS-010-SMS-030";
      traceId = "FS-180-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-180-HDS-010-SDS-010;
        SMS = ../../SMS/FS-180-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-180-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-180-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-180-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-180-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-180-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-180-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-181-HDS-010-SDS-010-SMS-010" = {
      id = "FS-181-HDS-010-SDS-010-SMS-010";
      traceId = "FS-181-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-181-HDS-010-SDS-010;
        SMS = ../../SMS/FS-181-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-181-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-181-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-181-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-181-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-181-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-181-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-181-HDS-010-SDS-020-SMS-010" = {
      id = "FS-181-HDS-010-SDS-020-SMS-010";
      traceId = "FS-181-HDS-010-SDS-020-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-181-HDS-010-SDS-020;
        SMS = ../../SMS/FS-181-HDS-010-SDS-020-SMS-010;
        SMT = ../FS-181-HDS-010-SDS-020-SMS-010;
        SIT = ../../SIT/FS-181-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-181-HDS-010-SDS-020-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-181-HDS-010-SDS-020-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-181-HDS-010-SDS-020-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-181-HDS-010-SDS-020-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-181-HDS-010-SDS-030-SMS-010" = {
      id = "FS-181-HDS-010-SDS-030-SMS-010";
      traceId = "FS-181-HDS-010-SDS-030-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-181-HDS-010-SDS-030;
        SMS = ../../SMS/FS-181-HDS-010-SDS-030-SMS-010;
        SMT = ../FS-181-HDS-010-SDS-030-SMS-010;
        SIT = ../../SIT/FS-181-HDS-010-SDS-030;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-181-HDS-010-SDS-030-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-181-HDS-010-SDS-030-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-181-HDS-010-SDS-030-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-181-HDS-010-SDS-030-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-181-HDS-010-SDS-040-SMS-010" = {
      id = "FS-181-HDS-010-SDS-040-SMS-010";
      traceId = "FS-181-HDS-010-SDS-040-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-181-HDS-010-SDS-040;
        SMS = ../../SMS/FS-181-HDS-010-SDS-040-SMS-010;
        SMT = ../FS-181-HDS-010-SDS-040-SMS-010;
        SIT = ../../SIT/FS-181-HDS-010-SDS-040;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-181-HDS-010-SDS-040-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-181-HDS-010-SDS-040-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-181-HDS-010-SDS-040-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-181-HDS-010-SDS-040-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-190-HDS-010-SDS-010-SMS-020" = {
      id = "FS-190-HDS-010-SDS-010-SMS-020";
      traceId = "FS-190-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-190-HDS-010-SDS-010;
        SMS = ../../SMS/FS-190-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-190-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-190-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-190-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-190-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-190-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-190-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-190-HDS-010-SDS-010-SMS-030" = {
      id = "FS-190-HDS-010-SDS-010-SMS-030";
      traceId = "FS-190-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-190-HDS-010-SDS-010;
        SMS = ../../SMS/FS-190-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-190-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-190-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-190-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-190-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-190-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-190-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-200-HDS-010-SDS-010-SMS-020" = {
      id = "FS-200-HDS-010-SDS-010-SMS-020";
      traceId = "FS-200-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-200-HDS-010-SDS-010;
        SMS = ../../SMS/FS-200-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-200-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-200-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-200-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-200-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-200-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-200-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-200-HDS-010-SDS-010-SMS-030" = {
      id = "FS-200-HDS-010-SDS-010-SMS-030";
      traceId = "FS-200-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-200-HDS-010-SDS-010;
        SMS = ../../SMS/FS-200-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-200-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-200-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-200-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-200-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-200-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-200-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-210-HDS-010-SDS-010-SMS-010" = {
      id = "FS-210-HDS-010-SDS-010-SMS-010";
      traceId = "FS-210-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-210-HDS-010-SDS-010;
        SMS = ../../SMS/FS-210-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-210-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-210-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-210-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-210-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-210-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-210-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-210-HDS-010-SDS-010-SMS-020" = {
      id = "FS-210-HDS-010-SDS-010-SMS-020";
      traceId = "FS-210-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-210-HDS-010-SDS-010;
        SMS = ../../SMS/FS-210-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-210-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-210-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-210-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-210-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-210-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-210-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-210-HDS-010-SDS-010-SMS-030" = {
      id = "FS-210-HDS-010-SDS-010-SMS-030";
      traceId = "FS-210-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-210-HDS-010-SDS-010;
        SMS = ../../SMS/FS-210-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-210-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-210-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-210-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-210-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-210-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-210-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-220-HDS-010-SDS-010-SMS-010" = {
      id = "FS-220-HDS-010-SDS-010-SMS-010";
      traceId = "FS-220-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-220-HDS-010-SDS-010;
        SMS = ../../SMS/FS-220-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-220-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-220-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-220-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-220-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-220-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-220-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-230-HDS-010-SDS-010-SMS-010" = {
      id = "FS-230-HDS-010-SDS-010-SMS-010";
      traceId = "FS-230-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-230-HDS-010-SDS-010;
        SMS = ../../SMS/FS-230-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-230-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-230-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-230-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-230-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-230-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-230-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-230-HDS-010-SDS-010-SMS-020" = {
      id = "FS-230-HDS-010-SDS-010-SMS-020";
      traceId = "FS-230-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-230-HDS-010-SDS-010;
        SMS = ../../SMS/FS-230-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-230-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-230-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-230-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-230-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-230-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-230-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-230-HDS-010-SDS-010-SMS-030" = {
      id = "FS-230-HDS-010-SDS-010-SMS-030";
      traceId = "FS-230-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-230-HDS-010-SDS-010;
        SMS = ../../SMS/FS-230-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-230-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-230-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-230-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-230-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-230-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-230-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-240-HDS-010-SDS-010-SMS-010" = {
      id = "FS-240-HDS-010-SDS-010-SMS-010";
      traceId = "FS-240-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-240-HDS-010-SDS-010;
        SMS = ../../SMS/FS-240-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-240-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-240-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-240-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-240-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-240-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-240-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-240-HDS-010-SDS-010-SMS-020" = {
      id = "FS-240-HDS-010-SDS-010-SMS-020";
      traceId = "FS-240-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-240-HDS-010-SDS-010;
        SMS = ../../SMS/FS-240-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-240-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-240-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-240-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-240-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-240-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-240-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-240-HDS-010-SDS-010-SMS-030" = {
      id = "FS-240-HDS-010-SDS-010-SMS-030";
      traceId = "FS-240-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-240-HDS-010-SDS-010;
        SMS = ../../SMS/FS-240-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-240-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-240-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-240-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-240-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-240-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-240-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-250-HDS-010-SDS-010-SMS-010" = {
      id = "FS-250-HDS-010-SDS-010-SMS-010";
      traceId = "FS-250-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-250-HDS-010-SDS-010;
        SMS = ../../SMS/FS-250-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-250-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-250-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-250-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-250-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-250-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-250-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-250-HDS-010-SDS-010-SMS-020" = {
      id = "FS-250-HDS-010-SDS-010-SMS-020";
      traceId = "FS-250-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-250-HDS-010-SDS-010;
        SMS = ../../SMS/FS-250-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-250-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-250-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-250-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-250-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-250-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-250-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-255-HDS-010-SDS-010-SMS-010" = {
      id = "FS-255-HDS-010-SDS-010-SMS-010";
      traceId = "FS-255-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-255-HDS-010-SDS-010;
        SMS = ../../SMS/FS-255-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-255-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-255-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-255-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-255-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-255-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-255-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-260-HDS-010-SDS-010-SMS-010" = {
      id = "FS-260-HDS-010-SDS-010-SMS-010";
      traceId = "FS-260-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-260-HDS-010-SDS-010;
        SMS = ../../SMS/FS-260-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-260-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-260-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-260-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-260-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-260-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-260-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-260-HDS-010-SDS-010-SMS-012" = {
      id = "FS-260-HDS-010-SDS-010-SMS-012";
      traceId = "FS-260-HDS-010-SDS-010-SMS-012";
      rowDirectories = {
        SDS = ../../SDS/FS-260-HDS-010-SDS-010;
        SMS = ../../SMS/FS-260-HDS-010-SDS-010-SMS-012;
        SMT = ../FS-260-HDS-010-SDS-010-SMS-012;
        SIT = ../../SIT/FS-260-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-260-HDS-010-SDS-010-SMS-012/intent.nix;
        expectedRelationIds = [ "FS-260-HDS-010-SDS-010-SMS-012__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-260-HDS-010-SDS-010-SMS-012.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-260-HDS-010-SDS-010-SMS-012 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-260-HDS-010-SDS-010-SMS-015" = {
      id = "FS-260-HDS-010-SDS-010-SMS-015";
      traceId = "FS-260-HDS-010-SDS-010-SMS-015";
      rowDirectories = {
        SDS = ../../SDS/FS-260-HDS-010-SDS-010;
        SMS = ../../SMS/FS-260-HDS-010-SDS-010-SMS-015;
        SMT = ../FS-260-HDS-010-SDS-010-SMS-015;
        SIT = ../../SIT/FS-260-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-260-HDS-010-SDS-010-SMS-015/intent.nix;
        expectedRelationIds = [ "FS-260-HDS-010-SDS-010-SMS-015__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-260-HDS-010-SDS-010-SMS-015.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-260-HDS-010-SDS-010-SMS-015 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-260-HDS-010-SDS-010-SMS-020" = {
      id = "FS-260-HDS-010-SDS-010-SMS-020";
      traceId = "FS-260-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-260-HDS-010-SDS-010;
        SMS = ../../SMS/FS-260-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-260-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-260-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-260-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-260-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-260-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-260-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-260-HDS-010-SDS-010-SMS-030" = {
      id = "FS-260-HDS-010-SDS-010-SMS-030";
      traceId = "FS-260-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-260-HDS-010-SDS-010;
        SMS = ../../SMS/FS-260-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-260-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-260-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-260-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-260-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-260-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-260-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-260-HDS-010-SDS-010-SMS-050" = {
      id = "FS-260-HDS-010-SDS-010-SMS-050";
      traceId = "FS-260-HDS-010-SDS-010-SMS-050";
      rowDirectories = {
        SDS = ../../SDS/FS-260-HDS-010-SDS-010;
        SMS = ../../SMS/FS-260-HDS-010-SDS-010-SMS-050;
        SMT = ../FS-260-HDS-010-SDS-010-SMS-050;
        SIT = ../../SIT/FS-260-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-260-HDS-010-SDS-010-SMS-050/intent.nix;
        expectedRelationIds = [ "FS-260-HDS-010-SDS-010-SMS-050__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-260-HDS-010-SDS-010-SMS-050.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-260-HDS-010-SDS-010-SMS-050 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-260-HDS-010-SDS-010-SMS-060" = {
      id = "FS-260-HDS-010-SDS-010-SMS-060";
      traceId = "FS-260-HDS-010-SDS-010-SMS-060";
      rowDirectories = {
        SDS = ../../SDS/FS-260-HDS-010-SDS-010;
        SMS = ../../SMS/FS-260-HDS-010-SDS-010-SMS-060;
        SMT = ../FS-260-HDS-010-SDS-010-SMS-060;
        SIT = ../../SIT/FS-260-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-260-HDS-010-SDS-010-SMS-060/intent.nix;
        expectedRelationIds = [ "FS-260-HDS-010-SDS-010-SMS-060__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-260-HDS-010-SDS-010-SMS-060.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-260-HDS-010-SDS-010-SMS-060 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-260-HDS-010-SDS-010-SMS-070" = {
      id = "FS-260-HDS-010-SDS-010-SMS-070";
      traceId = "FS-260-HDS-010-SDS-010-SMS-070";
      rowDirectories = {
        SDS = ../../SDS/FS-260-HDS-010-SDS-010;
        SMS = ../../SMS/FS-260-HDS-010-SDS-010-SMS-070;
        SMT = ../FS-260-HDS-010-SDS-010-SMS-070;
        SIT = ../../SIT/FS-260-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-260-HDS-010-SDS-010-SMS-070/intent.nix;
        expectedRelationIds = [ "FS-260-HDS-010-SDS-010-SMS-070__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-260-HDS-010-SDS-010-SMS-070.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-260-HDS-010-SDS-010-SMS-070 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-260-HDS-010-SDS-010-SMS-080" = {
      id = "FS-260-HDS-010-SDS-010-SMS-080";
      traceId = "FS-260-HDS-010-SDS-010-SMS-080";
      rowDirectories = {
        SDS = ../../SDS/FS-260-HDS-010-SDS-010;
        SMS = ../../SMS/FS-260-HDS-010-SDS-010-SMS-080;
        SMT = ../FS-260-HDS-010-SDS-010-SMS-080;
        SIT = ../../SIT/FS-260-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-260-HDS-010-SDS-010-SMS-080/intent.nix;
        expectedRelationIds = [ "FS-260-HDS-010-SDS-010-SMS-080__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-260-HDS-010-SDS-010-SMS-080.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-260-HDS-010-SDS-010-SMS-080 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-260-HDS-010-SDS-010-SMS-090" = {
      id = "FS-260-HDS-010-SDS-010-SMS-090";
      traceId = "FS-260-HDS-010-SDS-010-SMS-090";
      rowDirectories = {
        SDS = ../../SDS/FS-260-HDS-010-SDS-010;
        SMS = ../../SMS/FS-260-HDS-010-SDS-010-SMS-090;
        SMT = ../FS-260-HDS-010-SDS-010-SMS-090;
        SIT = ../../SIT/FS-260-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-260-HDS-010-SDS-010-SMS-090/intent.nix;
        expectedRelationIds = [ "FS-260-HDS-010-SDS-010-SMS-090__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-260-HDS-010-SDS-010-SMS-090.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-260-HDS-010-SDS-010-SMS-090 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-265-HDS-010-SDS-010-SMS-010" = {
      id = "FS-265-HDS-010-SDS-010-SMS-010";
      traceId = "FS-265-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-265-HDS-010-SDS-010;
        SMS = ../../SMS/FS-265-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-265-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-265-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-265-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-265-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-265-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-265-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-267-HDS-010-SDS-010-SMS-010" = {
      id = "FS-267-HDS-010-SDS-010-SMS-010";
      traceId = "FS-267-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-267-HDS-010-SDS-010;
        SMS = ../../SMS/FS-267-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-267-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-267-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-267-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-267-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-267-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-267-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-270-HDS-010-SDS-010-SMS-010" = {
      id = "FS-270-HDS-010-SDS-010-SMS-010";
      traceId = "FS-270-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-270-HDS-010-SDS-010;
        SMS = ../../SMS/FS-270-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-270-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-270-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-270-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-270-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-270-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-270-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-270-HDS-010-SDS-010-SMS-020" = {
      id = "FS-270-HDS-010-SDS-010-SMS-020";
      traceId = "FS-270-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-270-HDS-010-SDS-010;
        SMS = ../../SMS/FS-270-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-270-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-270-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-270-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-270-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-270-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-270-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-270-HDS-010-SDS-010-SMS-030" = {
      id = "FS-270-HDS-010-SDS-010-SMS-030";
      traceId = "FS-270-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-270-HDS-010-SDS-010;
        SMS = ../../SMS/FS-270-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-270-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-270-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-270-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-270-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-270-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-270-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-275-HDS-010-SDS-010-SMS-010" = {
      id = "FS-275-HDS-010-SDS-010-SMS-010";
      traceId = "FS-275-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-275-HDS-010-SDS-010;
        SMS = ../../SMS/FS-275-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-275-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-275-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-275-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-275-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-275-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-275-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-280-HDS-010-SDS-010-SMS-010" = {
      id = "FS-280-HDS-010-SDS-010-SMS-010";
      traceId = "FS-280-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-280-HDS-010-SDS-010;
        SMS = ../../SMS/FS-280-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-280-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-280-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-280-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-280-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-280-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-280-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-280-HDS-010-SDS-010-SMS-020" = {
      id = "FS-280-HDS-010-SDS-010-SMS-020";
      traceId = "FS-280-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-280-HDS-010-SDS-010;
        SMS = ../../SMS/FS-280-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-280-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-280-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-280-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-280-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-280-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-280-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-290-HDS-010-SDS-010-SMS-010" = {
      id = "FS-290-HDS-010-SDS-010-SMS-010";
      traceId = "FS-290-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-290-HDS-010-SDS-010;
        SMS = ../../SMS/FS-290-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-290-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-290-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-290-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-290-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-290-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-290-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-290-HDS-010-SDS-010-SMS-020" = {
      id = "FS-290-HDS-010-SDS-010-SMS-020";
      traceId = "FS-290-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-290-HDS-010-SDS-010;
        SMS = ../../SMS/FS-290-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-290-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-290-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-290-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-290-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-290-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-290-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-290-HDS-010-SDS-010-SMS-030" = {
      id = "FS-290-HDS-010-SDS-010-SMS-030";
      traceId = "FS-290-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-290-HDS-010-SDS-010;
        SMS = ../../SMS/FS-290-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-290-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-290-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-290-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-290-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-290-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-290-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-300-HDS-010-SDS-010-SMS-010" = {
      id = "FS-300-HDS-010-SDS-010-SMS-010";
      traceId = "FS-300-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-300-HDS-010-SDS-010;
        SMS = ../../SMS/FS-300-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-300-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-300-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-300-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-300-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-300-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-300-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-300-HDS-010-SDS-010-SMS-020" = {
      id = "FS-300-HDS-010-SDS-010-SMS-020";
      traceId = "FS-300-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-300-HDS-010-SDS-010;
        SMS = ../../SMS/FS-300-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-300-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-300-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-300-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-300-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-300-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-300-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-300-HDS-010-SDS-010-SMS-030" = {
      id = "FS-300-HDS-010-SDS-010-SMS-030";
      traceId = "FS-300-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-300-HDS-010-SDS-010;
        SMS = ../../SMS/FS-300-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-300-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-300-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-300-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-300-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-300-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-300-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-305-HDS-010-SDS-010-SMS-010" = {
      id = "FS-305-HDS-010-SDS-010-SMS-010";
      traceId = "FS-305-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-305-HDS-010-SDS-010;
        SMS = ../../SMS/FS-305-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-305-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-305-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-305-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-305-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-305-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-305-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-010-SDS-010-SMS-020" = {
      id = "FS-310-HDS-010-SDS-010-SMS-020";
      traceId = "FS-310-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-010-SDS-010;
        SMS = ../../SMS/FS-310-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-310-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-310-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-010-SDS-010-SMS-120" = {
      id = "FS-310-HDS-010-SDS-010-SMS-120";
      traceId = "FS-310-HDS-010-SDS-010-SMS-120";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-010-SDS-010;
        SMS = ../../SMS/FS-310-HDS-010-SDS-010-SMS-120;
        SMT = ../FS-310-HDS-010-SDS-010-SMS-120;
        SIT = ../../SIT/FS-310-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-010-SDS-010-SMS-120/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-010-SDS-010-SMS-120__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-010-SDS-010-SMS-120.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-010-SDS-010-SMS-120 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-010-SDS-010-SMS-130" = {
      id = "FS-310-HDS-010-SDS-010-SMS-130";
      traceId = "FS-310-HDS-010-SDS-010-SMS-130";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-010-SDS-010;
        SMS = ../../SMS/FS-310-HDS-010-SDS-010-SMS-130;
        SMT = ../FS-310-HDS-010-SDS-010-SMS-130;
        SIT = ../../SIT/FS-310-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-010-SDS-010-SMS-130/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-010-SDS-010-SMS-130__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-010-SDS-010-SMS-130.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-010-SDS-010-SMS-130 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-020-SDS-010-SMS-050" = {
      id = "FS-310-HDS-020-SDS-010-SMS-050";
      traceId = "FS-310-HDS-020-SDS-010-SMS-050";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-020-SDS-010;
        SMS = ../../SMS/FS-310-HDS-020-SDS-010-SMS-050;
        SMT = ../FS-310-HDS-020-SDS-010-SMS-050;
        SIT = ../../SIT/FS-310-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-020-SDS-010-SMS-050/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-020-SDS-010-SMS-050__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-020-SDS-010-SMS-050.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-020-SDS-010-SMS-050 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-020-SDS-010-SMS-060" = {
      id = "FS-310-HDS-020-SDS-010-SMS-060";
      traceId = "FS-310-HDS-020-SDS-010-SMS-060";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-020-SDS-010;
        SMS = ../../SMS/FS-310-HDS-020-SDS-010-SMS-060;
        SMT = ../FS-310-HDS-020-SDS-010-SMS-060;
        SIT = ../../SIT/FS-310-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-020-SDS-010-SMS-060/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-020-SDS-010-SMS-060__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-020-SDS-010-SMS-060.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-020-SDS-010-SMS-060 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-020-SDS-010-SMS-070" = {
      id = "FS-310-HDS-020-SDS-010-SMS-070";
      traceId = "FS-310-HDS-020-SDS-010-SMS-070";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-020-SDS-010;
        SMS = ../../SMS/FS-310-HDS-020-SDS-010-SMS-070;
        SMT = ../FS-310-HDS-020-SDS-010-SMS-070;
        SIT = ../../SIT/FS-310-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-020-SDS-010-SMS-070/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-020-SDS-010-SMS-070__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-020-SDS-010-SMS-070.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-020-SDS-010-SMS-070 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-020-SDS-010-SMS-190" = {
      id = "FS-310-HDS-020-SDS-010-SMS-190";
      traceId = "FS-310-HDS-020-SDS-010-SMS-190";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-020-SDS-010;
        SMS = ../../SMS/FS-310-HDS-020-SDS-010-SMS-190;
        SMT = ../FS-310-HDS-020-SDS-010-SMS-190;
        SIT = ../../SIT/FS-310-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-020-SDS-010-SMS-190/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-020-SDS-010-SMS-190__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-020-SDS-010-SMS-190.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-020-SDS-010-SMS-190 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-020-SDS-010-SMS-210" = {
      id = "FS-310-HDS-020-SDS-010-SMS-210";
      traceId = "FS-310-HDS-020-SDS-010-SMS-210";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-020-SDS-010;
        SMS = ../../SMS/FS-310-HDS-020-SDS-010-SMS-210;
        SMT = ../FS-310-HDS-020-SDS-010-SMS-210;
        SIT = ../../SIT/FS-310-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-020-SDS-010-SMS-210/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-020-SDS-010-SMS-210__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-020-SDS-010-SMS-210.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-020-SDS-010-SMS-210 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-030-SDS-010-SMS-080" = {
      id = "FS-310-HDS-030-SDS-010-SMS-080";
      traceId = "FS-310-HDS-030-SDS-010-SMS-080";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-030-SDS-010;
        SMS = ../../SMS/FS-310-HDS-030-SDS-010-SMS-080;
        SMT = ../FS-310-HDS-030-SDS-010-SMS-080;
        SIT = ../../SIT/FS-310-HDS-030-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-030-SDS-010-SMS-080/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-030-SDS-010-SMS-080__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-030-SDS-010-SMS-080.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-030-SDS-010-SMS-080 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-030-SDS-010-SMS-090" = {
      id = "FS-310-HDS-030-SDS-010-SMS-090";
      traceId = "FS-310-HDS-030-SDS-010-SMS-090";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-030-SDS-010;
        SMS = ../../SMS/FS-310-HDS-030-SDS-010-SMS-090;
        SMT = ../FS-310-HDS-030-SDS-010-SMS-090;
        SIT = ../../SIT/FS-310-HDS-030-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-030-SDS-010-SMS-090/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-030-SDS-010-SMS-090__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-030-SDS-010-SMS-090.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-030-SDS-010-SMS-090 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-030-SDS-010-SMS-110" = {
      id = "FS-310-HDS-030-SDS-010-SMS-110";
      traceId = "FS-310-HDS-030-SDS-010-SMS-110";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-030-SDS-010;
        SMS = ../../SMS/FS-310-HDS-030-SDS-010-SMS-110;
        SMT = ../FS-310-HDS-030-SDS-010-SMS-110;
        SIT = ../../SIT/FS-310-HDS-030-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-030-SDS-010-SMS-110/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-030-SDS-010-SMS-110__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-030-SDS-010-SMS-110.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-030-SDS-010-SMS-110 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-030-SDS-010-SMS-111" = {
      id = "FS-310-HDS-030-SDS-010-SMS-111";
      traceId = "FS-310-HDS-030-SDS-010-SMS-111";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-030-SDS-010;
        SMS = ../../SMS/FS-310-HDS-030-SDS-010-SMS-111;
        SMT = ../FS-310-HDS-030-SDS-010-SMS-111;
        SIT = ../../SIT/FS-310-HDS-030-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-030-SDS-010-SMS-111/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-030-SDS-010-SMS-111__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-030-SDS-010-SMS-111.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-030-SDS-010-SMS-111 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-030-SDS-010-SMS-112" = {
      id = "FS-310-HDS-030-SDS-010-SMS-112";
      traceId = "FS-310-HDS-030-SDS-010-SMS-112";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-030-SDS-010;
        SMS = ../../SMS/FS-310-HDS-030-SDS-010-SMS-112;
        SMT = ../FS-310-HDS-030-SDS-010-SMS-112;
        SIT = ../../SIT/FS-310-HDS-030-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-030-SDS-010-SMS-112/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-030-SDS-010-SMS-112__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-030-SDS-010-SMS-112.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-030-SDS-010-SMS-112 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-040-SDS-010-SMS-100" = {
      id = "FS-310-HDS-040-SDS-010-SMS-100";
      traceId = "FS-310-HDS-040-SDS-010-SMS-100";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-040-SDS-010;
        SMS = ../../SMS/FS-310-HDS-040-SDS-010-SMS-100;
        SMT = ../FS-310-HDS-040-SDS-010-SMS-100;
        SIT = ../../SIT/FS-310-HDS-040-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-040-SDS-010-SMS-100/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-040-SDS-010-SMS-100__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-040-SDS-010-SMS-100.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-040-SDS-010-SMS-100 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-040-SDS-010-SMS-101" = {
      id = "FS-310-HDS-040-SDS-010-SMS-101";
      traceId = "FS-310-HDS-040-SDS-010-SMS-101";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-040-SDS-010;
        SMS = ../../SMS/FS-310-HDS-040-SDS-010-SMS-101;
        SMT = ../FS-310-HDS-040-SDS-010-SMS-101;
        SIT = ../../SIT/FS-310-HDS-040-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-040-SDS-010-SMS-101/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-040-SDS-010-SMS-101__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-040-SDS-010-SMS-101.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-040-SDS-010-SMS-101 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-040-SDS-010-SMS-102" = {
      id = "FS-310-HDS-040-SDS-010-SMS-102";
      traceId = "FS-310-HDS-040-SDS-010-SMS-102";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-040-SDS-010;
        SMS = ../../SMS/FS-310-HDS-040-SDS-010-SMS-102;
        SMT = ../FS-310-HDS-040-SDS-010-SMS-102;
        SIT = ../../SIT/FS-310-HDS-040-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-040-SDS-010-SMS-102/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-040-SDS-010-SMS-102__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-040-SDS-010-SMS-102.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-040-SDS-010-SMS-102 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-040-SDS-010-SMS-140" = {
      id = "FS-310-HDS-040-SDS-010-SMS-140";
      traceId = "FS-310-HDS-040-SDS-010-SMS-140";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-040-SDS-010;
        SMS = ../../SMS/FS-310-HDS-040-SDS-010-SMS-140;
        SMT = ../FS-310-HDS-040-SDS-010-SMS-140;
        SIT = ../../SIT/FS-310-HDS-040-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-040-SDS-010-SMS-140/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-040-SDS-010-SMS-140__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-040-SDS-010-SMS-140.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-040-SDS-010-SMS-140 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-040-SDS-010-SMS-150" = {
      id = "FS-310-HDS-040-SDS-010-SMS-150";
      traceId = "FS-310-HDS-040-SDS-010-SMS-150";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-040-SDS-010;
        SMS = ../../SMS/FS-310-HDS-040-SDS-010-SMS-150;
        SMT = ../FS-310-HDS-040-SDS-010-SMS-150;
        SIT = ../../SIT/FS-310-HDS-040-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-040-SDS-010-SMS-150/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-040-SDS-010-SMS-150__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-040-SDS-010-SMS-150.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-040-SDS-010-SMS-150 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-040-SDS-010-SMS-160" = {
      id = "FS-310-HDS-040-SDS-010-SMS-160";
      traceId = "FS-310-HDS-040-SDS-010-SMS-160";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-040-SDS-010;
        SMS = ../../SMS/FS-310-HDS-040-SDS-010-SMS-160;
        SMT = ../FS-310-HDS-040-SDS-010-SMS-160;
        SIT = ../../SIT/FS-310-HDS-040-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-040-SDS-010-SMS-160/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-040-SDS-010-SMS-160__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-040-SDS-010-SMS-160.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-040-SDS-010-SMS-160 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-040-SDS-010-SMS-170" = {
      id = "FS-310-HDS-040-SDS-010-SMS-170";
      traceId = "FS-310-HDS-040-SDS-010-SMS-170";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-040-SDS-010;
        SMS = ../../SMS/FS-310-HDS-040-SDS-010-SMS-170;
        SMT = ../FS-310-HDS-040-SDS-010-SMS-170;
        SIT = ../../SIT/FS-310-HDS-040-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-040-SDS-010-SMS-170/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-040-SDS-010-SMS-170__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-040-SDS-010-SMS-170.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-040-SDS-010-SMS-170 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-040-SDS-010-SMS-180" = {
      id = "FS-310-HDS-040-SDS-010-SMS-180";
      traceId = "FS-310-HDS-040-SDS-010-SMS-180";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-040-SDS-010;
        SMS = ../../SMS/FS-310-HDS-040-SDS-010-SMS-180;
        SMT = ../FS-310-HDS-040-SDS-010-SMS-180;
        SIT = ../../SIT/FS-310-HDS-040-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-040-SDS-010-SMS-180/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-040-SDS-010-SMS-180__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-040-SDS-010-SMS-180.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-040-SDS-010-SMS-180 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-050-SDS-010-SMS-220" = {
      id = "FS-310-HDS-050-SDS-010-SMS-220";
      traceId = "FS-310-HDS-050-SDS-010-SMS-220";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-050-SDS-010;
        SMS = ../../SMS/FS-310-HDS-050-SDS-010-SMS-220;
        SMT = ../FS-310-HDS-050-SDS-010-SMS-220;
        SIT = ../../SIT/FS-310-HDS-050-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-050-SDS-010-SMS-220/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-050-SDS-010-SMS-220__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-050-SDS-010-SMS-220.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-050-SDS-010-SMS-220 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-320-HDS-010-SDS-010-SMS-030" = {
      id = "FS-320-HDS-010-SDS-010-SMS-030";
      traceId = "FS-320-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-320-HDS-010-SDS-010;
        SMS = ../../SMS/FS-320-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-320-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-320-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-320-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-320-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-320-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-320-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-320-HDS-020-SDS-010-SMS-020" = {
      id = "FS-320-HDS-020-SDS-010-SMS-020";
      traceId = "FS-320-HDS-020-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-320-HDS-020-SDS-010;
        SMS = ../../SMS/FS-320-HDS-020-SDS-010-SMS-020;
        SMT = ../FS-320-HDS-020-SDS-010-SMS-020;
        SIT = ../../SIT/FS-320-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-320-HDS-020-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-320-HDS-020-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-320-HDS-020-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-320-HDS-020-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-320-HDS-020-SDS-010-SMS-030" = {
      id = "FS-320-HDS-020-SDS-010-SMS-030";
      traceId = "FS-320-HDS-020-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-320-HDS-020-SDS-010;
        SMS = ../../SMS/FS-320-HDS-020-SDS-010-SMS-030;
        SMT = ../FS-320-HDS-020-SDS-010-SMS-030;
        SIT = ../../SIT/FS-320-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-320-HDS-020-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-320-HDS-020-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-320-HDS-020-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-320-HDS-020-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-320-HDS-030-SDS-010-SMS-050" = {
      id = "FS-320-HDS-030-SDS-010-SMS-050";
      traceId = "FS-320-HDS-030-SDS-010-SMS-050";
      rowDirectories = {
        SDS = ../../SDS/FS-320-HDS-030-SDS-010;
        SMS = ../../SMS/FS-320-HDS-030-SDS-010-SMS-050;
        SMT = ../FS-320-HDS-030-SDS-010-SMS-050;
        SIT = ../../SIT/FS-320-HDS-030-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-320-HDS-030-SDS-010-SMS-050/intent.nix;
        expectedRelationIds = [ "FS-320-HDS-030-SDS-010-SMS-050__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-320-HDS-030-SDS-010-SMS-050.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-320-HDS-030-SDS-010-SMS-050 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-320-HDS-040-SDS-010-SMS-060" = {
      id = "FS-320-HDS-040-SDS-010-SMS-060";
      traceId = "FS-320-HDS-040-SDS-010-SMS-060";
      rowDirectories = {
        SDS = ../../SDS/FS-320-HDS-040-SDS-010;
        SMS = ../../SMS/FS-320-HDS-040-SDS-010-SMS-060;
        SMT = ../FS-320-HDS-040-SDS-010-SMS-060;
        SIT = ../../SIT/FS-320-HDS-040-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-320-HDS-040-SDS-010-SMS-060/intent.nix;
        expectedRelationIds = [ "FS-320-HDS-040-SDS-010-SMS-060__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-320-HDS-040-SDS-010-SMS-060.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-320-HDS-040-SDS-010-SMS-060 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-330-HDS-010-SDS-010-SMS-010" = {
      id = "FS-330-HDS-010-SDS-010-SMS-010";
      traceId = "FS-330-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-330-HDS-010-SDS-010;
        SMS = ../../SMS/FS-330-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-330-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-330-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-330-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-330-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-330-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-330-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-330-HDS-010-SDS-010-SMS-020" = {
      id = "FS-330-HDS-010-SDS-010-SMS-020";
      traceId = "FS-330-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-330-HDS-010-SDS-010;
        SMS = ../../SMS/FS-330-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-330-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-330-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-330-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-330-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-330-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-330-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-330-HDS-010-SDS-010-SMS-030" = {
      id = "FS-330-HDS-010-SDS-010-SMS-030";
      traceId = "FS-330-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-330-HDS-010-SDS-010;
        SMS = ../../SMS/FS-330-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-330-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-330-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-330-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-330-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-330-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-330-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-340-HDS-010-SDS-010-SMS-010" = {
      id = "FS-340-HDS-010-SDS-010-SMS-010";
      traceId = "FS-340-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-340-HDS-010-SDS-010;
        SMS = ../../SMS/FS-340-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-340-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-340-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-340-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-340-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-340-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-340-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-340-HDS-010-SDS-010-SMS-020" = {
      id = "FS-340-HDS-010-SDS-010-SMS-020";
      traceId = "FS-340-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-340-HDS-010-SDS-010;
        SMS = ../../SMS/FS-340-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-340-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-340-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-340-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-340-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-340-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-340-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-340-HDS-010-SDS-010-SMS-030" = {
      id = "FS-340-HDS-010-SDS-010-SMS-030";
      traceId = "FS-340-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-340-HDS-010-SDS-010;
        SMS = ../../SMS/FS-340-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-340-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-340-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-340-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-340-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-340-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-340-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-350-HDS-010-SDS-010-SMS-020" = {
      id = "FS-350-HDS-010-SDS-010-SMS-020";
      traceId = "FS-350-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-350-HDS-010-SDS-010;
        SMS = ../../SMS/FS-350-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-350-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-350-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-350-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-350-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-350-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-350-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-350-HDS-010-SDS-010-SMS-030" = {
      id = "FS-350-HDS-010-SDS-010-SMS-030";
      traceId = "FS-350-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-350-HDS-010-SDS-010;
        SMS = ../../SMS/FS-350-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-350-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-350-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-350-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-350-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-350-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-350-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-350-HDS-010-SDS-010-SMS-050" = {
      id = "FS-350-HDS-010-SDS-010-SMS-050";
      traceId = "FS-350-HDS-010-SDS-010-SMS-050";
      rowDirectories = {
        SDS = ../../SDS/FS-350-HDS-010-SDS-010;
        SMS = ../../SMS/FS-350-HDS-010-SDS-010-SMS-050;
        SMT = ../FS-350-HDS-010-SDS-010-SMS-050;
        SIT = ../../SIT/FS-350-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-350-HDS-010-SDS-010-SMS-050/intent.nix;
        expectedRelationIds = [ "FS-350-HDS-010-SDS-010-SMS-050__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-350-HDS-010-SDS-010-SMS-050.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-350-HDS-010-SDS-010-SMS-050 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-360-HDS-010-SDS-010-SMS-010" = {
      id = "FS-360-HDS-010-SDS-010-SMS-010";
      traceId = "FS-360-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-360-HDS-010-SDS-010;
        SMS = ../../SMS/FS-360-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-360-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-360-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-360-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-360-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-360-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-360-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-360-HDS-010-SDS-010-SMS-020" = {
      id = "FS-360-HDS-010-SDS-010-SMS-020";
      traceId = "FS-360-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-360-HDS-010-SDS-010;
        SMS = ../../SMS/FS-360-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-360-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-360-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-360-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-360-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-360-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-360-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-360-HDS-010-SDS-010-SMS-030" = {
      id = "FS-360-HDS-010-SDS-010-SMS-030";
      traceId = "FS-360-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-360-HDS-010-SDS-010;
        SMS = ../../SMS/FS-360-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-360-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-360-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-360-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-360-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-360-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-360-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-370-HDS-010-SDS-010-SMS-010" = {
      id = "FS-370-HDS-010-SDS-010-SMS-010";
      traceId = "FS-370-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-370-HDS-010-SDS-010;
        SMS = ../../SMS/FS-370-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-370-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-370-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-370-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-370-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-370-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-370-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-370-HDS-010-SDS-010-SMS-020" = {
      id = "FS-370-HDS-010-SDS-010-SMS-020";
      traceId = "FS-370-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-370-HDS-010-SDS-010;
        SMS = ../../SMS/FS-370-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-370-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-370-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-370-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-370-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-370-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-370-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-370-HDS-010-SDS-010-SMS-030" = {
      id = "FS-370-HDS-010-SDS-010-SMS-030";
      traceId = "FS-370-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-370-HDS-010-SDS-010;
        SMS = ../../SMS/FS-370-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-370-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-370-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-370-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-370-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-370-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-370-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-370-HDS-010-SDS-010-SMS-060" = {
      id = "FS-370-HDS-010-SDS-010-SMS-060";
      traceId = "FS-370-HDS-010-SDS-010-SMS-060";
      rowDirectories = {
        SDS = ../../SDS/FS-370-HDS-010-SDS-010;
        SMS = ../../SMS/FS-370-HDS-010-SDS-010-SMS-060;
        SMT = ../FS-370-HDS-010-SDS-010-SMS-060;
        SIT = ../../SIT/FS-370-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-370-HDS-010-SDS-010-SMS-060/intent.nix;
        expectedRelationIds = [ "FS-370-HDS-010-SDS-010-SMS-060__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-370-HDS-010-SDS-010-SMS-060.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-370-HDS-010-SDS-010-SMS-060 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-370-HDS-010-SDS-010-SMS-070" = {
      id = "FS-370-HDS-010-SDS-010-SMS-070";
      traceId = "FS-370-HDS-010-SDS-010-SMS-070";
      rowDirectories = {
        SDS = ../../SDS/FS-370-HDS-010-SDS-010;
        SMS = ../../SMS/FS-370-HDS-010-SDS-010-SMS-070;
        SMT = ../FS-370-HDS-010-SDS-010-SMS-070;
        SIT = ../../SIT/FS-370-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-370-HDS-010-SDS-010-SMS-070/intent.nix;
        expectedRelationIds = [ "FS-370-HDS-010-SDS-010-SMS-070__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-370-HDS-010-SDS-010-SMS-070.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-370-HDS-010-SDS-010-SMS-070 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-370-HDS-010-SDS-010-SMS-080" = {
      id = "FS-370-HDS-010-SDS-010-SMS-080";
      traceId = "FS-370-HDS-010-SDS-010-SMS-080";
      rowDirectories = {
        SDS = ../../SDS/FS-370-HDS-010-SDS-010;
        SMS = ../../SMS/FS-370-HDS-010-SDS-010-SMS-080;
        SMT = ../FS-370-HDS-010-SDS-010-SMS-080;
        SIT = ../../SIT/FS-370-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-370-HDS-010-SDS-010-SMS-080/intent.nix;
        expectedRelationIds = [ "FS-370-HDS-010-SDS-010-SMS-080__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-370-HDS-010-SDS-010-SMS-080.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-370-HDS-010-SDS-010-SMS-080 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-370-HDS-010-SDS-010-SMS-090" = {
      id = "FS-370-HDS-010-SDS-010-SMS-090";
      traceId = "FS-370-HDS-010-SDS-010-SMS-090";
      rowDirectories = {
        SDS = ../../SDS/FS-370-HDS-010-SDS-010;
        SMS = ../../SMS/FS-370-HDS-010-SDS-010-SMS-090;
        SMT = ../FS-370-HDS-010-SDS-010-SMS-090;
        SIT = ../../SIT/FS-370-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-370-HDS-010-SDS-010-SMS-090/intent.nix;
        expectedRelationIds = [ "FS-370-HDS-010-SDS-010-SMS-090__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-370-HDS-010-SDS-010-SMS-090.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-370-HDS-010-SDS-010-SMS-090 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-370-HDS-010-SDS-010-SMS-100" = {
      id = "FS-370-HDS-010-SDS-010-SMS-100";
      traceId = "FS-370-HDS-010-SDS-010-SMS-100";
      rowDirectories = {
        SDS = ../../SDS/FS-370-HDS-010-SDS-010;
        SMS = ../../SMS/FS-370-HDS-010-SDS-010-SMS-100;
        SMT = ../FS-370-HDS-010-SDS-010-SMS-100;
        SIT = ../../SIT/FS-370-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-370-HDS-010-SDS-010-SMS-100/intent.nix;
        expectedRelationIds = [ "FS-370-HDS-010-SDS-010-SMS-100__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-370-HDS-010-SDS-010-SMS-100.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-370-HDS-010-SDS-010-SMS-100 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-370-HDS-010-SDS-010-SMS-110" = {
      id = "FS-370-HDS-010-SDS-010-SMS-110";
      traceId = "FS-370-HDS-010-SDS-010-SMS-110";
      rowDirectories = {
        SDS = ../../SDS/FS-370-HDS-010-SDS-010;
        SMS = ../../SMS/FS-370-HDS-010-SDS-010-SMS-110;
        SMT = ../FS-370-HDS-010-SDS-010-SMS-110;
        SIT = ../../SIT/FS-370-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-370-HDS-010-SDS-010-SMS-110/intent.nix;
        expectedRelationIds = [ "FS-370-HDS-010-SDS-010-SMS-110__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-370-HDS-010-SDS-010-SMS-110.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-370-HDS-010-SDS-010-SMS-110 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-370-HDS-010-SDS-010-SMS-120" = {
      id = "FS-370-HDS-010-SDS-010-SMS-120";
      traceId = "FS-370-HDS-010-SDS-010-SMS-120";
      rowDirectories = {
        SDS = ../../SDS/FS-370-HDS-010-SDS-010;
        SMS = ../../SMS/FS-370-HDS-010-SDS-010-SMS-120;
        SMT = ../FS-370-HDS-010-SDS-010-SMS-120;
        SIT = ../../SIT/FS-370-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-370-HDS-010-SDS-010-SMS-120/intent.nix;
        expectedRelationIds = [ "FS-370-HDS-010-SDS-010-SMS-120__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-370-HDS-010-SDS-010-SMS-120.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-370-HDS-010-SDS-010-SMS-120 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-380-HDS-010-SDS-010-SMS-010" = {
      id = "FS-380-HDS-010-SDS-010-SMS-010";
      traceId = "FS-380-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-380-HDS-010-SDS-010;
        SMS = ../../SMS/FS-380-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-380-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-380-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-380-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-380-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-380-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-380-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-380-HDS-010-SDS-010-SMS-020" = {
      id = "FS-380-HDS-010-SDS-010-SMS-020";
      traceId = "FS-380-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-380-HDS-010-SDS-010;
        SMS = ../../SMS/FS-380-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-380-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-380-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-380-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-380-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-380-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-380-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-380-HDS-010-SDS-010-SMS-030" = {
      id = "FS-380-HDS-010-SDS-010-SMS-030";
      traceId = "FS-380-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-380-HDS-010-SDS-010;
        SMS = ../../SMS/FS-380-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-380-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-380-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-380-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-380-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-380-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-380-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-380-HDS-020-SDS-010-SMS-060" = {
      id = "FS-380-HDS-020-SDS-010-SMS-060";
      traceId = "FS-380-HDS-020-SDS-010-SMS-060";
      rowDirectories = {
        SDS = ../../SDS/FS-380-HDS-020-SDS-010;
        SMS = ../../SMS/FS-380-HDS-020-SDS-010-SMS-060;
        SMT = ../FS-380-HDS-020-SDS-010-SMS-060;
        SIT = ../../SIT/FS-380-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-380-HDS-020-SDS-010-SMS-060/intent.nix;
        expectedRelationIds = [ "FS-380-HDS-020-SDS-010-SMS-060__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-380-HDS-020-SDS-010-SMS-060.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-380-HDS-020-SDS-010-SMS-060 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-380-HDS-020-SDS-010-SMS-070" = {
      id = "FS-380-HDS-020-SDS-010-SMS-070";
      traceId = "FS-380-HDS-020-SDS-010-SMS-070";
      rowDirectories = {
        SDS = ../../SDS/FS-380-HDS-020-SDS-010;
        SMS = ../../SMS/FS-380-HDS-020-SDS-010-SMS-070;
        SMT = ../FS-380-HDS-020-SDS-010-SMS-070;
        SIT = ../../SIT/FS-380-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-380-HDS-020-SDS-010-SMS-070/intent.nix;
        expectedRelationIds = [ "FS-380-HDS-020-SDS-010-SMS-070__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-380-HDS-020-SDS-010-SMS-070.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-380-HDS-020-SDS-010-SMS-070 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-380-HDS-020-SDS-010-SMS-080" = {
      id = "FS-380-HDS-020-SDS-010-SMS-080";
      traceId = "FS-380-HDS-020-SDS-010-SMS-080";
      rowDirectories = {
        SDS = ../../SDS/FS-380-HDS-020-SDS-010;
        SMS = ../../SMS/FS-380-HDS-020-SDS-010-SMS-080;
        SMT = ../FS-380-HDS-020-SDS-010-SMS-080;
        SIT = ../../SIT/FS-380-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-380-HDS-020-SDS-010-SMS-080/intent.nix;
        expectedRelationIds = [ "FS-380-HDS-020-SDS-010-SMS-080__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-380-HDS-020-SDS-010-SMS-080.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-380-HDS-020-SDS-010-SMS-080 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-380-HDS-020-SDS-010-SMS-090" = {
      id = "FS-380-HDS-020-SDS-010-SMS-090";
      traceId = "FS-380-HDS-020-SDS-010-SMS-090";
      rowDirectories = {
        SDS = ../../SDS/FS-380-HDS-020-SDS-010;
        SMS = ../../SMS/FS-380-HDS-020-SDS-010-SMS-090;
        SMT = ../FS-380-HDS-020-SDS-010-SMS-090;
        SIT = ../../SIT/FS-380-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-380-HDS-020-SDS-010-SMS-090/intent.nix;
        expectedRelationIds = [ "FS-380-HDS-020-SDS-010-SMS-090__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-380-HDS-020-SDS-010-SMS-090.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-380-HDS-020-SDS-010-SMS-090 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-380-HDS-020-SDS-010-SMS-100" = {
      id = "FS-380-HDS-020-SDS-010-SMS-100";
      traceId = "FS-380-HDS-020-SDS-010-SMS-100";
      rowDirectories = {
        SDS = ../../SDS/FS-380-HDS-020-SDS-010;
        SMS = ../../SMS/FS-380-HDS-020-SDS-010-SMS-100;
        SMT = ../FS-380-HDS-020-SDS-010-SMS-100;
        SIT = ../../SIT/FS-380-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-380-HDS-020-SDS-010-SMS-100/intent.nix;
        expectedRelationIds = [ "FS-380-HDS-020-SDS-010-SMS-100__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-380-HDS-020-SDS-010-SMS-100.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-380-HDS-020-SDS-010-SMS-100 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-380-HDS-020-SDS-010-SMS-110" = {
      id = "FS-380-HDS-020-SDS-010-SMS-110";
      traceId = "FS-380-HDS-020-SDS-010-SMS-110";
      rowDirectories = {
        SDS = ../../SDS/FS-380-HDS-020-SDS-010;
        SMS = ../../SMS/FS-380-HDS-020-SDS-010-SMS-110;
        SMT = ../FS-380-HDS-020-SDS-010-SMS-110;
        SIT = ../../SIT/FS-380-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-380-HDS-020-SDS-010-SMS-110/intent.nix;
        expectedRelationIds = [ "FS-380-HDS-020-SDS-010-SMS-110__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-380-HDS-020-SDS-010-SMS-110.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-380-HDS-020-SDS-010-SMS-110 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-390-HDS-010-SDS-010-SMS-010" = {
      id = "FS-390-HDS-010-SDS-010-SMS-010";
      traceId = "FS-390-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-390-HDS-010-SDS-010;
        SMS = ../../SMS/FS-390-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-390-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-390-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-390-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [
          "FS-390-HDS-010-SDS-010-SMS-010__mini-verify"
          "FS-390-HDS-010-SDS-010-SMS-010__client-to-tenant-api"
          "FS-390-HDS-010-SDS-010-SMS-010__client-to-fixture-missing-output"
          "FS-390-HDS-010-SDS-010-SMS-010__testnet-to-public-web"
        ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-390-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-390-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-390-HDS-010-SDS-010-SMS-020" = {
      id = "FS-390-HDS-010-SDS-010-SMS-020";
      traceId = "FS-390-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-390-HDS-010-SDS-010;
        SMS = ../../SMS/FS-390-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-390-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-390-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-390-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-390-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-390-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-390-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-390-HDS-010-SDS-010-SMS-030" = {
      id = "FS-390-HDS-010-SDS-010-SMS-030";
      traceId = "FS-390-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-390-HDS-010-SDS-010;
        SMS = ../../SMS/FS-390-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-390-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-390-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-390-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-390-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-390-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-390-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-400-HDS-010-SDS-010-SMS-010" = {
      id = "FS-400-HDS-010-SDS-010-SMS-010";
      traceId = "FS-400-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-400-HDS-010-SDS-010;
        SMS = ../../SMS/FS-400-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-400-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-400-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-400-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-400-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-400-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-400-HDS-010-SDS-010-SMS-010 SMT construction verifier";
      maxRuntimeTargets = 0;
    };

    "FS-400-HDS-010-SDS-010-SMS-030" = {
      id = "FS-400-HDS-010-SDS-010-SMS-030";
      traceId = "FS-400-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-400-HDS-010-SDS-010;
        SMS = ../../SMS/FS-400-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-400-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-400-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-400-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-400-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-400-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-400-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-400-HDS-010-SDS-010-SMS-050" = {
      id = "FS-400-HDS-010-SDS-010-SMS-050";
      traceId = "FS-400-HDS-010-SDS-010-SMS-050";
      rowDirectories = {
        SDS = ../../SDS/FS-400-HDS-010-SDS-010;
        SMS = ../../SMS/FS-400-HDS-010-SDS-010-SMS-050;
        SMT = ../FS-400-HDS-010-SDS-010-SMS-050;
        SIT = ../../SIT/FS-400-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-400-HDS-010-SDS-010-SMS-050/intent.nix;
        expectedRelationIds = [ "FS-400-HDS-010-SDS-010-SMS-050__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-400-HDS-010-SDS-010-SMS-050.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-400-HDS-010-SDS-010-SMS-050 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-400-HDS-010-SDS-010-SMS-060" = {
      id = "FS-400-HDS-010-SDS-010-SMS-060";
      traceId = "FS-400-HDS-010-SDS-010-SMS-060";
      rowDirectories = {
        SDS = ../../SDS/FS-400-HDS-010-SDS-010;
        SMS = ../../SMS/FS-400-HDS-010-SDS-010-SMS-060;
        SMT = ../FS-400-HDS-010-SDS-010-SMS-060;
        SIT = ../../SIT/FS-400-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-400-HDS-010-SDS-010-SMS-060/intent.nix;
        expectedRelationIds = [ "FS-400-HDS-010-SDS-010-SMS-060__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-400-HDS-010-SDS-010-SMS-060.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-400-HDS-010-SDS-010-SMS-060 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-410-HDS-010-SDS-010-SMS-010" = {
      id = "FS-410-HDS-010-SDS-010-SMS-010";
      traceId = "FS-410-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-410-HDS-010-SDS-010;
        SMS = ../../SMS/FS-410-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-410-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-410-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-410-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-410-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-410-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-410-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-410-HDS-010-SDS-010-SMS-020" = {
      id = "FS-410-HDS-010-SDS-010-SMS-020";
      traceId = "FS-410-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-410-HDS-010-SDS-010;
        SMS = ../../SMS/FS-410-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-410-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-410-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-410-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-410-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-410-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-410-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-410-HDS-010-SDS-010-SMS-030" = {
      id = "FS-410-HDS-010-SDS-010-SMS-030";
      traceId = "FS-410-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-410-HDS-010-SDS-010;
        SMS = ../../SMS/FS-410-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-410-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-410-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-410-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-410-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-410-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-410-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-410-HDS-010-SDS-010-SMS-040" = {
      id = "FS-410-HDS-010-SDS-010-SMS-040";
      traceId = "FS-410-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-410-HDS-010-SDS-010;
        SMS = ../../SMS/FS-410-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-410-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-410-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-410-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-410-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-410-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-410-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-410-HDS-010-SDS-010-SMS-050" = {
      id = "FS-410-HDS-010-SDS-010-SMS-050";
      traceId = "FS-410-HDS-010-SDS-010-SMS-050";
      rowDirectories = {
        SDS = ../../SDS/FS-410-HDS-010-SDS-010;
        SMS = ../../SMS/FS-410-HDS-010-SDS-010-SMS-050;
        SMT = ../FS-410-HDS-010-SDS-010-SMS-050;
        SIT = ../../SIT/FS-410-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-410-HDS-010-SDS-010-SMS-050/intent.nix;
        expectedRelationIds = [ "FS-410-HDS-010-SDS-010-SMS-050__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-410-HDS-010-SDS-010-SMS-050.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-410-HDS-010-SDS-010-SMS-050 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-420-HDS-010-SDS-010-SMS-010" = {
      id = "FS-420-HDS-010-SDS-010-SMS-010";
      traceId = "FS-420-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-420-HDS-010-SDS-010;
        SMS = ../../SMS/FS-420-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-420-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-420-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-420-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-420-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-420-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-420-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-420-HDS-010-SDS-010-SMS-020" = {
      id = "FS-420-HDS-010-SDS-010-SMS-020";
      traceId = "FS-420-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-420-HDS-010-SDS-010;
        SMS = ../../SMS/FS-420-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-420-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-420-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-420-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-420-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-420-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-420-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-420-HDS-010-SDS-010-SMS-030" = {
      id = "FS-420-HDS-010-SDS-010-SMS-030";
      traceId = "FS-420-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-420-HDS-010-SDS-010;
        SMS = ../../SMS/FS-420-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-420-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-420-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-420-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-420-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-420-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-420-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-430-HDS-010-SDS-010-SMS-010" = {
      id = "FS-430-HDS-010-SDS-010-SMS-010";
      traceId = "FS-430-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-430-HDS-010-SDS-010;
        SMS = ../../SMS/FS-430-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-430-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-430-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-430-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-430-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-430-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-430-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-430-HDS-010-SDS-010-SMS-020" = {
      id = "FS-430-HDS-010-SDS-010-SMS-020";
      traceId = "FS-430-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-430-HDS-010-SDS-010;
        SMS = ../../SMS/FS-430-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-430-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-430-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-430-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-430-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-430-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-430-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-430-HDS-010-SDS-010-SMS-030" = {
      id = "FS-430-HDS-010-SDS-010-SMS-030";
      traceId = "FS-430-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-430-HDS-010-SDS-010;
        SMS = ../../SMS/FS-430-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-430-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-430-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-430-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-430-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-430-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-430-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-440-HDS-010-SDS-010-SMS-010" = {
      id = "FS-440-HDS-010-SDS-010-SMS-010";
      traceId = "FS-440-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-440-HDS-010-SDS-010;
        SMS = ../../SMS/FS-440-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-440-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-440-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-440-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-440-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-440-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-440-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-440-HDS-010-SDS-010-SMS-020" = {
      id = "FS-440-HDS-010-SDS-010-SMS-020";
      traceId = "FS-440-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-440-HDS-010-SDS-010;
        SMS = ../../SMS/FS-440-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-440-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-440-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-440-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-440-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-440-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-440-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-440-HDS-010-SDS-010-SMS-030" = {
      id = "FS-440-HDS-010-SDS-010-SMS-030";
      traceId = "FS-440-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-440-HDS-010-SDS-010;
        SMS = ../../SMS/FS-440-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-440-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-440-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-440-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-440-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-440-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-440-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-440-HDS-010-SDS-010-SMS-050" = {
      id = "FS-440-HDS-010-SDS-010-SMS-050";
      traceId = "FS-440-HDS-010-SDS-010-SMS-050";
      rowDirectories = {
        SDS = ../../SDS/FS-440-HDS-010-SDS-010;
        SMS = ../../SMS/FS-440-HDS-010-SDS-010-SMS-050;
        SMT = ../FS-440-HDS-010-SDS-010-SMS-050;
        SIT = ../../SIT/FS-440-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-440-HDS-010-SDS-010-SMS-050/intent.nix;
        expectedRelationIds = [ "FS-440-HDS-010-SDS-010-SMS-050__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-440-HDS-010-SDS-010-SMS-050.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-440-HDS-010-SDS-010-SMS-050 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-450-HDS-010-SDS-010-SMS-010" = {
      id = "FS-450-HDS-010-SDS-010-SMS-010";
      traceId = "FS-450-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-450-HDS-010-SDS-010;
        SMS = ../../SMS/FS-450-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-450-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-450-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-450-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-450-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-450-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-450-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-450-HDS-010-SDS-010-SMS-020" = {
      id = "FS-450-HDS-010-SDS-010-SMS-020";
      traceId = "FS-450-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-450-HDS-010-SDS-010;
        SMS = ../../SMS/FS-450-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-450-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-450-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-450-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-450-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-450-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-450-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-450-HDS-010-SDS-010-SMS-030" = {
      id = "FS-450-HDS-010-SDS-010-SMS-030";
      traceId = "FS-450-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-450-HDS-010-SDS-010;
        SMS = ../../SMS/FS-450-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-450-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-450-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-450-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-450-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-450-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-450-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-460-HDS-010-SDS-010-SMS-010" = {
      id = "FS-460-HDS-010-SDS-010-SMS-010";
      traceId = "FS-460-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-460-HDS-010-SDS-010;
        SMS = ../../SMS/FS-460-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-460-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-460-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-460-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-460-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-460-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-460-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-460-HDS-010-SDS-010-SMS-020" = {
      id = "FS-460-HDS-010-SDS-010-SMS-020";
      traceId = "FS-460-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-460-HDS-010-SDS-010;
        SMS = ../../SMS/FS-460-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-460-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-460-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-460-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-460-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-460-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-460-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-460-HDS-010-SDS-010-SMS-021" = {
      id = "FS-460-HDS-010-SDS-010-SMS-021";
      traceId = "FS-460-HDS-010-SDS-010-SMS-021";
      rowDirectories = {
        SDS = ../../SDS/FS-460-HDS-010-SDS-010;
        SMS = ../../SMS/FS-460-HDS-010-SDS-010-SMS-021;
        SMT = ../FS-460-HDS-010-SDS-010-SMS-021;
        SIT = ../../SIT/FS-460-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-460-HDS-010-SDS-010-SMS-021/intent.nix;
        expectedRelationIds = [ "FS-460-HDS-010-SDS-010-SMS-021__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-460-HDS-010-SDS-010-SMS-021.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-460-HDS-010-SDS-010-SMS-021 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-460-HDS-010-SDS-010-SMS-030" = {
      id = "FS-460-HDS-010-SDS-010-SMS-030";
      traceId = "FS-460-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-460-HDS-010-SDS-010;
        SMS = ../../SMS/FS-460-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-460-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-460-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-460-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-460-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-460-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-460-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-460-HDS-010-SDS-010-SMS-041" = {
      id = "FS-460-HDS-010-SDS-010-SMS-041";
      traceId = "FS-460-HDS-010-SDS-010-SMS-041";
      rowDirectories = {
        SDS = ../../SDS/FS-460-HDS-010-SDS-010;
        SMS = ../../SMS/FS-460-HDS-010-SDS-010-SMS-041;
        SMT = ../FS-460-HDS-010-SDS-010-SMS-041;
        SIT = ../../SIT/FS-460-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-460-HDS-010-SDS-010-SMS-041/intent.nix;
        expectedRelationIds = [ "FS-460-HDS-010-SDS-010-SMS-041__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-460-HDS-010-SDS-010-SMS-041.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-460-HDS-010-SDS-010-SMS-041 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-460-HDS-010-SDS-010-SMS-050" = {
      id = "FS-460-HDS-010-SDS-010-SMS-050";
      traceId = "FS-460-HDS-010-SDS-010-SMS-050";
      rowDirectories = {
        SDS = ../../SDS/FS-460-HDS-010-SDS-010;
        SMS = ../../SMS/FS-460-HDS-010-SDS-010-SMS-050;
        SMT = ../FS-460-HDS-010-SDS-010-SMS-050;
        SIT = ../../SIT/FS-460-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-460-HDS-010-SDS-010-SMS-050/intent.nix;
        expectedRelationIds = [ "FS-460-HDS-010-SDS-010-SMS-050__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-460-HDS-010-SDS-010-SMS-050.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-460-HDS-010-SDS-010-SMS-050 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-460-HDS-010-SDS-010-SMS-060" = {
      id = "FS-460-HDS-010-SDS-010-SMS-060";
      traceId = "FS-460-HDS-010-SDS-010-SMS-060";
      rowDirectories = {
        SDS = ../../SDS/FS-460-HDS-010-SDS-010;
        SMS = ../../SMS/FS-460-HDS-010-SDS-010-SMS-060;
        SMT = ../FS-460-HDS-010-SDS-010-SMS-060;
        SIT = ../../SIT/FS-460-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-460-HDS-010-SDS-010-SMS-060/intent.nix;
        expectedRelationIds = [ "FS-460-HDS-010-SDS-010-SMS-060__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-460-HDS-010-SDS-010-SMS-060.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-460-HDS-010-SDS-010-SMS-060 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-460-HDS-010-SDS-010-SMS-070" = {
      id = "FS-460-HDS-010-SDS-010-SMS-070";
      traceId = "FS-460-HDS-010-SDS-010-SMS-070";
      rowDirectories = {
        SDS = ../../SDS/FS-460-HDS-010-SDS-010;
        SMS = ../../SMS/FS-460-HDS-010-SDS-010-SMS-070;
        SMT = ../FS-460-HDS-010-SDS-010-SMS-070;
        SIT = ../../SIT/FS-460-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-460-HDS-010-SDS-010-SMS-070/intent.nix;
        expectedRelationIds = [ "FS-460-HDS-010-SDS-010-SMS-070__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-460-HDS-010-SDS-010-SMS-070.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-460-HDS-010-SDS-010-SMS-070 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-460-HDS-010-SDS-010-SMS-080" = {
      id = "FS-460-HDS-010-SDS-010-SMS-080";
      traceId = "FS-460-HDS-010-SDS-010-SMS-080";
      rowDirectories = {
        SDS = ../../SDS/FS-460-HDS-010-SDS-010;
        SMS = ../../SMS/FS-460-HDS-010-SDS-010-SMS-080;
        SMT = ../FS-460-HDS-010-SDS-010-SMS-080;
        SIT = ../../SIT/FS-460-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-460-HDS-010-SDS-010-SMS-080/intent.nix;
        expectedRelationIds = [ "FS-460-HDS-010-SDS-010-SMS-080__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-460-HDS-010-SDS-010-SMS-080.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-460-HDS-010-SDS-010-SMS-080 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-460-HDS-010-SDS-010-SMS-090" = {
      id = "FS-460-HDS-010-SDS-010-SMS-090";
      traceId = "FS-460-HDS-010-SDS-010-SMS-090";
      rowDirectories = {
        SDS = ../../SDS/FS-460-HDS-010-SDS-010;
        SMS = ../../SMS/FS-460-HDS-010-SDS-010-SMS-090;
        SMT = ../FS-460-HDS-010-SDS-010-SMS-090;
        SIT = ../../SIT/FS-460-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-460-HDS-010-SDS-010-SMS-090/intent.nix;
        expectedRelationIds = [ "FS-460-HDS-010-SDS-010-SMS-090__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-460-HDS-010-SDS-010-SMS-090.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-460-HDS-010-SDS-010-SMS-090 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-470-HDS-010-SDS-010-SMS-020" = {
      id = "FS-470-HDS-010-SDS-010-SMS-020";
      traceId = "FS-470-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-470-HDS-010-SDS-010;
        SMS = ../../SMS/FS-470-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-470-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-470-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-470-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-470-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-470-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-470-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-470-HDS-010-SDS-010-SMS-021" = {
      id = "FS-470-HDS-010-SDS-010-SMS-021";
      traceId = "FS-470-HDS-010-SDS-010-SMS-021";
      rowDirectories = {
        SDS = ../../SDS/FS-470-HDS-010-SDS-010;
        SMS = ../../SMS/FS-470-HDS-010-SDS-010-SMS-021;
        SMT = ../FS-470-HDS-010-SDS-010-SMS-021;
        SIT = ../../SIT/FS-470-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-470-HDS-010-SDS-010-SMS-021/intent.nix;
        expectedRelationIds = [ "FS-470-HDS-010-SDS-010-SMS-021__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-470-HDS-010-SDS-010-SMS-021.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-470-HDS-010-SDS-010-SMS-021 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-470-HDS-010-SDS-010-SMS-022" = {
      id = "FS-470-HDS-010-SDS-010-SMS-022";
      traceId = "FS-470-HDS-010-SDS-010-SMS-022";
      rowDirectories = {
        SDS = ../../SDS/FS-470-HDS-010-SDS-010;
        SMS = ../../SMS/FS-470-HDS-010-SDS-010-SMS-022;
        SMT = ../FS-470-HDS-010-SDS-010-SMS-022;
        SIT = ../../SIT/FS-470-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-470-HDS-010-SDS-010-SMS-022/intent.nix;
        expectedRelationIds = [ "FS-470-HDS-010-SDS-010-SMS-022__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-470-HDS-010-SDS-010-SMS-022.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-470-HDS-010-SDS-010-SMS-022 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-470-HDS-010-SDS-010-SMS-030" = {
      id = "FS-470-HDS-010-SDS-010-SMS-030";
      traceId = "FS-470-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-470-HDS-010-SDS-010;
        SMS = ../../SMS/FS-470-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-470-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-470-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-470-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-470-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-470-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-470-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-470-HDS-010-SDS-010-SMS-041" = {
      id = "FS-470-HDS-010-SDS-010-SMS-041";
      traceId = "FS-470-HDS-010-SDS-010-SMS-041";
      rowDirectories = {
        SDS = ../../SDS/FS-470-HDS-010-SDS-010;
        SMS = ../../SMS/FS-470-HDS-010-SDS-010-SMS-041;
        SMT = ../FS-470-HDS-010-SDS-010-SMS-041;
        SIT = ../../SIT/FS-470-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-470-HDS-010-SDS-010-SMS-041/intent.nix;
        expectedRelationIds = [ "FS-470-HDS-010-SDS-010-SMS-041__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-470-HDS-010-SDS-010-SMS-041.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-470-HDS-010-SDS-010-SMS-041 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-470-HDS-010-SDS-010-SMS-050" = {
      id = "FS-470-HDS-010-SDS-010-SMS-050";
      traceId = "FS-470-HDS-010-SDS-010-SMS-050";
      rowDirectories = {
        SDS = ../../SDS/FS-470-HDS-010-SDS-010;
        SMS = ../../SMS/FS-470-HDS-010-SDS-010-SMS-050;
        SMT = ../FS-470-HDS-010-SDS-010-SMS-050;
        SIT = ../../SIT/FS-470-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-470-HDS-010-SDS-010-SMS-050/intent.nix;
        expectedRelationIds = [ "FS-470-HDS-010-SDS-010-SMS-050__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-470-HDS-010-SDS-010-SMS-050.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-470-HDS-010-SDS-010-SMS-050 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-470-HDS-010-SDS-010-SMS-060" = {
      id = "FS-470-HDS-010-SDS-010-SMS-060";
      traceId = "FS-470-HDS-010-SDS-010-SMS-060";
      rowDirectories = {
        SDS = ../../SDS/FS-470-HDS-010-SDS-010;
        SMS = ../../SMS/FS-470-HDS-010-SDS-010-SMS-060;
        SMT = ../FS-470-HDS-010-SDS-010-SMS-060;
        SIT = ../../SIT/FS-470-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-470-HDS-010-SDS-010-SMS-060/intent.nix;
        expectedRelationIds = [ "FS-470-HDS-010-SDS-010-SMS-060__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-470-HDS-010-SDS-010-SMS-060.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-470-HDS-010-SDS-010-SMS-060 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-470-HDS-010-SDS-010-SMS-070" = {
      id = "FS-470-HDS-010-SDS-010-SMS-070";
      traceId = "FS-470-HDS-010-SDS-010-SMS-070";
      rowDirectories = {
        SDS = ../../SDS/FS-470-HDS-010-SDS-010;
        SMS = ../../SMS/FS-470-HDS-010-SDS-010-SMS-070;
        SMT = ../FS-470-HDS-010-SDS-010-SMS-070;
        SIT = ../../SIT/FS-470-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-470-HDS-010-SDS-010-SMS-070/intent.nix;
        expectedRelationIds = [ "FS-470-HDS-010-SDS-010-SMS-070__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-470-HDS-010-SDS-010-SMS-070.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-470-HDS-010-SDS-010-SMS-070 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-470-HDS-010-SDS-010-SMS-080" = {
      id = "FS-470-HDS-010-SDS-010-SMS-080";
      traceId = "FS-470-HDS-010-SDS-010-SMS-080";
      rowDirectories = {
        SDS = ../../SDS/FS-470-HDS-010-SDS-010;
        SMS = ../../SMS/FS-470-HDS-010-SDS-010-SMS-080;
        SMT = ../FS-470-HDS-010-SDS-010-SMS-080;
        SIT = ../../SIT/FS-470-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-470-HDS-010-SDS-010-SMS-080/intent.nix;
        expectedRelationIds = [ "FS-470-HDS-010-SDS-010-SMS-080__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-470-HDS-010-SDS-010-SMS-080.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-470-HDS-010-SDS-010-SMS-080 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-480-HDS-010-SDS-010-SMS-010" = {
      id = "FS-480-HDS-010-SDS-010-SMS-010";
      traceId = "FS-480-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-480-HDS-010-SDS-010;
        SMS = ../../SMS/FS-480-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-480-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-480-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-480-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-480-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-480-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-480-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-480-HDS-010-SDS-010-SMS-020" = {
      id = "FS-480-HDS-010-SDS-010-SMS-020";
      traceId = "FS-480-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-480-HDS-010-SDS-010;
        SMS = ../../SMS/FS-480-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-480-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-480-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-480-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-480-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-480-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-480-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-480-HDS-010-SDS-010-SMS-030" = {
      id = "FS-480-HDS-010-SDS-010-SMS-030";
      traceId = "FS-480-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-480-HDS-010-SDS-010;
        SMS = ../../SMS/FS-480-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-480-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-480-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-480-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-480-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-480-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-480-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-490-HDS-010-SDS-010-SMS-010" = {
      id = "FS-490-HDS-010-SDS-010-SMS-010";
      traceId = "FS-490-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-490-HDS-010-SDS-010;
        SMS = ../../SMS/FS-490-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-490-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-490-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-490-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-490-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-490-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-490-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-490-HDS-010-SDS-010-SMS-020" = {
      id = "FS-490-HDS-010-SDS-010-SMS-020";
      traceId = "FS-490-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-490-HDS-010-SDS-010;
        SMS = ../../SMS/FS-490-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-490-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-490-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-490-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-490-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-490-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-490-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-490-HDS-010-SDS-010-SMS-030" = {
      id = "FS-490-HDS-010-SDS-010-SMS-030";
      traceId = "FS-490-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-490-HDS-010-SDS-010;
        SMS = ../../SMS/FS-490-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-490-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-490-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-490-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-490-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-490-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-490-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-510-HDS-010-SDS-010-SMS-010" = {
      id = "FS-510-HDS-010-SDS-010-SMS-010";
      traceId = "FS-510-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-510-HDS-010-SDS-010;
        SMS = ../../SMS/FS-510-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-510-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-510-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-510-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-510-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-510-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-510-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-510-HDS-010-SDS-010-SMS-020" = {
      id = "FS-510-HDS-010-SDS-010-SMS-020";
      traceId = "FS-510-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-510-HDS-010-SDS-010;
        SMS = ../../SMS/FS-510-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-510-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-510-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-510-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-510-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-510-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-510-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-510-HDS-010-SDS-010-SMS-030" = {
      id = "FS-510-HDS-010-SDS-010-SMS-030";
      traceId = "FS-510-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-510-HDS-010-SDS-010;
        SMS = ../../SMS/FS-510-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-510-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-510-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-510-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-510-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-510-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-510-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-520-HDS-010-SDS-010-SMS-010" = {
      id = "FS-520-HDS-010-SDS-010-SMS-010";
      traceId = "FS-520-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-520-HDS-010-SDS-010;
        SMS = ../../SMS/FS-520-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-520-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-520-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-520-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-520-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-520-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-520-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-520-HDS-010-SDS-010-SMS-020" = {
      id = "FS-520-HDS-010-SDS-010-SMS-020";
      traceId = "FS-520-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-520-HDS-010-SDS-010;
        SMS = ../../SMS/FS-520-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-520-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-520-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-520-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-520-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-520-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-520-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-520-HDS-010-SDS-010-SMS-030" = {
      id = "FS-520-HDS-010-SDS-010-SMS-030";
      traceId = "FS-520-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-520-HDS-010-SDS-010;
        SMS = ../../SMS/FS-520-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-520-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-520-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-520-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-520-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-520-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-520-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-530-HDS-010-SDS-010-SMS-010" = {
      id = "FS-530-HDS-010-SDS-010-SMS-010";
      traceId = "FS-530-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-530-HDS-010-SDS-010;
        SMS = ../../SMS/FS-530-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-530-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-530-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-530-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-530-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-530-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-530-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-530-HDS-010-SDS-010-SMS-020" = {
      id = "FS-530-HDS-010-SDS-010-SMS-020";
      traceId = "FS-530-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-530-HDS-010-SDS-010;
        SMS = ../../SMS/FS-530-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-530-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-530-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-530-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-530-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-530-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-530-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-530-HDS-010-SDS-010-SMS-030" = {
      id = "FS-530-HDS-010-SDS-010-SMS-030";
      traceId = "FS-530-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-530-HDS-010-SDS-010;
        SMS = ../../SMS/FS-530-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-530-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-530-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-530-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-530-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-530-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-530-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-540-HDS-010-SDS-010-SMS-025" = {
      id = "FS-540-HDS-010-SDS-010-SMS-025";
      traceId = "FS-540-HDS-010-SDS-010-SMS-025";
      rowDirectories = {
        SDS = ../../SDS/FS-540-HDS-010-SDS-010;
        SMS = ../../SMS/FS-540-HDS-010-SDS-010-SMS-025;
        SMT = ../FS-540-HDS-010-SDS-010-SMS-025;
        SIT = ../../SIT/FS-540-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-540-HDS-010-SDS-010-SMS-025/intent.nix;
        expectedRelationIds = [ "FS-540-HDS-010-SDS-010-SMS-025__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-540-HDS-010-SDS-010-SMS-025.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-540-HDS-010-SDS-010-SMS-025 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-540-HDS-010-SDS-010-SMS-030" = {
      id = "FS-540-HDS-010-SDS-010-SMS-030";
      traceId = "FS-540-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-540-HDS-010-SDS-010;
        SMS = ../../SMS/FS-540-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-540-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-540-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-540-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-540-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-540-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-540-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-540-HDS-010-SDS-010-SMS-035" = {
      id = "FS-540-HDS-010-SDS-010-SMS-035";
      traceId = "FS-540-HDS-010-SDS-010-SMS-035";
      rowDirectories = {
        SDS = ../../SDS/FS-540-HDS-010-SDS-010;
        SMS = ../../SMS/FS-540-HDS-010-SDS-010-SMS-035;
        SMT = ../FS-540-HDS-010-SDS-010-SMS-035;
        SIT = ../../SIT/FS-540-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-540-HDS-010-SDS-010-SMS-035/intent.nix;
        expectedRelationIds = [ "FS-540-HDS-010-SDS-010-SMS-035__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-540-HDS-010-SDS-010-SMS-035.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-540-HDS-010-SDS-010-SMS-035 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-540-HDS-020-SDS-010-SMS-010" = {
      id = "FS-540-HDS-020-SDS-010-SMS-010";
      traceId = "FS-540-HDS-020-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-540-HDS-020-SDS-010;
        SMS = ../../SMS/FS-540-HDS-020-SDS-010-SMS-010;
        SMT = ../FS-540-HDS-020-SDS-010-SMS-010;
        SIT = ../../SIT/FS-540-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-540-HDS-020-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-540-HDS-020-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-540-HDS-020-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-540-HDS-020-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-550-HDS-010-SDS-010-SMS-010" = {
      id = "FS-550-HDS-010-SDS-010-SMS-010";
      traceId = "FS-550-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-550-HDS-010-SDS-010;
        SMS = ../../SMS/FS-550-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-550-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-550-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-550-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-550-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-550-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-550-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-550-HDS-010-SDS-010-SMS-020" = {
      id = "FS-550-HDS-010-SDS-010-SMS-020";
      traceId = "FS-550-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-550-HDS-010-SDS-010;
        SMS = ../../SMS/FS-550-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-550-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-550-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-550-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-550-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-550-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-550-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-550-HDS-010-SDS-010-SMS-030" = {
      id = "FS-550-HDS-010-SDS-010-SMS-030";
      traceId = "FS-550-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-550-HDS-010-SDS-010;
        SMS = ../../SMS/FS-550-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-550-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-550-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-550-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-550-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-550-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-550-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-550-HDS-010-SDS-010-SMS-050" = {
      id = "FS-550-HDS-010-SDS-010-SMS-050";
      traceId = "FS-550-HDS-010-SDS-010-SMS-050";
      rowDirectories = {
        SDS = ../../SDS/FS-550-HDS-010-SDS-010;
        SMS = ../../SMS/FS-550-HDS-010-SDS-010-SMS-050;
        SMT = ../FS-550-HDS-010-SDS-010-SMS-050;
        SIT = ../../SIT/FS-550-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-550-HDS-010-SDS-010-SMS-050/intent.nix;
        expectedRelationIds = [ "FS-550-HDS-010-SDS-010-SMS-050__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-550-HDS-010-SDS-010-SMS-050.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-550-HDS-010-SDS-010-SMS-050 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-560-HDS-010-SDS-010-SMS-010" = {
      id = "FS-560-HDS-010-SDS-010-SMS-010";
      traceId = "FS-560-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-560-HDS-010-SDS-010;
        SMS = ../../SMS/FS-560-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-560-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-560-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-560-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-560-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-560-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-560-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-560-HDS-010-SDS-010-SMS-020" = {
      id = "FS-560-HDS-010-SDS-010-SMS-020";
      traceId = "FS-560-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-560-HDS-010-SDS-010;
        SMS = ../../SMS/FS-560-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-560-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-560-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-560-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-560-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-560-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-560-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-560-HDS-010-SDS-010-SMS-030" = {
      id = "FS-560-HDS-010-SDS-010-SMS-030";
      traceId = "FS-560-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-560-HDS-010-SDS-010;
        SMS = ../../SMS/FS-560-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-560-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-560-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-560-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-560-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-560-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-560-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-570-HDS-010-SDS-010-SMS-010" = {
      id = "FS-570-HDS-010-SDS-010-SMS-010";
      traceId = "FS-570-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-570-HDS-010-SDS-010;
        SMS = ../../SMS/FS-570-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-570-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-570-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-570-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-570-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-570-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-570-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-570-HDS-010-SDS-010-SMS-020" = {
      id = "FS-570-HDS-010-SDS-010-SMS-020";
      traceId = "FS-570-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-570-HDS-010-SDS-010;
        SMS = ../../SMS/FS-570-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-570-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-570-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-570-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-570-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-570-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-570-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-570-HDS-010-SDS-010-SMS-030" = {
      id = "FS-570-HDS-010-SDS-010-SMS-030";
      traceId = "FS-570-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-570-HDS-010-SDS-010;
        SMS = ../../SMS/FS-570-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-570-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-570-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-570-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-570-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-570-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-570-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-580-HDS-010-SDS-010-SMS-010" = {
      id = "FS-580-HDS-010-SDS-010-SMS-010";
      traceId = "FS-580-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-580-HDS-010-SDS-010;
        SMS = ../../SMS/FS-580-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-580-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-580-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-580-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-580-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-580-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-580-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-580-HDS-010-SDS-010-SMS-020" = {
      id = "FS-580-HDS-010-SDS-010-SMS-020";
      traceId = "FS-580-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-580-HDS-010-SDS-010;
        SMS = ../../SMS/FS-580-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-580-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-580-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-580-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-580-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-580-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-580-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-580-HDS-010-SDS-010-SMS-030" = {
      id = "FS-580-HDS-010-SDS-010-SMS-030";
      traceId = "FS-580-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-580-HDS-010-SDS-010;
        SMS = ../../SMS/FS-580-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-580-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-580-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-580-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-580-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-580-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-580-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-590-HDS-010-SDS-010-SMS-010" = {
      id = "FS-590-HDS-010-SDS-010-SMS-010";
      traceId = "FS-590-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-590-HDS-010-SDS-010;
        SMS = ../../SMS/FS-590-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-590-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-590-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-590-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-590-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-590-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-590-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-590-HDS-010-SDS-010-SMS-020" = {
      id = "FS-590-HDS-010-SDS-010-SMS-020";
      traceId = "FS-590-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-590-HDS-010-SDS-010;
        SMS = ../../SMS/FS-590-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-590-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-590-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-590-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-590-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-590-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-590-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-590-HDS-010-SDS-010-SMS-030" = {
      id = "FS-590-HDS-010-SDS-010-SMS-030";
      traceId = "FS-590-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-590-HDS-010-SDS-010;
        SMS = ../../SMS/FS-590-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-590-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-590-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-590-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-590-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-590-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-590-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-600-HDS-010-SDS-010-SMS-010" = {
      id = "FS-600-HDS-010-SDS-010-SMS-010";
      traceId = "FS-600-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-600-HDS-010-SDS-010;
        SMS = ../../SMS/FS-600-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-600-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-600-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-600-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-600-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-600-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-600-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-600-HDS-010-SDS-010-SMS-020" = {
      id = "FS-600-HDS-010-SDS-010-SMS-020";
      traceId = "FS-600-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-600-HDS-010-SDS-010;
        SMS = ../../SMS/FS-600-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-600-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-600-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-600-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-600-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-600-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-600-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-600-HDS-010-SDS-010-SMS-030" = {
      id = "FS-600-HDS-010-SDS-010-SMS-030";
      traceId = "FS-600-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-600-HDS-010-SDS-010;
        SMS = ../../SMS/FS-600-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-600-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-600-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-600-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-600-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-600-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-600-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-610-HDS-010-SDS-010-SMS-010" = {
      id = "FS-610-HDS-010-SDS-010-SMS-010";
      traceId = "FS-610-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-610-HDS-010-SDS-010;
        SMS = ../../SMS/FS-610-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-610-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-610-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-610-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-610-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-610-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-610-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-610-HDS-010-SDS-010-SMS-020" = {
      id = "FS-610-HDS-010-SDS-010-SMS-020";
      traceId = "FS-610-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-610-HDS-010-SDS-010;
        SMS = ../../SMS/FS-610-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-610-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-610-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-610-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-610-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-610-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-610-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-610-HDS-010-SDS-010-SMS-030" = {
      id = "FS-610-HDS-010-SDS-010-SMS-030";
      traceId = "FS-610-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-610-HDS-010-SDS-010;
        SMS = ../../SMS/FS-610-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-610-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-610-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-610-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-610-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-610-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-610-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-620-HDS-010-SDS-010-SMS-010" = {
      id = "FS-620-HDS-010-SDS-010-SMS-010";
      traceId = "FS-620-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-620-HDS-010-SDS-010;
        SMS = ../../SMS/FS-620-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-620-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-620-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-620-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-620-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-620-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-620-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-620-HDS-010-SDS-010-SMS-020" = {
      id = "FS-620-HDS-010-SDS-010-SMS-020";
      traceId = "FS-620-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-620-HDS-010-SDS-010;
        SMS = ../../SMS/FS-620-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-620-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-620-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-620-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-620-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-620-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-620-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-620-HDS-010-SDS-010-SMS-030" = {
      id = "FS-620-HDS-010-SDS-010-SMS-030";
      traceId = "FS-620-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-620-HDS-010-SDS-010;
        SMS = ../../SMS/FS-620-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-620-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-620-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-620-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-620-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-620-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-620-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-630-HDS-010-SDS-010-SMS-010" = {
      id = "FS-630-HDS-010-SDS-010-SMS-010";
      traceId = "FS-630-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-630-HDS-010-SDS-010;
        SMS = ../../SMS/FS-630-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-630-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-630-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-630-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-630-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-630-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-630-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-630-HDS-010-SDS-010-SMS-020" = {
      id = "FS-630-HDS-010-SDS-010-SMS-020";
      traceId = "FS-630-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-630-HDS-010-SDS-010;
        SMS = ../../SMS/FS-630-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-630-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-630-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-630-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-630-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-630-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-630-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-630-HDS-010-SDS-010-SMS-030" = {
      id = "FS-630-HDS-010-SDS-010-SMS-030";
      traceId = "FS-630-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-630-HDS-010-SDS-010;
        SMS = ../../SMS/FS-630-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-630-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-630-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-630-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-630-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-630-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-630-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-640-HDS-010-SDS-010-SMS-010" = {
      id = "FS-640-HDS-010-SDS-010-SMS-010";
      traceId = "FS-640-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-640-HDS-010-SDS-010;
        SMS = ../../SMS/FS-640-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-640-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-640-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-640-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-640-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-640-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-640-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-640-HDS-010-SDS-010-SMS-020" = {
      id = "FS-640-HDS-010-SDS-010-SMS-020";
      traceId = "FS-640-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-640-HDS-010-SDS-010;
        SMS = ../../SMS/FS-640-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-640-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-640-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-640-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-640-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-640-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-640-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-640-HDS-010-SDS-010-SMS-030" = {
      id = "FS-640-HDS-010-SDS-010-SMS-030";
      traceId = "FS-640-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-640-HDS-010-SDS-010;
        SMS = ../../SMS/FS-640-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-640-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-640-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-640-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-640-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-640-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-640-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-640-HDS-010-SDS-010-SMS-050" = {
      id = "FS-640-HDS-010-SDS-010-SMS-050";
      traceId = "FS-640-HDS-010-SDS-010-SMS-050";
      rowDirectories = {
        SDS = ../../SDS/FS-640-HDS-010-SDS-010;
        SMS = ../../SMS/FS-640-HDS-010-SDS-010-SMS-050;
        SMT = ../FS-640-HDS-010-SDS-010-SMS-050;
        SIT = ../../SIT/FS-640-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-640-HDS-010-SDS-010-SMS-050/intent.nix;
        expectedRelationIds = [ "FS-640-HDS-010-SDS-010-SMS-050__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-640-HDS-010-SDS-010-SMS-050.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-640-HDS-010-SDS-010-SMS-050 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-640-HDS-010-SDS-010-SMS-060" = {
      id = "FS-640-HDS-010-SDS-010-SMS-060";
      traceId = "FS-640-HDS-010-SDS-010-SMS-060";
      rowDirectories = {
        SDS = ../../SDS/FS-640-HDS-010-SDS-010;
        SMS = ../../SMS/FS-640-HDS-010-SDS-010-SMS-060;
        SMT = ../FS-640-HDS-010-SDS-010-SMS-060;
        SIT = ../../SIT/FS-640-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-640-HDS-010-SDS-010-SMS-060/intent.nix;
        expectedRelationIds = [ "FS-640-HDS-010-SDS-010-SMS-060__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-640-HDS-010-SDS-010-SMS-060.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-640-HDS-010-SDS-010-SMS-060 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-650-HDS-010-SDS-010-SMS-010" = {
      id = "FS-650-HDS-010-SDS-010-SMS-010";
      traceId = "FS-650-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-650-HDS-010-SDS-010;
        SMS = ../../SMS/FS-650-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-650-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-650-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-650-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-650-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-650-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-650-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-650-HDS-010-SDS-010-SMS-020" = {
      id = "FS-650-HDS-010-SDS-010-SMS-020";
      traceId = "FS-650-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-650-HDS-010-SDS-010;
        SMS = ../../SMS/FS-650-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-650-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-650-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-650-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-650-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-650-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-650-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-650-HDS-010-SDS-010-SMS-030" = {
      id = "FS-650-HDS-010-SDS-010-SMS-030";
      traceId = "FS-650-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-650-HDS-010-SDS-010;
        SMS = ../../SMS/FS-650-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-650-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-650-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-650-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-650-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-650-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-650-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-660-HDS-010-SDS-010-SMS-010" = {
      id = "FS-660-HDS-010-SDS-010-SMS-010";
      traceId = "FS-660-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-660-HDS-010-SDS-010;
        SMS = ../../SMS/FS-660-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-660-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-660-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-660-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-660-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-660-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-660-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-660-HDS-010-SDS-010-SMS-020" = {
      id = "FS-660-HDS-010-SDS-010-SMS-020";
      traceId = "FS-660-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-660-HDS-010-SDS-010;
        SMS = ../../SMS/FS-660-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-660-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-660-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-660-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-660-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-660-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-660-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-660-HDS-010-SDS-010-SMS-030" = {
      id = "FS-660-HDS-010-SDS-010-SMS-030";
      traceId = "FS-660-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-660-HDS-010-SDS-010;
        SMS = ../../SMS/FS-660-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-660-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-660-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-660-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-660-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-660-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-660-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-670-HDS-010-SDS-010-SMS-010" = {
      id = "FS-670-HDS-010-SDS-010-SMS-010";
      traceId = "FS-670-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-670-HDS-010-SDS-010;
        SMS = ../../SMS/FS-670-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-670-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-670-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-670-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-670-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-670-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-670-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-670-HDS-010-SDS-010-SMS-020" = {
      id = "FS-670-HDS-010-SDS-010-SMS-020";
      traceId = "FS-670-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-670-HDS-010-SDS-010;
        SMS = ../../SMS/FS-670-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-670-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-670-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-670-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-670-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-670-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-670-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-670-HDS-010-SDS-010-SMS-030" = {
      id = "FS-670-HDS-010-SDS-010-SMS-030";
      traceId = "FS-670-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-670-HDS-010-SDS-010;
        SMS = ../../SMS/FS-670-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-670-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-670-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-670-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-670-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-670-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-670-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-680-HDS-010-SDS-010-SMS-010" = {
      id = "FS-680-HDS-010-SDS-010-SMS-010";
      traceId = "FS-680-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-680-HDS-010-SDS-010;
        SMS = ../../SMS/FS-680-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-680-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-680-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-680-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-680-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-680-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-680-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-680-HDS-010-SDS-010-SMS-020" = {
      id = "FS-680-HDS-010-SDS-010-SMS-020";
      traceId = "FS-680-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-680-HDS-010-SDS-010;
        SMS = ../../SMS/FS-680-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-680-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-680-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-680-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-680-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-680-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-680-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-680-HDS-010-SDS-010-SMS-030" = {
      id = "FS-680-HDS-010-SDS-010-SMS-030";
      traceId = "FS-680-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-680-HDS-010-SDS-010;
        SMS = ../../SMS/FS-680-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-680-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-680-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-680-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-680-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-680-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-680-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-680-HDS-010-SDS-010-SMS-050" = {
      id = "FS-680-HDS-010-SDS-010-SMS-050";
      traceId = "FS-680-HDS-010-SDS-010-SMS-050";
      rowDirectories = {
        SDS = ../../SDS/FS-680-HDS-010-SDS-010;
        SMS = ../../SMS/FS-680-HDS-010-SDS-010-SMS-050;
        SMT = ../FS-680-HDS-010-SDS-010-SMS-050;
        SIT = ../../SIT/FS-680-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-680-HDS-010-SDS-010-SMS-050/intent.nix;
        expectedRelationIds = [ "FS-680-HDS-010-SDS-010-SMS-050__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-680-HDS-010-SDS-010-SMS-050.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-680-HDS-010-SDS-010-SMS-050 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-690-HDS-010-SDS-010-SMS-010" = {
      id = "FS-690-HDS-010-SDS-010-SMS-010";
      traceId = "FS-690-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-690-HDS-010-SDS-010;
        SMS = ../../SMS/FS-690-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-690-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-690-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-690-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-690-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-690-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-690-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-690-HDS-010-SDS-010-SMS-020" = {
      id = "FS-690-HDS-010-SDS-010-SMS-020";
      traceId = "FS-690-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-690-HDS-010-SDS-010;
        SMS = ../../SMS/FS-690-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-690-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-690-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-690-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-690-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-690-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-690-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-690-HDS-010-SDS-010-SMS-030" = {
      id = "FS-690-HDS-010-SDS-010-SMS-030";
      traceId = "FS-690-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-690-HDS-010-SDS-010;
        SMS = ../../SMS/FS-690-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-690-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-690-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-690-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-690-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-690-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-690-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-700-HDS-010-SDS-010-SMS-010" = {
      id = "FS-700-HDS-010-SDS-010-SMS-010";
      traceId = "FS-700-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-700-HDS-010-SDS-010;
        SMS = ../../SMS/FS-700-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-700-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-700-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-700-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-700-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-700-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-700-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-700-HDS-010-SDS-020-SMS-010" = {
      id = "FS-700-HDS-010-SDS-020-SMS-010";
      traceId = "FS-700-HDS-010-SDS-020-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-700-HDS-010-SDS-020;
        SMS = ../../SMS/FS-700-HDS-010-SDS-020-SMS-010;
        SMT = ../FS-700-HDS-010-SDS-020-SMS-010;
        SIT = ../../SIT/FS-700-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-700-HDS-010-SDS-020-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-700-HDS-010-SDS-020-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-700-HDS-010-SDS-020-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-700-HDS-010-SDS-020-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-700-HDS-020-SDS-010-SMS-010" = {
      id = "FS-700-HDS-020-SDS-010-SMS-010";
      traceId = "FS-700-HDS-020-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-700-HDS-020-SDS-010;
        SMS = ../../SMS/FS-700-HDS-020-SDS-010-SMS-010;
        SMT = ../FS-700-HDS-020-SDS-010-SMS-010;
        SIT = ../../SIT/FS-700-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-700-HDS-020-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-700-HDS-020-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-700-HDS-020-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-700-HDS-020-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-710-HDS-010-SDS-010-SMS-005" = {
      id = "FS-710-HDS-010-SDS-010-SMS-005";
      traceId = "FS-710-HDS-010-SDS-010-SMS-005";
      rowDirectories = {
        SDS = ../../SDS/FS-710-HDS-010-SDS-010;
        SMS = ../../SMS/FS-710-HDS-010-SDS-010-SMS-005;
        SMT = ../FS-710-HDS-010-SDS-010-SMS-005;
        SIT = ../../SIT/FS-710-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-710-HDS-010-SDS-010-SMS-005/intent.nix;
        expectedRelationIds = [ "FS-710-HDS-010-SDS-010-SMS-005__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-710-HDS-010-SDS-010-SMS-005.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-710-HDS-010-SDS-010-SMS-005 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-710-HDS-010-SDS-010-SMS-010" = {
      id = "FS-710-HDS-010-SDS-010-SMS-010";
      traceId = "FS-710-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-710-HDS-010-SDS-010;
        SMS = ../../SMS/FS-710-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-710-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-710-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-710-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-710-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-710-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-710-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-710-HDS-010-SDS-010-SMS-020" = {
      id = "FS-710-HDS-010-SDS-010-SMS-020";
      traceId = "FS-710-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-710-HDS-010-SDS-010;
        SMS = ../../SMS/FS-710-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-710-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-710-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-710-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-710-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-710-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-710-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-710-HDS-010-SDS-010-SMS-030" = {
      id = "FS-710-HDS-010-SDS-010-SMS-030";
      traceId = "FS-710-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-710-HDS-010-SDS-010;
        SMS = ../../SMS/FS-710-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-710-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-710-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-710-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-710-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-710-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-710-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-710-HDS-020-SDS-010-SMS-010" = {
      id = "FS-710-HDS-020-SDS-010-SMS-010";
      traceId = "FS-710-HDS-020-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-710-HDS-020-SDS-010;
        SMS = ../../SMS/FS-710-HDS-020-SDS-010-SMS-010;
        SMT = ../FS-710-HDS-020-SDS-010-SMS-010;
        SIT = ../../SIT/FS-710-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-710-HDS-020-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-710-HDS-020-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-710-HDS-020-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-710-HDS-020-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-720-HDS-010-SDS-010-SMS-010" = {
      id = "FS-720-HDS-010-SDS-010-SMS-010";
      traceId = "FS-720-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-720-HDS-010-SDS-010;
        SMS = ../../SMS/FS-720-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-720-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-720-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-720-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-720-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-720-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-720-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-720-HDS-010-SDS-010-SMS-020" = {
      id = "FS-720-HDS-010-SDS-010-SMS-020";
      traceId = "FS-720-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-720-HDS-010-SDS-010;
        SMS = ../../SMS/FS-720-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-720-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-720-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-720-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-720-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-720-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-720-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-720-HDS-010-SDS-010-SMS-030" = {
      id = "FS-720-HDS-010-SDS-010-SMS-030";
      traceId = "FS-720-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-720-HDS-010-SDS-010;
        SMS = ../../SMS/FS-720-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-720-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-720-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-720-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-720-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-720-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-720-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-720-HDS-010-SDS-015-SMS-010" = {
      id = "FS-720-HDS-010-SDS-015-SMS-010";
      traceId = "FS-720-HDS-010-SDS-015-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-720-HDS-010-SDS-015;
        SMS = ../../SMS/FS-720-HDS-010-SDS-015-SMS-010;
        SMT = ../FS-720-HDS-010-SDS-015-SMS-010;
        SIT = ../../SIT/FS-720-HDS-010-SDS-015;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-720-HDS-010-SDS-015-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-720-HDS-010-SDS-015-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-720-HDS-010-SDS-015-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-720-HDS-010-SDS-015-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-720-HDS-010-SDS-020-SMS-010" = {
      id = "FS-720-HDS-010-SDS-020-SMS-010";
      traceId = "FS-720-HDS-010-SDS-020-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-720-HDS-010-SDS-020;
        SMS = ../../SMS/FS-720-HDS-010-SDS-020-SMS-010;
        SMT = ../FS-720-HDS-010-SDS-020-SMS-010;
        SIT = ../../SIT/FS-720-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-720-HDS-010-SDS-020-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-720-HDS-010-SDS-020-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-720-HDS-010-SDS-020-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-720-HDS-010-SDS-020-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-720-HDS-010-SDS-020-SMS-040" = {
      id = "FS-720-HDS-010-SDS-020-SMS-040";
      traceId = "FS-720-HDS-010-SDS-020-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-720-HDS-010-SDS-020;
        SMS = ../../SMS/FS-720-HDS-010-SDS-020-SMS-040;
        SMT = ../FS-720-HDS-010-SDS-020-SMS-040;
        SIT = ../../SIT/FS-720-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-720-HDS-010-SDS-020-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-720-HDS-010-SDS-020-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-720-HDS-010-SDS-020-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-720-HDS-010-SDS-020-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-720-HDS-010-SDS-025-SMS-010" = {
      id = "FS-720-HDS-010-SDS-025-SMS-010";
      traceId = "FS-720-HDS-010-SDS-025-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-720-HDS-010-SDS-025;
        SMS = ../../SMS/FS-720-HDS-010-SDS-025-SMS-010;
        SMT = ../FS-720-HDS-010-SDS-025-SMS-010;
        SIT = ../../SIT/FS-720-HDS-010-SDS-025;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-720-HDS-010-SDS-025-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-720-HDS-010-SDS-025-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-720-HDS-010-SDS-025-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-720-HDS-010-SDS-025-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-720-HDS-010-SDS-040-SMS-010" = {
      id = "FS-720-HDS-010-SDS-040-SMS-010";
      traceId = "FS-720-HDS-010-SDS-040-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-720-HDS-010-SDS-040;
        SMS = ../../SMS/FS-720-HDS-010-SDS-040-SMS-010;
        SMT = ../FS-720-HDS-010-SDS-040-SMS-010;
        SIT = ../../SIT/FS-720-HDS-010-SDS-040;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-720-HDS-010-SDS-040-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-720-HDS-010-SDS-040-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-720-HDS-010-SDS-040-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-720-HDS-010-SDS-040-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-720-HDS-010-SDS-050-SMS-010" = {
      id = "FS-720-HDS-010-SDS-050-SMS-010";
      traceId = "FS-720-HDS-010-SDS-050-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-720-HDS-010-SDS-050;
        SMS = ../../SMS/FS-720-HDS-010-SDS-050-SMS-010;
        SMT = ../FS-720-HDS-010-SDS-050-SMS-010;
        SIT = ../../SIT/FS-720-HDS-010-SDS-050;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-720-HDS-010-SDS-050-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-720-HDS-010-SDS-050-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-720-HDS-010-SDS-050-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-720-HDS-010-SDS-050-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-720-HDS-010-SDS-060-SMS-010" = {
      id = "FS-720-HDS-010-SDS-060-SMS-010";
      traceId = "FS-720-HDS-010-SDS-060-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-720-HDS-010-SDS-060;
        SMS = ../../SMS/FS-720-HDS-010-SDS-060-SMS-010;
        SMT = ../FS-720-HDS-010-SDS-060-SMS-010;
        SIT = ../../SIT/FS-720-HDS-010-SDS-060;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-720-HDS-010-SDS-060-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-720-HDS-010-SDS-060-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-720-HDS-010-SDS-060-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-720-HDS-010-SDS-060-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-720-HDS-020-SDS-010-SMS-010" = {
      id = "FS-720-HDS-020-SDS-010-SMS-010";
      traceId = "FS-720-HDS-020-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-720-HDS-020-SDS-010;
        SMS = ../../SMS/FS-720-HDS-020-SDS-010-SMS-010;
        SMT = ../FS-720-HDS-020-SDS-010-SMS-010;
        SIT = ../../SIT/FS-720-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-720-HDS-020-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-720-HDS-020-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-720-HDS-020-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-720-HDS-020-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-720-HDS-030-SDS-010-SMS-021" = {
      id = "FS-720-HDS-030-SDS-010-SMS-021";
      traceId = "FS-720-HDS-030-SDS-010-SMS-021";
      rowDirectories = {
        SDS = ../../SDS/FS-720-HDS-030-SDS-010;
        SMS = ../../SMS/FS-720-HDS-030-SDS-010-SMS-021;
        SMT = ../FS-720-HDS-030-SDS-010-SMS-021;
        SIT = ../../SIT/FS-720-HDS-030-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-720-HDS-030-SDS-010-SMS-021/intent.nix;
        expectedRelationIds = [ "FS-720-HDS-030-SDS-010-SMS-021__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-720-HDS-030-SDS-010-SMS-021.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-720-HDS-030-SDS-010-SMS-021 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-720-HDS-030-SDS-010-SMS-041" = {
      id = "FS-720-HDS-030-SDS-010-SMS-041";
      traceId = "FS-720-HDS-030-SDS-010-SMS-041";
      rowDirectories = {
        SDS = ../../SDS/FS-720-HDS-030-SDS-010;
        SMS = ../../SMS/FS-720-HDS-030-SDS-010-SMS-041;
        SMT = ../FS-720-HDS-030-SDS-010-SMS-041;
        SIT = ../../SIT/FS-720-HDS-030-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-720-HDS-030-SDS-010-SMS-041/intent.nix;
        expectedRelationIds = [ "FS-720-HDS-030-SDS-010-SMS-041__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-720-HDS-030-SDS-010-SMS-041.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-720-HDS-030-SDS-010-SMS-041 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-720-HDS-040-SDS-010-SMS-010" = {
      id = "FS-720-HDS-040-SDS-010-SMS-010";
      traceId = "FS-720-HDS-040-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-720-HDS-040-SDS-010;
        SMS = ../../SMS/FS-720-HDS-040-SDS-010-SMS-010;
        SMT = ../FS-720-HDS-040-SDS-010-SMS-010;
        SIT = ../../SIT/FS-720-HDS-040-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-720-HDS-040-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-720-HDS-040-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-720-HDS-040-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-720-HDS-040-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-725-HDS-010-SDS-010-SMS-010" = {
      id = "FS-725-HDS-010-SDS-010-SMS-010";
      traceId = "FS-725-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-725-HDS-010-SDS-010;
        SMS = ../../SMS/FS-725-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-725-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-725-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-725-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-725-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-725-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-725-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-725-HDS-020-SDS-010-SMS-010" = {
      id = "FS-725-HDS-020-SDS-010-SMS-010";
      traceId = "FS-725-HDS-020-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-725-HDS-020-SDS-010;
        SMS = ../../SMS/FS-725-HDS-020-SDS-010-SMS-010;
        SMT = ../FS-725-HDS-020-SDS-010-SMS-010;
        SIT = ../../SIT/FS-725-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-725-HDS-020-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-725-HDS-020-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-725-HDS-020-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-725-HDS-020-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-730-HDS-010-SDS-010-SMS-010" = {
      id = "FS-730-HDS-010-SDS-010-SMS-010";
      traceId = "FS-730-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-730-HDS-010-SDS-010;
        SMS = ../../SMS/FS-730-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-730-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-730-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-730-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-730-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-730-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-730-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-730-HDS-010-SDS-010-SMS-020" = {
      id = "FS-730-HDS-010-SDS-010-SMS-020";
      traceId = "FS-730-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-730-HDS-010-SDS-010;
        SMS = ../../SMS/FS-730-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-730-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-730-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-730-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-730-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-730-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-730-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-730-HDS-010-SDS-010-SMS-030" = {
      id = "FS-730-HDS-010-SDS-010-SMS-030";
      traceId = "FS-730-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-730-HDS-010-SDS-010;
        SMS = ../../SMS/FS-730-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-730-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-730-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-730-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-730-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-730-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-730-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-730-HDS-020-SDS-010-SMS-010" = {
      id = "FS-730-HDS-020-SDS-010-SMS-010";
      traceId = "FS-730-HDS-020-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-730-HDS-020-SDS-010;
        SMS = ../../SMS/FS-730-HDS-020-SDS-010-SMS-010;
        SMT = ../FS-730-HDS-020-SDS-010-SMS-010;
        SIT = ../../SIT/FS-730-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-730-HDS-020-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-730-HDS-020-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-730-HDS-020-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-730-HDS-020-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-740-HDS-010-SDS-010-SMS-010" = {
      id = "FS-740-HDS-010-SDS-010-SMS-010";
      traceId = "FS-740-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-740-HDS-010-SDS-010;
        SMS = ../../SMS/FS-740-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-740-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-740-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-740-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-740-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-740-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-740-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-740-HDS-010-SDS-010-SMS-020" = {
      id = "FS-740-HDS-010-SDS-010-SMS-020";
      traceId = "FS-740-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-740-HDS-010-SDS-010;
        SMS = ../../SMS/FS-740-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-740-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-740-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-740-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-740-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-740-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-740-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-740-HDS-010-SDS-010-SMS-030" = {
      id = "FS-740-HDS-010-SDS-010-SMS-030";
      traceId = "FS-740-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-740-HDS-010-SDS-010;
        SMS = ../../SMS/FS-740-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-740-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-740-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-740-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-740-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-740-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-740-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-740-HDS-020-SDS-010-SMS-010" = {
      id = "FS-740-HDS-020-SDS-010-SMS-010";
      traceId = "FS-740-HDS-020-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-740-HDS-020-SDS-010;
        SMS = ../../SMS/FS-740-HDS-020-SDS-010-SMS-010;
        SMT = ../FS-740-HDS-020-SDS-010-SMS-010;
        SIT = ../../SIT/FS-740-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-740-HDS-020-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-740-HDS-020-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-740-HDS-020-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-740-HDS-020-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-740-HDS-030-SDS-010-SMS-010" = {
      id = "FS-740-HDS-030-SDS-010-SMS-010";
      traceId = "FS-740-HDS-030-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-740-HDS-030-SDS-010;
        SMS = ../../SMS/FS-740-HDS-030-SDS-010-SMS-010;
        SMT = ../FS-740-HDS-030-SDS-010-SMS-010;
        SIT = ../../SIT/FS-740-HDS-030-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-740-HDS-030-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-740-HDS-030-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-740-HDS-030-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-740-HDS-030-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-740-HDS-040-SDS-010-SMS-010" = {
      id = "FS-740-HDS-040-SDS-010-SMS-010";
      traceId = "FS-740-HDS-040-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-740-HDS-040-SDS-010;
        SMS = ../../SMS/FS-740-HDS-040-SDS-010-SMS-010;
        SMT = ../FS-740-HDS-040-SDS-010-SMS-010;
        SIT = ../../SIT/FS-740-HDS-040-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-740-HDS-040-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-740-HDS-040-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-740-HDS-040-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-740-HDS-040-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-750-HDS-010-SDS-010-SMS-010" = {
      id = "FS-750-HDS-010-SDS-010-SMS-010";
      traceId = "FS-750-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-750-HDS-010-SDS-010;
        SMS = ../../SMS/FS-750-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-750-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-750-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-750-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-750-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-750-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-750-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-750-HDS-010-SDS-010-SMS-020" = {
      id = "FS-750-HDS-010-SDS-010-SMS-020";
      traceId = "FS-750-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-750-HDS-010-SDS-010;
        SMS = ../../SMS/FS-750-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-750-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-750-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-750-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-750-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-750-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-750-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-750-HDS-010-SDS-010-SMS-030" = {
      id = "FS-750-HDS-010-SDS-010-SMS-030";
      traceId = "FS-750-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-750-HDS-010-SDS-010;
        SMS = ../../SMS/FS-750-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-750-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-750-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-750-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-750-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-750-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-750-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-750-HDS-020-SDS-010-SMS-010" = {
      id = "FS-750-HDS-020-SDS-010-SMS-010";
      traceId = "FS-750-HDS-020-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-750-HDS-020-SDS-010;
        SMS = ../../SMS/FS-750-HDS-020-SDS-010-SMS-010;
        SMT = ../FS-750-HDS-020-SDS-010-SMS-010;
        SIT = ../../SIT/FS-750-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-750-HDS-020-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-750-HDS-020-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-750-HDS-020-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-750-HDS-020-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-760-HDS-010-SDS-010-SMS-010" = {
      id = "FS-760-HDS-010-SDS-010-SMS-010";
      traceId = "FS-760-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-760-HDS-010-SDS-010;
        SMS = ../../SMS/FS-760-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-760-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-760-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-760-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-760-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-760-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-760-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-760-HDS-010-SDS-010-SMS-020" = {
      id = "FS-760-HDS-010-SDS-010-SMS-020";
      traceId = "FS-760-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-760-HDS-010-SDS-010;
        SMS = ../../SMS/FS-760-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-760-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-760-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-760-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-760-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-760-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-760-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-760-HDS-010-SDS-010-SMS-030" = {
      id = "FS-760-HDS-010-SDS-010-SMS-030";
      traceId = "FS-760-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-760-HDS-010-SDS-010;
        SMS = ../../SMS/FS-760-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-760-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-760-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-760-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-760-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-760-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-760-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-760-HDS-010-SDS-010-SMS-050" = {
      id = "FS-760-HDS-010-SDS-010-SMS-050";
      traceId = "FS-760-HDS-010-SDS-010-SMS-050";
      rowDirectories = {
        SDS = ../../SDS/FS-760-HDS-010-SDS-010;
        SMS = ../../SMS/FS-760-HDS-010-SDS-010-SMS-050;
        SMT = ../FS-760-HDS-010-SDS-010-SMS-050;
        SIT = ../../SIT/FS-760-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-760-HDS-010-SDS-010-SMS-050/intent.nix;
        expectedRelationIds = [ "FS-760-HDS-010-SDS-010-SMS-050__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-760-HDS-010-SDS-010-SMS-050.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-760-HDS-010-SDS-010-SMS-050 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-760-HDS-020-SDS-010-SMS-010" = {
      id = "FS-760-HDS-020-SDS-010-SMS-010";
      traceId = "FS-760-HDS-020-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-760-HDS-020-SDS-010;
        SMS = ../../SMS/FS-760-HDS-020-SDS-010-SMS-010;
        SMT = ../FS-760-HDS-020-SDS-010-SMS-010;
        SIT = ../../SIT/FS-760-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-760-HDS-020-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-760-HDS-020-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-760-HDS-020-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-760-HDS-020-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-760-HDS-030-SDS-010-SMS-010" = {
      id = "FS-760-HDS-030-SDS-010-SMS-010";
      traceId = "FS-760-HDS-030-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-760-HDS-030-SDS-010;
        SMS = ../../SMS/FS-760-HDS-030-SDS-010-SMS-010;
        SMT = ../FS-760-HDS-030-SDS-010-SMS-010;
        SIT = ../../SIT/FS-760-HDS-030-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-760-HDS-030-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-760-HDS-030-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-760-HDS-030-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-760-HDS-030-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-760-HDS-040-SDS-010-SMS-010" = {
      id = "FS-760-HDS-040-SDS-010-SMS-010";
      traceId = "FS-760-HDS-040-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-760-HDS-040-SDS-010;
        SMS = ../../SMS/FS-760-HDS-040-SDS-010-SMS-010;
        SMT = ../FS-760-HDS-040-SDS-010-SMS-010;
        SIT = ../../SIT/FS-760-HDS-040-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-760-HDS-040-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-760-HDS-040-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-760-HDS-040-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-760-HDS-040-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-770-HDS-010-SDS-010-SMS-010" = {
      id = "FS-770-HDS-010-SDS-010-SMS-010";
      traceId = "FS-770-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-770-HDS-010-SDS-010;
        SMS = ../../SMS/FS-770-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-770-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-770-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-770-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-770-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-770-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-770-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-770-HDS-010-SDS-010-SMS-020" = {
      id = "FS-770-HDS-010-SDS-010-SMS-020";
      traceId = "FS-770-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-770-HDS-010-SDS-010;
        SMS = ../../SMS/FS-770-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-770-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-770-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-770-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-770-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-770-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-770-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-770-HDS-010-SDS-010-SMS-030" = {
      id = "FS-770-HDS-010-SDS-010-SMS-030";
      traceId = "FS-770-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-770-HDS-010-SDS-010;
        SMS = ../../SMS/FS-770-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-770-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-770-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-770-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-770-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-770-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-770-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-770-HDS-010-SDS-020-SMS-010" = {
      id = "FS-770-HDS-010-SDS-020-SMS-010";
      traceId = "FS-770-HDS-010-SDS-020-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-770-HDS-010-SDS-020;
        SMS = ../../SMS/FS-770-HDS-010-SDS-020-SMS-010;
        SMT = ../FS-770-HDS-010-SDS-020-SMS-010;
        SIT = ../../SIT/FS-770-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-770-HDS-010-SDS-020-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-770-HDS-010-SDS-020-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-770-HDS-010-SDS-020-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-770-HDS-010-SDS-020-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-770-HDS-010-SDS-020-SMS-020" = {
      id = "FS-770-HDS-010-SDS-020-SMS-020";
      traceId = "FS-770-HDS-010-SDS-020-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-770-HDS-010-SDS-020;
        SMS = ../../SMS/FS-770-HDS-010-SDS-020-SMS-020;
        SMT = ../FS-770-HDS-010-SDS-020-SMS-020;
        SIT = ../../SIT/FS-770-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-770-HDS-010-SDS-020-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-770-HDS-010-SDS-020-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-770-HDS-010-SDS-020-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-770-HDS-010-SDS-020-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-770-HDS-010-SDS-020-SMS-030" = {
      id = "FS-770-HDS-010-SDS-020-SMS-030";
      traceId = "FS-770-HDS-010-SDS-020-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-770-HDS-010-SDS-020;
        SMS = ../../SMS/FS-770-HDS-010-SDS-020-SMS-030;
        SMT = ../FS-770-HDS-010-SDS-020-SMS-030;
        SIT = ../../SIT/FS-770-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-770-HDS-010-SDS-020-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-770-HDS-010-SDS-020-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-770-HDS-010-SDS-020-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-770-HDS-010-SDS-020-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-770-HDS-010-SDS-030-SMS-010" = {
      id = "FS-770-HDS-010-SDS-030-SMS-010";
      traceId = "FS-770-HDS-010-SDS-030-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-770-HDS-010-SDS-030;
        SMS = ../../SMS/FS-770-HDS-010-SDS-030-SMS-010;
        SMT = ../FS-770-HDS-010-SDS-030-SMS-010;
        SIT = ../../SIT/FS-770-HDS-010-SDS-030;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-770-HDS-010-SDS-030-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-770-HDS-010-SDS-030-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-770-HDS-010-SDS-030-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-770-HDS-010-SDS-030-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-770-HDS-010-SDS-030-SMS-020" = {
      id = "FS-770-HDS-010-SDS-030-SMS-020";
      traceId = "FS-770-HDS-010-SDS-030-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-770-HDS-010-SDS-030;
        SMS = ../../SMS/FS-770-HDS-010-SDS-030-SMS-020;
        SMT = ../FS-770-HDS-010-SDS-030-SMS-020;
        SIT = ../../SIT/FS-770-HDS-010-SDS-030;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-770-HDS-010-SDS-030-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-770-HDS-010-SDS-030-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-770-HDS-010-SDS-030-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-770-HDS-010-SDS-030-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-770-HDS-010-SDS-030-SMS-030" = {
      id = "FS-770-HDS-010-SDS-030-SMS-030";
      traceId = "FS-770-HDS-010-SDS-030-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-770-HDS-010-SDS-030;
        SMS = ../../SMS/FS-770-HDS-010-SDS-030-SMS-030;
        SMT = ../FS-770-HDS-010-SDS-030-SMS-030;
        SIT = ../../SIT/FS-770-HDS-010-SDS-030;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-770-HDS-010-SDS-030-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-770-HDS-010-SDS-030-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-770-HDS-010-SDS-030-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-770-HDS-010-SDS-030-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-770-HDS-020-SDS-010-SMS-010" = {
      id = "FS-770-HDS-020-SDS-010-SMS-010";
      traceId = "FS-770-HDS-020-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-770-HDS-020-SDS-010;
        SMS = ../../SMS/FS-770-HDS-020-SDS-010-SMS-010;
        SMT = ../FS-770-HDS-020-SDS-010-SMS-010;
        SIT = ../../SIT/FS-770-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-770-HDS-020-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-770-HDS-020-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-770-HDS-020-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-770-HDS-020-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-780-HDS-010-SDS-010-SMS-010" = {
      id = "FS-780-HDS-010-SDS-010-SMS-010";
      traceId = "FS-780-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-780-HDS-010-SDS-010;
        SMS = ../../SMS/FS-780-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-780-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-780-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-780-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-780-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-780-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-780-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-780-HDS-010-SDS-020-SMS-010" = {
      id = "FS-780-HDS-010-SDS-020-SMS-010";
      traceId = "FS-780-HDS-010-SDS-020-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-780-HDS-010-SDS-020;
        SMS = ../../SMS/FS-780-HDS-010-SDS-020-SMS-010;
        SMT = ../FS-780-HDS-010-SDS-020-SMS-010;
        SIT = ../../SIT/FS-780-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-780-HDS-010-SDS-020-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-780-HDS-010-SDS-020-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-780-HDS-010-SDS-020-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-780-HDS-010-SDS-020-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-780-HDS-010-SDS-020-SMS-020" = {
      id = "FS-780-HDS-010-SDS-020-SMS-020";
      traceId = "FS-780-HDS-010-SDS-020-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-780-HDS-010-SDS-020;
        SMS = ../../SMS/FS-780-HDS-010-SDS-020-SMS-020;
        SMT = ../FS-780-HDS-010-SDS-020-SMS-020;
        SIT = ../../SIT/FS-780-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-780-HDS-010-SDS-020-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-780-HDS-010-SDS-020-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-780-HDS-010-SDS-020-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-780-HDS-010-SDS-020-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-780-HDS-020-SDS-010-SMS-010" = {
      id = "FS-780-HDS-020-SDS-010-SMS-010";
      traceId = "FS-780-HDS-020-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-780-HDS-020-SDS-010;
        SMS = ../../SMS/FS-780-HDS-020-SDS-010-SMS-010;
        SMT = ../FS-780-HDS-020-SDS-010-SMS-010;
        SIT = ../../SIT/FS-780-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-780-HDS-020-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-780-HDS-020-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-780-HDS-020-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-780-HDS-020-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-790-HDS-010-SDS-010-SMS-010" = {
      id = "FS-790-HDS-010-SDS-010-SMS-010";
      traceId = "FS-790-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-790-HDS-010-SDS-010;
        SMS = ../../SMS/FS-790-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-790-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-790-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-790-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-790-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-790-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-790-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-790-HDS-010-SDS-010-SMS-020" = {
      id = "FS-790-HDS-010-SDS-010-SMS-020";
      traceId = "FS-790-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-790-HDS-010-SDS-010;
        SMS = ../../SMS/FS-790-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-790-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-790-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-790-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-790-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-790-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-790-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-790-HDS-010-SDS-010-SMS-030" = {
      id = "FS-790-HDS-010-SDS-010-SMS-030";
      traceId = "FS-790-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-790-HDS-010-SDS-010;
        SMS = ../../SMS/FS-790-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-790-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-790-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-790-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-790-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-790-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-790-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-790-HDS-020-SDS-010-SMS-010" = {
      id = "FS-790-HDS-020-SDS-010-SMS-010";
      traceId = "FS-790-HDS-020-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-790-HDS-020-SDS-010;
        SMS = ../../SMS/FS-790-HDS-020-SDS-010-SMS-010;
        SMT = ../FS-790-HDS-020-SDS-010-SMS-010;
        SIT = ../../SIT/FS-790-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-790-HDS-020-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-790-HDS-020-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-790-HDS-020-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-790-HDS-020-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-800-HDS-010-SDS-010-SMS-010" = {
      id = "FS-800-HDS-010-SDS-010-SMS-010";
      traceId = "FS-800-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-800-HDS-010-SDS-010;
        SMS = ../../SMS/FS-800-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-800-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-800-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-800-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-800-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-800-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-800-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-800-HDS-010-SDS-010-SMS-020" = {
      id = "FS-800-HDS-010-SDS-010-SMS-020";
      traceId = "FS-800-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-800-HDS-010-SDS-010;
        SMS = ../../SMS/FS-800-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-800-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-800-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-800-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-800-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-800-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-800-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-800-HDS-010-SDS-010-SMS-030" = {
      id = "FS-800-HDS-010-SDS-010-SMS-030";
      traceId = "FS-800-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-800-HDS-010-SDS-010;
        SMS = ../../SMS/FS-800-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-800-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-800-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-800-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-800-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-800-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-800-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-800-HDS-010-SDS-011-SMS-010" = {
      id = "FS-800-HDS-010-SDS-011-SMS-010";
      traceId = "FS-800-HDS-010-SDS-011-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-800-HDS-010-SDS-011;
        SMS = ../../SMS/FS-800-HDS-010-SDS-011-SMS-010;
        SMT = ../FS-800-HDS-010-SDS-011-SMS-010;
        SIT = ../../SIT/FS-800-HDS-010-SDS-011;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-800-HDS-010-SDS-011-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-800-HDS-010-SDS-011-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-800-HDS-010-SDS-011-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-800-HDS-010-SDS-011-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-800-HDS-010-SDS-012-SMS-010" = {
      id = "FS-800-HDS-010-SDS-012-SMS-010";
      traceId = "FS-800-HDS-010-SDS-012-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-800-HDS-010-SDS-012;
        SMS = ../../SMS/FS-800-HDS-010-SDS-012-SMS-010;
        SMT = ../FS-800-HDS-010-SDS-012-SMS-010;
        SIT = ../../SIT/FS-800-HDS-010-SDS-012;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-800-HDS-010-SDS-012-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-800-HDS-010-SDS-012-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-800-HDS-010-SDS-012-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-800-HDS-010-SDS-012-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-800-HDS-010-SDS-013-SMS-020" = {
      id = "FS-800-HDS-010-SDS-013-SMS-020";
      traceId = "FS-800-HDS-010-SDS-013-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-800-HDS-010-SDS-013;
        SMS = ../../SMS/FS-800-HDS-010-SDS-013-SMS-020;
        SMT = ../FS-800-HDS-010-SDS-013-SMS-020;
        SIT = ../../SIT/FS-800-HDS-010-SDS-013;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-800-HDS-010-SDS-013-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-800-HDS-010-SDS-013-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-800-HDS-010-SDS-013-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-800-HDS-010-SDS-013-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-800-HDS-010-SDS-020-SMS-010" = {
      id = "FS-800-HDS-010-SDS-020-SMS-010";
      traceId = "FS-800-HDS-010-SDS-020-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-800-HDS-010-SDS-020;
        SMS = ../../SMS/FS-800-HDS-010-SDS-020-SMS-010;
        SMT = ../FS-800-HDS-010-SDS-020-SMS-010;
        SIT = ../../SIT/FS-800-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-800-HDS-010-SDS-020-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-800-HDS-010-SDS-020-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-800-HDS-010-SDS-020-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-800-HDS-010-SDS-020-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-800-HDS-010-SDS-020-SMS-020" = {
      id = "FS-800-HDS-010-SDS-020-SMS-020";
      traceId = "FS-800-HDS-010-SDS-020-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-800-HDS-010-SDS-020;
        SMS = ../../SMS/FS-800-HDS-010-SDS-020-SMS-020;
        SMT = ../FS-800-HDS-010-SDS-020-SMS-020;
        SIT = ../../SIT/FS-800-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-800-HDS-010-SDS-020-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-800-HDS-010-SDS-020-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-800-HDS-010-SDS-020-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-800-HDS-010-SDS-020-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-800-HDS-010-SDS-020-SMS-030" = {
      id = "FS-800-HDS-010-SDS-020-SMS-030";
      traceId = "FS-800-HDS-010-SDS-020-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-800-HDS-010-SDS-020;
        SMS = ../../SMS/FS-800-HDS-010-SDS-020-SMS-030;
        SMT = ../FS-800-HDS-010-SDS-020-SMS-030;
        SIT = ../../SIT/FS-800-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-800-HDS-010-SDS-020-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-800-HDS-010-SDS-020-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-800-HDS-010-SDS-020-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-800-HDS-010-SDS-020-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-800-HDS-010-SDS-030-SMS-010" = {
      id = "FS-800-HDS-010-SDS-030-SMS-010";
      traceId = "FS-800-HDS-010-SDS-030-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-800-HDS-010-SDS-030;
        SMS = ../../SMS/FS-800-HDS-010-SDS-030-SMS-010;
        SMT = ../FS-800-HDS-010-SDS-030-SMS-010;
        SIT = ../../SIT/FS-800-HDS-010-SDS-030;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-800-HDS-010-SDS-030-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-800-HDS-010-SDS-030-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-800-HDS-010-SDS-030-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-800-HDS-010-SDS-030-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-800-HDS-010-SDS-030-SMS-020" = {
      id = "FS-800-HDS-010-SDS-030-SMS-020";
      traceId = "FS-800-HDS-010-SDS-030-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-800-HDS-010-SDS-030;
        SMS = ../../SMS/FS-800-HDS-010-SDS-030-SMS-020;
        SMT = ../FS-800-HDS-010-SDS-030-SMS-020;
        SIT = ../../SIT/FS-800-HDS-010-SDS-030;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-800-HDS-010-SDS-030-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-800-HDS-010-SDS-030-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-800-HDS-010-SDS-030-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-800-HDS-010-SDS-030-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-800-HDS-010-SDS-030-SMS-030" = {
      id = "FS-800-HDS-010-SDS-030-SMS-030";
      traceId = "FS-800-HDS-010-SDS-030-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-800-HDS-010-SDS-030;
        SMS = ../../SMS/FS-800-HDS-010-SDS-030-SMS-030;
        SMT = ../FS-800-HDS-010-SDS-030-SMS-030;
        SIT = ../../SIT/FS-800-HDS-010-SDS-030;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-800-HDS-010-SDS-030-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-800-HDS-010-SDS-030-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-800-HDS-010-SDS-030-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-800-HDS-010-SDS-030-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-800-HDS-020-SDS-021-SMS-010" = {
      id = "FS-800-HDS-020-SDS-021-SMS-010";
      traceId = "FS-800-HDS-020-SDS-021-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-800-HDS-020-SDS-021;
        SMS = ../../SMS/FS-800-HDS-020-SDS-021-SMS-010;
        SMT = ../FS-800-HDS-020-SDS-021-SMS-010;
        SIT = ../../SIT/FS-800-HDS-020-SDS-021;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-800-HDS-020-SDS-021-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-800-HDS-020-SDS-021-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-800-HDS-020-SDS-021-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-800-HDS-020-SDS-021-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-800-HDS-020-SDS-040-SMS-010" = {
      id = "FS-800-HDS-020-SDS-040-SMS-010";
      traceId = "FS-800-HDS-020-SDS-040-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-800-HDS-020-SDS-040;
        SMS = ../../SMS/FS-800-HDS-020-SDS-040-SMS-010;
        SMT = ../FS-800-HDS-020-SDS-040-SMS-010;
        SIT = ../../SIT/FS-800-HDS-020-SDS-040;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-800-HDS-020-SDS-040-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-800-HDS-020-SDS-040-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-800-HDS-020-SDS-040-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-800-HDS-020-SDS-040-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-800-HDS-030-SDS-010-SMS-010" = {
      id = "FS-800-HDS-030-SDS-010-SMS-010";
      traceId = "FS-800-HDS-030-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-800-HDS-030-SDS-010;
        SMS = ../../SMS/FS-800-HDS-030-SDS-010-SMS-010;
        SMT = ../FS-800-HDS-030-SDS-010-SMS-010;
        SIT = ../../SIT/FS-800-HDS-030-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-800-HDS-030-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-800-HDS-030-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-800-HDS-030-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-800-HDS-030-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-800-HDS-030-SDS-020-SMS-010" = {
      id = "FS-800-HDS-030-SDS-020-SMS-010";
      traceId = "FS-800-HDS-030-SDS-020-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-800-HDS-030-SDS-020;
        SMS = ../../SMS/FS-800-HDS-030-SDS-020-SMS-010;
        SMT = ../FS-800-HDS-030-SDS-020-SMS-010;
        SIT = ../../SIT/FS-800-HDS-030-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-800-HDS-030-SDS-020-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-800-HDS-030-SDS-020-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-800-HDS-030-SDS-020-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-800-HDS-030-SDS-020-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-800-HDS-030-SDS-030-SMS-040" = {
      id = "FS-800-HDS-030-SDS-030-SMS-040";
      traceId = "FS-800-HDS-030-SDS-030-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-800-HDS-030-SDS-030;
        SMS = ../../SMS/FS-800-HDS-030-SDS-030-SMS-040;
        SMT = ../FS-800-HDS-030-SDS-030-SMS-040;
        SIT = ../../SIT/FS-800-HDS-030-SDS-030;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-800-HDS-030-SDS-030-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-800-HDS-030-SDS-030-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-800-HDS-030-SDS-030-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-800-HDS-030-SDS-030-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-810-HDS-010-SDS-010-SMS-010" = {
      id = "FS-810-HDS-010-SDS-010-SMS-010";
      traceId = "FS-810-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-810-HDS-010-SDS-010;
        SMS = ../../SMS/FS-810-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-810-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-810-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-810-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-810-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-810-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-810-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-810-HDS-010-SDS-010-SMS-020" = {
      id = "FS-810-HDS-010-SDS-010-SMS-020";
      traceId = "FS-810-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-810-HDS-010-SDS-010;
        SMS = ../../SMS/FS-810-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-810-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-810-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-810-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-810-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-810-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-810-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-810-HDS-010-SDS-010-SMS-030" = {
      id = "FS-810-HDS-010-SDS-010-SMS-030";
      traceId = "FS-810-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-810-HDS-010-SDS-010;
        SMS = ../../SMS/FS-810-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-810-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-810-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-810-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-810-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-810-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-810-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-820-HDS-010-SDS-010-SMS-010" = {
      id = "FS-820-HDS-010-SDS-010-SMS-010";
      traceId = "FS-820-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-820-HDS-010-SDS-010;
        SMS = ../../SMS/FS-820-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-820-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-820-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-820-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-820-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-820-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-820-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-820-HDS-010-SDS-010-SMS-020" = {
      id = "FS-820-HDS-010-SDS-010-SMS-020";
      traceId = "FS-820-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-820-HDS-010-SDS-010;
        SMS = ../../SMS/FS-820-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-820-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-820-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-820-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-820-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-820-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-820-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-820-HDS-010-SDS-010-SMS-030" = {
      id = "FS-820-HDS-010-SDS-010-SMS-030";
      traceId = "FS-820-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-820-HDS-010-SDS-010;
        SMS = ../../SMS/FS-820-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-820-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-820-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-820-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-820-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-820-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-820-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-820-HDS-010-SDS-010-SMS-050" = {
      id = "FS-820-HDS-010-SDS-010-SMS-050";
      traceId = "FS-820-HDS-010-SDS-010-SMS-050";
      rowDirectories = {
        SDS = ../../SDS/FS-820-HDS-010-SDS-010;
        SMS = ../../SMS/FS-820-HDS-010-SDS-010-SMS-050;
        SMT = ../FS-820-HDS-010-SDS-010-SMS-050;
        SIT = ../../SIT/FS-820-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-820-HDS-010-SDS-010-SMS-050/intent.nix;
        expectedRelationIds = [ "FS-820-HDS-010-SDS-010-SMS-050__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-820-HDS-010-SDS-010-SMS-050.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-820-HDS-010-SDS-010-SMS-050 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-820-HDS-010-SDS-010-SMS-060" = {
      id = "FS-820-HDS-010-SDS-010-SMS-060";
      traceId = "FS-820-HDS-010-SDS-010-SMS-060";
      rowDirectories = {
        SDS = ../../SDS/FS-820-HDS-010-SDS-010;
        SMS = ../../SMS/FS-820-HDS-010-SDS-010-SMS-060;
        SMT = ../FS-820-HDS-010-SDS-010-SMS-060;
        SIT = ../../SIT/FS-820-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-820-HDS-010-SDS-010-SMS-060/intent.nix;
        expectedRelationIds = [ "FS-820-HDS-010-SDS-010-SMS-060__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-820-HDS-010-SDS-010-SMS-060.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-820-HDS-010-SDS-010-SMS-060 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-830-HDS-010-SDS-010-SMS-010" = {
      id = "FS-830-HDS-010-SDS-010-SMS-010";
      traceId = "FS-830-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-830-HDS-010-SDS-010;
        SMS = ../../SMS/FS-830-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-830-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-830-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-830-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-830-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-830-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-830-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-830-HDS-010-SDS-010-SMS-020" = {
      id = "FS-830-HDS-010-SDS-010-SMS-020";
      traceId = "FS-830-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-830-HDS-010-SDS-010;
        SMS = ../../SMS/FS-830-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-830-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-830-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-830-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-830-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-830-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-830-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-830-HDS-010-SDS-010-SMS-030" = {
      id = "FS-830-HDS-010-SDS-010-SMS-030";
      traceId = "FS-830-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-830-HDS-010-SDS-010;
        SMS = ../../SMS/FS-830-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-830-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-830-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-830-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-830-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-830-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-830-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-840-HDS-010-SDS-010-SMS-010" = {
      id = "FS-840-HDS-010-SDS-010-SMS-010";
      traceId = "FS-840-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-840-HDS-010-SDS-010;
        SMS = ../../SMS/FS-840-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-840-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-840-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-840-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-840-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-840-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-840-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-840-HDS-010-SDS-010-SMS-020" = {
      id = "FS-840-HDS-010-SDS-010-SMS-020";
      traceId = "FS-840-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-840-HDS-010-SDS-010;
        SMS = ../../SMS/FS-840-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-840-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-840-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-840-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-840-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-840-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-840-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-840-HDS-010-SDS-010-SMS-030" = {
      id = "FS-840-HDS-010-SDS-010-SMS-030";
      traceId = "FS-840-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-840-HDS-010-SDS-010;
        SMS = ../../SMS/FS-840-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-840-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-840-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-840-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-840-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-840-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-840-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-850-HDS-010-SDS-010-SMS-010" = {
      id = "FS-850-HDS-010-SDS-010-SMS-010";
      traceId = "FS-850-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-850-HDS-010-SDS-010;
        SMS = ../../SMS/FS-850-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-850-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-850-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-850-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-850-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-850-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-850-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-850-HDS-010-SDS-010-SMS-020" = {
      id = "FS-850-HDS-010-SDS-010-SMS-020";
      traceId = "FS-850-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-850-HDS-010-SDS-010;
        SMS = ../../SMS/FS-850-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-850-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-850-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-850-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-850-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-850-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-850-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-850-HDS-010-SDS-010-SMS-030" = {
      id = "FS-850-HDS-010-SDS-010-SMS-030";
      traceId = "FS-850-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-850-HDS-010-SDS-010;
        SMS = ../../SMS/FS-850-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-850-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-850-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-850-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-850-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-850-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-850-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-860-HDS-010-SDS-010-SMS-010" = {
      id = "FS-860-HDS-010-SDS-010-SMS-010";
      traceId = "FS-860-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-860-HDS-010-SDS-010;
        SMS = ../../SMS/FS-860-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-860-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-860-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-860-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-860-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-860-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-860-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-860-HDS-010-SDS-010-SMS-020" = {
      id = "FS-860-HDS-010-SDS-010-SMS-020";
      traceId = "FS-860-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-860-HDS-010-SDS-010;
        SMS = ../../SMS/FS-860-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-860-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-860-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-860-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-860-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-860-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-860-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-860-HDS-010-SDS-010-SMS-030" = {
      id = "FS-860-HDS-010-SDS-010-SMS-030";
      traceId = "FS-860-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-860-HDS-010-SDS-010;
        SMS = ../../SMS/FS-860-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-860-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-860-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-860-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-860-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-860-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-860-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-870-HDS-010-SDS-010-SMS-010" = {
      id = "FS-870-HDS-010-SDS-010-SMS-010";
      traceId = "FS-870-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-870-HDS-010-SDS-010;
        SMS = ../../SMS/FS-870-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-870-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-870-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-870-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-870-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-870-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-870-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-870-HDS-010-SDS-010-SMS-020" = {
      id = "FS-870-HDS-010-SDS-010-SMS-020";
      traceId = "FS-870-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-870-HDS-010-SDS-010;
        SMS = ../../SMS/FS-870-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-870-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-870-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-870-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-870-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-870-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-870-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-870-HDS-010-SDS-010-SMS-030" = {
      id = "FS-870-HDS-010-SDS-010-SMS-030";
      traceId = "FS-870-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-870-HDS-010-SDS-010;
        SMS = ../../SMS/FS-870-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-870-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-870-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-870-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-870-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-870-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-870-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-880-HDS-010-SDS-010-SMS-010" = {
      id = "FS-880-HDS-010-SDS-010-SMS-010";
      traceId = "FS-880-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-880-HDS-010-SDS-010;
        SMS = ../../SMS/FS-880-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-880-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-880-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-880-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-880-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-880-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-880-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-880-HDS-010-SDS-010-SMS-020" = {
      id = "FS-880-HDS-010-SDS-010-SMS-020";
      traceId = "FS-880-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-880-HDS-010-SDS-010;
        SMS = ../../SMS/FS-880-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-880-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-880-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-880-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-880-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-880-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-880-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-880-HDS-010-SDS-010-SMS-030" = {
      id = "FS-880-HDS-010-SDS-010-SMS-030";
      traceId = "FS-880-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-880-HDS-010-SDS-010;
        SMS = ../../SMS/FS-880-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-880-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-880-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-880-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-880-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-880-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-880-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-890-HDS-010-SDS-010-SMS-010" = {
      id = "FS-890-HDS-010-SDS-010-SMS-010";
      traceId = "FS-890-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-890-HDS-010-SDS-010;
        SMS = ../../SMS/FS-890-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-890-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-890-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-890-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-890-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-890-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-890-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-890-HDS-010-SDS-010-SMS-020" = {
      id = "FS-890-HDS-010-SDS-010-SMS-020";
      traceId = "FS-890-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-890-HDS-010-SDS-010;
        SMS = ../../SMS/FS-890-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-890-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-890-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-890-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-890-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-890-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-890-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-890-HDS-010-SDS-010-SMS-030" = {
      id = "FS-890-HDS-010-SDS-010-SMS-030";
      traceId = "FS-890-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-890-HDS-010-SDS-010;
        SMS = ../../SMS/FS-890-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-890-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-890-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-890-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-890-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-890-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-890-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-900-HDS-010-SDS-010-SMS-010" = {
      id = "FS-900-HDS-010-SDS-010-SMS-010";
      traceId = "FS-900-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-900-HDS-010-SDS-010;
        SMS = ../../SMS/FS-900-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-900-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-900-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-900-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-900-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-900-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-900-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-900-HDS-010-SDS-010-SMS-020" = {
      id = "FS-900-HDS-010-SDS-010-SMS-020";
      traceId = "FS-900-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-900-HDS-010-SDS-010;
        SMS = ../../SMS/FS-900-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-900-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-900-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-900-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-900-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-900-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-900-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-900-HDS-010-SDS-010-SMS-030" = {
      id = "FS-900-HDS-010-SDS-010-SMS-030";
      traceId = "FS-900-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-900-HDS-010-SDS-010;
        SMS = ../../SMS/FS-900-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-900-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-900-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-900-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-900-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-900-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-900-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-910-HDS-010-SDS-010-SMS-010" = {
      id = "FS-910-HDS-010-SDS-010-SMS-010";
      traceId = "FS-910-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-910-HDS-010-SDS-010;
        SMS = ../../SMS/FS-910-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-910-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-910-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-910-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-910-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-910-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-910-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-910-HDS-010-SDS-010-SMS-020" = {
      id = "FS-910-HDS-010-SDS-010-SMS-020";
      traceId = "FS-910-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-910-HDS-010-SDS-010;
        SMS = ../../SMS/FS-910-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-910-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-910-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-910-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-910-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-910-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-910-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-910-HDS-010-SDS-010-SMS-030" = {
      id = "FS-910-HDS-010-SDS-010-SMS-030";
      traceId = "FS-910-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-910-HDS-010-SDS-010;
        SMS = ../../SMS/FS-910-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-910-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-910-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-910-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-910-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-910-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-910-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-920-HDS-010-SDS-010-SMS-010" = {
      id = "FS-920-HDS-010-SDS-010-SMS-010";
      traceId = "FS-920-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-920-HDS-010-SDS-010;
        SMS = ../../SMS/FS-920-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-920-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-920-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-920-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-920-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-920-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-920-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-920-HDS-010-SDS-010-SMS-020" = {
      id = "FS-920-HDS-010-SDS-010-SMS-020";
      traceId = "FS-920-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-920-HDS-010-SDS-010;
        SMS = ../../SMS/FS-920-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-920-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-920-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-920-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-920-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-920-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-920-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-920-HDS-010-SDS-010-SMS-030" = {
      id = "FS-920-HDS-010-SDS-010-SMS-030";
      traceId = "FS-920-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-920-HDS-010-SDS-010;
        SMS = ../../SMS/FS-920-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-920-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-920-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-920-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-920-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-920-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-920-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-930-HDS-010-SDS-010-SMS-010" = {
      id = "FS-930-HDS-010-SDS-010-SMS-010";
      traceId = "FS-930-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-930-HDS-010-SDS-010;
        SMS = ../../SMS/FS-930-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-930-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-930-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-930-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-930-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-930-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-930-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-930-HDS-010-SDS-010-SMS-020" = {
      id = "FS-930-HDS-010-SDS-010-SMS-020";
      traceId = "FS-930-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-930-HDS-010-SDS-010;
        SMS = ../../SMS/FS-930-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-930-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-930-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-930-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-930-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-930-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-930-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-930-HDS-010-SDS-010-SMS-030" = {
      id = "FS-930-HDS-010-SDS-010-SMS-030";
      traceId = "FS-930-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-930-HDS-010-SDS-010;
        SMS = ../../SMS/FS-930-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-930-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-930-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-930-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-930-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-930-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-930-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-940-HDS-010-SDS-010-SMS-010" = {
      id = "FS-940-HDS-010-SDS-010-SMS-010";
      traceId = "FS-940-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-940-HDS-010-SDS-010;
        SMS = ../../SMS/FS-940-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-940-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-940-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-940-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-940-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-940-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-940-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-940-HDS-010-SDS-010-SMS-020" = {
      id = "FS-940-HDS-010-SDS-010-SMS-020";
      traceId = "FS-940-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-940-HDS-010-SDS-010;
        SMS = ../../SMS/FS-940-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-940-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-940-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-940-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-940-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-940-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-940-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-940-HDS-010-SDS-010-SMS-030" = {
      id = "FS-940-HDS-010-SDS-010-SMS-030";
      traceId = "FS-940-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-940-HDS-010-SDS-010;
        SMS = ../../SMS/FS-940-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-940-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-940-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-940-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-940-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-940-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-940-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-940-HDS-010-SDS-010-SMS-050" = {
      id = "FS-940-HDS-010-SDS-010-SMS-050";
      traceId = "FS-940-HDS-010-SDS-010-SMS-050";
      rowDirectories = {
        SDS = ../../SDS/FS-940-HDS-010-SDS-010;
        SMS = ../../SMS/FS-940-HDS-010-SDS-010-SMS-050;
        SMT = ../FS-940-HDS-010-SDS-010-SMS-050;
        SIT = ../../SIT/FS-940-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-940-HDS-010-SDS-010-SMS-050/intent.nix;
        expectedRelationIds = [ "FS-940-HDS-010-SDS-010-SMS-050__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-940-HDS-010-SDS-010-SMS-050.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-940-HDS-010-SDS-010-SMS-050 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-940-HDS-010-SDS-010-SMS-060" = {
      id = "FS-940-HDS-010-SDS-010-SMS-060";
      traceId = "FS-940-HDS-010-SDS-010-SMS-060";
      rowDirectories = {
        SDS = ../../SDS/FS-940-HDS-010-SDS-010;
        SMS = ../../SMS/FS-940-HDS-010-SDS-010-SMS-060;
        SMT = ../FS-940-HDS-010-SDS-010-SMS-060;
        SIT = ../../SIT/FS-940-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-940-HDS-010-SDS-010-SMS-060/intent.nix;
        expectedRelationIds = [ "FS-940-HDS-010-SDS-010-SMS-060__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-940-HDS-010-SDS-010-SMS-060.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-940-HDS-010-SDS-010-SMS-060 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-940-HDS-010-SDS-010-SMS-070" = {
      id = "FS-940-HDS-010-SDS-010-SMS-070";
      traceId = "FS-940-HDS-010-SDS-010-SMS-070";
      rowDirectories = {
        SDS = ../../SDS/FS-940-HDS-010-SDS-010;
        SMS = ../../SMS/FS-940-HDS-010-SDS-010-SMS-070;
        SMT = ../FS-940-HDS-010-SDS-010-SMS-070;
        SIT = ../../SIT/FS-940-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-940-HDS-010-SDS-010-SMS-070/intent.nix;
        expectedRelationIds = [ "FS-940-HDS-010-SDS-010-SMS-070__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-940-HDS-010-SDS-010-SMS-070.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-940-HDS-010-SDS-010-SMS-070 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-940-HDS-010-SDS-020-SMS-010" = {
      id = "FS-940-HDS-010-SDS-020-SMS-010";
      traceId = "FS-940-HDS-010-SDS-020-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-940-HDS-010-SDS-020;
        SMS = ../../SMS/FS-940-HDS-010-SDS-020-SMS-010;
        SMT = ../FS-940-HDS-010-SDS-020-SMS-010;
        SIT = ../../SIT/FS-940-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-940-HDS-010-SDS-020-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-940-HDS-010-SDS-020-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-940-HDS-010-SDS-020-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-940-HDS-010-SDS-020-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-940-HDS-010-SDS-020-SMS-020" = {
      id = "FS-940-HDS-010-SDS-020-SMS-020";
      traceId = "FS-940-HDS-010-SDS-020-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-940-HDS-010-SDS-020;
        SMS = ../../SMS/FS-940-HDS-010-SDS-020-SMS-020;
        SMT = ../FS-940-HDS-010-SDS-020-SMS-020;
        SIT = ../../SIT/FS-940-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-940-HDS-010-SDS-020-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-940-HDS-010-SDS-020-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-940-HDS-010-SDS-020-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-940-HDS-010-SDS-020-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-940-HDS-010-SDS-020-SMS-030" = {
      id = "FS-940-HDS-010-SDS-020-SMS-030";
      traceId = "FS-940-HDS-010-SDS-020-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-940-HDS-010-SDS-020;
        SMS = ../../SMS/FS-940-HDS-010-SDS-020-SMS-030;
        SMT = ../FS-940-HDS-010-SDS-020-SMS-030;
        SIT = ../../SIT/FS-940-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-940-HDS-010-SDS-020-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-940-HDS-010-SDS-020-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-940-HDS-010-SDS-020-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-940-HDS-010-SDS-020-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-940-HDS-010-SDS-020-SMS-050" = {
      id = "FS-940-HDS-010-SDS-020-SMS-050";
      traceId = "FS-940-HDS-010-SDS-020-SMS-050";
      rowDirectories = {
        SDS = ../../SDS/FS-940-HDS-010-SDS-020;
        SMS = ../../SMS/FS-940-HDS-010-SDS-020-SMS-050;
        SMT = ../FS-940-HDS-010-SDS-020-SMS-050;
        SIT = ../../SIT/FS-940-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-940-HDS-010-SDS-020-SMS-050/intent.nix;
        expectedRelationIds = [ "FS-940-HDS-010-SDS-020-SMS-050__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-940-HDS-010-SDS-020-SMS-050.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-940-HDS-010-SDS-020-SMS-050 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-940-HDS-010-SDS-020-SMS-060" = {
      id = "FS-940-HDS-010-SDS-020-SMS-060";
      traceId = "FS-940-HDS-010-SDS-020-SMS-060";
      rowDirectories = {
        SDS = ../../SDS/FS-940-HDS-010-SDS-020;
        SMS = ../../SMS/FS-940-HDS-010-SDS-020-SMS-060;
        SMT = ../FS-940-HDS-010-SDS-020-SMS-060;
        SIT = ../../SIT/FS-940-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-940-HDS-010-SDS-020-SMS-060/intent.nix;
        expectedRelationIds = [ "FS-940-HDS-010-SDS-020-SMS-060__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-940-HDS-010-SDS-020-SMS-060.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-940-HDS-010-SDS-020-SMS-060 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-940-HDS-010-SDS-020-SMS-070" = {
      id = "FS-940-HDS-010-SDS-020-SMS-070";
      traceId = "FS-940-HDS-010-SDS-020-SMS-070";
      rowDirectories = {
        SDS = ../../SDS/FS-940-HDS-010-SDS-020;
        SMS = ../../SMS/FS-940-HDS-010-SDS-020-SMS-070;
        SMT = ../FS-940-HDS-010-SDS-020-SMS-070;
        SIT = ../../SIT/FS-940-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-940-HDS-010-SDS-020-SMS-070/intent.nix;
        expectedRelationIds = [ "FS-940-HDS-010-SDS-020-SMS-070__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-940-HDS-010-SDS-020-SMS-070.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-940-HDS-010-SDS-020-SMS-070 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-940-HDS-010-SDS-020-SMS-080" = {
      id = "FS-940-HDS-010-SDS-020-SMS-080";
      traceId = "FS-940-HDS-010-SDS-020-SMS-080";
      rowDirectories = {
        SDS = ../../SDS/FS-940-HDS-010-SDS-020;
        SMS = ../../SMS/FS-940-HDS-010-SDS-020-SMS-080;
        SMT = ../FS-940-HDS-010-SDS-020-SMS-080;
        SIT = ../../SIT/FS-940-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-940-HDS-010-SDS-020-SMS-080/intent.nix;
        expectedRelationIds = [ "FS-940-HDS-010-SDS-020-SMS-080__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-940-HDS-010-SDS-020-SMS-080.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-940-HDS-010-SDS-020-SMS-080 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-950-HDS-010-SDS-010-SMS-010" = {
      id = "FS-950-HDS-010-SDS-010-SMS-010";
      traceId = "FS-950-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-950-HDS-010-SDS-010;
        SMS = ../../SMS/FS-950-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-950-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-950-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-950-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-950-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-950-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-950-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-950-HDS-010-SDS-010-SMS-020" = {
      id = "FS-950-HDS-010-SDS-010-SMS-020";
      traceId = "FS-950-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-950-HDS-010-SDS-010;
        SMS = ../../SMS/FS-950-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-950-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-950-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-950-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-950-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-950-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-950-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-950-HDS-010-SDS-010-SMS-030" = {
      id = "FS-950-HDS-010-SDS-010-SMS-030";
      traceId = "FS-950-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-950-HDS-010-SDS-010;
        SMS = ../../SMS/FS-950-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-950-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-950-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-950-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-950-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-950-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-950-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-960-HDS-010-SDS-010-SMS-010" = {
      id = "FS-960-HDS-010-SDS-010-SMS-010";
      traceId = "FS-960-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-960-HDS-010-SDS-010;
        SMS = ../../SMS/FS-960-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-960-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-960-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-960-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-960-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-960-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-960-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-960-HDS-010-SDS-010-SMS-020" = {
      id = "FS-960-HDS-010-SDS-010-SMS-020";
      traceId = "FS-960-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-960-HDS-010-SDS-010;
        SMS = ../../SMS/FS-960-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-960-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-960-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-960-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-960-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-960-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-960-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-960-HDS-010-SDS-010-SMS-030" = {
      id = "FS-960-HDS-010-SDS-010-SMS-030";
      traceId = "FS-960-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-960-HDS-010-SDS-010;
        SMS = ../../SMS/FS-960-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-960-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-960-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-960-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-960-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-960-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-960-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-960-HDS-010-SDS-010-SMS-050" = {
      id = "FS-960-HDS-010-SDS-010-SMS-050";
      traceId = "FS-960-HDS-010-SDS-010-SMS-050";
      rowDirectories = {
        SDS = ../../SDS/FS-960-HDS-010-SDS-010;
        SMS = ../../SMS/FS-960-HDS-010-SDS-010-SMS-050;
        SMT = ../FS-960-HDS-010-SDS-010-SMS-050;
        SIT = ../../SIT/FS-960-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-960-HDS-010-SDS-010-SMS-050/intent.nix;
        expectedRelationIds = [ "FS-960-HDS-010-SDS-010-SMS-050__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-960-HDS-010-SDS-010-SMS-050.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-960-HDS-010-SDS-010-SMS-050 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-960-HDS-010-SDS-010-SMS-060" = {
      id = "FS-960-HDS-010-SDS-010-SMS-060";
      traceId = "FS-960-HDS-010-SDS-010-SMS-060";
      rowDirectories = {
        SDS = ../../SDS/FS-960-HDS-010-SDS-010;
        SMS = ../../SMS/FS-960-HDS-010-SDS-010-SMS-060;
        SMT = ../FS-960-HDS-010-SDS-010-SMS-060;
        SIT = ../../SIT/FS-960-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-960-HDS-010-SDS-010-SMS-060/intent.nix;
        expectedRelationIds = [ "FS-960-HDS-010-SDS-010-SMS-060__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-960-HDS-010-SDS-010-SMS-060.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-960-HDS-010-SDS-010-SMS-060 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-960-HDS-010-SDS-010-SMS-070" = {
      id = "FS-960-HDS-010-SDS-010-SMS-070";
      traceId = "FS-960-HDS-010-SDS-010-SMS-070";
      rowDirectories = {
        SDS = ../../SDS/FS-960-HDS-010-SDS-010;
        SMS = ../../SMS/FS-960-HDS-010-SDS-010-SMS-070;
        SMT = ../FS-960-HDS-010-SDS-010-SMS-070;
        SIT = ../../SIT/FS-960-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-960-HDS-010-SDS-010-SMS-070/intent.nix;
        expectedRelationIds = [ "FS-960-HDS-010-SDS-010-SMS-070__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-960-HDS-010-SDS-010-SMS-070.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-960-HDS-010-SDS-010-SMS-070 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-960-HDS-010-SDS-010-SMS-080" = {
      id = "FS-960-HDS-010-SDS-010-SMS-080";
      traceId = "FS-960-HDS-010-SDS-010-SMS-080";
      rowDirectories = {
        SDS = ../../SDS/FS-960-HDS-010-SDS-010;
        SMS = ../../SMS/FS-960-HDS-010-SDS-010-SMS-080;
        SMT = ../FS-960-HDS-010-SDS-010-SMS-080;
        SIT = ../../SIT/FS-960-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-960-HDS-010-SDS-010-SMS-080/intent.nix;
        expectedRelationIds = [ "FS-960-HDS-010-SDS-010-SMS-080__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-960-HDS-010-SDS-010-SMS-080.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-960-HDS-010-SDS-010-SMS-080 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-960-HDS-010-SDS-010-SMS-090" = {
      id = "FS-960-HDS-010-SDS-010-SMS-090";
      traceId = "FS-960-HDS-010-SDS-010-SMS-090";
      rowDirectories = {
        SDS = ../../SDS/FS-960-HDS-010-SDS-010;
        SMS = ../../SMS/FS-960-HDS-010-SDS-010-SMS-090;
        SMT = ../FS-960-HDS-010-SDS-010-SMS-090;
        SIT = ../../SIT/FS-960-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-960-HDS-010-SDS-010-SMS-090/intent.nix;
        expectedRelationIds = [ "FS-960-HDS-010-SDS-010-SMS-090__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-960-HDS-010-SDS-010-SMS-090.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-960-HDS-010-SDS-010-SMS-090 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-960-HDS-010-SDS-011-SMS-010" = {
      id = "FS-960-HDS-010-SDS-011-SMS-010";
      traceId = "FS-960-HDS-010-SDS-011-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-960-HDS-010-SDS-011;
        SMS = ../../SMS/FS-960-HDS-010-SDS-011-SMS-010;
        SMT = ../FS-960-HDS-010-SDS-011-SMS-010;
        SIT = ../../SIT/FS-960-HDS-010-SDS-011;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-960-HDS-010-SDS-011-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-960-HDS-010-SDS-011-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-960-HDS-010-SDS-011-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-960-HDS-010-SDS-011-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-960-HDS-010-SDS-012-SMS-010" = {
      id = "FS-960-HDS-010-SDS-012-SMS-010";
      traceId = "FS-960-HDS-010-SDS-012-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-960-HDS-010-SDS-012;
        SMS = ../../SMS/FS-960-HDS-010-SDS-012-SMS-010;
        SMT = ../FS-960-HDS-010-SDS-012-SMS-010;
        SIT = ../../SIT/FS-960-HDS-010-SDS-012;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-960-HDS-010-SDS-012-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-960-HDS-010-SDS-012-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-960-HDS-010-SDS-012-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-960-HDS-010-SDS-012-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-960-HDS-010-SDS-013-SMS-010" = {
      id = "FS-960-HDS-010-SDS-013-SMS-010";
      traceId = "FS-960-HDS-010-SDS-013-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-960-HDS-010-SDS-013;
        SMS = ../../SMS/FS-960-HDS-010-SDS-013-SMS-010;
        SMT = ../FS-960-HDS-010-SDS-013-SMS-010;
        SIT = ../../SIT/FS-960-HDS-010-SDS-013;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-960-HDS-010-SDS-013-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-960-HDS-010-SDS-013-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-960-HDS-010-SDS-013-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-960-HDS-010-SDS-013-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-960-HDS-010-SDS-014-SMS-010" = {
      id = "FS-960-HDS-010-SDS-014-SMS-010";
      traceId = "FS-960-HDS-010-SDS-014-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-960-HDS-010-SDS-014;
        SMS = ../../SMS/FS-960-HDS-010-SDS-014-SMS-010;
        SMT = ../FS-960-HDS-010-SDS-014-SMS-010;
        SIT = ../../SIT/FS-960-HDS-010-SDS-014;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-960-HDS-010-SDS-014-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-960-HDS-010-SDS-014-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-960-HDS-010-SDS-014-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-960-HDS-010-SDS-014-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-960-HDS-010-SDS-015-SMS-010" = {
      id = "FS-960-HDS-010-SDS-015-SMS-010";
      traceId = "FS-960-HDS-010-SDS-015-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-960-HDS-010-SDS-015;
        SMS = ../../SMS/FS-960-HDS-010-SDS-015-SMS-010;
        SMT = ../FS-960-HDS-010-SDS-015-SMS-010;
        SIT = ../../SIT/FS-960-HDS-010-SDS-015;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-960-HDS-010-SDS-015-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-960-HDS-010-SDS-015-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-960-HDS-010-SDS-015-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-960-HDS-010-SDS-015-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-960-HDS-010-SDS-016-SMS-010" = {
      id = "FS-960-HDS-010-SDS-016-SMS-010";
      traceId = "FS-960-HDS-010-SDS-016-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-960-HDS-010-SDS-016;
        SMS = ../../SMS/FS-960-HDS-010-SDS-016-SMS-010;
        SMT = ../FS-960-HDS-010-SDS-016-SMS-010;
        SIT = ../../SIT/FS-960-HDS-010-SDS-016;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-960-HDS-010-SDS-016-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-960-HDS-010-SDS-016-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-960-HDS-010-SDS-016-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-960-HDS-010-SDS-016-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-960-HDS-010-SDS-016-SMS-020" = {
      id = "FS-960-HDS-010-SDS-016-SMS-020";
      traceId = "FS-960-HDS-010-SDS-016-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-960-HDS-010-SDS-016;
        SMS = ../../SMS/FS-960-HDS-010-SDS-016-SMS-020;
        SMT = ../FS-960-HDS-010-SDS-016-SMS-020;
        SIT = ../../SIT/FS-960-HDS-010-SDS-016;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-960-HDS-010-SDS-016-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-960-HDS-010-SDS-016-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-960-HDS-010-SDS-016-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-960-HDS-010-SDS-016-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-960-HDS-010-SDS-016-SMS-030" = {
      id = "FS-960-HDS-010-SDS-016-SMS-030";
      traceId = "FS-960-HDS-010-SDS-016-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-960-HDS-010-SDS-016;
        SMS = ../../SMS/FS-960-HDS-010-SDS-016-SMS-030;
        SMT = ../FS-960-HDS-010-SDS-016-SMS-030;
        SIT = ../../SIT/FS-960-HDS-010-SDS-016;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-960-HDS-010-SDS-016-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-960-HDS-010-SDS-016-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-960-HDS-010-SDS-016-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-960-HDS-010-SDS-016-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-960-HDS-010-SDS-016-SMS-050" = {
      id = "FS-960-HDS-010-SDS-016-SMS-050";
      traceId = "FS-960-HDS-010-SDS-016-SMS-050";
      rowDirectories = {
        SDS = ../../SDS/FS-960-HDS-010-SDS-016;
        SMS = ../../SMS/FS-960-HDS-010-SDS-016-SMS-050;
        SMT = ../FS-960-HDS-010-SDS-016-SMS-050;
        SIT = ../../SIT/FS-960-HDS-010-SDS-016;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-960-HDS-010-SDS-016-SMS-050/intent.nix;
        expectedRelationIds = [ "FS-960-HDS-010-SDS-016-SMS-050__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-960-HDS-010-SDS-016-SMS-050.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-960-HDS-010-SDS-016-SMS-050 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-960-HDS-010-SDS-016-SMS-060" = {
      id = "FS-960-HDS-010-SDS-016-SMS-060";
      traceId = "FS-960-HDS-010-SDS-016-SMS-060";
      rowDirectories = {
        SDS = ../../SDS/FS-960-HDS-010-SDS-016;
        SMS = ../../SMS/FS-960-HDS-010-SDS-016-SMS-060;
        SMT = ../FS-960-HDS-010-SDS-016-SMS-060;
        SIT = ../../SIT/FS-960-HDS-010-SDS-016;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-960-HDS-010-SDS-016-SMS-060/intent.nix;
        expectedRelationIds = [ "FS-960-HDS-010-SDS-016-SMS-060__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-960-HDS-010-SDS-016-SMS-060.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-960-HDS-010-SDS-016-SMS-060 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-960-HDS-020-SDS-010-SMS-010" = {
      id = "FS-960-HDS-020-SDS-010-SMS-010";
      traceId = "FS-960-HDS-020-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-960-HDS-020-SDS-010;
        SMS = ../../SMS/FS-960-HDS-020-SDS-010-SMS-010;
        SMT = ../FS-960-HDS-020-SDS-010-SMS-010;
        SIT = ../../SIT/FS-960-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-960-HDS-020-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-960-HDS-020-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-960-HDS-020-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-960-HDS-020-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-970-HDS-010-SDS-010-SMS-010" = {
      id = "FS-970-HDS-010-SDS-010-SMS-010";
      traceId = "FS-970-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-970-HDS-010-SDS-010;
        SMS = ../../SMS/FS-970-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-970-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-970-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-970-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-970-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-970-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-970-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-970-HDS-010-SDS-010-SMS-020" = {
      id = "FS-970-HDS-010-SDS-010-SMS-020";
      traceId = "FS-970-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-970-HDS-010-SDS-010;
        SMS = ../../SMS/FS-970-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-970-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-970-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-970-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-970-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-970-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-970-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-970-HDS-010-SDS-010-SMS-030" = {
      id = "FS-970-HDS-010-SDS-010-SMS-030";
      traceId = "FS-970-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-970-HDS-010-SDS-010;
        SMS = ../../SMS/FS-970-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-970-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-970-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-970-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-970-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-970-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-970-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-970-HDS-010-SDS-020-SMS-010" = {
      id = "FS-970-HDS-010-SDS-020-SMS-010";
      traceId = "FS-970-HDS-010-SDS-020-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-970-HDS-010-SDS-020;
        SMS = ../../SMS/FS-970-HDS-010-SDS-020-SMS-010;
        SMT = ../FS-970-HDS-010-SDS-020-SMS-010;
        SIT = ../../SIT/FS-970-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-970-HDS-010-SDS-020-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-970-HDS-010-SDS-020-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-970-HDS-010-SDS-020-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-970-HDS-010-SDS-020-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-970-HDS-010-SDS-020-SMS-020" = {
      id = "FS-970-HDS-010-SDS-020-SMS-020";
      traceId = "FS-970-HDS-010-SDS-020-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-970-HDS-010-SDS-020;
        SMS = ../../SMS/FS-970-HDS-010-SDS-020-SMS-020;
        SMT = ../FS-970-HDS-010-SDS-020-SMS-020;
        SIT = ../../SIT/FS-970-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-970-HDS-010-SDS-020-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-970-HDS-010-SDS-020-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-970-HDS-010-SDS-020-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-970-HDS-010-SDS-020-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-970-HDS-010-SDS-020-SMS-030" = {
      id = "FS-970-HDS-010-SDS-020-SMS-030";
      traceId = "FS-970-HDS-010-SDS-020-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-970-HDS-010-SDS-020;
        SMS = ../../SMS/FS-970-HDS-010-SDS-020-SMS-030;
        SMT = ../FS-970-HDS-010-SDS-020-SMS-030;
        SIT = ../../SIT/FS-970-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-970-HDS-010-SDS-020-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-970-HDS-010-SDS-020-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-970-HDS-010-SDS-020-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-970-HDS-010-SDS-020-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-980-HDS-010-SDS-010-SMS-010" = {
      id = "FS-980-HDS-010-SDS-010-SMS-010";
      traceId = "FS-980-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-980-HDS-010-SDS-010;
        SMS = ../../SMS/FS-980-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-980-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-980-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-980-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-980-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-980-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-980-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-980-HDS-010-SDS-010-SMS-020" = {
      id = "FS-980-HDS-010-SDS-010-SMS-020";
      traceId = "FS-980-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-980-HDS-010-SDS-010;
        SMS = ../../SMS/FS-980-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-980-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-980-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-980-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-980-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-980-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-980-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-980-HDS-010-SDS-010-SMS-030" = {
      id = "FS-980-HDS-010-SDS-010-SMS-030";
      traceId = "FS-980-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-980-HDS-010-SDS-010;
        SMS = ../../SMS/FS-980-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-980-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-980-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-980-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-980-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-980-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-980-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-981-HDS-010-SDS-010-SMS-010" = {
      id = "FS-981-HDS-010-SDS-010-SMS-010";
      traceId = "FS-981-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-981-HDS-010-SDS-010;
        SMS = ../../SMS/FS-981-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-981-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-981-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-981-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-981-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-981-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-981-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-981-HDS-010-SDS-010-SMS-020" = {
      id = "FS-981-HDS-010-SDS-010-SMS-020";
      traceId = "FS-981-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-981-HDS-010-SDS-010;
        SMS = ../../SMS/FS-981-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-981-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-981-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-981-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-981-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-981-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-981-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-981-HDS-010-SDS-010-SMS-030" = {
      id = "FS-981-HDS-010-SDS-010-SMS-030";
      traceId = "FS-981-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-981-HDS-010-SDS-010;
        SMS = ../../SMS/FS-981-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-981-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-981-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-981-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-981-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-981-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-981-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-981-HDS-010-SDS-010-SMS-050" = {
      id = "FS-981-HDS-010-SDS-010-SMS-050";
      traceId = "FS-981-HDS-010-SDS-010-SMS-050";
      rowDirectories = {
        SDS = ../../SDS/FS-981-HDS-010-SDS-010;
        SMS = ../../SMS/FS-981-HDS-010-SDS-010-SMS-050;
        SMT = ../FS-981-HDS-010-SDS-010-SMS-050;
        SIT = ../../SIT/FS-981-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-981-HDS-010-SDS-010-SMS-050/intent.nix;
        expectedRelationIds = [ "FS-981-HDS-010-SDS-010-SMS-050__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-981-HDS-010-SDS-010-SMS-050.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-981-HDS-010-SDS-010-SMS-050 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-981-HDS-010-SDS-010-SMS-060" = {
      id = "FS-981-HDS-010-SDS-010-SMS-060";
      traceId = "FS-981-HDS-010-SDS-010-SMS-060";
      rowDirectories = {
        SDS = ../../SDS/FS-981-HDS-010-SDS-010;
        SMS = ../../SMS/FS-981-HDS-010-SDS-010-SMS-060;
        SMT = ../FS-981-HDS-010-SDS-010-SMS-060;
        SIT = ../../SIT/FS-981-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-981-HDS-010-SDS-010-SMS-060/intent.nix;
        expectedRelationIds = [ "FS-981-HDS-010-SDS-010-SMS-060__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-981-HDS-010-SDS-010-SMS-060.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-981-HDS-010-SDS-010-SMS-060 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-982-HDS-010-SDS-010-SMS-010" = {
      id = "FS-982-HDS-010-SDS-010-SMS-010";
      traceId = "FS-982-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-982-HDS-010-SDS-010;
        SMS = ../../SMS/FS-982-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-982-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-982-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-982-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-982-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-982-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-982-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-982-HDS-010-SDS-010-SMS-020" = {
      id = "FS-982-HDS-010-SDS-010-SMS-020";
      traceId = "FS-982-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-982-HDS-010-SDS-010;
        SMS = ../../SMS/FS-982-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-982-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-982-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-982-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-982-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-982-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-982-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-982-HDS-010-SDS-010-SMS-030" = {
      id = "FS-982-HDS-010-SDS-010-SMS-030";
      traceId = "FS-982-HDS-010-SDS-010-SMS-030";
      rowDirectories = {
        SDS = ../../SDS/FS-982-HDS-010-SDS-010;
        SMS = ../../SMS/FS-982-HDS-010-SDS-010-SMS-030;
        SMT = ../FS-982-HDS-010-SDS-010-SMS-030;
        SIT = ../../SIT/FS-982-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-982-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [ "FS-982-HDS-010-SDS-010-SMS-030__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-982-HDS-010-SDS-010-SMS-030.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-982-HDS-010-SDS-010-SMS-030 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-982-HDS-010-SDS-010-SMS-050" = {
      id = "FS-982-HDS-010-SDS-010-SMS-050";
      traceId = "FS-982-HDS-010-SDS-010-SMS-050";
      rowDirectories = {
        SDS = ../../SDS/FS-982-HDS-010-SDS-010;
        SMS = ../../SMS/FS-982-HDS-010-SDS-010-SMS-050;
        SMT = ../FS-982-HDS-010-SDS-010-SMS-050;
        SIT = ../../SIT/FS-982-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-982-HDS-010-SDS-010-SMS-050/intent.nix;
        expectedRelationIds = [ "FS-982-HDS-010-SDS-010-SMS-050__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-982-HDS-010-SDS-010-SMS-050.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-982-HDS-010-SDS-010-SMS-050 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-982-HDS-010-SDS-010-SMS-060" = {
      id = "FS-982-HDS-010-SDS-010-SMS-060";
      traceId = "FS-982-HDS-010-SDS-010-SMS-060";
      rowDirectories = {
        SDS = ../../SDS/FS-982-HDS-010-SDS-010;
        SMS = ../../SMS/FS-982-HDS-010-SDS-010-SMS-060;
        SMT = ../FS-982-HDS-010-SDS-010-SMS-060;
        SIT = ../../SIT/FS-982-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-982-HDS-010-SDS-010-SMS-060/intent.nix;
        expectedRelationIds = [ "FS-982-HDS-010-SDS-010-SMS-060__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-982-HDS-010-SDS-010-SMS-060.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-982-HDS-010-SDS-010-SMS-060 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-982-HDS-010-SDS-010-SMS-070" = {
      id = "FS-982-HDS-010-SDS-010-SMS-070";
      traceId = "FS-982-HDS-010-SDS-010-SMS-070";
      rowDirectories = {
        SDS = ../../SDS/FS-982-HDS-010-SDS-010;
        SMS = ../../SMS/FS-982-HDS-010-SDS-010-SMS-070;
        SMT = ../FS-982-HDS-010-SDS-010-SMS-070;
        SIT = ../../SIT/FS-982-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-982-HDS-010-SDS-010-SMS-070/intent.nix;
        expectedRelationIds = [ "FS-982-HDS-010-SDS-010-SMS-070__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-982-HDS-010-SDS-010-SMS-070.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-982-HDS-010-SDS-010-SMS-070 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-982-HDS-010-SDS-010-SMS-080" = {
      id = "FS-982-HDS-010-SDS-010-SMS-080";
      traceId = "FS-982-HDS-010-SDS-010-SMS-080";
      rowDirectories = {
        SDS = ../../SDS/FS-982-HDS-010-SDS-010;
        SMS = ../../SMS/FS-982-HDS-010-SDS-010-SMS-080;
        SMT = ../FS-982-HDS-010-SDS-010-SMS-080;
        SIT = ../../SIT/FS-982-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-982-HDS-010-SDS-010-SMS-080/intent.nix;
        expectedRelationIds = [ "FS-982-HDS-010-SDS-010-SMS-080__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-982-HDS-010-SDS-010-SMS-080.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-982-HDS-010-SDS-010-SMS-080 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-982-HDS-010-SDS-010-SMS-090" = {
      id = "FS-982-HDS-010-SDS-010-SMS-090";
      traceId = "FS-982-HDS-010-SDS-010-SMS-090";
      rowDirectories = {
        SDS = ../../SDS/FS-982-HDS-010-SDS-010;
        SMS = ../../SMS/FS-982-HDS-010-SDS-010-SMS-090;
        SMT = ../FS-982-HDS-010-SDS-010-SMS-090;
        SIT = ../../SIT/FS-982-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-982-HDS-010-SDS-010-SMS-090/intent.nix;
        expectedRelationIds = [ "FS-982-HDS-010-SDS-010-SMS-090__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-982-HDS-010-SDS-010-SMS-090.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-982-HDS-010-SDS-010-SMS-090 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-982-HDS-010-SDS-010-SMS-100" = {
      id = "FS-982-HDS-010-SDS-010-SMS-100";
      traceId = "FS-982-HDS-010-SDS-010-SMS-100";
      rowDirectories = {
        SDS = ../../SDS/FS-982-HDS-010-SDS-010;
        SMS = ../../SMS/FS-982-HDS-010-SDS-010-SMS-100;
        SMT = ../FS-982-HDS-010-SDS-010-SMS-100;
        SIT = ../../SIT/FS-982-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-982-HDS-010-SDS-010-SMS-100/intent.nix;
        expectedRelationIds = [ "FS-982-HDS-010-SDS-010-SMS-100__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-982-HDS-010-SDS-010-SMS-100.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-982-HDS-010-SDS-010-SMS-100 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-982-HDS-010-SDS-010-SMS-110" = {
      id = "FS-982-HDS-010-SDS-010-SMS-110";
      traceId = "FS-982-HDS-010-SDS-010-SMS-110";
      rowDirectories = {
        SDS = ../../SDS/FS-982-HDS-010-SDS-010;
        SMS = ../../SMS/FS-982-HDS-010-SDS-010-SMS-110;
        SMT = ../FS-982-HDS-010-SDS-010-SMS-110;
        SIT = ../../SIT/FS-982-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-982-HDS-010-SDS-010-SMS-110/intent.nix;
        expectedRelationIds = [ "FS-982-HDS-010-SDS-010-SMS-110__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-982-HDS-010-SDS-010-SMS-110.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-982-HDS-010-SDS-010-SMS-110 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-983-HDS-010-SDS-010-SMS-010" = {
      id = "FS-983-HDS-010-SDS-010-SMS-010";
      traceId = "FS-983-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-983-HDS-010-SDS-010;
        SMS = ../../SMS/FS-983-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-983-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-983-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-983-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-983-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-983-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-983-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-984-HDS-010-SDS-010-SMS-010" = {
      id = "FS-984-HDS-010-SDS-010-SMS-010";
      traceId = "FS-984-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-984-HDS-010-SDS-010;
        SMS = ../../SMS/FS-984-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-984-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-984-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-984-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-984-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-984-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-984-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-985-HDS-010-SDS-010-SMS-010" = {
      id = "FS-985-HDS-010-SDS-010-SMS-010";
      traceId = "FS-985-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-985-HDS-010-SDS-010;
        SMS = ../../SMS/FS-985-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-985-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-985-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-985-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-985-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-985-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-985-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-985-HDS-010-SDS-010-SMS-020" = {
      id = "FS-985-HDS-010-SDS-010-SMS-020";
      traceId = "FS-985-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-985-HDS-010-SDS-010;
        SMS = ../../SMS/FS-985-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-985-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-985-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-985-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-985-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-985-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-985-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-030-HDS-010-SDS-010-SMS-020" = {
      id = "FS-030-HDS-010-SDS-010-SMS-020";
      traceId = "FS-030-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-030-HDS-010-SDS-010;
        SMS = ../../SMS/FS-030-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-030-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-030-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-030-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-030-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-030-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-030-HDS-010-SDS-010-SMS-040" = {
      id = "FS-030-HDS-010-SDS-010-SMS-040";
      traceId = "FS-030-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-030-HDS-010-SDS-010;
        SMS = ../../SMS/FS-030-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-030-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-030-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-030-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-030-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-030-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-050-HDS-010-SDS-010-SMS-010" = {
      id = "FS-050-HDS-010-SDS-010-SMS-010";
      traceId = "FS-050-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-050-HDS-010-SDS-010;
        SMS = ../../SMS/FS-050-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-050-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-050-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-050-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-050-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-050-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-050-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-100-HDS-010-SDS-010-SMS-040" = {
      id = "FS-100-HDS-010-SDS-010-SMS-040";
      traceId = "FS-100-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-100-HDS-010-SDS-010;
        SMS = ../../SMS/FS-100-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-100-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-100-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-100-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-100-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-100-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-100-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-165-HDS-010-SDS-010-SMS-010" = {
      id = "FS-165-HDS-010-SDS-010-SMS-010";
      traceId = "FS-165-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-165-HDS-010-SDS-010;
        SMS = ../../SMS/FS-165-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-165-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-165-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-165-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-165-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-165-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-165-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-180-HDS-010-SDS-010-SMS-040" = {
      id = "FS-180-HDS-010-SDS-010-SMS-040";
      traceId = "FS-180-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-180-HDS-010-SDS-010;
        SMS = ../../SMS/FS-180-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-180-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-180-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-180-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-180-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-180-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-180-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-190-HDS-010-SDS-010-SMS-010" = {
      id = "FS-190-HDS-010-SDS-010-SMS-010";
      traceId = "FS-190-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-190-HDS-010-SDS-010;
        SMS = ../../SMS/FS-190-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-190-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-190-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-190-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-190-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-190-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-190-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-200-HDS-010-SDS-010-SMS-010" = {
      id = "FS-200-HDS-010-SDS-010-SMS-010";
      traceId = "FS-200-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-200-HDS-010-SDS-010;
        SMS = ../../SMS/FS-200-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-200-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-200-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-200-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-200-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-200-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-200-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-260-HDS-010-SDS-010-SMS-040" = {
      id = "FS-260-HDS-010-SDS-010-SMS-040";
      traceId = "FS-260-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-260-HDS-010-SDS-010;
        SMS = ../../SMS/FS-260-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-260-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-260-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-260-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-260-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-260-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-260-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-270-HDS-010-SDS-010-SMS-040" = {
      id = "FS-270-HDS-010-SDS-010-SMS-040";
      traceId = "FS-270-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-270-HDS-010-SDS-010;
        SMS = ../../SMS/FS-270-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-270-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-270-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-270-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-270-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-270-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-270-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-010-SDS-010-SMS-010" = {
      id = "FS-310-HDS-010-SDS-010-SMS-010";
      traceId = "FS-310-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-010-SDS-010;
        SMS = ../../SMS/FS-310-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-310-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-310-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-020-SDS-010-SMS-040" = {
      id = "FS-310-HDS-020-SDS-010-SMS-040";
      traceId = "FS-310-HDS-020-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-020-SDS-010;
        SMS = ../../SMS/FS-310-HDS-020-SDS-010-SMS-040;
        SMT = ../FS-310-HDS-020-SDS-010-SMS-040;
        SIT = ../../SIT/FS-310-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-020-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-020-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-020-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-020-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-310-HDS-020-SDS-010-SMS-200" = {
      id = "FS-310-HDS-020-SDS-010-SMS-200";
      traceId = "FS-310-HDS-020-SDS-010-SMS-200";
      rowDirectories = {
        SDS = ../../SDS/FS-310-HDS-020-SDS-010;
        SMS = ../../SMS/FS-310-HDS-020-SDS-010-SMS-200;
        SMT = ../FS-310-HDS-020-SDS-010-SMS-200;
        SIT = ../../SIT/FS-310-HDS-020-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-310-HDS-020-SDS-010-SMS-200/intent.nix;
        expectedRelationIds = [ "FS-310-HDS-020-SDS-010-SMS-200__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-310-HDS-020-SDS-010-SMS-200.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-310-HDS-020-SDS-010-SMS-200 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-320-HDS-010-SDS-010-SMS-010" = {
      id = "FS-320-HDS-010-SDS-010-SMS-010";
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
        expectedRelationIds = [ "FS-320-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-320-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-320-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-320-HDS-010-SDS-010-SMS-020" = {
      id = "FS-320-HDS-010-SDS-010-SMS-020";
      traceId = "FS-320-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-320-HDS-010-SDS-010;
        SMS = ../../SMS/FS-320-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-320-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-320-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-320-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-320-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-320-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-320-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-320-HDS-030-SDS-010-SMS-040" = {
      id = "FS-320-HDS-030-SDS-010-SMS-040";
      traceId = "FS-320-HDS-030-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-320-HDS-030-SDS-010;
        SMS = ../../SMS/FS-320-HDS-030-SDS-010-SMS-040;
        SMT = ../FS-320-HDS-030-SDS-010-SMS-040;
        SIT = ../../SIT/FS-320-HDS-030-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-320-HDS-030-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-320-HDS-030-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-320-HDS-030-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-320-HDS-030-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-340-HDS-010-SDS-010-SMS-040" = {
      id = "FS-340-HDS-010-SDS-010-SMS-040";
      traceId = "FS-340-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-340-HDS-010-SDS-010;
        SMS = ../../SMS/FS-340-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-340-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-340-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-340-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-340-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-340-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-340-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-350-HDS-010-SDS-010-SMS-010" = {
      id = "FS-350-HDS-010-SDS-010-SMS-010";
      traceId = "FS-350-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-350-HDS-010-SDS-010;
        SMS = ../../SMS/FS-350-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-350-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-350-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-350-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-350-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-350-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-350-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-350-HDS-010-SDS-010-SMS-040" = {
      id = "FS-350-HDS-010-SDS-010-SMS-040";
      traceId = "FS-350-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-350-HDS-010-SDS-010;
        SMS = ../../SMS/FS-350-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-350-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-350-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-350-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-350-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-350-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-350-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-370-HDS-010-SDS-010-SMS-040" = {
      id = "FS-370-HDS-010-SDS-010-SMS-040";
      traceId = "FS-370-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-370-HDS-010-SDS-010;
        SMS = ../../SMS/FS-370-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-370-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-370-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-370-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-370-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-370-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-370-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-370-HDS-010-SDS-010-SMS-101" = {
      id = "FS-370-HDS-010-SDS-010-SMS-101";
      traceId = "FS-370-HDS-010-SDS-010-SMS-101";
      rowDirectories = {
        SDS = ../../SDS/FS-370-HDS-010-SDS-010;
        SMS = ../../SMS/FS-370-HDS-010-SDS-010-SMS-101;
        SMT = ../FS-370-HDS-010-SDS-010-SMS-101;
        SIT = ../../SIT/FS-370-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-370-HDS-010-SDS-010-SMS-101/intent.nix;
        expectedRelationIds = [ "FS-370-HDS-010-SDS-010-SMS-101__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-370-HDS-010-SDS-010-SMS-101.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-370-HDS-010-SDS-010-SMS-101 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-380-HDS-010-SDS-010-SMS-040" = {
      id = "FS-380-HDS-010-SDS-010-SMS-040";
      traceId = "FS-380-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-380-HDS-010-SDS-010;
        SMS = ../../SMS/FS-380-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-380-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-380-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-380-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-380-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-380-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-380-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-400-HDS-010-SDS-010-SMS-020" = {
      id = "FS-400-HDS-010-SDS-010-SMS-020";
      traceId = "FS-400-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-400-HDS-010-SDS-010;
        SMS = ../../SMS/FS-400-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-400-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-400-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-400-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-400-HDS-010-SDS-010-SMS-020__mini-ula-nat66-tenant-to-wan" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-400-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-400-HDS-010-SDS-010-SMS-020 SMT construction verifier";
      maxRuntimeTargets = 0;
    };

    "FS-400-HDS-010-SDS-010-SMS-040" = {
      id = "FS-400-HDS-010-SDS-010-SMS-040";
      traceId = "FS-400-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-400-HDS-010-SDS-010;
        SMS = ../../SMS/FS-400-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-400-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-400-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-400-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-400-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-400-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-400-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-440-HDS-010-SDS-010-SMS-040" = {
      id = "FS-440-HDS-010-SDS-010-SMS-040";
      traceId = "FS-440-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-440-HDS-010-SDS-010;
        SMS = ../../SMS/FS-440-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-440-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-440-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-440-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-440-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-440-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-440-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-460-HDS-010-SDS-010-SMS-040" = {
      id = "FS-460-HDS-010-SDS-010-SMS-040";
      traceId = "FS-460-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-460-HDS-010-SDS-010;
        SMS = ../../SMS/FS-460-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-460-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-460-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-460-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-460-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-460-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-460-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-470-HDS-010-SDS-010-SMS-040" = {
      id = "FS-470-HDS-010-SDS-010-SMS-040";
      traceId = "FS-470-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-470-HDS-010-SDS-010;
        SMS = ../../SMS/FS-470-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-470-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-470-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-470-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-470-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-470-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-470-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-480-HDS-010-SDS-010-SMS-040" = {
      id = "FS-480-HDS-010-SDS-010-SMS-040";
      traceId = "FS-480-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-480-HDS-010-SDS-010;
        SMS = ../../SMS/FS-480-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-480-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-480-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-480-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-480-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-480-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-480-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-500-HDS-010-SDS-010-SMS-020" = {
      id = "FS-500-HDS-010-SDS-010-SMS-020";
      traceId = "FS-500-HDS-010-SDS-010-SMS-020";
      rowDirectories = {
        SDS = ../../SDS/FS-500-HDS-010-SDS-010;
        SMS = ../../SMS/FS-500-HDS-010-SDS-010-SMS-020;
        SMT = ../FS-500-HDS-010-SDS-010-SMS-020;
        SIT = ../../SIT/FS-500-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-500-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = [ "FS-500-HDS-010-SDS-010-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-500-HDS-010-SDS-010-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-500-HDS-010-SDS-010-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-510-HDS-010-SDS-010-SMS-040" = {
      id = "FS-510-HDS-010-SDS-010-SMS-040";
      traceId = "FS-510-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-510-HDS-010-SDS-010;
        SMS = ../../SMS/FS-510-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-510-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-510-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-510-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-510-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-510-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-510-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-520-HDS-010-SDS-010-SMS-040" = {
      id = "FS-520-HDS-010-SDS-010-SMS-040";
      traceId = "FS-520-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-520-HDS-010-SDS-010;
        SMS = ../../SMS/FS-520-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-520-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-520-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-520-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-520-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-520-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-520-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-530-HDS-010-SDS-010-SMS-040" = {
      id = "FS-530-HDS-010-SDS-010-SMS-040";
      traceId = "FS-530-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-530-HDS-010-SDS-010;
        SMS = ../../SMS/FS-530-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-530-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-530-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-530-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-530-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-530-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-530-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-540-HDS-010-SDS-010-SMS-010" = {
      id = "FS-540-HDS-010-SDS-010-SMS-010";
      traceId = "FS-540-HDS-010-SDS-010-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-540-HDS-010-SDS-010;
        SMS = ../../SMS/FS-540-HDS-010-SDS-010-SMS-010;
        SMT = ../FS-540-HDS-010-SDS-010-SMS-010;
        SIT = ../../SIT/FS-540-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-540-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-540-HDS-010-SDS-010-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-540-HDS-010-SDS-010-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-540-HDS-010-SDS-010-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-540-HDS-010-SDS-010-SMS-040" = {
      id = "FS-540-HDS-010-SDS-010-SMS-040";
      traceId = "FS-540-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-540-HDS-010-SDS-010;
        SMS = ../../SMS/FS-540-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-540-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-540-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-540-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-540-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-540-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-540-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-550-HDS-010-SDS-010-SMS-040" = {
      id = "FS-550-HDS-010-SDS-010-SMS-040";
      traceId = "FS-550-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-550-HDS-010-SDS-010;
        SMS = ../../SMS/FS-550-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-550-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-550-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-550-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-550-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-550-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-550-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-560-HDS-010-SDS-010-SMS-040" = {
      id = "FS-560-HDS-010-SDS-010-SMS-040";
      traceId = "FS-560-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-560-HDS-010-SDS-010;
        SMS = ../../SMS/FS-560-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-560-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-560-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-560-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-560-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-560-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-560-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-570-HDS-010-SDS-010-SMS-040" = {
      id = "FS-570-HDS-010-SDS-010-SMS-040";
      traceId = "FS-570-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-570-HDS-010-SDS-010;
        SMS = ../../SMS/FS-570-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-570-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-570-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-570-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-570-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-570-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-570-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-580-HDS-010-SDS-010-SMS-040" = {
      id = "FS-580-HDS-010-SDS-010-SMS-040";
      traceId = "FS-580-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-580-HDS-010-SDS-010;
        SMS = ../../SMS/FS-580-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-580-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-580-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-580-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-580-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-580-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-580-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-590-HDS-010-SDS-010-SMS-040" = {
      id = "FS-590-HDS-010-SDS-010-SMS-040";
      traceId = "FS-590-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-590-HDS-010-SDS-010;
        SMS = ../../SMS/FS-590-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-590-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-590-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-590-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-590-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-590-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-590-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-600-HDS-010-SDS-010-SMS-040" = {
      id = "FS-600-HDS-010-SDS-010-SMS-040";
      traceId = "FS-600-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-600-HDS-010-SDS-010;
        SMS = ../../SMS/FS-600-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-600-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-600-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-600-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-600-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-600-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-600-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-610-HDS-010-SDS-010-SMS-040" = {
      id = "FS-610-HDS-010-SDS-010-SMS-040";
      traceId = "FS-610-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-610-HDS-010-SDS-010;
        SMS = ../../SMS/FS-610-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-610-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-610-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-610-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-610-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-610-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-610-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-620-HDS-010-SDS-010-SMS-040" = {
      id = "FS-620-HDS-010-SDS-010-SMS-040";
      traceId = "FS-620-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-620-HDS-010-SDS-010;
        SMS = ../../SMS/FS-620-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-620-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-620-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-620-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-620-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-620-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-620-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-630-HDS-010-SDS-010-SMS-040" = {
      id = "FS-630-HDS-010-SDS-010-SMS-040";
      traceId = "FS-630-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-630-HDS-010-SDS-010;
        SMS = ../../SMS/FS-630-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-630-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-630-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-630-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-630-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-630-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-630-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-640-HDS-010-SDS-010-SMS-040" = {
      id = "FS-640-HDS-010-SDS-010-SMS-040";
      traceId = "FS-640-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-640-HDS-010-SDS-010;
        SMS = ../../SMS/FS-640-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-640-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-640-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-640-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-640-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-640-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-640-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-650-HDS-010-SDS-010-SMS-040" = {
      id = "FS-650-HDS-010-SDS-010-SMS-040";
      traceId = "FS-650-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-650-HDS-010-SDS-010;
        SMS = ../../SMS/FS-650-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-650-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-650-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-650-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-650-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-650-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-650-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-660-HDS-010-SDS-010-SMS-040" = {
      id = "FS-660-HDS-010-SDS-010-SMS-040";
      traceId = "FS-660-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-660-HDS-010-SDS-010;
        SMS = ../../SMS/FS-660-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-660-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-660-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-660-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-660-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-660-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-660-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-670-HDS-010-SDS-010-SMS-040" = {
      id = "FS-670-HDS-010-SDS-010-SMS-040";
      traceId = "FS-670-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-670-HDS-010-SDS-010;
        SMS = ../../SMS/FS-670-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-670-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-670-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-670-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-670-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-670-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-670-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-680-HDS-010-SDS-010-SMS-040" = {
      id = "FS-680-HDS-010-SDS-010-SMS-040";
      traceId = "FS-680-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-680-HDS-010-SDS-010;
        SMS = ../../SMS/FS-680-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-680-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-680-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-680-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-680-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-680-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-680-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-710-HDS-010-SDS-010-SMS-040" = {
      id = "FS-710-HDS-010-SDS-010-SMS-040";
      traceId = "FS-710-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-710-HDS-010-SDS-010;
        SMS = ../../SMS/FS-710-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-710-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-710-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-710-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-710-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-710-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-710-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-720-HDS-010-SDS-010-SMS-040" = {
      id = "FS-720-HDS-010-SDS-010-SMS-040";
      traceId = "FS-720-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-720-HDS-010-SDS-010;
        SMS = ../../SMS/FS-720-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-720-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-720-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-720-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-720-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-720-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-720-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-720-HDS-010-SDS-020-SMS-020" = {
      id = "FS-720-HDS-010-SDS-020-SMS-020";
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
        expectedRelationIds = [ "FS-720-HDS-010-SDS-020-SMS-020__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-720-HDS-010-SDS-020-SMS-020.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-720-HDS-010-SDS-020-SMS-020 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-720-HDS-010-SDS-030-SMS-010" = {
      id = "FS-720-HDS-010-SDS-030-SMS-010";
      traceId = "FS-720-HDS-010-SDS-030-SMS-010";
      rowDirectories = {
        SDS = ../../SDS/FS-720-HDS-010-SDS-030;
        SMS = ../../SMS/FS-720-HDS-010-SDS-030-SMS-010;
        SMT = ../FS-720-HDS-010-SDS-030-SMS-010;
        SIT = ../../SIT/FS-720-HDS-010-SDS-030;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-720-HDS-010-SDS-030-SMS-010/intent.nix;
        expectedRelationIds = [ "FS-720-HDS-010-SDS-030-SMS-010__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-720-HDS-010-SDS-030-SMS-010.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-720-HDS-010-SDS-030-SMS-010 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-740-HDS-010-SDS-010-SMS-040" = {
      id = "FS-740-HDS-010-SDS-010-SMS-040";
      traceId = "FS-740-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-740-HDS-010-SDS-010;
        SMS = ../../SMS/FS-740-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-740-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-740-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-740-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-740-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-740-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-740-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-760-HDS-010-SDS-010-SMS-040" = {
      id = "FS-760-HDS-010-SDS-010-SMS-040";
      traceId = "FS-760-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-760-HDS-010-SDS-010;
        SMS = ../../SMS/FS-760-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-760-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-760-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-760-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-760-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-760-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-760-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-770-HDS-010-SDS-020-SMS-040" = {
      id = "FS-770-HDS-010-SDS-020-SMS-040";
      traceId = "FS-770-HDS-010-SDS-020-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-770-HDS-010-SDS-020;
        SMS = ../../SMS/FS-770-HDS-010-SDS-020-SMS-040;
        SMT = ../FS-770-HDS-010-SDS-020-SMS-040;
        SIT = ../../SIT/FS-770-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-770-HDS-010-SDS-020-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-770-HDS-010-SDS-020-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-770-HDS-010-SDS-020-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-770-HDS-010-SDS-020-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-790-HDS-010-SDS-010-SMS-040" = {
      id = "FS-790-HDS-010-SDS-010-SMS-040";
      traceId = "FS-790-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-790-HDS-010-SDS-010;
        SMS = ../../SMS/FS-790-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-790-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-790-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-790-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-790-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-790-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-790-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-800-HDS-010-SDS-030-SMS-040" = {
      id = "FS-800-HDS-010-SDS-030-SMS-040";
      traceId = "FS-800-HDS-010-SDS-030-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-800-HDS-010-SDS-030;
        SMS = ../../SMS/FS-800-HDS-010-SDS-030-SMS-040;
        SMT = ../FS-800-HDS-010-SDS-030-SMS-040;
        SIT = ../../SIT/FS-800-HDS-010-SDS-030;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-800-HDS-010-SDS-030-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-800-HDS-010-SDS-030-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-800-HDS-010-SDS-030-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-800-HDS-010-SDS-030-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-830-HDS-010-SDS-010-SMS-040" = {
      id = "FS-830-HDS-010-SDS-010-SMS-040";
      traceId = "FS-830-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-830-HDS-010-SDS-010;
        SMS = ../../SMS/FS-830-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-830-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-830-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-830-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-830-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-830-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-830-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-840-HDS-010-SDS-010-SMS-040" = {
      id = "FS-840-HDS-010-SDS-010-SMS-040";
      traceId = "FS-840-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-840-HDS-010-SDS-010;
        SMS = ../../SMS/FS-840-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-840-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-840-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-840-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-840-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-840-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-840-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-930-HDS-010-SDS-010-SMS-040" = {
      id = "FS-930-HDS-010-SDS-010-SMS-040";
      traceId = "FS-930-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-930-HDS-010-SDS-010;
        SMS = ../../SMS/FS-930-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-930-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-930-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-930-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-930-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-930-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-930-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-940-HDS-010-SDS-010-SMS-040" = {
      id = "FS-940-HDS-010-SDS-010-SMS-040";
      traceId = "FS-940-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-940-HDS-010-SDS-010;
        SMS = ../../SMS/FS-940-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-940-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-940-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-940-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-940-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-940-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-940-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-940-HDS-010-SDS-020-SMS-040" = {
      id = "FS-940-HDS-010-SDS-020-SMS-040";
      traceId = "FS-940-HDS-010-SDS-020-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-940-HDS-010-SDS-020;
        SMS = ../../SMS/FS-940-HDS-010-SDS-020-SMS-040;
        SMT = ../FS-940-HDS-010-SDS-020-SMS-040;
        SIT = ../../SIT/FS-940-HDS-010-SDS-020;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-940-HDS-010-SDS-020-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-940-HDS-010-SDS-020-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-940-HDS-010-SDS-020-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-940-HDS-010-SDS-020-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-950-HDS-010-SDS-010-SMS-040" = {
      id = "FS-950-HDS-010-SDS-010-SMS-040";
      traceId = "FS-950-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-950-HDS-010-SDS-010;
        SMS = ../../SMS/FS-950-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-950-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-950-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-950-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-950-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-950-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-950-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-960-HDS-010-SDS-010-SMS-040" = {
      id = "FS-960-HDS-010-SDS-010-SMS-040";
      traceId = "FS-960-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-960-HDS-010-SDS-010;
        SMS = ../../SMS/FS-960-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-960-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-960-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-960-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-960-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-960-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-960-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-960-HDS-010-SDS-016-SMS-040" = {
      id = "FS-960-HDS-010-SDS-016-SMS-040";
      traceId = "FS-960-HDS-010-SDS-016-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-960-HDS-010-SDS-016;
        SMS = ../../SMS/FS-960-HDS-010-SDS-016-SMS-040;
        SMT = ../FS-960-HDS-010-SDS-016-SMS-040;
        SIT = ../../SIT/FS-960-HDS-010-SDS-016;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-960-HDS-010-SDS-016-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-960-HDS-010-SDS-016-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-960-HDS-010-SDS-016-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-960-HDS-010-SDS-016-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-970-HDS-010-SDS-010-SMS-040" = {
      id = "FS-970-HDS-010-SDS-010-SMS-040";
      traceId = "FS-970-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-970-HDS-010-SDS-010;
        SMS = ../../SMS/FS-970-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-970-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-970-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-970-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-970-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-970-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-970-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-980-HDS-010-SDS-010-SMS-040" = {
      id = "FS-980-HDS-010-SDS-010-SMS-040";
      traceId = "FS-980-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-980-HDS-010-SDS-010;
        SMS = ../../SMS/FS-980-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-980-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-980-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-980-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-980-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-980-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-980-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-981-HDS-010-SDS-010-SMS-040" = {
      id = "FS-981-HDS-010-SDS-010-SMS-040";
      traceId = "FS-981-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-981-HDS-010-SDS-010;
        SMS = ../../SMS/FS-981-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-981-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-981-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-981-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-981-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-981-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-981-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };

    "FS-982-HDS-010-SDS-010-SMS-040" = {
      id = "FS-982-HDS-010-SDS-010-SMS-040";
      traceId = "FS-982-HDS-010-SDS-010-SMS-040";
      rowDirectories = {
        SDS = ../../SDS/FS-982-HDS-010-SDS-010;
        SMS = ../../SMS/FS-982-HDS-010-SDS-010-SMS-040;
        SMT = ../FS-982-HDS-010-SDS-010-SMS-040;
        SIT = ../../SIT/FS-982-HDS-010-SDS-010;
      };
      source = {
        kind = "intent-source";
        intent = ../FS-982-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [ "FS-982-HDS-010-SDS-010-SMS-040__mini-verify" ];
      };
      evidenceLevels = [ "SMT" "SIT" ];
      rendererTarget = null;
      script = "../network-codex-agent/scripts/smt-live-FS-982-HDS-010-SDS-010-SMS-040.sh";
      independent = true;
      aggregateOnly = false;
      scope = "FS-982-HDS-010-SDS-010-SMS-040 SMT live verifier";
      maxRuntimeTargets = 5;
    };
  };
}
