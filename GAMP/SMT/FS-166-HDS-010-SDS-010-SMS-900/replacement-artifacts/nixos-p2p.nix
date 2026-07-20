let
  traceId = "FS-166-HDS-010-SDS-010-SMS-902";
  mkTarget = name: address4: address6: peer4: peer6: {
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
      peer = {
        ipv4 = peer4;
        ipv6 = peer6;
      };
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
        edge-a = mkTarget "edge-a" "10.200.0.0/31" "fd42:200::/127" "10.200.0.1" "fd42:200::1";
        edge-b = mkTarget "edge-b" "10.200.0.1/31" "fd42:200::1/127" "10.200.0.0" "fd42:200::";
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
