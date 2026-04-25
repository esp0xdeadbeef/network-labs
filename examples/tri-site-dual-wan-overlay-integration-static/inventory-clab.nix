let
  base = import ./inventory-base.nix;
  baseDeployment = base.deployment or { };
  baseContainerlab = base.containerlab or { };
  baseHost = (baseDeployment.hosts or { }).s-router-test or { };
in
base
// {
  deployment =
    baseDeployment
    // {
      hosts =
        (baseDeployment.hosts or { })
        // {
          s-router-test =
            baseHost
            // {
              uplinks = {
                uplink-isp-a = {
                  parent = "eno1";
                  bridge = "br-uplink0";
                  upstream = "isp-a";
                  ipv4.method = "dhcp";
                  ipv6.method = "slaac";
                };

                uplink-isp-b = {
                  parent = "eno2";
                  bridge = "br-uplink1";
                  upstream = "isp-b";
                  ipv4.method = "dhcp";
                  ipv6.method = "slaac";
                };
              };
            };
        };
    };

  containerlab =
    baseContainerlab
    // {
      roles =
        (baseContainerlab.roles or { })
        // {
          core = {
            forwarding.disable_eth0 = false;
            wan_firewall.masquerade = {
              oifnames = [ "eth0" ];
              ipv4 = true;
              ipv6 = true;
            };
          };
          policy.forwarding.disable_eth0 = true;
          upstream-selector.forwarding.disable_eth0 = true;
          downstream-selector.forwarding.disable_eth0 = true;
          wan-peer.forwarding.disable_eth0 = false;
          isp.forwarding.disable_eth0 = false;
        };
    };
}
