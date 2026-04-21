(import ./inventory.nix) // {
  containerlab = {
    roles = {
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
