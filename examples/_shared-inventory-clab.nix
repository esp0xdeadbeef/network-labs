{ inventory }:
let
  base = import inventory;

  baseDeployment = base.deployment or { };
  baseContainerlab = base.containerlab or { };
in
base
// {
  deployment =
    baseDeployment
    // {
      hosts = baseDeployment.hosts or { };
    };

  # Containerlab/VM lab convenience settings.
  # Kept in inventory so the renderer stays generic and technique-agnostic.
  containerlab =
    baseContainerlab
    // {
      roles =
        (baseContainerlab.roles or { })
        // {
          core = {
            forwarding = {
              # Core boxes may legitimately need eth0 (CLAB mgmt) for lab internet egress.
              disable_eth0 = false;
            };
            wan_firewall = {
              masquerade = {
                # Containerlab management NIC.
                oifnames = [ "eth0" ];
                ipv4 = true;
                ipv6 = true;
              };
            };
          };

          policy = { forwarding.disable_eth0 = true; };
          upstream-selector = { forwarding.disable_eth0 = true; };
          downstream-selector = { forwarding.disable_eth0 = true; };

          # If these exist in a topology, they can use eth0 normally.
          wan-peer = { forwarding.disable_eth0 = false; };
          isp = { forwarding.disable_eth0 = false; };
        };
    };
}
