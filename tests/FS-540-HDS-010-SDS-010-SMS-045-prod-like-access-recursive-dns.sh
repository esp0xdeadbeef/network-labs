#!/usr/bin/env bash
# GAMP-ID: FS-540-HDS-010-SDS-010-SMS-045
# GAMP-SCOPE: active-lab mini SMT; prod-like recursive DNS over VLAN4; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
trace_id="FS-540-HDS-010-SDS-010-SMS-045"
client_dns_relation_id="${trace_id}__prod-like-client-to-access-dns"
dns_vlan4_relation_id="${trace_id}__prod-like-access-dns-to-vlan4"
internet_relation_id="${trace_id}__prod-like-client-to-vlan4-internet"
row_root="${repo_root}/GAMP/SMT/${trace_id}"
manifest_file="${repo_root}/GAMP/SMT/mini-smt/tests.nix"
mini_file="${repo_root}/GAMP/SMT/mini-smt/default.nix"

fail() {
  echo "FAIL ${trace_id} prod-like-access-recursive-dns: $*" >&2
  exit 1
}

expect_nix_failure() {
  local name="$1"
  local expected="$2"
  local expr_file="$3"
  local out_file="${tmp_dir}/${name}.out"
  local err_file="${tmp_dir}/${name}.err"

  if nix eval --impure --file "${expr_file}" >"${out_file}" 2>"${err_file}"; then
    cat "${out_file}" >&2
    fail "seeded negative ${name} unexpectedly passed"
  fi

  if ! grep -F "${expected}" "${err_file}" >/dev/null; then
    cat "${err_file}" >&2
    fail "seeded negative ${name} did not report '${expected}'"
  fi
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
  expectedRelationIds = [
    \"${client_dns_relation_id}\"
    \"${dns_vlan4_relation_id}\"
    \"${internet_relation_id}\"
  ];
  findOne = what: pred: values:
    let matches = builtins.filter pred values;
    in if builtins.length matches == 1 then builtins.head matches else throw (\"expected exactly one \" + what);
  trafficTypeByName = name:
    findOne (\"traffic type \" + name) (trafficType: trafficType.name == name) site.communicationContract.trafficTypes;
  relationById = id:
    findOne (\"relation \" + id) (relation: relation.id == id) site.communicationContract.relations;
  serviceByName = name:
    findOne (\"service \" + name) (service: service.name == name) site.communicationContract.services;
  ipv4Traffic = trafficTypeByName \"ipv4-any\";
  dnsTraffic = trafficTypeByName \"dns\";
  clientDnsRelation = relationById \"${client_dns_relation_id}\";
  dnsVlan4Relation = relationById \"${dns_vlan4_relation_id}\";
  internetRelation = relationById \"${internet_relation_id}\";
  accessDnsService = serviceByName \"access-dns\";
  accessDnsEndpoint = findOne \"ownership service endpoint access-dns\" (endpoint: endpoint.name == \"access-dns\") (site.ownership.endpoints or [ ]);
  clientEndpoint =
    intentClients.control_plane_model.data.\"mini-smt\".\"${trace_id}\".endpointAssignment.\"prod-like-dns-client01\";
  clabClientEndpoint =
    intentClients.control_plane_model.data.\"mini-smt\".\"${trace_id}\".endpointAssignment.\"prod-like-dns-clab-client01\";
  vlan4Ok = uplink:
    uplink.mode == \"vlan\"
    && uplink.parent == \"eth0\"
    && uplink.vlan == 4
    && uplink.bridge == \"internet-vlan4\"
    && uplink.ipv4.enable == true
    && uplink.ipv4.dhcp == true
    && uplink.ipv4.method == \"dhcp\";
  clientBridgeOk = host:
    host.bridgeNetworks.dnsclient.mode == \"vlan\"
    && host.bridgeNetworks.dnsclient.parent == \"eth0\"
    && host.bridgeNetworks.dnsclient.vlan == 304;
  clabClientBridgeOk = host:
    host.bridgeNetworks.dnsclab.mode == \"vlan\"
    && host.bridgeNetworks.dnsclab.parent == \"eth0\"
    && host.bridgeNetworks.dnsclab.vlan == 305;
  managementUplinkOk = host:
    host.uplinks.management.mode == \"vlan\"
    && host.uplinks.management.parent == \"eth0\"
    && host.uplinks.management.vlan == 2
    && host.uplinks.management.bridge == \"vlan2\"
    && host.uplinks.management.ipv4.enable == true
    && host.uplinks.management.ipv4.dhcp == true
    && host.uplinks.management.ipv4.method == \"dhcp\"
    && host.uplinks.management.ipv6.enable == false
    && host.uplinks.management.ipv6.acceptRA == false;
  accessPortOk = expectedBridge: inventory:
    let port = inventory.realization.nodes.\"mini-smt-${trace_id}-access-vlan2\".ports.tenant-client;
    in port.attach.kind == \"bridge\" && port.attach.bridge == expectedBridge && port.interface.name == \"lan2\";
  accessDnsOk = inventory:
    let
      node = inventory.realization.nodes.\"mini-smt-${trace_id}-access-vlan2\";
      dns = node.services.dns;
    in
    inventory.endpoints.access-dns.ipv4 == [ \"10.54.45.1\" ]
    && dns.forwarders == [ \"1.1.1.1\" \"9.9.9.9\" ]
    && dns.outgoingInterfaces == [ \"10.54.45.1\" ]
    && dns.roles.recursion.outgoingInterfaces == [ \"10.54.45.1\" ];
in
  require (row.traceId == \"${trace_id}\" && rowDefault.traceId == \"${trace_id}\")
    \"manifest and row default must carry the full SMS trace\"
  && require (row.script == \"tests/FS-540-HDS-010-SDS-010-SMS-045-prod-like-access-recursive-dns.sh\")
    \"manifest must point at the full-trace focused script\"
  && require (row.maxRuntimeTargets == 5 && lab.maxRuntimeTargets == 5)
    \"prod-like recursive DNS row must keep the five-node router runtime cap\"
  && require (builtins.attrNames lab.runtimeTargets == expectedTargets)
    \"prod-like recursive DNS row must declare access-vlan2/downstream/policy/upstream/core targets\"
  && require (row.source.expectedRelationIds == expectedRelationIds && rowDefault.source.expectedRelationIds == expectedRelationIds && lab.source.expectedRelationIds == expectedRelationIds)
    \"manifest, row default, and mini row must carry the exact prod-like relation ids\"
  && require (builtins.map (relation: relation.id) site.communicationContract.relations == expectedRelationIds)
    \"row relations must keep full-trace ids in declared order\"
  && require (clientDnsRelation.from == { kind = \"tenant\"; name = \"client\"; } && clientDnsRelation.to == { kind = \"service\"; name = \"access-dns\"; } && clientDnsRelation.trafficType == \"dns\")
    \"row must model client access to the access DNS service\"
  && require (dnsVlan4Relation.from == { kind = \"service\"; name = \"access-dns\"; } && dnsVlan4Relation.to.kind == \"external\" && dnsVlan4Relation.to.uplinks == [ \"internet-vlan4\" ] && dnsVlan4Relation.trafficType == \"dns\")
    \"row must model access DNS service egress to VLAN4\"
  && require (internetRelation.id == \"${internet_relation_id}\" && internetRelation.trafficType == \"ipv4-any\")
    \"row relation must be IPv4-only and full-trace identified\"
  && require (internetRelation.to.uplinks == [ \"internet-vlan4\" ])
    \"row internet relation must target the VLAN4 upstream only\"
  && require (accessDnsService == { name = \"access-dns\"; providers = [ \"access-dns\" ]; trafficType = \"dns\"; })
    \"row must declare the access DNS service provider explicitly\"
  && require (accessDnsEndpoint == { kind = \"host\"; name = \"access-dns\"; tenant = \"client\"; ipv4 = [ \"10.54.45.1\" ]; ipv6 = [ \"fd42:540:45::1\" ]; })
    \"row must bind the access DNS service provider to an explicit host/listener ownership endpoint\"
  && require (dnsTraffic.match == [
    { family = \"ipv4\"; proto = \"udp\"; dports = [ 53 ]; }
    { family = \"ipv4\"; proto = \"tcp\"; dports = [ 53 ]; }
  ])
    \"row DNS traffic type must be IPv4 UDP/TCP 53 only\"
  && require (ipv4Traffic.match == [ { family = \"ipv4\"; proto = \"any\"; } ])
    \"row traffic type must be IPv4-only\"
  && require (site.ownership.prefixes == [ { kind = \"tenant\"; name = \"client\"; ipv4 = \"10.54.45.0/24\"; ipv6 = \"fd42:540:45::/64\"; } ])
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
  && require (lab.clientEndpoint.name == \"prod-like-dns-client01\")
    \"mini row must name the real s-router-test-clients endpoint\"
  && require (lab.clientEndpoint.address4 == \"10.54.45.10\" && lab.clientEndpoint.gateway4 == \"10.54.45.1\")
    \"mini row endpoint must be static behind access-vlan2\"
  && require (lab.clientEndpoint.host == \"s-router-test-clients\" && lab.clientEndpoint.bridge == \"dnsclient\")
    \"mini row endpoint must run on s-router-test-clients and attach to dnsclient bridge\"
  && require (clientBridgeOk inventoryNixos.deploymentHosts.s-router-nixos)
    \"NixOS router host must expose shared VLAN304 dnsclient bridge\"
  && require (clabClientBridgeOk inventoryClab.deploymentHosts.s-router-clab)
    \"CLAB host must expose isolated VLAN305 dnsclab bridge\"
  && require (clientBridgeOk inventoryClients.deploymentHosts.s-router-test-clients)
    \"test-client host must expose shared VLAN304 dnsclient bridge\"
  && require (clabClientBridgeOk inventoryClients.deploymentHosts.s-router-test-clients)
    \"test-client host must expose isolated VLAN305 dnsclab bridge for CLAB\"
  && require (managementUplinkOk inventoryClients.deploymentHosts.s-router-test-clients)
    \"test-client inventory must expose management VLAN2 as CPM host uplink source\"
  && require (managementUplinkOk intentClients.control_plane_model.deployment.hosts.s-router-test-clients)
    \"test-client endpoint CPM source must carry management VLAN2 host uplink\"
  && require (vlan4Ok inventoryNixos.deploymentHosts.s-router-nixos.uplinks.internet-vlan4)
    \"NixOS router host must expose VLAN4 DHCP upstream\"
  && require (vlan4Ok inventoryClab.deploymentHosts.s-router-clab.uplinks.internet-vlan4)
    \"CLAB host must expose VLAN4 DHCP upstream\"
  && require (accessPortOk \"dnsclient\" inventoryNixos)
    \"NixOS access-vlan2 tenant port must attach to the shared dnsclient bridge\"
  && require (accessPortOk \"dnsclab\" inventoryClab)
    \"CLAB access-vlan2 tenant port must attach to the isolated dnsclab bridge\"
  && require (accessDnsOk inventoryNixos)
    \"NixOS access-vlan2 must carry explicit IPv4 DNS forwarder/source authority\"
  && require (accessDnsOk inventoryClab)
    \"CLAB access-vlan2 must carry explicit IPv4 DNS forwarder/source authority\"
  && require (clientEndpoint.bridge == \"dnsclient\" && clientEndpoint.mode == \"static\")
    \"test-client endpoint must attach to the shared dnsclient bridge as a static endpoint\"
  && require (clientEndpoint.static.address == \"10.54.45.10\" && clientEndpoint.static.gateway4 == \"10.54.45.1\" && clientEndpoint.static.prefixLength == 24)
    \"test-client endpoint must carry explicit IPv4 address, prefix, and gateway\"
  && require (clabClientEndpoint.bridge == \"dnsclab\" && clabClientEndpoint.mode == \"static\")
    \"CLAB test-client endpoint must attach to the isolated dnsclab bridge as a static endpoint\"
  && require (clabClientEndpoint.static.address == \"10.54.45.10\" && clabClientEndpoint.static.gateway4 == \"10.54.45.1\" && clabClientEndpoint.static.prefixLength == 24)
    \"CLAB test-client endpoint must carry explicit IPv4 address, prefix, and gateway\"
  && require (smsDefault.titleSlug == \"prod-like-access-recursive-dns\")
    \"SMS template must identify the prod-like recursive DNS row\"
  && require (lab.expectedPath == expectedPath)
    \"mini row must preserve the expected prod-like path\"
" >/dev/null || fail "source contract failed"

tmp_dir="$(mktemp -d "/tmp/${trace_id}.XXXXXX")"
trap 'rm -rf "${tmp_dir}"' EXIT
ln -s "${repo_root}/GAMP" "${tmp_dir}/GAMP"

cat >"${tmp_dir}/negative-missing-recursive-egress.nix" <<EOF
let
  trace = "${trace_id}";
  recursiveEgressRelationId = "${dns_vlan4_relation_id}";
  source = import ${row_root}/intent.nix;
  site = source."mini-smt".\${trace};
  badSite = site // {
    communicationContract = site.communicationContract // {
      relations = builtins.filter
        (relation: relation.id != recursiveEgressRelationId)
        site.communicationContract.relations;
    };
  };
  relationMatches = builtins.filter
    (relation: relation.id == recursiveEgressRelationId)
    badSite.communicationContract.relations;
in
if builtins.length relationMatches == 1 then
  true
else
  throw "${trace_id} missing recursive egress relation ${dns_vlan4_relation_id}"
EOF

cat >"${tmp_dir}/negative-advertised-without-recursion.nix" <<EOF
let
  trace = "${trace_id}";
  recursiveEgressRelationId = "${dns_vlan4_relation_id}";
  source = import ${row_root}/intent.nix;
  site = source."mini-smt".\${trace};
  clients = import ${row_root}/intent-test-clients.nix;
  endpoint =
    clients.control_plane_model.data."mini-smt".\${trace}.endpointAssignment."prod-like-dns-client01";
  badRelations = builtins.filter
    (relation: relation.id != recursiveEgressRelationId)
    site.communicationContract.relations;
  advertised = endpoint.static.dnsServers == [ "10.54.45.1" ];
  hasRecursiveEgress =
    builtins.length (builtins.filter
      (relation: relation.id == recursiveEgressRelationId)
      badRelations) == 1;
in
if advertised && ! hasRecursiveEgress then
  throw "${trace_id} resolver advertised without modeled recursion for 10.54.45.1"
else
  true
EOF

cat >"${tmp_dir}/negative-public-resolver-fallback.nix" <<EOF
let
  trace = "${trace_id}";
  clients = import ${row_root}/intent-test-clients.nix;
  endpoint =
    clients.control_plane_model.data."mini-smt".\${trace}.endpointAssignment."prod-like-dns-client01";
  badEndpoint = endpoint // {
    static = endpoint.static // {
      dnsServers = [ "1.1.1.1" ];
    };
  };
in
if badEndpoint.static.dnsServers != [ "10.54.45.1" ] then
  throw "${trace_id} unmodeled public resolver fallback for prod-like DNS client"
else
  true
EOF

expect_nix_failure \
  "negative-missing-recursive-egress" \
  "${trace_id} missing recursive egress relation ${dns_vlan4_relation_id}" \
  "${tmp_dir}/negative-missing-recursive-egress.nix"

expect_nix_failure \
  "negative-advertised-without-recursion" \
  "${trace_id} resolver advertised without modeled recursion for 10.54.45.1" \
  "${tmp_dir}/negative-advertised-without-recursion.nix"

expect_nix_failure \
  "negative-public-resolver-fallback" \
  "${trace_id} unmodeled public resolver fallback for prod-like DNS client" \
  "${tmp_dir}/negative-public-resolver-fallback.nix"

NETWORK_LABS_CURRENT_LAB_DIR="${tmp_dir}/current-lab" \
  bash "${repo_root}/scripts/select-current-lab.sh" SMT "${trace_id}" >/dev/null

# CPM nix run + jq validation removed per FS-985-HDS-010-SDS-010-SMS-020 (repo-local test boundary).
# CPM output validation belongs in network-control-plane-model/tests/.

nix eval --json --impure --expr "
let
  intentClients = import ${tmp_dir}/current-lab/intent-s-router-test-clients.nix;
  inventoryClients = import ${tmp_dir}/current-lab/inventory-test-clients.nix;
in
{
  endpoint = intentClients.control_plane_model.data.\"mini-smt\".\"${trace_id}\".endpointAssignment.\"prod-like-dns-client01\";
  clabEndpoint = intentClients.control_plane_model.data.\"mini-smt\".\"${trace_id}\".endpointAssignment.\"prod-like-dns-clab-client01\";
  host = intentClients.control_plane_model.deployment.hosts.s-router-test-clients;
  inventoryHost = inventoryClients.deploymentHosts.s-router-test-clients;
}
" | jq -e '
  .endpoint.bridge == "dnsclient"
  and .endpoint.mode == "static"
  and .endpoint.static.address == "10.54.45.10"
  and .endpoint.static.gateway4 == "10.54.45.1"
  and .endpoint.static.prefixLength == 24
  and .clabEndpoint.bridge == "dnsclab"
  and .clabEndpoint.mode == "static"
  and .clabEndpoint.static.address == "10.54.45.10"
  and .clabEndpoint.static.gateway4 == "10.54.45.1"
  and .clabEndpoint.static.prefixLength == 24
  and .host.bridgeNetworks.dnsclient.mode == "vlan"
  and .host.bridgeNetworks.dnsclient.vlan == 304
  and .host.bridgeNetworks."dnsclab".mode == "vlan"
  and .host.bridgeNetworks."dnsclab".vlan == 305
  and .inventoryHost.uplinks.management.vlan == 2
' >/dev/null || fail "test-client endpoint current-lab artifact failed"

echo "PASS ${trace_id} prod-like-access-recursive-dns"
