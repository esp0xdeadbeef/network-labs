let
  traceId = "FS-166-HDS-010-SDS-010-SMS-906";
  mkTarget = name: {
    logicalNode = {
      enterprise = "acme";
      site = "lab";
      inherit name;
    };
    role = "access";
    routingMode = "static";
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
        lab-client-nebula = mkTarget "lab-client-nebula";
        lab-lighthouse = mkTarget "lab-lighthouse";
      };
      overlays.nebula-lab = {
        type = "nebula";
        nodes = {
          lab-client-nebula = {
            addr4 = "10.206.0.2/24";
            addr6 = "fd42:206::2/64";
          };
          lab-lighthouse = {
            addr4 = "10.206.0.1/24";
            addr6 = "fd42:206::1/64";
          };
        };
        lighthouse.node = "lab-lighthouse";
      };
    };
  };
}
