#!/usr/bin/env bash
# GAMP-ID: FS-380-HDS-020-SDS-010-SMS-120
# GAMP-SCOPE: active-lab mini SMT; prod-like IPv4 client egress over VLAN4; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
trace_id="FS-380-HDS-020-SDS-010-SMS-120"
relation_id="${trace_id}__prod-like-client-to-vlan4-internet"
row_root="${repo_root}/GAMP/SMT/${trace_id}"
manifest_file="${repo_root}/GAMP/SMT/mini-smt/tests.nix"
mini_file="${repo_root}/GAMP/SMT/mini-smt/default.nix"

fail() {
  echo "FAIL ${trace_id} prod-like-vlan4-client-egress: $*" >&2
  exit 1
}

[[ -f "${row_root}/intent.nix" ]] || fail "missing row intent"
[[ -f "${row_root}/intent-test-clients.nix" ]] || fail "missing row test-client endpoint CPM source"

nix eval --impure --expr "
let
  manifest = import ${manifest_file};
  mini = import ${mini_file};
  row = manifest.tests.\"${trace_id}\";
  lab = mini.labs.\"${trace_id}\";
  rowDefault = import ${row_root}/default.nix;
  smsDefault = import ${repo_root}/GAMP/SMS/${trace_id}/default.nix;
  intent = import ${row_root}/intent.nix;
  inventoryNixos = import ${row_root}/inventory-nixos.nix;
  inventoryClab = import ${row_root}/inventory-clab.nix;
  inventoryClients = import ${row_root}/inventory-test-clients.nix;
  intentClients = import ${row_root}/intent-test-clients.nix;
  site = intent.\"mini-smt\".\"${trace_id}\";
  require = cond: msg: if cond then true else throw msg;
  expectedTargets = [
    \"access-vlan2\"
    \"core\"
    \"downstream-selector\"
    \"policy\"
    \"upstream-selector\"
  ];
  expectedPath = [
    \"access-vlan2\"
    \"downstream-selector\"
    \"policy\"
    \"upstream-selector\"
    \"core\"
  ];
  ipv4Traffic = builtins.head site.communicationContract.trafficTypes;
  relation = builtins.head site.communicationContract.relations;
  clientEndpoint =
    intentClients.control_plane_model.data.\"mini-smt\".\"${trace_id}\".endpointAssignment.\"prod-like-vlan4-client01\";
  vlan4Ok = uplink:
    uplink.mode == \"vlan\"
    && uplink.parent == \"eth0\"
    && uplink.vlan == 4
    && uplink.bridge == \"internet-vlan4\"
    && uplink.ipv4.enable == true
    && uplink.ipv4.dhcp == true
    && uplink.ipv4.method == \"dhcp\";
  clientBridgeOk = host:
    host.bridgeNetworks.client.mode == \"vlan\"
    && host.bridgeNetworks.client.parent == \"eth0\"
    && host.bridgeNetworks.client.vlan == 302;
  accessPortOk = inventory:
    let port = inventory.realization.nodes.\"mini-smt-${trace_id}-access-vlan2\".ports.tenant-client;
    in port.attach.kind == \"bridge\" && port.attach.bridge == \"client\" && port.interface.name == \"lan2\";
