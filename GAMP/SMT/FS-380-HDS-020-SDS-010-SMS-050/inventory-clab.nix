{
  meta = {
    traceId = "FS-380-HDS-020-SDS-010-SMS-050";
    renderer = "clab";
    scope = "row-local-smt-sit-inventory-stub";
    evidenceBoundary = "source-stub-only";
  };
  hosts = { };
  deploymentHosts = {
    s-router-clab = {
      accessHandoff = {
        kind = "pppoe";
        server = "emulated-isp";
      };
      uplinks = {
        emulated-isp-vlan4 = {
          mode = "dhcp";
          bridge = "vlan4";
          vlan = 4;
        };
        emulated-isp-vlan5 = {
          mode = "dhcp";
          bridge = "vlan5";
          vlan = 5;
        };
      };
    };
  };
}
