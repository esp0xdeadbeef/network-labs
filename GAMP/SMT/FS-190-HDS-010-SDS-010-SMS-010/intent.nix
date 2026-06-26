{
  "mini-smt" = {
    "service-exposure-classification" = {
      communicationContract = {
        interfaceTags = {
          tenant-client = "client";
        };
        relations = [ ];
        services = [
          {
            name = "web-service";
            kind = "shared-local";
            exposureClass = "shared-local";
            ownerScope = {
              kind = "tenant";
              name = "client";
            };
            requesterScope = {
              kind = "tenant";
              name = "client";
            };
          }
        ];
        trafficTypes = [
          {
            name = "web";
            match = [
              {
                family = "ipv4";
                proto = "tcp";
                port = 443;
              }
            ];
          }
        ];
      };
      ownership = {
        prefixes = [
          {
            kind = "tenant";
            name = "client";
            ipv4 = "10.190.10.0/24";
            ipv6 = "fd42:190:4010::/64";
          }
        ];
      };
      topology = {
        links = [
          [
            "access-node"
            "core-node"
          ]
        ];
        nodes = {
          access-node = {
            role = "access";
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
          };
          core-node = {
            role = "core";
          };
        };
      };
    };
  };
}
