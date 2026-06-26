let
  pppoeTraceId = "FS-800-HDS-030-SDS-030-SMS-010";
  reachabilityTraceId = "FS-500-HDS-010-SDS-010-SMS-010";
  p2pTraceId = "FS-500-HDS-010-SDS-010-SMS-040";

  pppoePairResult =
    pair:
    let
      hasProvider = pair ? provider && builtins.isAttrs pair.provider;
      hasCustomer = pair ? customer && builtins.isAttrs pair.customer;
      fallbackEnabled = pair ? fallback && pair.fallback == true;
      opaqueTransport =
        pair ? transportClassification && pair.transportClassification != "pppoe";
    in
    if !hasProvider then {
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
  };

  labs = {
    "${pppoeTraceId}" = {
      kind = "mini-smt";
      traceId = pppoeTraceId;
      smsAtom = "PPPoE provider/customer pairing and fallback rejection";
      evidenceBoundary = "mini-lab shape; runtime evidence must use a live mini runner that starts exactly these targets";
      source = {
        kind = "intent-source";
        intent = ../FS-800-HDS-030-SDS-030-SMS-010/intent.nix;
        expectedRelationIds = [
          "FS-800-HDS-030-SDS-030-SMS-010__mini-pppoe-client-to-provider"
        ];
      };
      maxRuntimeTargets = 2;
      runtimeTargets = {
        pppoe-client = {
          role = "pppoe-client";
          interface = "wan0";
          runtimeInterface = "ppp0";
        };
        pppoe-server = {
          role = "pppoe-server";
          interface = "wan0";
          service = "accel-ppp";
        };
      };
      pppoePairs = {
        primary = {
          provider = {
            target = "pppoe-server";
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
        "s-router-nixos"
        "s-router-clab"
        "s-router-test-clients"
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
      maxRuntimeTargets = 2;
      runtimeTargets = {
        client-edge = {
          role = "access";
          tenant = "client";
        };
        testnet-edge = {
          role = "external";
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
        "s-router-nixos"
        "s-router-clab"
        "s-router-test-clients"
        "HAT"
        "SAT"
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
      maxRuntimeTargets = 2;
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
  };
}
