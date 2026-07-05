let
  pppoeTraceId = "FS-800-HDS-030-SDS-030-SMS-010";
  reachabilityTraceId = "FS-500-HDS-010-SDS-010-SMS-010";
  decisionReasonTraceId = "FS-500-HDS-010-SDS-010-SMS-030";
  p2pTraceId = "FS-500-HDS-010-SDS-010-SMS-040";
  laneEgressBindingTraceId = "FS-370-HDS-010-SDS-010-SMS-050";
  dnsResolverConfigTraceId = "FS-540-HDS-010-SDS-010-SMS-020";
  prodLikeRecursiveDnsTraceId = "FS-540-HDS-010-SDS-010-SMS-045";
  wireguardRemoteEgressTraceId = "FS-470-HDS-010-SDS-010-SMS-010";
  dnsResolverRelationIds = [
    "${dnsResolverConfigTraceId}__mini-client-to-access-dns"
    "${dnsResolverConfigTraceId}__mini-access-dns-service-to-testnet"
    "${dnsResolverConfigTraceId}__mini-dns-client-to-testnet"
  ];
  internetModeTraceId = "FS-380-HDS-020-SDS-010-SMS-050";
  prodLikeVlan4TraceId = "FS-380-HDS-020-SDS-010-SMS-120";

  pppoePairResult =
    pair:
    let
      hasProvider = pair ? provider && builtins.isAttrs pair.provider;
      hasCustomer = pair ? customer && builtins.isAttrs pair.customer;
      fallbackEnabled = pair ? fallback && pair.fallback == true;
      opaqueTransport =
        pair ? transportClassification && pair.transportClassification != "pppoe";
    in
    if !hasProvider && !hasCustomer then {
      ok = false;
      diagnostic = "unpaired-pppoe-row";
    } else if !hasProvider then {
      ok = false;
      diagnostic = "missing-provider-surface";
    } else if !hasCustomer then {
      ok = false;
      diagnostic = "missing-customer-surface";
    } else if fallbackEnabled then {
      ok = false;
      diagnostic = "fallback-enabled";
    } else if opaqueTransport then {
      ok = false;
      diagnostic = "opaque-transport-classification";
    } else {
      ok = true;
      diagnostic = null;
    };

  p2pRouteResult =
    lab: route:
    let
      hasLink = route ? link && builtins.hasAttr route.link lab.links;
      endpoints = if hasLink then lab.links.${route.link}.endpoints else [ ];
      sourceMatches =
        builtins.filter
          (endpoint: endpoint.target == route.sourceTarget)
          endpoints;
      nextHopMatches =
        builtins.filter
          (endpoint:
            (route ? via4 && endpoint ? address4 && endpoint.address4 == route.via4)
            || (route ? via6 && endpoint ? address6 && endpoint.address6 == route.via6))
          endpoints;
      nextHopIsSource =
        nextHopMatches != [ ]
        && sourceMatches != [ ]
        && (builtins.head nextHopMatches).target == (builtins.head sourceMatches).target;
    in
    if !hasLink then {
      ok = false;
      diagnostic = "p2p-link-missing";
    } else if sourceMatches == [ ] then {
      ok = false;
      diagnostic = "p2p-source-endpoint-missing";
    } else if nextHopMatches == [ ] then {
      ok = false;
      diagnostic = "p2p-next-hop-not-on-link";
    } else if nextHopIsSource then {
      ok = false;
      diagnostic = "p2p-next-hop-is-self";
    } else {
      ok = true;
      diagnostic = null;
    };

  reachabilityDecisionResult =
    relation:
    if !(relation ? id) || relation.id != "${reachabilityTraceId}__mini-allow-client-to-testnet" then {
      ok = false;
      diagnostic = "reachability-relation-id-missing";
      decisionClass = null;
    } else if !(relation ? action) then {
      ok = false;
      diagnostic = "reachability-action-missing";
      decisionClass = null;
    } else if relation.action == "allow" then {
      ok = true;
      diagnostic = null;
      decisionClass = "allowed";
    } else if relation.action == "deny" then {
      ok = true;
      diagnostic = null;
      decisionClass = "denied";
    } else {
      ok = false;
      diagnostic = "reachability-action-unsupported";
      decisionClass = null;
    };

  laneEgressBindingResult =
    relation:
    if !(relation ? id) || relation.id != "${laneEgressBindingTraceId}__mini-client-to-testnet-uplink" then {
      ok = false;
      diagnostic = "lane-egress-relation-id-missing";
    } else if !(relation ? action) then {
      ok = false;
      diagnostic = "lane-egress-action-missing";
    } else if relation.action == "allow" then {
      ok = true;
      diagnostic = null;
      expectedLaneKind = "access-uplink";
    } else {
      ok = false;
      diagnostic = "lane-egress-action-unsupported";
    };

  decisionReasonDiagnosticResult =
    path:
    let
      hasRelationId = path ? relationId && builtins.isString path.relationId;
      hasAction = path ? action && builtins.isString path.action;
      validId = hasRelationId && path.relationId == "${decisionReasonTraceId}__mini-decision-reason-diagnostic";
    in
    if !hasRelationId then {
      ok = false;
      diagnostic = "missing-evidence";
      reasonType = "missingEvidence";
    } else if !hasAction then {
      ok = false;
      diagnostic = "missing-action-field";
      reasonType = null;
    } else if !validId then {
      ok = false;
      diagnostic = "missing-evidence";
      reasonType = "missingEvidence";
    } else if path.action == "allow" then {
      ok = true;
      diagnostic = null;
      reasonType = null;
    } else if path.action == "deny" || path.action == "reject" then {
      ok = false;
      diagnostic = "contract-contradiction";
      reasonType = "contractContradiction";
    } else {
      ok = false;
      diagnostic = "unsupported-action";
      reasonType = null;
    };

  dnsResolverConfigResult =
    relation:
    let
      relationId = relation.id or null;
      from = if builtins.isAttrs (relation.from or null) then relation.from else { };
      to = if builtins.isAttrs (relation.to or null) then relation.to else { };
      isClientToService = relationId == "${dnsResolverConfigTraceId}__mini-client-to-access-dns";
      isServiceToTestnet = relationId == "${dnsResolverConfigTraceId}__mini-access-dns-service-to-testnet";
      isClientToTestnet = relationId == "${dnsResolverConfigTraceId}__mini-dns-client-to-testnet";
      isDnsTraffic = (relation.trafficType or null) == "dns";
      isAnyTraffic = (relation.trafficType or null) == "any";
      pointsAtTestnet = (to.uplinks or [ ]) == [ "testnet-vlan4" ];
    in
    if !(builtins.elem relationId dnsResolverRelationIds) then {
      ok = false;
      diagnostic = "dns-resolver-relation-id-missing";
    } else if !(relation ? action) then {
      ok = false;
      diagnostic = "dns-resolver-action-missing";
    } else if relation.action != "allow" then {
      ok = false;
      diagnostic = "dns-resolver-action-unsupported";
    } else if isClientToService && !(
      from.kind or null == "tenant"
      && from.name or null == "client"
      && to.kind or null == "service"
      && to.name or null == "access-dns"
      && isDnsTraffic
    ) then {
      ok = false;
      diagnostic = "dns-resolver-client-service-policy-missing";
    } else if isServiceToTestnet && !(
      from.kind or null == "service"
      && from.name or null == "access-dns"
      && to.kind or null == "external"
      && pointsAtTestnet
      && isDnsTraffic
    ) then {
      ok = false;
      diagnostic = "dns-resolver-service-egress-policy-missing";
    } else if isClientToTestnet && !(
      from.kind or null == "tenant"
      && from.name or null == "client"
      && to.kind or null == "external"
      && pointsAtTestnet
      && isAnyTraffic
    ) then {
      ok = false;
      diagnostic = "dns-resolver-client-egress-policy-missing";
    } else {
      ok = true;
      diagnostic = null;
    };

  internetModeVerificationResult =
    record:
    let
      hasSkip =
        (record.skipInternet or false)
        || (record.skipInternetTest or false)
        || (record ? skipReason);
      hasNat = record ? privateNat44 || record ? nat44 || record ? nat || record ? masquerade;
      handoff = record.accessHandoff or { };
      upstream = record.upstream or { };
      uplinks = upstream.internetUplinks or [ ];
      allowedVlan = vlan: vlan == 4 || vlan == 5;
      allowedUplinkName = name: name == "isp" || name == "pppoe-provider";
      allowedHandoffKind =
        kind:
        kind == "pppoe" || kind == "dhcp-provider" || kind == "routed-testnet";
      uplinkOk =
        uplink:
        uplink ? name
        && allowedUplinkName uplink.name
        && (uplink.mode or null) == "dhcp";
      hasVlan2 = builtins.any (uplink: (uplink.vlan or null) == 2 || (uplink.name or null) == "vlan2") uplinks;
      hasBadVlan = builtins.any (uplink: uplink ? vlan && !(allowedVlan uplink.vlan)) uplinks;
      hasBadUplinkName =
        builtins.any (uplink: uplink ? name && !(allowedUplinkName uplink.name)) uplinks;
      hasBadMode = builtins.any (uplink: (uplink.mode or null) != "dhcp") uplinks;
    in
    if hasSkip then {
      ok = false;
      diagnostic = "internet-test-skip-not-allowed";
    } else if hasNat then {
      ok = false;
      diagnostic = "nat-not-allowed";
    } else if !(handoff ? kind) then {
      ok = false;
      diagnostic = "missing-emulated-access-handoff";
    } else if !(allowedHandoffKind handoff.kind) then {
      ok = false;
      diagnostic = "unsupported-emulated-access-handoff";
    } else if (handoff.server or null) != "emulated-isp" then {
      ok = false;
      diagnostic = "access-handoff-server-not-emulated-isp";
    } else if (handoff.client or null) != "client-edge" then {
      ok = false;
      diagnostic = "access-handoff-client-not-test-client";
    } else if (upstream.kind or null) != "emulated-isp" then {
      ok = false;
      diagnostic = "upstream-not-emulated-isp";
    } else if uplinks == [ ] then {
      ok = false;
      diagnostic = "missing-internet-uplinks";
    } else if hasVlan2 then {
      ok = false;
      diagnostic = "vlan2-not-allowed";
    } else if hasBadVlan then {
      ok = false;
      diagnostic = "internet-vlan-not-allowed";
    } else if hasBadUplinkName then {
      ok = false;
      diagnostic = "internet-uplink-not-allowed";
    } else if hasBadMode then {
      ok = false;
      diagnostic = "internet-uplink-must-use-dhcp";
    } else if !(builtins.all uplinkOk uplinks) then {
      ok = false;
      diagnostic = "invalid-internet-uplink";
    } else {
      ok = true;
      diagnostic = null;
    };
