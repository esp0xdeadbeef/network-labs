{
  "mini-smt" = {
    "endpoint-harness-consumption" = {
      communicationContract = {
        interfaceTags = {
          tenant-client = "client";
          tenant-printer = "printer";
          tenant-receiver = "receiver";
        };
        relations = [
          {
            id = "FS-720-HDS-010-SDS-020-SMS-020__mini-client-harness-consumption";
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "tenant";
              name = "printer";
            };
            trafficType = "any";
            priority = 100;
          }
        ];
        services = [ ];
        trafficTypes = [
          {
            name = "any";
            match = [
              {
                family = "any";
                proto = "any";
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
            ipv4 = "10.50.20.0/24";
            ipv6 = "fd42:mini:720:20::/64";
          }
          {
            kind = "tenant";
            name = "printer";
            ipv4 = "10.50.30.0/24";
            ipv6 = "fd42:mini:720:30::/64";
          }
          {
            kind = "tenant";
            name = "receiver";
            ipv4 = "10.50.40.0/24";
            ipv6 = "fd42:mini:720:40::/64";
          }
        ];
      };
      pools = {
        loopback = {
          ipv4 = "10.50.0.0/24";
          ipv6 = "fd42:mini:720:ff::/118";
        };
        p2p = {
          ipv4 = "10.50.255.0/24";
          ipv6 = "fd42:mini:720:fe::/118";
        };
      };
      topology = {
        links = [ ];
        nodes = {
          client-edge = {
            role = "access";
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
          };
          printer-edge = {
            role = "access";
            attachments = [
              {
                kind = "tenant";
                name = "printer";
              }
            ];
          };
          receiver-edge = {
            role = "access";
            attachments = [
              {
                kind = "tenant";
                name = "receiver";
              }
            ];
          };
        };
      };
    };
  };
}
