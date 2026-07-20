let
  traceId = "FS-166-HDS-010-SDS-010-SMS-901";
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
      runtimeTargets.poc-router = {
        logicalNode = {
          enterprise = "acme";
          site = "lab";
          name = "poc-router";
        };
        role = "access";
        routingMode = "static";
      };
    };
  };
}
