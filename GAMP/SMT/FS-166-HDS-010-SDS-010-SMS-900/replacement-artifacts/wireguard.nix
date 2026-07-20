let
  traceId = "FS-166-HDS-010-SDS-010-SMS-905";
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
      runtimeTargets.wireguard-egress = {
        logicalNode = {
          enterprise = "acme";
          site = "lab";
          name = "wireguard-egress";
        };
        role = "access";
        routingMode = "static";
      };
      overlays.wg-lab = {
        type = "wireguard";
        terminateOn = [ "wireguard-egress" ];
        nodes.wireguard-egress = {
          addr4 = "10.205.0.2/32";
          addr6 = "fd42:205::2/128";
        };
      };
    };
  };
}
