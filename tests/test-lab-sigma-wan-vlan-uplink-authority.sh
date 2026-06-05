#!/usr/bin/env bash
# GAMP-ID: FS-780-HDS-010-SDS-010-SMS-010
# GAMP-ID: FS-800-HDS-010-SDS-010-SMS-010
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/sat"

check_inventory() {
  local renderer="$1"

  nix eval --impure --json --expr "import ${lab_dir}/getInventory.nix { renderer = \"${renderer}\"; }" \
    | jq -e '
      def target_vlans: [4, 5];
      def is_target_vlan($value): target_vlans | index($value) != null;

      def wan_vlan_host_uplinks:
        .deployment.hosts
        | to_entries
        | map(
            .key as $host
            | ((.value.uplinks // {}) | to_entries[])
            | select(is_target_vlan(.value.vlan // null))
            | {
                host: $host,
                name: .key,
                bridge: (.value.bridge // .key),
                parent: (.value.parent // null),
                upstream: (.value.upstream // null),
                vlan: .value.vlan
              }
          );

      def target_vlan_bridge_networks:
        .deployment.hosts
        | to_entries
        | map(
            .key as $host
            | ((.value.bridgeNetworks // {}) | to_entries[])
            | select(is_target_vlan(.value.vlan // null))
            | {
                host: $host,
                name: .key,
                parent: (.value.parent // null),
                vlan: .value.vlan
              }
          );

      def ports_using_wan_vlan_bridges:
        wan_vlan_host_uplinks as $uplinks
        | .realization.nodes
        | to_entries
        | map(
            .key as $node
            | .value.host as $host
            | ((.value.ports // {}) | to_entries[])
            | (.value.attach // {}) as $attach
            | select($attach.kind == "bridge")
            | select(any($uplinks[]; .host == $host and .bridge == $attach.bridge))
            | {
                node: $node,
                port: .key,
                host: $host,
                bridge: $attach.bridge,
                external: (.value.external // false),
                uplink: (.value.uplink // null)
              }
          );

      def routed_prefix_authority_mentions_wan_vlan:
        [.. | objects | .routedPrefixes? // empty]
        | tostring
        | test("vlan4|vlan5|vlan-4|vlan-5|br-uplink0|br-uplink1|uplink-isp-a|uplink-isp-b"; "i");

      wan_vlan_host_uplinks as $uplinks
      | target_vlan_bridge_networks as $bridge_networks
      | ports_using_wan_vlan_bridges as $ports
      | routed_prefix_authority_mentions_wan_vlan as $prefix_mentions
      | (target_vlans as $target | all($target[]; . as $v | any($uplinks[]; .vlan == $v)))
      and all(["s-router-test", "s-router-clab"][]; . as $host | all(target_vlans[]; . as $v | any($uplinks[]; .host == $host and .vlan == $v)))
      and ($uplinks | all((.bridge | type) == "string" and (.bridge | length) > 0 and (.parent | type) == "string" and (.parent | length) > 0))
      and ($bridge_networks | length) == 0
      and ($ports | length) > 0
      and ($ports | all(.external == true and (.uplink | type) == "string" and (.uplink | length) > 0))
      and ($prefix_mentions | not)
    ' >/dev/null
}

check_inventory "nixos"
check_inventory "clab"

echo "PASS lab-sigma-wan-vlan-uplink-authority"
