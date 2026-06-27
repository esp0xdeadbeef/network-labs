{
  meta = {
    traceId = "FS-410-HDS-010-SDS-010-SMS-040";
    scope = "row-local-smt-sit-source-stub";
    evidenceBoundary = "source-stub-only";
  };
  "mini-smt" = {
    "fs_410_hds_010_sds_010_sms_040" = {
      communicationContract = {
        interfaceTags = {
          tenant-client = "client";
          external-testnet = "testnet";
        };
        relations = [
          {
            id = "FS-410-HDS-010-SDS-010-SMS-040__row-local-client-to-testnet";
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
