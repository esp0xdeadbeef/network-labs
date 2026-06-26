{
  "mini-smt" = {
    "bidirectional-nft" = {
      communicationContract = {
        interfaceTags = {
          tenant-tenant-a = "tenant-a";
          tenant-tenant-b = "tenant-b";
        };
        relations = [
          {
            id = "FS-180-HDS-010-SDS-010-SMS-040__mini-bidirectional-web";
            action = "allow";
            returnBehavior = "symmetric";
            from = {
              kind = "tenant";
              name = "tenant-a";
            };
            to = {
              kind = "tenant";
              name = "tenant-b";
            };
            trafficType = "web";
          }
        ];
        services = [ ];
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
            name = "tenant-a";
            ipv4 = "10.180.10.0/24";
            ipv6 = "fd42:180:4010::/64";
          }
          {
            kind = "tenant";
            name = "tenant-b";
            ipv4 = "10.180.20.0/24";
            ipv6 = "fd42:180:4020::/64";
          }
        ];
      };
      pools = {
        p2p = {
          ipv4 = "10.180.0.0/24";
          ipv6 = "fd42:180:40ff::/118";
        };
      };
      topology = {
        links = [
          [
            "router-a"
            "router-b"
          ]
        ];
        nodes = {
          router-a = {
            role = "access";
            attachments = [
              {
                kind = "tenant";
                name = "tenant-a";
              }
            ];
          };
          router-b = {
            role = "access";
            attachments = [
              {
                kind = "tenant";
                name = "tenant-b";
              }
            ];
          };
        };
      };
    };
  };
}
