#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
inventory="${repo_root}/labs/lab-s-sigma/s-router-test-three-site/inventory-clab.nix"
nixos_inventory="${repo_root}/labs/lab-s-sigma/s-router-test-three-site/inventory-nixos.nix"

nix eval --impure --json --expr "import ${inventory}" \
  | jq -e '
      def clab_access_vlans:
        {
          mgmt: 350,
          admin: 351,
          client: 352,
          client2: 353,
          dmz: 354,
          branch: 355,
          hostile: 356,
          streaming: 357
        };

      def client_fixture_vlans:
        {
          "site-c-mgmt": 358,
          "home-users": 359,
          printer: 360,
          nas: 361
        };

      def bridge_vlans_are(host_name; expected):
        .deployment.hosts[host_name].bridgeNetworks as $bridges
        | expected
        | to_entries
        | all(
            $bridges[.key].mode == "vlan"
            and $bridges[.key].parent == "eth0"
            and $bridges[.key].vlan == .value
          );

      def host_has_access_vlans(host_name):
        bridge_vlans_are(host_name; clab_access_vlans);

      host_has_access_vlans("s-router-test")
      and host_has_access_vlans("s-router-test-clients")
      and bridge_vlans_are("s-router-test-clients"; client_fixture_vlans)
    ' >/dev/null

nix eval --impure --json --expr "import ${nixos_inventory}" \
  | jq -e '
      def client_fixture_vlans:
        {
          "site-c-mgmt": 358,
          "home-users": 359,
          printer: 360,
          nas: 361
        };

      .deployment.hosts["s-router-test-clients"].bridgeNetworks as $bridges
      | client_fixture_vlans
      | to_entries
      | all(
          $bridges[.key].mode == "vlan"
          and $bridges[.key].parent == "eth0"
          and $bridges[.key].vlan == .value
        )
    ' >/dev/null

echo "PASS s-router-clab-access-vlans"
