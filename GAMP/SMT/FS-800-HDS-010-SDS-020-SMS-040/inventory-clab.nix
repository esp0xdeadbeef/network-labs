let
  vlanUplink = vlan: {
      bridge = "vlan${toString vlan}";
      ipv4 = {
        dhcp = true;
        enable = true;
        method = "dhcp";
      };
      ipv6 = {
        acceptRA = true;
        dhcp = false;
        dhcpv6PD = false;
        enable = true;
        method = "slaac";
      };
      mode = "vlan";
      parent = "eth0";
      inherit vlan;
  };
in
{
  meta = {
    traceId = "FS-800-HDS-010-SDS-020-SMS-040";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-010-SDS-020-SMS-040-provider-access-default-route-selection.md";
    renderer = "clab";
    scope = "canonical-sms-source-stub";
    evidenceBoundary = "source-stub-only";
  };
  hosts = { };
  deploymentHosts = {
    s-router-clab = {
      uplinks = {
        isp = vlanUplink 4;
        pppoe-provider = vlanUplink 5;
      };
    };
  };
}
