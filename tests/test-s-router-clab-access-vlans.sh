#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/sat"

common_vlan_checks='
  def vlan_bindings:
    .deployment.hosts
    | to_entries
    | map(
        .key as $host
        | [
            ((.value.bridgeNetworks // {})
              | to_entries[]
              | select((.value.mode // "") == "vlan")
              | {
                  kind: "bridgeNetwork",
                  host: $host,
                  name: .key,
                  parent: .value.parent,
                  vlan: .value.vlan
                }),
            ((.value.uplinks // {})
              | to_entries[]
              | select((.value.mode // "") == "vlan")
              | {
                  kind: "uplink",
                  host: $host,
                  name: (.value.bridge // .key),
                  parent: .value.parent,
                  vlan: .value.vlan
                })
          ]
      )
    | flatten;

  def declared_bridges:
    .deployment.hosts
    | to_entries
    | map(
        .key as $host
        | [
            ((.value.bridgeNetworks // {}) | keys[] | { host: $host, bridge: . }),
            ((.value.uplinks // {}) | to_entries[] | { host: $host, bridge: (.value.bridge // .key) })
          ]
      )
    | flatten
    | unique;

  def used_bridges:
    .realization.nodes
    | to_entries
    | map(
        .key as $node
        | .value.host as $host
        | (.value.ports // {})
        | to_entries[]
        | select(.value.attach.kind == "bridge")
        | { host: $host, bridge: .value.attach.bridge, node: $node, port: .key }
      );

  def has_no_duplicate_host_parent_vlan:
    vlan_bindings
    | group_by([.host, .parent, .vlan])
    | all(length == 1);

  def has_no_bridge_name_vlan_collision:
    vlan_bindings
    | group_by([.host, .name])
    | all((map(.vlan) | unique | length) == 1);

  def all_used_bridges_are_declared:
    declared_bridges as $declared
    | used_bridges
    | all(. as $used | any($declared[]; .host == $used.host and .bridge == $used.bridge));

  def no_management_vlan2_in_clab_inventory:
    vlan_bindings
    | map(select(.host == "s-router-clab" or .host == "s-router-test-clients"))
    | map(select(.kind == "bridgeNetwork"))
    | all(.vlan != 2 and .name != "vlan2");
'

check_inventory() {
  local inventory_expr="$1"
  local assertion="$2"

  nix eval --impure --json --expr "${inventory_expr}" \
    | jq -e "${common_vlan_checks} ${assertion}" >/dev/null
}

check_inventory "import ${lab_dir}/getInventory.nix { renderer = \"clab\"; }" '
  def clab_access_vlans:
    {
      mgmt: 300,
      admin: 301,
      client: 302,
      dmz: 304,
      branch: 305,
      hostile: 306,
      streaming: 311
    };

  def client_fixture_vlans:
    {};

  def bridge_vlans_are(host_name; expected):
    .deployment.hosts[host_name].bridgeNetworks as $bridges
    | expected
    | to_entries
    | all(
        $bridges[.key].mode == "vlan"
        and $bridges[.key].parent == "eth0"
        and $bridges[.key].vlan == .value
      );

  bridge_vlans_are("s-router-clab"; clab_access_vlans)
  and bridge_vlans_are("s-router-test-clients"; clab_access_vlans)
  and bridge_vlans_are("s-router-test-clients"; client_fixture_vlans)
  and has_no_duplicate_host_parent_vlan
  and has_no_bridge_name_vlan_collision
  and all_used_bridges_are_declared
  and no_management_vlan2_in_clab_inventory
'

check_inventory "import ${lab_dir}/getInventory.nix { renderer = \"nixos\"; }" '
  .deployment.hosts["s-router-test-clients"].bridgeNetworks as $bridges
  | all(["hetz-mgmt", "home-users", "printer", "nas"][]; $bridges[.] == null)
  and has_no_duplicate_host_parent_vlan
  and has_no_bridge_name_vlan_collision
  and all_used_bridges_are_declared
'

echo "PASS s-router-clab-access-vlans"
