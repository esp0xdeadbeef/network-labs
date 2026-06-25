let
  pppoeTraceId = "FS-800-HDS-030-SDS-030-SMS-010";
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
in
{
  meta = {
    contract = "active-lab mini SMT fixtures";
    scope = "one SMS/SMT atom per mini-lab; not HAT/SAT approval";
    defaultRule = "A mini SMT may start only the runtime targets declared by that mini-lab.";
  };

  validators = {
    pppoePair = pppoePairResult;
    p2pRoute = p2pRouteResult;
  };

  labs = {
    "${pppoeTraceId}" = {
      kind = "mini-smt";
      traceId = pppoeTraceId;
      smsAtom = "PPPoE provider/customer pairing and fallback rejection";
      evidenceBoundary = "mini-lab shape; runtime evidence must use a live mini runner that starts exactly these targets";
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

    "${p2pTraceId}" = {
      kind = "mini-smt";
      traceId = p2pTraceId;
      smsAtom = "point-to-point next-hop pairing";
      evidenceBoundary = "mini-lab shape; runtime evidence must use a live mini runner that starts exactly these targets";
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
