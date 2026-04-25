{ inventory }:
let
  base = import inventory;

  # CLAB VM examples should not depend on host-specific physical uplink parents
  # like eno1/eno2 or vlan-backed host wiring. Keep the logical uplink/bridge
  # shape intact, but strip the concrete parent so examples remain runnable in
  # the generic VM while still modeling VLAN/trunk structure in the inventory.
  normalizeHost = host:
    host
    // {
      uplinks = builtins.mapAttrs (_: uplink: builtins.removeAttrs uplink [ "parent" ]) (host.uplinks or { });
    };

  baseDeployment = base.deployment or { };
  baseContainerlab = base.containerlab or { };
in
base
// {
  deployment =
    baseDeployment
    // {
      hosts = builtins.mapAttrs (_: normalizeHost) (baseDeployment.hosts or { });
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
