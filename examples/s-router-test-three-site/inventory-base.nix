let
  base =
    (
      let
        publicDns4 = [
          "1.1.1.1"
          "9.9.9.9"
        ];

        publicDns6 = [
          "2606:4700:4700::1111"
          "2620:fe::fe"
        ];
      in
      {
        controlPlane = {
          sites = {
            esp0xdeadbeef = {
              "site-a" = {
                routing = {
                  mode = "bgp";
                  bgp = {
                    asn = 65000;
                    topology = "policy-rr";
                  };
                };
              };
            };
          };
        };

        deployment = {
          hosts = {
            s-router-test = {
              uplinks = {
                management = {
                  parent = "eth0";
                  mode = "vlan";
                  vlan = 2;
                  bridge = "vlan2";

                  ipv4 = {
                    method = "dhcp";
                    enable = true;
                    dhcp = true;
                  };

                  ipv6 = {
                    method = "none";
                    enable = false;
                    acceptRA = false;
                    dhcp = false;
                    dhcpv6PD = false;
                  };
                };

                uplink-isp-a = {
                  parent = "eth0";
                  mode = "vlan";
                  vlan = 4;
                  bridge = "br-uplink0";
                  upstream = "isp-a";

                  ipv4 = {
                    method = "dhcp";
                    enable = true;
                    dhcp = true;
                  };

                  ipv6 = {
                    method = "slaac";
                    enable = true;
                    acceptRA = true;
                    dhcp = false;
                    dhcpv6PD = false;
                  };
                };

                uplink-isp-b = {
                  parent = "eth0";
                  mode = "vlan";
                  vlan = 5;
                  bridge = "br-uplink1";
                  upstream = "isp-b";

                  ipv4 = {
                    method = "dhcp";
                    enable = true;
                    dhcp = true;
                  };

                  ipv6 = {
                    method = "slaac";
                    enable = true;
                    acceptRA = true;
                    dhcp = false;
                    dhcpv6PD = false;
                  };
                };
              };

              bridgeNetworks = {
                br-site-a-core-isp-a-upstream = { };
                br-site-a-core-isp-b-upstream = { };

                br-site-a-policy-upstream-access-admin-isp-a = { };
                br-site-a-policy-upstream-access-admin-isp-b = { };
                br-site-a-policy-upstream-access-client-isp-a = { };
                br-site-a-policy-upstream-access-client-isp-b = { };
                br-site-a-policy-upstream-access-mgmt-isp-a = { };
                br-site-a-policy-upstream-access-mgmt-isp-b = { };

                br-site-a-downstream-policy-access-admin = { };
                br-site-a-downstream-policy-access-client = { };
                br-site-a-downstream-policy-access-mgmt = { };

                br-site-a-downstream-admin = { };
                br-site-a-downstream-client = { };
                br-site-a-downstream-mgmt = { };

                admin = { };
                client = { };
                mgmt = { };
              };
            };
          };
        };

        realization = {
          nodes = {
            esp0xdeadbeef-site-a-s-router-core-isp-a = {
              host = "s-router-test";
              platform = "nixos-container";

              logicalNode = {
                enterprise = "esp0xdeadbeef";
                site = "site-a";
                name = "s-router-core-isp-a";
              };

              containers.default.runtimeName = "s-router-core-isp-a";

              ports = {
                upstream-selector = {
                  link = "p2p-s-router-core-isp-a-s-router-upstream-selector";
                  adapterName = "p2p-s-router-core-isp-a-s-router-upstream-selector-upstream-selector";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-core-isp-a-upstream";
                  };
                  interface.name = "upstream";
                };

                isp-a = {
                  uplink = "isp-a";
                  external = true;
                  attach = {
                    kind = "bridge";
                    bridge = "br-uplink0";
                  };
                  interface.name = "isp-a";
                };
              };
            };

            esp0xdeadbeef-site-a-s-router-core-isp-b = {
              host = "s-router-test";
              platform = "nixos-container";

              logicalNode = {
                enterprise = "esp0xdeadbeef";
                site = "site-a";
                name = "s-router-core-isp-b";
              };

              containers.default.runtimeName = "s-router-core-isp-b";

              ports = {
                upstream-selector = {
                  link = "p2p-s-router-core-isp-b-s-router-upstream-selector";
                  adapterName = "p2p-s-router-core-isp-b-s-router-upstream-selector-upstream-selector";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-core-isp-b-upstream";
                  };
                  interface.name = "upstream";
                };

                isp-b = {
                  uplink = "isp-b";
                  external = true;
                  attach = {
                    kind = "bridge";
                    bridge = "br-uplink1";
                  };
                  interface.name = "isp-b";
                };
              };
            };

            esp0xdeadbeef-site-a-s-router-core-nebula = {
              host = "s-router-test";
              platform = "nixos-container";

              logicalNode = {
                enterprise = "esp0xdeadbeef";
                site = "site-a";
                name = "s-router-core-nebula";
              };

              containers.default.runtimeName = "s-router-core-nebula";

              ports = {
                upstream-selector = {
                  link = "p2p-s-router-core-nebula-s-router-upstream-selector";
                  adapterName = "p2p-s-router-core-nebula-s-router-upstream-selector-upstream-selector";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-core-nebula-upstream";
                  };
                  interface.name = "upstream";
                };

                east-west = {
                  uplink = "east-west";
                  external = true;
                  attach = {
                    kind = "bridge";
                    bridge = "br-uplink1";
                  };
                  interface.name = "east-west";
                };

                site-c-storage = {
                  uplink = "site-c-storage";
                  external = true;
                  attach = {
                    kind = "bridge";
                    bridge = "br-uplink1";
                  };
                  interface.name = "site-c-storage";
                };
              };
            };

            esp0xdeadbeef-site-a-s-router-access-admin = {
              host = "s-router-test";
              platform = "nixos-container";

              logicalNode = {
                enterprise = "esp0xdeadbeef";
                site = "site-a";
                name = "s-router-access-admin";
              };

              containers.default.runtimeName = "s-router-access-admin";
              services.dns = {
                listen = [
                  "10.20.15.1"
                  "fd42:dead:beef:15::1"
                ];
                allowFrom = [
                  "10.20.15.0/24"
                  "fd42:dead:beef:15::/64"
                ];
                forwarders = publicDns4 ++ publicDns6;
              };

              ports = {
                transit-downstream-selector = {
                  link = "p2p-s-router-access-admin-s-router-downstream-selector";
                  adapterName = "p2p-s-router-access-admin-s-router-downstream-selector-transit-downstream-selector";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-downstream-admin";
                  };
                  interface.name = "transit";
                };

                tenant-admin = {
                  logicalInterface = "tenant-admin";
                  attach = {
                    kind = "bridge";
                    bridge = "admin";
                  };
                  interface = {
                    name = "tenant-admin";
                    addr4 = "10.20.15.1/24";
                    addr6 = "fd42:dead:beef:15::1/64";
                  };
                };
              };

              advertisements = {
                dhcp4.tenant-admin = {
                  interface = "tenant-admin";
                  id = "admin";
                  subnet = "10.20.15.0/24";
                  pool = {
                    start = "10.20.15.100";
                    end = "10.20.15.200";
                  };
                  router = "10.20.15.1";
                  dnsServers = publicDns4;
                  domain = "lan.";
                };

                ipv6Ra.tenant-admin = {
                  interface = "tenant-admin";
                  prefixes = [ "fd42:dead:beef:15::/64" ];
                  rdnss = publicDns6;
                  dnssl = [ "lan." ];
                };
              };
            };

            esp0xdeadbeef-site-a-s-router-access-client = {
              host = "s-router-test";
              platform = "nixos-container";

              logicalNode = {
                enterprise = "esp0xdeadbeef";
                site = "site-a";
                name = "s-router-access-client";
              };

              containers.default.runtimeName = "s-router-access-client";
              services.dns = {
                listen = [
                  "10.20.20.1"
                  "fd42:dead:beef:20::1"
                ];
                allowFrom = [
                  "10.20.20.0/24"
                  "fd42:dead:beef:20::/64"
                ];
                forwarders = publicDns4 ++ publicDns6;
              };

              ports = {
                transit-downstream-selector = {
                  link = "p2p-s-router-access-client-s-router-downstream-selector";
                  adapterName = "p2p-s-router-access-client-s-router-downstream-selector-transit-downstream-selector";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-downstream-client";
                  };
                  interface.name = "transit";
                };

                tenant-client = {
                  logicalInterface = "tenant-client";
                  attach = {
                    kind = "bridge";
                    bridge = "client";
                  };
                  interface = {
                    name = "tenant-client";
                    addr4 = "10.20.20.1/24";
                    addr6 = "fd42:dead:beef:20::1/64";
                  };
                };
              };

              advertisements = {
                dhcp4.tenant-client = {
                  interface = "tenant-client";
                  id = "client";
                  subnet = "10.20.20.0/24";
                  pool = {
                    start = "10.20.20.100";
                    end = "10.20.20.200";
                  };
                  router = "10.20.20.1";
                  dnsServers = publicDns4;
                  domain = "lan.";
                };

                ipv6Ra.tenant-client = {
                  interface = "tenant-client";
                  prefixes = [ "fd42:dead:beef:20::/64" ];
                  rdnss = publicDns6;
                  dnssl = [ "lan." ];
                };
              };
            };

            esp0xdeadbeef-site-a-s-router-access-mgmt = {
              host = "s-router-test";
              platform = "nixos-container";

              logicalNode = {
                enterprise = "esp0xdeadbeef";
                site = "site-a";
                name = "s-router-access-mgmt";
              };

              containers.default.runtimeName = "s-router-access-mgmt";
              services.dns = {
                listen = [
                  "10.20.10.1"
                  "fd42:dead:beef:10::1"
                ];
                allowFrom = [
                  "10.20.10.0/24"
                  "fd42:dead:beef:10::/64"
                ];
                forwarders = publicDns4 ++ publicDns6;
              };

              ports = {
                transit-downstream-selector = {
                  link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
                  adapterName = "p2p-s-router-access-mgmt-s-router-downstream-selector-transit-downstream-selector";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-downstream-mgmt";
                  };
                  interface.name = "transit";
                };

                tenant-mgmt = {
                  logicalInterface = "tenant-mgmt";
                  attach = {
                    kind = "bridge";
                    bridge = "mgmt";
                  };
                  interface = {
                    name = "tenant-mgmt";
                    addr4 = "10.20.10.1/24";
                    addr6 = "fd42:dead:beef:10::1/64";
                  };
                };
              };

              advertisements = {
                dhcp4.tenant-mgmt = {
                  interface = "tenant-mgmt";
                  id = "mgmt";
                  subnet = "10.20.10.0/24";
                  pool = {
                    start = "10.20.10.100";
                    end = "10.20.10.200";
                  };
                  router = "10.20.10.1";
                  dnsServers = publicDns4;
                  domain = "lan.";
                };

                ipv6Ra.tenant-mgmt = {
                  interface = "tenant-mgmt";
                  prefixes = [ "fd42:dead:beef:10::/64" ];
                  rdnss = publicDns6;
                  dnssl = [ "lan." ];
                };
              };
            };

            esp0xdeadbeef-site-a-s-router-downstream-selector = {
              host = "s-router-test";
              platform = "nixos-container";

              logicalNode = {
                enterprise = "esp0xdeadbeef";
                site = "site-a";
                name = "s-router-downstream-selector";
              };

              containers.default.runtimeName = "s-router-downstream-selector";

              ports = {
                policy-admin = {
                  link = "p2p-s-router-downstream-selector-s-router-policy-only--access-s-router-access-admin";
                  adapterName = "p2p-s-router-downstream-selector-s-router-policy-only--access-s-router-access-admin-policy-admin";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-downstream-policy-access-admin";
                  };
                  interface.name = "policy-admin";
                };

                policy-client = {
                  link = "p2p-s-router-downstream-selector-s-router-policy-only--access-s-router-access-client";
                  adapterName = "p2p-s-router-downstream-selector-s-router-policy-only--access-s-router-access-client-policy-client";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-downstream-policy-access-client";
                  };
                  interface.name = "policy-client";
                };

                policy-mgmt = {
                  link = "p2p-s-router-downstream-selector-s-router-policy-only--access-s-router-access-mgmt";
                  adapterName = "p2p-s-router-downstream-selector-s-router-policy-only--access-s-router-access-mgmt-policy-mgmt";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-downstream-policy-access-mgmt";
                  };
                  interface.name = "policy-mgmt";
                };

                access-admin = {
                  link = "p2p-s-router-access-admin-s-router-downstream-selector";
                  adapterName = "p2p-s-router-access-admin-s-router-downstream-selector-access-admin";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-downstream-admin";
                  };
                  interface.name = "access-admin";
                };

                access-client = {
                  link = "p2p-s-router-access-client-s-router-downstream-selector";
                  adapterName = "p2p-s-router-access-client-s-router-downstream-selector-access-client";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-downstream-client";
                  };
                  interface.name = "access-client";
                };

                access-mgmt = {
                  link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
                  adapterName = "p2p-s-router-access-mgmt-s-router-downstream-selector-access-mgmt";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-downstream-mgmt";
                  };
                  interface.name = "access-mgmt";
                };
              };
            };

            esp0xdeadbeef-site-a-s-router-policy = {
              host = "s-router-test";
              platform = "nixos-container";

              logicalNode = {
                enterprise = "esp0xdeadbeef";
                site = "site-a";
                name = "s-router-policy-only";
              };

              containers.default.runtimeName = "s-router-policy-only";

              ports = {
                upstream-admin-isp-a = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-admin--uplink-isp-a";
                  adapterName = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-admin--uplink-isp-a-upstream-admin-isp-a";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-admin-isp-a";
                  };
                  interface.name = "up-admin-a";
                };

                upstream-admin-isp-b = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-admin--uplink-isp-b";
                  adapterName = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-admin--uplink-isp-b-upstream-admin-isp-b";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-admin-isp-b";
                  };
                  interface.name = "up-admin-b";
                };

                upstream-client-isp-a = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client--uplink-isp-a";
                  adapterName = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client--uplink-isp-a-upstream-client-isp-a";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-client-isp-a";
                  };
                  interface.name = "up-client-a";
                };

                upstream-client-isp-b = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client--uplink-isp-b";
                  adapterName = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client--uplink-isp-b-upstream-client-isp-b";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-client-isp-b";
                  };
                  interface.name = "up-client-b";
                };

                upstream-mgmt-isp-a = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-mgmt--uplink-isp-a";
                  adapterName = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-mgmt--uplink-isp-a-upstream-mgmt-isp-a";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-mgmt-isp-a";
                  };
                  interface.name = "up-mgmt-a";
                };

                upstream-mgmt-isp-b = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-mgmt--uplink-isp-b";
                  adapterName = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-mgmt--uplink-isp-b-upstream-mgmt-isp-b";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-mgmt-isp-b";
                  };
                  interface.name = "up-mgmt-b";
                };

                downstream-admin = {
                  link = "p2p-s-router-downstream-selector-s-router-policy-only--access-s-router-access-admin";
                  adapterName = "p2p-s-router-downstream-selector-s-router-policy-only--access-s-router-access-admin-downstream-admin";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-downstream-policy-access-admin";
                  };
                  interface.name = "downstream-admin";
                };

                downstream-client = {
                  link = "p2p-s-router-downstream-selector-s-router-policy-only--access-s-router-access-client";
                  adapterName = "p2p-s-router-downstream-selector-s-router-policy-only--access-s-router-access-client-downstream-client";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-downstream-policy-access-client";
                  };
                  interface.name = "downstream-client";
                };

                downstream-mgmt = {
                  link = "p2p-s-router-downstream-selector-s-router-policy-only--access-s-router-access-mgmt";
                  adapterName = "p2p-s-router-downstream-selector-s-router-policy-only--access-s-router-access-mgmt-downstream-mgmt";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-downstream-policy-access-mgmt";
                  };
                  interface.name = "downstream-mgmt";
                };
              };
            };

            esp0xdeadbeef-site-a-s-router-upstream-selector = {
              host = "s-router-test";
              platform = "nixos-container";

              logicalNode = {
                enterprise = "esp0xdeadbeef";
                site = "site-a";
                name = "s-router-upstream-selector";
              };

              containers.default.runtimeName = "s-router-upstream-selector";

              ports = {
                core-isp-a = {
                  link = "p2p-s-router-core-isp-a-s-router-upstream-selector";
                  adapterName = "p2p-s-router-core-isp-a-s-router-upstream-selector-core-isp-a";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-core-isp-a-upstream";
                  };
                  interface.name = "core-a";
                };

                core-isp-b = {
                  link = "p2p-s-router-core-isp-b-s-router-upstream-selector";
                  adapterName = "p2p-s-router-core-isp-b-s-router-upstream-selector-core-isp-b";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-core-isp-b-upstream";
                  };
                  interface.name = "core-b";
                };

                core-nebula = {
                  link = "p2p-s-router-core-nebula-s-router-upstream-selector";
                  adapterName = "p2p-s-router-core-nebula-s-router-upstream-selector-core-nebula";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-core-nebula-upstream";
                  };
                  interface.name = "core-nebula";
                };

                policy-admin-isp-a = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-admin--uplink-isp-a";
                  adapterName = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-admin--uplink-isp-a-policy-admin-isp-a";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-admin-isp-a";
                  };
                  interface.name = "pol-admin-a";
                };

                policy-admin-isp-b = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-admin--uplink-isp-b";
                  adapterName = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-admin--uplink-isp-b-policy-admin-isp-b";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-admin-isp-b";
                  };
                  interface.name = "pol-admin-b";
                };

                policy-client-isp-a = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client--uplink-isp-a";
                  adapterName = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client--uplink-isp-a-policy-client-isp-a";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-client-isp-a";
                  };
                  interface.name = "pol-client-a";
                };

                policy-client-isp-b = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client--uplink-isp-b";
                  adapterName = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client--uplink-isp-b-policy-client-isp-b";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-client-isp-b";
                  };
                  interface.name = "pol-client-b";
                };

                policy-mgmt-isp-a = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-mgmt--uplink-isp-a";
                  adapterName = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-mgmt--uplink-isp-a-policy-mgmt-isp-a";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-mgmt-isp-a";
                  };
                  interface.name = "pol-mgmt-a";
                };

                policy-mgmt-isp-b = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-mgmt--uplink-isp-b";
                  adapterName = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-mgmt--uplink-isp-b-policy-mgmt-isp-b";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-mgmt-isp-b";
                  };
                  interface.name = "pol-mgmt-b";
                };
              };
            };
          };
        };
      }
    );

  publicDns4 = [
    "1.1.1.1"
    "9.9.9.9"
  ];

  publicDns6 = [
    "2606:4700:4700::1111"
    "2620:fe::fe"
  ];

  dmzDns = {
    listen = [
      "10.20.30.1"
      "fd42:dead:beef:30::1"
    ];
    allowFrom = [
      "10.20.30.0/24"
      "fd42:dead:beef:30::/64"
    ];
    forwarders = publicDns4 ++ publicDns6;
    advertised = {
      dnsServers = [ "router-self" ];
      rdnss = [ "router-self" ];
    };
  };

  branchAccessDns = {
    listen = [
      "10.60.10.1"
      "fd42:dead:feed:10::1"
    ];
    allowFrom = [
      "10.60.10.0/24"
      "fd42:dead:feed:10::/64"
    ];
    forwarders = [
      "10.20.10.1"
      "fd42:dead:beef:10::1"
    ];
    advertised = {
      dnsServers = [ "router-self" ];
      rdnss = [ "router-self" ];
    };
  };

  hostileAccessDns = {
    listen = [
      "10.70.10.1"
      "fd42:dead:feed:70::1"
    ];
    allowFrom = [
      "10.70.10.0/24"
      "fd42:dead:feed:70::/64"
    ];
    forwarders = [
      "10.20.10.1"
      "fd42:dead:beef:10::1"
    ];
    advertised = {
      dnsServers = [ "router-self" ];
      rdnss = [ "router-self" ];
    };
  };

  policyDerivedDns = dnsAttrs: dnsAttrs;

  overrideAdvertisedRouterSelf =
    inherited: tenantKey:
    inherited
    // {
      dhcp4 =
        (inherited.dhcp4 or { })
        // {
          ${tenantKey} =
            inherited.dhcp4.${tenantKey}
            // {
              dnsServers = [ "router-self" ];
            };
        };
      ipv6Ra =
        (inherited.ipv6Ra or { })
        // {
          ${tenantKey} =
            inherited.ipv6Ra.${tenantKey}
            // {
              rdnss = [ "router-self" ];
            };
        };
    };

  host = base.deployment.hosts.s-router-test;

  siteANodes = base.realization.nodes;

  siteC = import ./inventory-parts/site-c.nix {
    inherit base publicDns4 publicDns6 policyDerivedDns;
  };
