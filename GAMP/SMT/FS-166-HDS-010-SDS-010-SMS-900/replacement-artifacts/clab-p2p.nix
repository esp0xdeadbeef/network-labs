let
  traceId = "FS-166-HDS-010-SDS-010-SMS-904";
  mkTarget = name: address4: address6: {
    logicalNode = {
      enterprise = "acme";
      site = "lab";
      inherit name;
    };
    role = "core";
    routingMode = "static";
    effectiveRuntimeRealization.interfaces.edge-a-b = {
      sourceKind = "p2p";
      addr4 = address4;
      addr6 = address6;
      backingRef = {
        kind = "logical-link";
        id = "edge-a-b";
      };
    };
  };
in
import ./mk-artifact.nix {
  inherit traceId;
  controlPlaneModel = {
    meta = {
      inherit traceId;
      sourceContract = "network-control-plane-artifact/v1";
    };
    data.acme.lab = {
      enterprise = "acme";
      siteName = "acme.lab";
      runtimeTargets = {
        edge-a = mkTarget "edge-a" "10.204.0.0/31" "fd42:204::/127";
        edge-b = mkTarget "edge-b" "10.204.0.1/31" "fd42:204::1/127";
      };
      transit.adjacencies = [
        {
          name = "edge-a-b";
          link = "edge-a-b";
          kind = "p2p";
          endpoints = [
            { unit = "edge-a"; }
            { unit = "edge-b"; }
          ];
        }
      ];
    };
  };
}
