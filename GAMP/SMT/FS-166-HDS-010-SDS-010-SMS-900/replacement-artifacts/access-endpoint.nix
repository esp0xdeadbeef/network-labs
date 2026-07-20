let
  traceId = "FS-166-HDS-010-SDS-010-SMS-903";
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
      endpointAssignment.poc-client = {
        name = "poc-client";
        tenant = "client";
        mode = "static";
        static = {
          address = "10.201.0.10";
          address6 = "fd42:201::10";
          prefixLength = 24;
          prefixLength6 = 64;
          gateway4 = "10.201.0.1";
          gateway6 = "fd42:201::1";
        };
      };
    };
  };
}
