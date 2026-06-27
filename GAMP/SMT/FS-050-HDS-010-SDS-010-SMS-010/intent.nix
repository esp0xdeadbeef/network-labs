{
  "mini-smt" = {
    "protected-inventory-boundary" = {
      communicationContract = {
        interfaceTags = {
          tenant-client = "client";
          external-testnet = "testnet";
        };
        relations = [
          {
            id = "FS-050-HDS-010-SDS-010-SMS-010__mini-client-to-testnet-protected";
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "external";
              name = "testnet";
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
      topology = {
        links = [
          [
            "client-edge"
            "testnet-edge"
          ]
        ];
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
          testnet-edge = {
            role = "external";
            external = "testnet";
          };
        };
      };
    };
  };
}
