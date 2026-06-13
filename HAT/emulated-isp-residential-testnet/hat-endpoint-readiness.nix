# HAT endpoint readiness: NixOS module that builds HAT endpoint fixture containers
# and the readiness service that the HAT rebuild loop checks.
#
# Owned by: network-labs HAT/emulated-isp-residential-testnet
# Consumed by: nixos repo s-router-test-clients/default.nix (thin import)
# Trace: URS L196-235 → FS-720 → HDS-030 → SDS-010
#
# This module reads inventory's hat.endpointClients, builds NixOS containers
# for each nixos-owned endpoint, and creates the oneshot readiness service
# that writes /run/s-router-test-clients-hat-endpoints-ready when all
# endpoint containers are up and configured.
{
  lib,
  hostName ? "s-router-test-clients",
  inventoryPath,
  rendererPath,
}:

{
  config,
  pkgs,
  lib,
  ...
}:

let
  inventoryFile =
    if builtins.pathExists inventoryPath then
      inventoryPath
    else
      throw "hat-endpoint-readiness: inventory path not found: ${toString inventoryPath}";

  labInventory = import inventoryFile;

  hatEndpointClients =
    (((labInventory.deployment or { }).hosts or { }).${hostName} or { }).hat.endpointClients
      or { };

  # Only build containers for nixos-owned endpoints (skip clab-owned)
  nixosEndpointClients = lib.filterAttrs
    (_name: ep: (ep.owningSubstrate or "nixos") == "nixos")
    hatEndpointClients;

  hatEndpointNames = builtins.attrNames nixosEndpointClients;

  # Import container builders from access-endpoint-nixos renderer
  builders = import "${rendererPath}/lib/client-builders.nix" {
    inherit lib pkgs;
  };

  # Build one container per HAT endpoint client
  mkHatEndpointContainer = name: ep:
    let
      assignment = ep.assignment or "dhcp";
      tenant = ep.tenant or name;
      bridge = ep.bridge or tenant;
      staticIpv4 = ep.ipv4 or [ ];
      staticIpv6 = ep.ipv6 or [ ];
    in
    if assignment == "dhcp" then
      {
        autoStart = true;
        privateNetwork = true;
        hostBridge = bridge;
        config = builders.mkDhcpEndpoint { hostname = name; };
      }
    else if assignment == "static-ipv4-or-ipv6-client" || assignment == "static" then
      let
        addr4 =
          if staticIpv4 != [ ] then
            let raw = builtins.head staticIpv4;
            in if lib.hasInfix "/" raw then raw
               else throw "hat-endpoint-readiness: ${name} ipv4 missing prefix: ${raw}"
          else throw "hat-endpoint-readiness: static endpoint ${name} has no ipv4";
        gw4 = ep.gateway4
          or (throw "hat-endpoint-readiness: static endpoint ${name} has no gateway4");
        addr6 =
          if staticIpv6 != [ ] then
            let raw = builtins.head staticIpv6;
            in if lib.hasInfix "/" raw then raw
               else throw "hat-endpoint-readiness: ${name} ipv6 missing prefix: ${raw}"
          else throw "hat-endpoint-readiness: static endpoint ${name} has no ipv6";
        gw6 = ep.gateway6
          or (throw "hat-endpoint-readiness: static endpoint ${name} has no gateway6");
      in
      {
        autoStart = true;
        privateNetwork = true;
        hostBridge = bridge;
        config = builders.mkStaticEndpoint {
          hostname = name;
          inherit addr4 gw4 addr6 gw6;
        };
      }
    else
      throw "hat-endpoint-readiness: ${name} unsupported assignment ${assignment}";

  # Static IP and route verification commands (injected into readiness script)
  hatEndpointStaticChecks = lib.concatMapStringsSep "\n"
    (name:
      let
        ep = nixosEndpointClients.${name};
        assignment = ep.assignment or "dhcp";
        staticIpv4 = ep.ipv4 or [ ];
        staticIpv6 = ep.ipv6 or [ ];
        ipv4Check =
          if staticIpv4 != [ ] then
            let addr = builtins.head staticIpv4;
                addrOnly = builtins.head (lib.splitString "/" addr);
            in ''
              timeout 5 nixos-container run ${lib.escapeShellArg name} -- \
                ip -br addr show dev eth0 | grep -F ${lib.escapeShellArg addrOnly} >/dev/null
            ''
          else "";
        ipv6Check =
          if staticIpv6 != [ ] then
            let addr = builtins.head staticIpv6;
                addrOnly = builtins.head (lib.splitString "/" addr);
            in ''
              timeout 5 nixos-container run ${lib.escapeShellArg name} -- \
                ip -br addr show dev eth0 | grep -F ${lib.escapeShellArg addrOnly} >/dev/null
            ''
          else "";
        routeCheck =
          if ep ? gateway4 then ''
            timeout 5 nixos-container run ${lib.escapeShellArg name} -- \
              ip route | grep -F ${lib.escapeShellArg "default via ${ep.gateway4}"} >/dev/null
          '' else "";
      in
      lib.optionalString (assignment == "static-ipv4-or-ipv6-client" || assignment == "static") ''
        ${ipv4Check}
        ${ipv6Check}
        ${routeCheck}
      ''
    )
    hatEndpointNames;

  # DHCP verification commands
  hatEndpointDhcpChecks = lib.concatMapStringsSep "\n"
    (name:
      let ep = nixosEndpointClients.${name};
          assignment = ep.assignment or "dhcp";
      in
      lib.optionalString (assignment == "dhcp") ''
        timeout 5 nixos-container run ${lib.escapeShellArg name} -- \
          ip -4 -o addr show scope global dev eth0 | grep -F " inet " >/dev/null
        timeout 5 nixos-container run ${lib.escapeShellArg name} -- \
          ip -4 route show default | grep -F "default " >/dev/null
      ''
    )
    hatEndpointNames;

  # The oneshot readiness script
  hatEndpointReadyScript = pkgs.writeShellScript "s-router-test-clients-hat-endpoint-ready" ''
    set -euo pipefail
    marker=/run/s-router-test-clients-hat-endpoints-ready
    check_hat_endpoints() {
      for client in ${lib.concatMapStringsSep " " lib.escapeShellArg hatEndpointNames}; do
        timeout 5 nixos-container status "$client" | grep -F "up" >/dev/null
      done
      ${hatEndpointStaticChecks}
      ${hatEndpointDhcpChecks}
    }
    for _ in $(seq 1 120); do
      if check_hat_endpoints; then
        printf 'ready\n' > "$marker"
        exit 0
      fi
      sleep 2
    done
    check_hat_endpoints
    printf 'ready\n' > "$marker"
  '';

  hatEndpointContainers = builtins.mapAttrs mkHatEndpointContainer nixosEndpointClients;

in
{
  containers = lib.mkIf (nixosEndpointClients != { }) hatEndpointContainers;

  systemd.services.s-router-test-clients-hat-endpoint-ready = lib.mkIf (nixosEndpointClients != { }) {
    wantedBy = [ "multi-user.target" ];
    after = map (name: "container@${name}.service") hatEndpointNames;
    requires = map (name: "container@${name}.service") hatEndpointNames;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = hatEndpointReadyScript;
    };
  };
}
