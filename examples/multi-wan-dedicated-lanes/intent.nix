{
  esp0xdeadbeef.site-a = {
    # Enable policy-derived "dedicated transit lanes" so intent/egress constraints can
    # force multiple parallel L2 segments between staged units (no renderer inference).
    transit.dedicatedLanes = true;

    pools = {
      p2p = {
        ipv4 = "10.10.0.0/24";
        ipv6 = "fd42:dead:beef:1000::/118";
      };
      loopback = {
        ipv4 = "10.19.0.0/24";
        ipv6 = "fd42:dead:beef:1900::/118";
      };
    };

    ownership.prefixes = [
      {
        kind = "tenant";
        name = "mgmt";
        ipv4 = "10.20.10.0/24";
        ipv6 = "fd42:dead:beef:20::/64";
      }
      {
        kind = "tenant";
        name = "adm";
        ipv4 = "10.21.10.0/24";
        ipv6 = "fd42:dead:beef:21::/64";
      }
    ];

    communicationContract = {
      trafficTypes = [ ];
      services = [ ];

      relations = [
        {
          id = "allow-tenants-to-uplinks";
          priority = 100;
          from = {
            kind = "tenant-set";
            members = [
              "mgmt"
              "adm"
            ];
          };
          to = {
            kind = "external";
            uplinks = [
              "isp-a"
              "isp-b"
            ];
          };
          trafficType = "any";
          action = "allow";
        }
      ];

      interfaceTags = {
        tenant-mgmt = "mgmt";
        tenant-adm = "adm";
        external-isp-a = "isp-a";
        external-isp-b = "isp-b";
      };
    };

    topology = {
      nodes = {
        s-router-core-isp-a = {
          role = "core";
          uplinks = {
            isp-a = {
              ipv4 = [ "0.0.0.0/0" ];
              ipv6 = [ "::/0" ];
            };
          };
        };

        s-router-core-isp-b = {
          role = "core";
          uplinks = {
            isp-b = {
              ipv4 = [ "0.0.0.0/0" ];
              ipv6 = [ "::/0" ];
            };
          };
        };

        s-router-upstream-selector = {
          role = "upstream-selector";
        };

        s-router-policy = {
          role = "policy";
        };

        s-router-downstream-selector = {
          role = "downstream-selector";
        };

        s-router-access-adm = {
          role = "access";
          attachments = [
            {
              kind = "tenant";
              name = "adm";
            }
          ];
        };

        s-router-access-mgmt = {
          role = "access";
          attachments = [
            {
              kind = "tenant";
              name = "mgmt";
            }
          ];
        };
      };

      # Note: The forwarding model will derive additional "lane" transit links between
      # downstream-selector<->policy and policy<->upstream-selector based on policy intent.
      links = [
        [
          "s-router-core-isp-a"
          "s-router-upstream-selector"
        ]
        [
          "s-router-core-isp-b"
          "s-router-upstream-selector"
        ]
        [
          "s-router-upstream-selector"
          "s-router-policy"
        ]
        [
          "s-router-policy"
          "s-router-downstream-selector"
        ]
        [
          "s-router-downstream-selector"
          "s-router-access-adm"
        ]
        [
          "s-router-downstream-selector"
          "s-router-access-mgmt"
        ]
      ];
    };
  };
}

