{
  meta = {
    traceId = "FS-380-HDS-020-SDS-010-SMS-050";
    renderer = "nixos";
    scope = "row-local-smt-sit-inventory-stub";
    evidenceBoundary = "source-stub-only";
  };
  hosts = { };
  deploymentHosts = {
    s-router-nixos = {
      accessHandoff = {
        kind = "pppoe";
        server = "emulated-isp";
      };
      uplinks = {
        emulated-isp-vlan4 = {
          mode = "dhcp";
          parent = "eth0";
          vlan = 4;
        };
        emulated-isp-vlan5 = {
          mode = "dhcp";
          parent = "eth0";
          vlan = 5;
        };
      };
    };
  };
}
