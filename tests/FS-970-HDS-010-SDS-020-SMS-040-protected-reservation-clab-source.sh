#!/usr/bin/env bash
# GAMP-ID: FS-970-HDS-010-SDS-020-SMS-040
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
row="${repo_root}/GAMP/SMT/FS-970-HDS-010-SDS-020-SMS-040"

nix eval --impure --json --expr "
let
  clab = import ${row}/inventory-clab.nix;
  nixos = import ${row}/inventory-nixos.nix;
  clients = import ${row}/intent-test-clients.nix;
  clabNode = clab.realization.nodes.\"mini-smt-fs-970-hds-010-sds-020-sms-040-client-edge\";
  source4 = clabNode.advertisements.dhcp4.tenant-client.reservationSource;
  source6 = clabNode.advertisements.dhcpv6.tenant-client.reservationSource;
in
assert clab.deploymentHosts.s-router-clab.bridgeNetworks.rsv970-clab.vlan == 398;
assert nixos.deploymentHosts.s-router-nixos.bridgeNetworks.rsv970.vlan == 397;
assert clabNode.host == \"s-router-clab\";
assert source4 == source6;
assert builtins.attrNames source4 == [ \"schema\" \"sourceClass\" \"sourceFile\" ];
assert source4.schema == \"gamp-protected-reservation-set-v1\";
assert source4.sourceClass == \"protected\";
assert source4.sourceFile == \"/run/secrets/fs970-clab-protected-reservations.json\";
assert builtins.attrNames clients.endpointAssignment == [ \"reservation-probe\" \"reservation-probe-clab\" ];
assert clients.endpointAssignment.reservation-probe.bridge == \"rsv970\";
assert clients.endpointAssignment.reservation-probe-clab.bridge == \"rsv970-clab\";
{
  clabVlan = clab.deploymentHosts.s-router-clab.bridgeNetworks.rsv970-clab.vlan;
  nixosVlan = nixos.deploymentHosts.s-router-nixos.bridgeNetworks.rsv970.vlan;
  endpointNames = builtins.attrNames clients.endpointAssignment;
}
" >/dev/null

nix eval --impure --json --expr "import ${row}/sops-routing-s-router-clab.nix {}" \
  | jq -e '.sops.secrets."fs970-clab-protected-reservations"
      | .key == "protected-reservations"
        and .mode == "0400"
        and .path == "/run/secrets/fs970-clab-protected-reservations.json"' \
      >/dev/null

jq -e '
  ."protected-reservations"
    | type == "string" and startswith("ENC[AES256_GCM")
' "${row}/secrets/sops-s-router-clab.json" >/dev/null
jq -e '
  [.sops.age[].recipient]
    | index("age1dug0ualmuqd5akne2y7zdmwztdwua35c9zle9j3e2540f2me2p3qpp6m6v") != null
' "${row}/secrets/sops-s-router-clab.json" >/dev/null

echo "PASS FS-970-HDS-010-SDS-020-SMS-040: separate encrypted CLAB reservation source on VLAN398"