in
  require (row.traceId == \"${trace_id}\" && rowDefault.traceId == \"${trace_id}\")
    \"manifest and row default must carry the full SMS trace\"
  && require (row.script == \"tests/FS-380-HDS-020-SDS-010-SMS-120-prod-like-vlan4-client-egress.sh\")
    \"manifest must point at the full-trace focused script\"
  && require (row.maxRuntimeTargets == 5 && lab.maxRuntimeTargets == 5)
    \"prod-like VLAN4 row must keep the five-node router runtime cap\"
  && require (builtins.attrNames lab.runtimeTargets == expectedTargets)
    \"prod-like VLAN4 row must declare access-vlan2/downstream/policy/upstream/core targets\"
  && require (row.source.expectedRelationIds == [ \"${relation_id}\" ])
    \"manifest must carry the exact prod-like relation id\"
  && require (relation.id == \"${relation_id}\" && relation.trafficType == \"ipv4-any\")
    \"row relation must be IPv4-only and full-trace identified\"
  && require (relation.to.uplinks == [ \"internet-vlan4\" ])
    \"row relation must target the VLAN4 upstream only\"
  && require (ipv4Traffic.match == [ { family = \"ipv4\"; proto = \"any\"; } ])
    \"row traffic type must be IPv4-only\"
  && require (site.ownership.prefixes == [ { kind = \"tenant\"; name = \"client\"; ipv4 = \"10.38.120.0/24\"; ipv6 = \"fd42:380:120::/64\"; } ])
    \"row must use lab-only client tenant prefixes, not the prod LAN CIDR\"
  && require ((builtins.attrNames site.topology.nodes) == expectedTargets)
    \"row topology nodes must match the prod-like five-node chain\"
  && require (site.topology.links == [
    [ \"access-vlan2\" \"downstream-selector\" ]
    [ \"downstream-selector\" \"policy\" ]
    [ \"policy\" \"upstream-selector\" ]
    [ \"upstream-selector\" \"core\" ]
  ])
    \"row topology links must match the prod-like routed chain\"
  && require (lab.clientEndpoint.name == \"prod-like-vlan4-client01\")
    \"mini row must name the real s-router-test-clients endpoint\"
  && require (lab.clientEndpoint.address4 == \"10.38.120.10\" && lab.clientEndpoint.gateway4 == \"10.38.120.1\")
    \"mini row endpoint must be static behind access-vlan2\"
  && require (lab.clientEndpoint.host == \"s-router-test-clients\" && lab.clientEndpoint.bridge == \"client\")
    \"mini row endpoint must run on s-router-test-clients and attach to client bridge\"
  && require (clientBridgeOk inventoryNixos.deploymentHosts.s-router-nixos)
    \"NixOS router host must expose shared VLAN302 client bridge\"
  && require (clientBridgeOk inventoryClab.deploymentHosts.s-router-clab)
    \"CLAB host must expose shared VLAN302 client bridge\"
  && require (clientBridgeOk inventoryClients.deploymentHosts.s-router-test-clients)
    \"test-client host must expose shared VLAN302 client bridge\"
  && require (vlan4Ok inventoryNixos.deploymentHosts.s-router-nixos.uplinks.internet-vlan4)
    \"NixOS router host must expose VLAN4 DHCP upstream\"
  && require (vlan4Ok inventoryClab.deploymentHosts.s-router-clab.uplinks.internet-vlan4)
    \"CLAB host must expose VLAN4 DHCP upstream\"
  && require (accessPortOk inventoryNixos)
    \"NixOS access-vlan2 tenant port must attach to the shared client bridge\"
  && require (accessPortOk inventoryClab)
    \"CLAB access-vlan2 tenant port must attach to the shared client bridge\"
  && require (clientEndpoint.bridge == \"client\" && clientEndpoint.mode == \"static\")
    \"test-client endpoint must attach to the shared client bridge as a static endpoint\"
  && require (clientEndpoint.static.address == \"10.38.120.10\" && clientEndpoint.static.gateway4 == \"10.38.120.1\" && clientEndpoint.static.prefixLength == 24)
    \"test-client endpoint must carry explicit IPv4 address, prefix, and gateway\"
  && require (smsDefault.titleSlug == \"prod-like-vlan4-client-egress\")
    \"SMS template must identify the prod-like VLAN4 egress row\"
  && require (lab.expectedPath == expectedPath)
    \"mini row must preserve the expected prod-like path\"
" >/dev/null || fail "source contract failed"

tmp_dir="$(mktemp -d "/tmp/${trace_id}.XXXXXX")"
trap 'rm -rf "${tmp_dir}"' EXIT
ln -s "${repo_root}/GAMP" "${tmp_dir}/GAMP"

NETWORK_LABS_CURRENT_LAB_DIR="${tmp_dir}/current-lab" \
  bash "${repo_root}/scripts/select-current-lab.sh" SMT "${trace_id}" >/dev/null

nix run --show-trace --no-warn-dirty --no-write-lock-file \
  "path:${NETWORK_CONTROL_PLANE_MODEL_ROOT:-${repo_root}/../network-control-plane-model}#compile-and-build-control-plane-model" -- \
  "${tmp_dir}/current-lab/intent.nix" \
  "${tmp_dir}/current-lab/inventory-nixos.nix" \
  "${tmp_dir}/cpm.json" >/dev/null

jq -e --arg trace "${trace_id}" --arg relation "${relation_id}" '
  .control_plane_model.data."mini-smt"[$trace] as $site
  | ($site.runtimeTargets | keys | sort) as $targets
  | [
      "mini-smt-\($trace)-access-vlan2",
      "mini-smt-\($trace)-core",
      "mini-smt-\($trace)-downstream-selector",
      "mini-smt-\($trace)-policy",
      "mini-smt-\($trace)-upstream-selector"
    ] as $expectedTargets
  | if $targets != $expectedTargets then
      error("runtime target mismatch: " + ($targets | join(",")))
    elif ([ $site.trafficPaths[]? | select(.relationId == $relation and .nodePath == ["access-vlan2","downstream-selector","policy","upstream-selector","core"]) ] | length) != 1 then
      error("prod-like path missing from trafficPaths")
    elif (($site.ipv4.internetModes.privateNat44 // []) | length) != 1 then
      error("expected one privateNat44 internet mode")
    elif ($site.ipv4.internetModes.privateNat44[0].runtimeTarget != "mini-smt-\($trace)-core") then
      error("privateNat44 must be owned by core")
    elif ($site.ipv4.internetModes.privateNat44[0].uplinks != ["internet-vlan4"]) then
      error("privateNat44 must use only internet-vlan4")
    elif (($site.ipv4.internetModes.privateNat44[0].sourcePrefixes // []) | index("10.38.120.0/24")) == null then
      error("privateNat44 must include the client tenant source prefix")
    elif (($site.hostNat.hostMasqueradePrefixes4 // []) | index("10.38.120.0/24")) == null then
      error("hostNat must include the client tenant source prefix")
    elif ($site.hostNat.egressBridge != "internet-vlan4") then
      error("hostNat egress bridge must be internet-vlan4")
    elif (($site.endpointAssignment // {}) != {}) then
      error("router CPM must not contain test-client endpointAssignment")
    else
      true
    end
' "${tmp_dir}/cpm.json" >/dev/null || fail "router CPM artifact failed"

nix eval --json --impure --expr "
let
  intentClients = import ${tmp_dir}/current-lab/intent-s-router-test-clients.nix;
  inventoryClients = import ${tmp_dir}/current-lab/inventory-test-clients.nix;
in
{
  endpoint = intentClients.control_plane_model.data.\"mini-smt\".\"${trace_id}\".endpointAssignment.\"prod-like-vlan4-client01\";
  host = intentClients.control_plane_model.deployment.hosts.s-router-test-clients;
  inventoryHost = inventoryClients.deploymentHosts.s-router-test-clients;
}
" | jq -e '
  .endpoint.bridge == "client"
  and .endpoint.mode == "static"
  and .endpoint.static.address == "10.38.120.10"
  and .endpoint.static.gateway4 == "10.38.120.1"
  and .endpoint.static.prefixLength == 24
  and .host.bridgeNetworks.client.mode == "vlan"
  and .host.bridgeNetworks.client.vlan == 302
  and .inventoryHost.uplinks.management.vlan == 2
' >/dev/null || fail "test-client endpoint current-lab artifact failed"

echo "PASS ${trace_id} prod-like-vlan4-client-egress"
