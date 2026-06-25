let
  base = import ../GAMP/HAT/emulated-isp-residential-testnet/inventory-clab.nix;
  host = base.deployment.hosts.s-router-clab or { };
in
base
// {
  activeLabInventoryStub = {
    kind = "runtime-clab-inventory-stub";
    source = ../GAMP/HAT/emulated-isp-residential-testnet/inventory-clab.nix;
    runtimeManagement.vlan2 = "management-only";
  };

  deployment = base.deployment // {
    hosts = base.deployment.hosts // {
      s-router-clab = host // {
        uplinks = (host.uplinks or { }) // {
          management = {
            bridge = "vlan2";
            ipv4 = {
              dhcp = true;
              enable = true;
              method = "dhcp";
            };
            ipv6 = {
              acceptRA = false;
              dhcp = false;
              dhcpv6PD = false;
              enable = false;
              method = "none";
            };
            mode = "vlan";
            parent = "eth0";
            vlan = 2;
          };
        };
      };
    };
  };
}