in
base
// {
  endpoints =
    (base.endpoints or { })
    // {
      site-dns-mgmt = {
        ipv4 = [ "10.20.10.1" ];
        ipv6 = [ "fd42:dead:beef:10::1" ];
      };

      nebula01 = {
        ipv4 = [ "10.20.30.10" ];
        ipv6 = [ "fd42:dead:beef:30::10" ];
      };
    }
    // siteC.endpoints;

  controlPlane =
    base.controlPlane
    // {
      sites =
        siteC.controlPlaneSites (
          base.controlPlane.sites
        // {
          esp0xdeadbeef =
            base.controlPlane.sites.esp0xdeadbeef
            // {
              "site-a" =
                base.controlPlane.sites.esp0xdeadbeef."site-a"
                // {
                  overlays.east-west = {
                    provider = "nebula";
                    ipam = {
                      ipv4.prefix = "100.96.10.0/24";
                      ipv6.prefix = "fd42:dead:beef:ee::/64";
                      nodes = {
                        s-router-core-nebula = {
                          addr4 = "100.96.10.1/32";
                          addr6 = "fd42:dead:beef:ee::1/128";
                        };

                        nebula-core = {
                          addr4 = "100.96.10.10/32";
                          addr6 = "fd42:dead:beef:ee::10/128";
                        };

                        hetzner-nebula-prodtest-01 = {
                          addr4 = "100.96.10.254/32";
                          addr6 = "fd42:dead:beef:ee::254/128";
                        };
                      };
                    };
                    nebula = {
                      role = "core-client";
                      lighthouse = {
                        node = "hetzner-nebula-prodtest-01";
                        endpoint = "46.224.173.254";
                        endpoint6 = "2a01:4f8:c013:628b::1";
                        port = 4242;
                      };
                    };
                    runtimeNodes = {
                      s-router-core-nebula = {
                        groups = [
                          "lab"
                          "core"
                        ];
                        service = {
                          name = "nebula-runtime";
                          interface = "nebula1";
                        };
                        container = {
                          targetContainer = "s-router-core-nebula";
                          profile = "core-router-nebula";
                        };
                      };

                      nebula-core = {
                        groups = [
                          "lab"
                          "core"
                        ];
                        service = {
                          name = "nebula-runtime";
                          interface = "nebula1";
                        };
                        container = {
                          hostBridge = "br-uplink1";
                          profile = "core-client";
                        };
                      };
                    };
                  };
                };
            };

          espbranch = {
            "site-b" = {
              ipv6 = {
                pd = {
                  uplink = "wan";
                  delegatedPrefixLength = 64;
                  perTenantPrefixLength = 64;
                  sourceFile = "/run/secrets/subnet-ipv6";
                };
              };

              tenants = {
                branch.ipv6 = {
                  mode = "static";
                  prefixes = [ "fd42:dead:feed:10::/64" ];
                };

                hostile.ipv6.mode = "slaac";
              };

              routing = {
                mode = "bgp";
                bgp = {
                  asn = 65100;
                  topology = "policy-rr";
                };
              };

              overlays.east-west = {
                provider = "nebula";
                ipam = {
                  ipv4.prefix = "100.96.10.0/24";
                  ipv6.prefix = "fd42:dead:beef:ee::/64";
                  nodes = {
                    b-router-core-nebula = {
                      addr4 = "100.96.10.2/32";
                      addr6 = "fd42:dead:beef:ee::2/128";
                    };

                    branch-node01 = {
                      addr4 = "100.96.10.20/32";
                      addr6 = "fd42:dead:beef:ee::20/128";
                    };

                    hostile-node01 = {
                      addr4 = "100.96.10.30/32";
                      addr6 = "fd42:dead:beef:ee::30/128";
                    };

                    hetzner-nebula-prodtest-01 = {
                      addr4 = "100.96.10.254/32";
                      addr6 = "fd42:dead:beef:ee::254/128";
                    };
                  };
                };
                nebula = {
                  role = "core-client";
                  lighthouse = {
                    node = "hetzner-nebula-prodtest-01";
                    endpoint = "46.224.173.254";
                    endpoint6 = "2a01:4f8:c013:628b::1";
                    port = 4242;
                  };
                };
                runtimeNodes = {
                  b-router-core-nebula = {
                    groups = [
                      "lab"
                      "branch"
                      "core"
                    ];
                    unsafeRoutes = [
                      {
                        route = "0.0.0.0/1";
                        install = true;
                      }
                      {
                        route = "128.0.0.0/1";
                        install = true;
                      }
                      {
                        route = "::/1";
                        install = true;
                      }
                      {
                        route = "8000::/1";
                        install = true;
                      }
                    ];
                    service = {
                      name = "nebula-runtime";
                      interface = "nebula1";
                    };
                    container = {
                      targetContainer = "b-router-core-nebula";
                      profile = "core-router-nebula";
                    };
                  };
                };
              };
            };
          };
        }
        );
    };

  deployment =
    base.deployment
    // {
      hosts =
        base.deployment.hosts
        // {
          s-router-test =
            siteC.deploymentHost (
              host
              // {
              # Ensure WAN-only nodes in this profile resolve to the ISP-B uplink
              # instead of falling back to an unrelated host uplink.
              wanUplink = "uplink-isp-b";

              bridgeNetworks =
                host.bridgeNetworks
                // {
                  br-site-a-policy-upstream-access-admin-east-west = { };
                  br-site-a-policy-upstream-access-client-east-west = { };
                  br-site-a-policy-upstream-access-client2-east-west = { };
                  br-site-a-policy-upstream-access-mgmt-east-west = { };
                  br-site-a-policy-upstream-access-mgmt-site-c-storage = { };
                  br-site-a-core-nebula-upstream = { };
                  br-site-a-policy-upstream-access-client2-isp-a = { };
                  br-site-a-policy-upstream-access-client2-isp-b = { };
                  br-site-a-downstream-policy-access-client2 = { };
                  br-site-a-downstream-client2 = { };
                  client2 = { };
                  br-site-a-downstream-policy-access-dmz = { };
                  br-site-a-downstream-dmz = { };
                  dmz = { };

                  br-site-b-core-nebula-upstream = { };
                  br-site-b-core-simulated-isp-upstream = { };
                  br-site-b-policy-upstream-access-branch-east-west = { };
                  br-site-b-policy-upstream-access-branch = { };
                  br-site-b-policy-upstream-access-hostile-east-west = { };
                  br-site-b-policy-upstream-access-hostile = { };
                  br-site-b-downstream-policy-access-branch = { };
                  br-site-b-downstream-policy-access-hostile = { };
                  br-site-b-downstream-branch = { };
                  br-site-b-downstream-hostile = { };
                  branch = { };
                  hostile = { };
                };
              }
            );
        };
    };

  realization = {
    nodes =
      siteANodes
      // {
        esp0xdeadbeef-site-a-s-router-access-admin =
          siteANodes.esp0xdeadbeef-site-a-s-router-access-admin
          // {
            services.dns = policyDerivedDns siteANodes.esp0xdeadbeef-site-a-s-router-access-admin.services.dns;
            advertisements =
              overrideAdvertisedRouterSelf
                siteANodes.esp0xdeadbeef-site-a-s-router-access-admin.advertisements
                "tenant-admin";
          };

        esp0xdeadbeef-site-a-s-router-access-client =
          siteANodes.esp0xdeadbeef-site-a-s-router-access-client
          // {
            services.dns = policyDerivedDns siteANodes.esp0xdeadbeef-site-a-s-router-access-client.services.dns;
            advertisements =
              overrideAdvertisedRouterSelf
                siteANodes.esp0xdeadbeef-site-a-s-router-access-client.advertisements
                "tenant-client";
          };

        esp0xdeadbeef-site-a-s-router-access-mgmt =
          siteANodes.esp0xdeadbeef-site-a-s-router-access-mgmt
          // {
            services.dns = policyDerivedDns siteANodes.esp0xdeadbeef-site-a-s-router-access-mgmt.services.dns;
            advertisements =
              overrideAdvertisedRouterSelf
                siteANodes.esp0xdeadbeef-site-a-s-router-access-mgmt.advertisements
                "tenant-mgmt";
          };

        esp0xdeadbeef-site-a-s-router-access-dmz = {
          host = "s-router-test";
          platform = "nixos-container";

          logicalNode = {
            enterprise = "esp0xdeadbeef";
            site = "site-a";
            name = "s-router-access-dmz";
          };

          containers.default.runtimeName = "s-router-access-dmz";
          services.dns = policyDerivedDns dmzDns;

          ports = {
            transit-downstream-selector = {
              link = "p2p-s-router-access-dmz-s-router-downstream-selector";
              adapterName = "${"p2p-s-router-access-dmz-s-router-downstream-selector"}-transit-downstream-selector";
              attach = {
                kind = "bridge";
                bridge = "br-site-a-downstream-dmz";
              };
              interface.name = "transit";
            };

            tenant-dmz = {
              logicalInterface = "tenant-dmz";
              attach = {
                kind = "bridge";
                bridge = "dmz";
              };
              interface = {
                name = "tenant-dmz";
                addr4 = "10.20.30.1/24";
                addr6 = "fd42:dead:beef:30::1/64";
              };
            };
          };

          advertisements = {
            dhcp4.tenant-dmz = {
              interface = "tenant-dmz";
              id = "dmz";
              subnet = "10.20.30.0/24";
              pool = {
                start = "10.20.30.100";
                end = "10.20.30.200";
              };
              router = "10.20.30.1";
              dnsServers = dmzDns.advertised.dnsServers;
              domain = "lan.";
            };

            ipv6Ra.tenant-dmz = {
              interface = "tenant-dmz";
              prefixes = [ "fd42:dead:beef:30::/64" ];
              rdnss = dmzDns.advertised.rdnss;
              dnssl = [ "lan." ];
            };
          };
        };

        esp0xdeadbeef-site-a-s-router-access-client2 = {
          host = "s-router-test";
          platform = "nixos-container";

          logicalNode = {
            enterprise = "esp0xdeadbeef";
            site = "site-a";
            name = "s-router-access-client2";
          };

          containers.default.runtimeName = "s-router-access-client2";
          services.dns = policyDerivedDns {
            listen = [
              "10.20.40.1"
              "fd42:dead:beef:40::1"
            ];
            allowFrom = [
              "10.20.40.0/24"
              "fd42:dead:beef:40::/64"
            ];
            forwarders = publicDns4 ++ publicDns6;
          };

          ports = {
            transit-downstream-selector = {
              link = "p2p-s-router-access-client2-s-router-downstream-selector";
              adapterName = "${"p2p-s-router-access-client2-s-router-downstream-selector"}-transit-downstream-selector";
              attach = {
                kind = "bridge";
                bridge = "br-site-a-downstream-client2";
              };
              interface.name = "transit";
            };

            tenant-client2 = {
              logicalInterface = "tenant-client2";
              attach = {
                kind = "bridge";
                bridge = "client2";
              };
              interface = {
                name = "tenant-client2";
                addr4 = "10.20.40.1/24";
                addr6 = "fd42:dead:beef:40::1/64";
              };
            };
          };

          advertisements = {
            dhcp4.tenant-client2 = {
              interface = "tenant-client2";
              id = "client2";
              subnet = "10.20.40.0/24";
              pool = {
                start = "10.20.40.100";
                end = "10.20.40.200";
              };
              router = "10.20.40.1";
              dnsServers = [ "router-self" ];
              domain = "lan.";
            };

            ipv6Ra.tenant-client2 = {
              interface = "tenant-client2";
              prefixes = [ "fd42:dead:beef:40::/64" ];
              rdnss = [ "router-self" ];
              dnssl = [ "lan." ];
            };
          };
        };

        esp0xdeadbeef-site-a-s-router-downstream-selector =
          siteANodes.esp0xdeadbeef-site-a-s-router-downstream-selector
          // {
            ports =
              siteANodes.esp0xdeadbeef-site-a-s-router-downstream-selector.ports
              // {
                policy-dmz = {
                  link = "p2p-s-router-downstream-selector-s-router-policy-only--access-s-router-access-dmz";
                  adapterName = "${"p2p-s-router-downstream-selector-s-router-policy-only--access-s-router-access-dmz"}-policy-dmz";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-downstream-policy-access-dmz";
                  };
                  interface.name = "policy-dmz";
                };

                access-dmz = {
                  link = "p2p-s-router-access-dmz-s-router-downstream-selector";
                  adapterName = "${"p2p-s-router-access-dmz-s-router-downstream-selector"}-access-dmz";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-downstream-dmz";
                  };
                  interface.name = "access-dmz";
                };

                policy-client2 = {
                  link = "p2p-s-router-downstream-selector-s-router-policy-only--access-s-router-access-client2";
                  adapterName = "${"p2p-s-router-downstream-selector-s-router-policy-only--access-s-router-access-client2"}-policy-client2";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-downstream-policy-access-client2";
                  };
                  interface.name = "policy-client2";
                };

                access-client2 = {
                  link = "p2p-s-router-access-client2-s-router-downstream-selector";
                  adapterName = "${"p2p-s-router-access-client2-s-router-downstream-selector"}-access-client2";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-downstream-client2";
                  };
                  interface.name = "access-client2";
                };
              };
          };

        esp0xdeadbeef-site-a-s-router-policy =
          siteANodes.esp0xdeadbeef-site-a-s-router-policy
          // {
            ports =
              siteANodes.esp0xdeadbeef-site-a-s-router-policy.ports
              // {
                upstream-admin-east-west = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-admin--uplink-east-west";
                  adapterName = "${"p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-admin--uplink-east-west"}-upstream-admin-east-west";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-admin-east-west";
                  };
                  interface.name = "up-adm-ew";
                };

                upstream-client-east-west = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client--uplink-east-west";
                  adapterName = "${"p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client--uplink-east-west"}-upstream-client-east-west";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-client-east-west";
                  };
                  interface.name = "up-cli-ew";
                };

                upstream-client2-east-west = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client2--uplink-east-west";
                  adapterName = "${"p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client2--uplink-east-west"}-upstream-client2-east-west";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-client2-east-west";
                  };
                  interface.name = "up-cl2-ew";
                };

                upstream-client2-isp-a = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client2--uplink-isp-a";
                  adapterName = "${"p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client2--uplink-isp-a"}-upstream-client2-isp-a";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-client2-isp-a";
                  };
                  interface.name = "up-cl2-a";
                };

                upstream-client2-isp-b = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client2--uplink-isp-b";
                  adapterName = "${"p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client2--uplink-isp-b"}-upstream-client2-isp-b";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-client2-isp-b";
                  };
                  interface.name = "up-cl2-b";
                };


                upstream-mgmt-east-west = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-mgmt--uplink-east-west";
                  adapterName = "${"p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-mgmt--uplink-east-west"}-upstream-mgmt-east-west";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-mgmt-east-west";
                  };
                  interface.name = "up-mgt-ew";
                };

                upstream-mgmt-site-c-storage = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-mgmt--uplink-site-c-storage";
                  adapterName = "${"p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-mgmt--uplink-site-c-storage"}-upstream-mgmt-site-c-storage";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-mgmt-site-c-storage";
                  };
                  interface.name = "up-mgt-sitec";
                };

                downstream-dmz = {
                  link = "p2p-s-router-downstream-selector-s-router-policy-only--access-s-router-access-dmz";
                  adapterName = "${"p2p-s-router-downstream-selector-s-router-policy-only--access-s-router-access-dmz"}-downstream-dmz";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-downstream-policy-access-dmz";
                  };
                  interface.name = "downstream-dmz";
                };

                downstream-client2 = {
                  link = "p2p-s-router-downstream-selector-s-router-policy-only--access-s-router-access-client2";
                  adapterName = "${"p2p-s-router-downstream-selector-s-router-policy-only--access-s-router-access-client2"}-downstream-client2";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-downstream-policy-access-client2";
                  };
                  interface.name = "downstream-client2";
                };
              };
          };

        esp0xdeadbeef-site-a-s-router-upstream-selector =
          siteANodes.esp0xdeadbeef-site-a-s-router-upstream-selector
          // {
            ports =
              siteANodes.esp0xdeadbeef-site-a-s-router-upstream-selector.ports
              // {
                policy-admin-east-west = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-admin--uplink-east-west";
                  adapterName = "${"p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-admin--uplink-east-west"}-policy-admin-east-west";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-admin-east-west";
                  };
                  interface.name = "pol-adm-ew";
                };

                policy-client-east-west = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client--uplink-east-west";
                  adapterName = "${"p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client--uplink-east-west"}-policy-client-east-west";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-client-east-west";
                  };
                  interface.name = "pol-cli-ew";
                };

                policy-client2-east-west = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client2--uplink-east-west";
                  adapterName = "${"p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client2--uplink-east-west"}-policy-client2-east-west";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-client2-east-west";
                  };
                  interface.name = "pol-cl2-ew";
                };

                policy-client2-isp-a = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client2--uplink-isp-a";
                  adapterName = "${"p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client2--uplink-isp-a"}-policy-client2-isp-a";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-client2-isp-a";
                  };
                  interface.name = "pol-cl2-a";
                };

                policy-client2-isp-b = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client2--uplink-isp-b";
                  adapterName = "${"p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-client2--uplink-isp-b"}-policy-client2-isp-b";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-client2-isp-b";
                  };
                  interface.name = "pol-cl2-b";
                };

                policy-mgmt-east-west = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-mgmt--uplink-east-west";
                  adapterName = "${"p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-mgmt--uplink-east-west"}-policy-mgmt-east-west";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-mgmt-east-west";
                  };
                  interface.name = "pol-mgt-ew";
                };

                policy-mgmt-site-c-storage = {
                  link = "p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-mgmt--uplink-site-c-storage";
                  adapterName = "${"p2p-s-router-policy-only-s-router-upstream-selector--access-s-router-access-mgmt--uplink-site-c-storage"}-policy-mgmt-site-c-storage";
                  attach = {
                    kind = "bridge";
                    bridge = "br-site-a-policy-upstream-access-mgmt-site-c-storage";
                  };
                  interface.name = "pol-mgt-sitec";
                };

              };
          };

        espbranch-site-b-b-router-core-nebula = {
          host = "s-router-test";
          platform = "nixos-container";

          logicalNode = {
            enterprise = "espbranch";
            site = "site-b";
            name = "b-router-core-nebula";
          };

          containers.default.runtimeName = "b-router-core-nebula";

          ports = {
            upstream-selector = {
              link = "p2p-b-router-core-nebula-b-router-upstream-selector";
              adapterName = "${"p2p-b-router-core-nebula-b-router-upstream-selector"}-upstream-selector";
              attach = {
                kind = "bridge";
                bridge = "br-site-b-core-nebula-upstream";
              };
              interface.name = "upstream";
            };

            east-west = {
              uplink = "east-west";
              external = true;
              attach = {
                kind = "bridge";
                bridge = "br-uplink1";
              };
              interface.name = "east-west";
            };
          };
        };

        espbranch-site-b-b-router-core-simulated-isp = {
          host = "s-router-test";
          platform = "nixos-container";

          logicalNode = {
            enterprise = "espbranch";
            site = "site-b";
            name = "b-router-core-simulated-isp";
          };

          containers.default.runtimeName = "b-router-core-simulated-isp";

          ports = {
            upstream-selector = {
              link = "p2p-b-router-core-simulated-isp-b-router-upstream-selector";
              adapterName = "${"p2p-b-router-core-simulated-isp-b-router-upstream-selector"}-upstream-selector";
              attach = {
                kind = "bridge";
                bridge = "br-site-b-core-simulated-isp-upstream";
              };
              interface.name = "upstream";
            };

            wan = {
              uplink = "wan";
              external = true;
              attach = {
                kind = "bridge";
                bridge = "br-uplink1";
              };
              interface.name = "wan";
            };
          };
        };

        espbranch-site-b-b-router-access-branch = {
          host = "s-router-test";
          platform = "nixos-container";

          logicalNode = {
            enterprise = "espbranch";
            site = "site-b";
            name = "b-router-access-branch";
          };

          containers.default.runtimeName = "b-router-access-branch";
          services.dns = branchAccessDns;

          ports = {
            transit-downstream-selector = {
              link = "p2p-b-router-access-branch-b-router-downstream-selector";
              adapterName = "${"p2p-b-router-access-branch-b-router-downstream-selector"}-transit-downstream-selector";
              attach = {
                kind = "bridge";
                bridge = "br-site-b-downstream-branch";
              };
              interface.name = "transit";
            };

            tenant-branch = {
              logicalInterface = "tenant-branch";
              attach = {
                kind = "bridge";
                bridge = "branch";
              };
              interface = {
                name = "tenant-branch";
                addr4 = "10.60.10.1/24";
                addr6 = "fd42:dead:feed:10::1/64";
              };
            };
          };

          advertisements = {
            dhcp4.tenant-branch = {
              interface = "tenant-branch";
              id = "branch";
              subnet = "10.60.10.0/24";
              pool = {
                start = "10.60.10.100";
                end = "10.60.10.200";
              };
              router = "10.60.10.1";
              dnsServers = branchAccessDns.advertised.dnsServers;
              domain = "lan.";
            };

            ipv6Ra.tenant-branch = {
              interface = "tenant-branch";
              prefixes = [ "fd42:dead:feed:10::/64" ];
              rdnss = branchAccessDns.advertised.rdnss;
              dnssl = [ "lan." ];
            };
          };
        };

        espbranch-site-b-b-router-access-hostile = {
          host = "s-router-test";
          platform = "nixos-container";

          logicalNode = {
            enterprise = "espbranch";
            site = "site-b";
            name = "b-router-access-hostile";
          };

          containers.default.runtimeName = "b-router-access-hostile";
          services.dns = hostileAccessDns;

          ports = {
            transit-downstream-selector = {
              link = "p2p-b-router-access-hostile-b-router-downstream-selector";
              adapterName = "${"p2p-b-router-access-hostile-b-router-downstream-selector"}-transit-downstream-selector";
              attach = {
                kind = "bridge";
                bridge = "br-site-b-downstream-hostile";
              };
              interface.name = "transit";
            };

            tenant-hostile = {
              logicalInterface = "tenant-hostile";
              attach = {
                kind = "bridge";
                bridge = "hostile";
              };
              interface = {
                name = "tenant-hostile";
                addr4 = "10.70.10.1/24";
                addr6 = "fd42:dead:feed:70::1/64";
              };
            };
          };

          advertisements = {
            dhcp4.tenant-hostile = {
              interface = "tenant-hostile";
              id = "hostile";
              subnet = "10.70.10.0/24";
              pool = {
                start = "10.70.10.100";
                end = "10.70.10.200";
              };
              router = "10.70.10.1";
              dnsServers = hostileAccessDns.advertised.dnsServers;
              domain = "lan.";
            };

            ipv6Ra.tenant-hostile = {
              interface = "tenant-hostile";
              prefixes = [ "2a01:4f8:1c17:b337::/64" ];
              rdnss = hostileAccessDns.advertised.rdnss;
              dnssl = [ "lan." ];
            };
          };
        };

        espbranch-site-b-b-router-downstream-selector = {
          host = "s-router-test";
          platform = "nixos-container";

          logicalNode = {
            enterprise = "espbranch";
            site = "site-b";
            name = "b-router-downstream-selector";
          };

          containers.default.runtimeName = "b-router-downstream-selector";

          ports = {
            policy-branch = {
              link = "p2p-b-router-downstream-selector-b-router-policy--access-b-router-access-branch";
              adapterName = "${"p2p-b-router-downstream-selector-b-router-policy--access-b-router-access-branch"}-policy-branch";
              attach = {
                kind = "bridge";
                bridge = "br-site-b-downstream-policy-access-branch";
              };
              interface.name = "policy-branch";
            };

            access-branch = {
              link = "p2p-b-router-access-branch-b-router-downstream-selector";
              adapterName = "${"p2p-b-router-access-branch-b-router-downstream-selector"}-access-branch";
              attach = {
                kind = "bridge";
                bridge = "br-site-b-downstream-branch";
              };
              interface.name = "access-branch";
            };

            policy-hostile = {
              link = "p2p-b-router-downstream-selector-b-router-policy--access-b-router-access-hostile";
              adapterName = "${"p2p-b-router-downstream-selector-b-router-policy--access-b-router-access-hostile"}-policy-hostile";
              attach = {
                kind = "bridge";
                bridge = "br-site-b-downstream-policy-access-hostile";
              };
              interface.name = "policy-hostile";
            };

            access-hostile = {
              link = "p2p-b-router-access-hostile-b-router-downstream-selector";
              adapterName = "${"p2p-b-router-access-hostile-b-router-downstream-selector"}-access-hostile";
              attach = {
                kind = "bridge";
                bridge = "br-site-b-downstream-hostile";
              };
              interface.name = "access-hostile";
            };
          };
        };

        espbranch-site-b-b-router-policy = {
          host = "s-router-test";
          platform = "nixos-container";

          logicalNode = {
            enterprise = "espbranch";
            site = "site-b";
            name = "b-router-policy";
          };

          containers.default.runtimeName = "b-router-policy";

          ports = {
            upstream-branch-east-west = {
              link = "p2p-b-router-policy-b-router-upstream-selector--access-b-router-access-branch--uplink-east-west";
              adapterName = "${"p2p-b-router-policy-b-router-upstream-selector--access-b-router-access-branch--uplink-east-west"}-upstream-branch-east-west";
              attach = {
                kind = "bridge";
                bridge = "br-site-b-policy-upstream-access-branch-east-west";
              };
              interface.name = "up-branch-ew";
            };

            upstream-branch = {
              link = "p2p-b-router-policy-b-router-upstream-selector--access-b-router-access-branch--uplink-wan";
              adapterName = "${"p2p-b-router-policy-b-router-upstream-selector--access-b-router-access-branch--uplink-wan"}-upstream-branch";
              attach = {
                kind = "bridge";
                bridge = "br-site-b-policy-upstream-access-branch";
              };
              interface.name = "upstream-branch";
            };

            downstream-branch = {
              link = "p2p-b-router-downstream-selector-b-router-policy--access-b-router-access-branch";
              adapterName = "${"p2p-b-router-downstream-selector-b-router-policy--access-b-router-access-branch"}-downstream-branch";
              attach = {
                kind = "bridge";
                bridge = "br-site-b-downstream-policy-access-branch";
              };
              interface.name = "downstream-branch";
            };

            upstream-hostile = {
              link = "p2p-b-router-policy-b-router-upstream-selector--access-b-router-access-hostile--uplink-wan";
              adapterName = "${"p2p-b-router-policy-b-router-upstream-selector--access-b-router-access-hostile--uplink-wan"}-upstream-hostile";
              attach = {
                kind = "bridge";
                bridge = "br-site-b-policy-upstream-access-hostile";
              };
              interface.name = "up-hostile";
            };

            upstream-hostile-east-west = {
              link = "p2p-b-router-policy-b-router-upstream-selector--access-b-router-access-hostile--uplink-east-west";
              adapterName = "${"p2p-b-router-policy-b-router-upstream-selector--access-b-router-access-hostile--uplink-east-west"}-upstream-hostile-east-west";
              attach = {
                kind = "bridge";
                bridge = "br-site-b-policy-upstream-access-hostile-east-west";
              };
              interface.name = "up-hostile-ew";
            };

            downstream-hostile = {
              link = "p2p-b-router-downstream-selector-b-router-policy--access-b-router-access-hostile";
              adapterName = "${"p2p-b-router-downstream-selector-b-router-policy--access-b-router-access-hostile"}-downstream-hostile";
              attach = {
                kind = "bridge";
                bridge = "br-site-b-downstream-policy-access-hostile";
              };
              interface.name = "downstream-hostile";
            };
          };
        };

        espbranch-site-b-b-router-upstream-selector = {
          host = "s-router-test";
          platform = "nixos-container";

          logicalNode = {
            enterprise = "espbranch";
            site = "site-b";
            name = "b-router-upstream-selector";
          };

          containers.default.runtimeName = "b-router-upstream-selector";

          ports = {
            core-nebula = {
              link = "p2p-b-router-core-nebula-b-router-upstream-selector";
              adapterName = "${"p2p-b-router-core-nebula-b-router-upstream-selector"}-core-nebula";
              attach = {
                kind = "bridge";
                bridge = "br-site-b-core-nebula-upstream";
              };
              interface.name = "core-nebula";
            };

            core-simulated-isp = {
              link = "p2p-b-router-core-simulated-isp-b-router-upstream-selector";
              adapterName = "${"p2p-b-router-core-simulated-isp-b-router-upstream-selector"}-core-simulated-isp";
              attach = {
                kind = "bridge";
                bridge = "br-site-b-core-simulated-isp-upstream";
              };
              interface.name = "core-isp";
            };

            policy-branch-east-west = {
              link = "p2p-b-router-policy-b-router-upstream-selector--access-b-router-access-branch--uplink-east-west";
              adapterName = "${"p2p-b-router-policy-b-router-upstream-selector--access-b-router-access-branch--uplink-east-west"}-policy-branch-east-west";
              attach = {
                kind = "bridge";
                bridge = "br-site-b-policy-upstream-access-branch-east-west";
              };
              interface.name = "pol-branch-ew";
            };

            policy-branch = {
              link = "p2p-b-router-policy-b-router-upstream-selector--access-b-router-access-branch--uplink-wan";
              adapterName = "${"p2p-b-router-policy-b-router-upstream-selector--access-b-router-access-branch--uplink-wan"}-policy-branch";
              attach = {
                kind = "bridge";
                bridge = "br-site-b-policy-upstream-access-branch";
              };
              interface.name = "policy-branch";
            };

            policy-hostile = {
              link = "p2p-b-router-policy-b-router-upstream-selector--access-b-router-access-hostile--uplink-wan";
              adapterName = "${"p2p-b-router-policy-b-router-upstream-selector--access-b-router-access-hostile--uplink-wan"}-policy-hostile";
              attach = {
                kind = "bridge";
                bridge = "br-site-b-policy-upstream-access-hostile";
              };
              interface.name = "policy-hostile";
            };

            policy-hostile-east-west = {
              link = "p2p-b-router-policy-b-router-upstream-selector--access-b-router-access-hostile--uplink-east-west";
              adapterName = "${"p2p-b-router-policy-b-router-upstream-selector--access-b-router-access-hostile--uplink-east-west"}-policy-hostile-east-west";
              attach = {
                kind = "bridge";
                bridge = "br-site-b-policy-upstream-access-hostile-east-west";
              };
              interface.name = "pol-hostile-ew";
            };
          };
        };
        }
      // siteC.realizationNodes;
  };
}