in
{
  meta = {
    contract = "active-lab mini SMT fixtures";
    scope = "one SMS/SMT atom per mini-lab; not HAT/SAT approval";
    defaultRule = "A mini SMT may start only the runtime targets declared by that mini-lab.";
  };

  validators = {
    pppoePair = pppoePairResult;
    reachabilityDecision = reachabilityDecisionResult;
    p2pRoute = p2pRouteResult;
    laneEgressBinding = laneEgressBindingResult;
    decisionReasonDiagnostic = decisionReasonDiagnosticResult;
    dnsResolverConfig = dnsResolverConfigResult;
    internetModeVerification = internetModeVerificationResult;
  };

  labs = {
    "${pppoeTraceId}" = {
      kind = "mini-smt";
      traceId = pppoeTraceId;
      smsAtom = "PPPoE provider/customer pairing and fallback rejection";
      evidenceBoundary = "mini-lab shape; runtime evidence must use a live mini runner that starts exactly this five-target policy path";
      source = {
        kind = "intent-source";
        intent = ../FS-800-HDS-030-SDS-030-SMS-010/intent.nix;
        expectedRelationIds = [
          "FS-800-HDS-030-SDS-030-SMS-010__mini-pppoe-client-to-provider"
        ];
      };
      maxRuntimeTargets = 5;
      runtimeTargets = {
        pppoe-client = {
          role = "pppoe-client";
          interface = "wan0";
          runtimeInterface = "ppp0";
        };
        downstream-selector = {
          role = "downstream-selector";
        };
        policy = {
          role = "policy";
        };
        upstream-selector = {
          role = "upstream-selector";
        };
        pppoe-provider = {
          role = "pppoe-provider";
          uplink = "pppoe-provider";
        };
      };
      pppoePairs = {
        primary = {
          provider = {
            target = "pppoe-provider";
            handoff = "pppoe";
            routeDeliveryClass = "connected";
          };
          customer = {
            target = "pppoe-client";
            coreInterface = "wan0";
            runtimeInterface = "ppp0";
            routeAuthority = "connected";
          };
          fallback = false;
          transportClassification = "pppoe";
        };
      };
      testsOnly = [
        "provider-customer-pairing"
        "fallback-rejection"
        "transport-classification"
      ];
      forbiddenScope = [
        "active-lab/full"
        "HAT"
        "SAT"
      ];
    };

    "${reachabilityTraceId}" = {
      kind = "mini-smt";
      traceId = reachabilityTraceId;
      smsAtom = "reachability decision result classification";
      evidenceBoundary = "mini-lab shape; runtime evidence must use a live mini runner that starts exactly these targets";
      source = {
        kind = "intent-source";
        intent = ../FS-500-HDS-010-SDS-010-SMS-010/intent.nix;
        expectedRelationIds = [
          "FS-500-HDS-010-SDS-010-SMS-010__mini-allow-client-to-testnet"
        ];
      };
      maxRuntimeTargets = 5;
      runtimeTargets = {
        client-edge = {
          role = "access";
          tenant = "client";
        };
        downstream-selector = {
          role = "downstream-selector";
        };
        policy = {
          role = "policy";
        };
        upstream-selector = {
          role = "upstream-selector";
          external = "testnet";
        };
        vlan4-client-dhcp-slaac = {
          role = "core";
          external = "testnet";
        };
      };
      reachabilityRelations = [
        {
          id = "FS-500-HDS-010-SDS-010-SMS-010__mini-allow-client-to-testnet";
          action = "allow";
          from = {
            kind = "tenant";
            name = "client";
          };
          to = {
            kind = "external";
            name = "testnet";
          };
          trafficType = "any";
          expectedDecisionClass = "allowed";
        }
      ];
      testsOnly = [
        "reachability-decision-class"
        "deny-not-elevated"
      ];
      forbiddenScope = [
        "active-lab/full"
        "HAT"
        "SAT"
      ];
      liveSurfaces = [
        "s-router-nixos"
        "s-router-clab"
        "s-router-test-clients"
      ];
    };

    "${p2pTraceId}" = {
      kind = "mini-smt";
      traceId = p2pTraceId;
      smsAtom = "point-to-point next-hop pairing";
      evidenceBoundary = "mini-lab shape; runtime evidence must use a live mini runner that starts exactly these targets";
      source = {
        kind = "intent-source";
        intent = ../FS-500-HDS-010-SDS-010-SMS-040/intent.nix;
        expectedRelationIds = [
          "FS-500-HDS-010-SDS-010-SMS-040__mini-p2p-route-to-peer"
        ];
      };
      maxRuntimeTargets = 5;
      runtimeTargets = {
        router-a = {
          role = "router";
          interfaces = {
            p2p-ab = {
              address4 = "10.0.0.0";
              prefixLength4 = 31;
            };
          };
        };
        router-b = {
          role = "router";
          interfaces = {
            p2p-ab = {
              address4 = "10.0.0.1";
              prefixLength4 = 31;
            };
          };
        };
        downstream-selector = {
          role = "downstream-selector";
        };
        policy = {
          role = "policy";
        };
        upstream-selector = {
          role = "upstream-selector";
          external = "testnet";
        };
      };
      links = {
        p2p-ab = {
          kind = "p2p";
          endpoints = [
            {
              target = "router-a";
              interface = "p2p-ab";
              address4 = "10.0.0.0";
            }
            {
              target = "router-b";
              interface = "p2p-ab";
              address4 = "10.0.0.1";
            }
          ];
        };
      };
      expectedRoutes = [
        {
          sourceTarget = "router-a";
          link = "p2p-ab";
          dst = "10.20.0.0/24";
          via4 = "10.0.0.1";
        }
      ];
      testsOnly = [
        "p2p-peer-next-hop"
        "route-renderability-shape"
        "five-node-runtime-shape"
      ];
      forbiddenScope = [
        "active-lab/full"
        "HAT"
        "SAT"
      ];
      liveSurfaces = [
        "s-router-nixos"
        "s-router-clab"
        "s-router-test-clients"
      ];
    };

    "${laneEgressBindingTraceId}" = {
      kind = "mini-smt";
      traceId = laneEgressBindingTraceId;
      smsAtom = "CPM lane egress binding: forwardingIntent lane annotations with access-uplink kind and non-null uplink";
      evidenceBoundary = "split: construction predicate plus active-lab live evidence on the declared five-target lane path";
      source = {
        kind = "intent-source";
        intent = ../FS-370-HDS-010-SDS-010-SMS-050/intent.nix;
        expectedRelationIds = [
          "FS-370-HDS-010-SDS-010-SMS-050__mini-client-to-testnet-uplink"
        ];
      };
      maxRuntimeTargets = 5;
      runtimeTargets = {
        client-edge = {
          role = "access";
          tenant = "client";
        };
        downstream-selector = {
          role = "downstream-selector";
        };
        policy = {
          role = "policy";
        };
        upstream-selector = {
          role = "upstream-selector";
          external = "testnet";
        };
        vlan4-client-dhcp-slaac = {
          role = "core";
          external = "testnet";
        };
      };
      laneEgressRelations = [
        {
          id = "FS-370-HDS-010-SDS-010-SMS-050__mini-client-to-testnet-uplink";
          action = "allow";
          from = {
            kind = "tenant";
            name = "client";
          };
          to = {
            kind = "external";
            name = "testnet";
          };
          trafficType = "any";
          expectedLaneKind = "access-uplink";
        }
      ];
      testsOnly = [
        "lane-egress-binding"
        "lane-uplink-annotation"
        "five-node-lane-runtime-shape"
      ];
      forbiddenScope = [
        "active-lab/full"
        "HAT"
        "SAT"
      ];
      liveSurfaces = [
        "s-router-nixos"
        "s-router-clab"
        "s-router-test-clients"
      ];
    };

    "${decisionReasonTraceId}" = {
      kind = "mini-smt";
      traceId = decisionReasonTraceId;
      smsAtom = "decision reason diagnostic: traffic-path validation against communication contract";
      evidenceBoundary = "mini-lab shape; runtime evidence must use a live mini runner that starts exactly these targets";
      source = {
        kind = "intent-source";
        intent = ../FS-500-HDS-010-SDS-010-SMS-030/intent.nix;
        expectedRelationIds = [
          "FS-500-HDS-010-SDS-010-SMS-030__mini-decision-reason-diagnostic"
        ];
      };
      maxRuntimeTargets = 5;
      runtimeTargets = {
        client-edge = {
          role = "access";
          tenant = "client";
        };
        downstream-selector = {
          role = "downstream-selector";
        };
        policy = {
          role = "policy";
        };
        upstream-selector = {
          role = "upstream-selector";
        };
        vlan4-client-dhcp-slaac = {
          role = "external";
          external = "testnet";
        };
      };
      decisionReasonRelations = [
        {
          id = "FS-500-HDS-010-SDS-010-SMS-030__mini-decision-reason-diagnostic";
          action = "allow";
          from = {
            kind = "tenant";
            name = "client";
          };
          to = {
            kind = "external";
            name = "testnet";
          };
          trafficType = "any";
        }
      ];
      testsOnly = [
        "decision-reason-diagnostic-class"
        "missing-evidence-detection"
        "contract-contradiction-detection"
        "five-node-diagnostic-runtime-shape"
      ];
      forbiddenScope = [
        "active-lab/full"
        "HAT"
        "SAT"
      ];
      liveSurfaces = [
        "s-router-nixos"
        "s-router-clab"
        "s-router-test-clients"
      ];
    };

    "${wireguardRemoteEgressTraceId}" = {
      kind = "mini-smt";
      traceId = wireguardRemoteEgressTraceId;
      smsAtom = "WireGuard remote egress provider runtime materialization";
      evidenceBoundary = "renderer-input CPM source plus active-lab live evidence on the declared one-target WireGuard remote-egress runtime";
      source = {
        kind = "renderer-input";
        cpm = ../FS-470-HDS-010-SDS-010-SMS-010/renderer-input/wireguard-remote-egress-cpm.nix;
      };
      maxRuntimeTargets = 1;
      runtimeTargets = {
        wireguard-remote-egress = {
          role = "provider-egress";
          placement.host = "s-router-nixos";
          overlay = "wg-remote-egress";
          interface = "wg-re-egress0";
          providerContract = "controlPlane.providerContracts.wireguard.wg-remote-egress";
        };
      };
      testsOnly = [
        "provider-runtime-contract-presence"
        "wireguard-hostmodule-runtime-import"
        "source-scoped-nat44-nat66"
        "dhcp4-ra-rdnss"
        "bootstrap-payload-separation"
      ];
      forbiddenScope = [
        "active-lab/full"
        "HAT"
        "SAT"
      ];
      liveSurfaces = [
        "s-router-nixos"
      ];
    };

    "${dnsResolverConfigTraceId}" = {
      kind = "mini-smt";
      traceId = dnsResolverConfigTraceId;
      smsAtom = "CPM per-interface DNS resolver configuration authority over the smallest requester-policy-resolver path";
      evidenceBoundary = "mini-lab shape; runtime evidence must use a live mini runner that starts exactly these targets";
      source = {
        kind = "intent-source";
        intent = ../FS-540-HDS-010-SDS-010-SMS-020/intent.nix;
        expectedRelationIds = dnsResolverRelationIds;
      };
      maxRuntimeTargets = 5;
      runtimeTargets = {
        access-dns = {
          role = "access";
          tenant = "client";
        };
        downstream-selector = {
          role = "downstream-selector";
        };
        policy = {
          role = "policy";
        };
        upstream-selector = {
          role = "upstream-selector";
          external = "testnet-vlan4";
        };
        resolver-node = {
          role = "core";
          external = "testnet-vlan4";
        };
      };
      dnsResolverRelations = [
        {
          id = "FS-540-HDS-010-SDS-010-SMS-020__mini-client-to-access-dns";
          action = "allow";
          from = {
            kind = "tenant";
            name = "client";
          };
          to = {
            kind = "service";
            name = "access-dns";
          };
          trafficType = "dns";
        }
        {
          id = "FS-540-HDS-010-SDS-010-SMS-020__mini-access-dns-service-to-testnet";
          action = "allow";
          from = {
            kind = "service";
            name = "access-dns";
          };
          to = {
            kind = "external";
            uplinks = [ "testnet-vlan4" ];
          };
          trafficType = "dns";
        }
        {
          id = "FS-540-HDS-010-SDS-010-SMS-020__mini-dns-client-to-testnet";
          action = "allow";
          from = {
            kind = "tenant";
            name = "client";
          };
          to = {
            kind = "external";
            uplinks = [ "testnet-vlan4" ];
          };
          trafficType = "any";
        }
      ];
      testsOnly = [
        "dns-resolver-relation-id"
        "dns-resolver-action-class"
        "dns-recursive-service-relation"
        "dns-service-egress-relation"
        "dns-resolver-minimal-policy-path"
      ];
      forbiddenScope = [
        "active-lab/full"
        "s-router-nixos"
        "s-router-clab"
        "s-router-test-clients"
        "HAT"
        "SAT"
      ];
    };

    "${internetModeTraceId}" = {
      kind = "mini-smt";
      traceId = internetModeTraceId;
      smsAtom = "internet mode verification: emulated ISP upstream fed only by VLAN4/VLAN5 DHCP";
      evidenceBoundary = "mini-lab shape; runtime evidence must use a live mini runner that starts exactly these targets";
      source = {
        kind = "intent-source";
        intent = ../FS-380-HDS-020-SDS-010-SMS-050/intent.nix;
        expectedRelationIds = [
          "FS-380-HDS-020-SDS-010-SMS-050__mini-client-to-emulated-isp"
        ];
      };
      maxRuntimeTargets = 2;
      runtimeTargets = {
        client-edge = {
          role = "access";
          tenant = "client";
          accessHandoff = {
            kind = "pppoe";
            server = "emulated-isp";
          };
        };
        emulated-isp = {
          role = "emulated-isp";
          accessServices = [
            {
              kind = "pppoe-server";
              client = "client-edge";
            }
          ];
          internetUplinks = [
            {
              vlan = 4;
              mode = "dhcp";
            }
            {
              vlan = 5;
              mode = "dhcp";
            }
          ];
        };
      };
      internetModeRecords = [
        {
          accessHandoff = {
            kind = "pppoe";
            client = "client-edge";
            server = "emulated-isp";
          };
          upstream = {
            kind = "emulated-isp";
            internetUplinks = [
              {
                name = "isp";
                mode = "dhcp";
              }
              {
                name = "pppoe-provider";
                mode = "dhcp";
              }
            ];
          };
        }
      ];
      testsOnly = [
        "internet-mode-emulated-pppoe-handoff"
        "internet-mode-emulated-isp-upstream"
        "internet-mode-vlan4-vlan5-dhcp"
        "internet-mode-no-skip"
        "internet-mode-no-nat"
        "internet-mode-no-vlan2"
      ];
      forbiddenScope = [
        "active-lab/full"
        "s-router-nixos"
        "s-router-clab"
        "s-router-test-clients"
        "HAT"
        "SAT"
      ];
    };

    "${prodLikeVlan4TraceId}" = {
      kind = "mini-smt";
      traceId = prodLikeVlan4TraceId;
      smsAtom = "prod-like IPv4 client egress and access DNS recursion through the five-node selector chain to a VLAN4 NAT upstream";
      evidenceBoundary = "mini-lab shape; runtime evidence must use a live mini runner that starts exactly these router targets plus the s-router-test-clients endpoint";
      source = {
        kind = "intent-source";
        intent = ../FS-380-HDS-020-SDS-010-SMS-120/intent.nix;
        expectedRelationIds = [
          "FS-380-HDS-020-SDS-010-SMS-120__prod-like-client-to-access-dns"
          "FS-380-HDS-020-SDS-010-SMS-120__prod-like-access-dns-to-vlan4"
          "FS-380-HDS-020-SDS-010-SMS-120__prod-like-client-to-vlan4-internet"
        ];
      };
      maxRuntimeTargets = 5;
      runtimeTargets = {
        access-vlan2 = {
          role = "access";
          tenant = "client";
        };
        downstream-selector = {
          role = "downstream-selector";
        };
        policy = {
          role = "policy";
        };
        upstream-selector = {
          role = "upstream-selector";
          external = "internet-vlan4";
        };
        core = {
          role = "core";
          external = "internet-vlan4";
          internetUplinks = [
            {
              name = "internet-vlan4";
              vlan = 4;
              mode = "dhcp";
            }
          ];
        };
      };
      expectedPath = [
        "access-vlan2"
        "downstream-selector"
        "policy"
        "upstream-selector"
        "core"
      ];
      clientEndpoint = {
        host = "s-router-test-clients";
        name = "prod-like-vlan4-client01";
        bridge = "client";
        address4 = "10.38.120.10";
        gateway4 = "10.38.120.1";
      };
      testsOnly = [
        "prod-like-five-node-ipv4-chain"
        "real-s-router-test-clients-endpoint"
        "vlan4-dhcp-upstream"
        "private-nat44-source-prefix"
        "access-dns-runtime-origin-egress"
        "no-pppoe-dependency"
        "no-prod-lan-cidr"
      ];
      liveSurfaces = [
        "s-router-nixos"
        "s-router-test-clients"
      ];
      forbiddenScope = [
        "active-lab/full"
        "HAT"
        "SAT"
      ];
    };

    "${prodLikeRecursiveDnsTraceId}" = {
      kind = "mini-smt";
      traceId = prodLikeRecursiveDnsTraceId;
      smsAtom = "prod-like recursive DNS from a real access-vlan2 client through downstream-selector, policy, upstream-selector, and core to VLAN4";
      evidenceBoundary = "split: source contract plus live runtime evidence from s-router-nixos, s-router-clab, and s-router-test-clients";
      source = {
        kind = "intent-source";
        intent = ../FS-540-HDS-010-SDS-010-SMS-045/intent.nix;
        expectedRelationIds = [
          "FS-540-HDS-010-SDS-010-SMS-045__prod-like-client-to-access-dns"
          "FS-540-HDS-010-SDS-010-SMS-045__prod-like-access-dns-to-vlan4"
          "FS-540-HDS-010-SDS-010-SMS-045__prod-like-client-to-vlan4-internet"
        ];
      };
      maxRuntimeTargets = 5;
      runtimeTargets = {
        access-vlan2 = {
          role = "access";
          tenant = "client";
        };
        downstream-selector = {
          role = "downstream-selector";
        };
        policy = {
          role = "policy";
        };
        upstream-selector = {
          role = "upstream-selector";
          external = "internet-vlan4";
        };
        core = {
          role = "core";
          external = "internet-vlan4";
          internetUplinks = [
            {
              name = "internet-vlan4";
              vlan = 4;
              mode = "dhcp";
            }
          ];
        };
      };
      expectedPath = [
        "access-vlan2"
        "downstream-selector"
        "policy"
        "upstream-selector"
        "core"
      ];
      clientEndpoint = {
        host = "s-router-test-clients";
        name = "prod-like-dns-client01";
        bridge = "dnsclient";
        address4 = "10.54.45.10";
        gateway4 = "10.54.45.1";
        resolver4 = "10.54.45.1";
      };
      testsOnly = [
        "prod-like-five-node-recursive-dns-chain"
        "explicit-client-to-access-dns-relation"
        "explicit-access-dns-to-vlan4-egress-relation"
        "real-s-router-test-clients-endpoint"
        "vlan4-dhcp-upstream"
        "access-dns-runtime-origin-egress"
        "client-resolver-advertisement-to-access-gateway"
        "no-pppoe-dependency"
        "no-prod-lan-cidr"
      ];
      liveSurfaces = [
        "s-router-nixos"
        "s-router-clab"
        "s-router-test-clients"
      ];
      forbiddenScope = [
        "active-lab/full"
        "HAT"
        "SAT"
      ];
    };
  };
}
