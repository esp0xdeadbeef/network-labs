{
  meta = {
    traceId = "FS-100-HDS-010-SDS-010-SMS-050";
    scope = "row-local-smt-sit-source-stub";
    evidenceBoundary = "source-stub-only";
  };
  "mini-smt" = {
    "fs_100_hds_010_sds_010_sms_050" = {
      communicationContract = {
        interfaceTags = {
          tenant-client = "client";
          external-testnet = "testnet";
        };
        relations = [
          {
            id = "FS-100-HDS-010-SDS-010-SMS-050__row-local-client-to-testnet";
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
