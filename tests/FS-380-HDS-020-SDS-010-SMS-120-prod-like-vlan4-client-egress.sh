#!/usr/bin/env bash
# GAMP-ID: FS-380-HDS-020-SDS-010-SMS-120
# GAMP-SCOPE: active-lab mini SMT; prod-like IPv4 client egress over VLAN4; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
trace_id="FS-380-HDS-020-SDS-010-SMS-120"
client_dns_relation_id="${trace_id}__prod-like-client-to-access-dns"
dns_vlan4_relation_id="${trace_id}__prod-like-access-dns-to-vlan4"
internet_relation_id="${trace_id}__prod-like-client-to-vlan4-internet"
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
    intentClients.control_plane_model.data.\"mini-smt\".\"${trace_id}\".endpointAssignment.\"prod-like-vlan4-client01\";
  clabClientEndpoint =
    intentClients.control_plane_model.data.\"mini-smt\".\"${trace_id}\".endpointAssignment.\"prod-like-vlan4-clab-client01\";
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
  clabClientBridgeOk = host:
    host.bridgeNetworks.\"client-clab\".mode == \"vlan\"
    && host.bridgeNetworks.\"client-clab\".parent == \"eth0\"
    && host.bridgeNetworks.\"client-clab\".vlan == 303;
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
    inventory.endpoints.access-dns.ipv4 == [ \"10.38.120.1\" ]
    && dns.forwarders == [ \"1.1.1.1\" \"9.9.9.9\" ]
    && dns.outgoingInterfaces == [ \"10.38.120.1\" ]
    && dns.roles.recursion.outgoingInterfaces == [ \"10.38.120.1\" ];
in
  require (row.traceId == \"${trace_id}\" && rowDefault.traceId == \"${trace_id}\")
    \"manifest and row default must carry the full SMS trace\"
  && require (row.script == \"tests/FS-380-HDS-020-SDS-010-SMS-120-prod-like-vlan4-client-egress.sh\")
    \"manifest must point at the full-trace focused script\"
  && require (row.maxRuntimeTargets == 5 && lab.maxRuntimeTargets == 5)
    \"prod-like VLAN4 row must keep the five-node router runtime cap\"
  && require (builtins.attrNames lab.runtimeTargets == expectedTargets)
    \"prod-like VLAN4 row must declare access-vlan2/downstream/policy/upstream/core targets\"
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
  && require (accessDnsEndpoint == { kind = \"service\"; name = \"access-dns\"; tenant = \"client\"; })
    \"row must declare the access DNS provider as a service endpoint, not a host/client endpoint\"
  && require (dnsTraffic.match == [
    { family = \"ipv4\"; proto = \"udp\"; dports = [ 53 ]; }
    { family = \"ipv4\"; proto = \"tcp\"; dports = [ 53 ]; }
  ])
    \"row DNS traffic type must be IPv4 UDP/TCP 53 only\"
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
  && require (clabClientBridgeOk inventoryClab.deploymentHosts.s-router-clab)
    \"CLAB host must expose isolated VLAN303 client-clab bridge\"
  && require (clientBridgeOk inventoryClients.deploymentHosts.s-router-test-clients)
    \"test-client host must expose shared VLAN302 client bridge\"
  && require (clabClientBridgeOk inventoryClients.deploymentHosts.s-router-test-clients)
    \"test-client host must expose isolated VLAN303 client-clab bridge for CLAB\"
  && require (managementUplinkOk inventoryClients.deploymentHosts.s-router-test-clients)
    \"test-client inventory must expose management VLAN2 as CPM host uplink source\"
  && require (managementUplinkOk intentClients.control_plane_model.deployment.hosts.s-router-test-clients)
    \"test-client endpoint CPM source must carry management VLAN2 host uplink\"
  && require (vlan4Ok inventoryNixos.deploymentHosts.s-router-nixos.uplinks.internet-vlan4)
    \"NixOS router host must expose VLAN4 DHCP upstream\"
  && require (vlan4Ok inventoryClab.deploymentHosts.s-router-clab.uplinks.internet-vlan4)
    \"CLAB host must expose VLAN4 DHCP upstream\"
  && require (accessPortOk \"client\" inventoryNixos)
    \"NixOS access-vlan2 tenant port must attach to the shared client bridge\"
  && require (accessPortOk \"client-clab\" inventoryClab)
    \"CLAB access-vlan2 tenant port must attach to the isolated client-clab bridge\"
  && require (accessDnsOk inventoryNixos)
    \"NixOS access-vlan2 must carry explicit IPv4 DNS forwarder/source authority\"
  && require (accessDnsOk inventoryClab)
    \"CLAB access-vlan2 must carry explicit IPv4 DNS forwarder/source authority\"
  && require (clientEndpoint.bridge == \"client\" && clientEndpoint.mode == \"static\")
    \"test-client endpoint must attach to the shared client bridge as a static endpoint\"
  && require (clientEndpoint.static.address == \"10.38.120.10\" && clientEndpoint.static.gateway4 == \"10.38.120.1\" && clientEndpoint.static.prefixLength == 24)
    \"test-client endpoint must carry explicit IPv4 address, prefix, and gateway\"
  && require (clabClientEndpoint.bridge == \"client-clab\" && clabClientEndpoint.mode == \"static\")
    \"CLAB test-client endpoint must attach to the isolated client-clab bridge as a static endpoint\"
  && require (clabClientEndpoint.static.address == \"10.38.120.10\" && clabClientEndpoint.static.gateway4 == \"10.38.120.1\" && clabClientEndpoint.static.prefixLength == 24)
    \"CLAB test-client endpoint must carry explicit IPv4 address, prefix, and gateway\"
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

jq -e --arg trace "${trace_id}" --arg internet_relation "${internet_relation_id}" '
  def prefixes($rule): [($rule.sourcePrefixes // [])[] | .prefix];
  def hasRuntimeOriginRule($site; $target; $from; $to):
    [ ($site.runtimeTargets[$target].forwardingIntent.rules // [])[]
      | select(
          .relationId == "runtime-origin-egress"
          and .fromInterface == $from
          and .toInterface == $to
          and ((prefixes(.) | index("10.38.120.1/32")) != null)
        )
    ] | length == 1;
  def hasCoreDnsEgressRule($site; $coreTarget):
    [ ($site.runtimeTargets[$coreTarget].forwardingIntent.rules // [])[]
      | select(
          .comment == "allow-dns-service-egress"
          and .fromInterface == "p0"
          and .toInterface == "u0"
          and .trafficType == "dns"
          and .family == 4
          and ((prefixes(.) | index("10.38.120.1")) != null)
          and (.matches == [
            {"dports":[53],"family":"ipv4","proto":"udp"},
            {"dports":[53],"family":"ipv4","proto":"tcp"}
          ])
        )
    ] | length == 1;
  .control_plane_model.data."mini-smt"[$trace] as $site
  | ($site.runtimeTargets | keys | sort) as $targets
  | "mini-smt-\($trace)-access-vlan2" as $accessTarget
  | "mini-smt-\($trace)-core" as $coreTarget
  | "mini-smt-\($trace)-downstream-selector" as $downstreamTarget
  | "mini-smt-\($trace)-policy" as $policyTarget
  | "mini-smt-\($trace)-upstream-selector" as $upstreamTarget
  | ($site.runtimeTargets[$accessTarget].services.dns // {}) as $accessDns
  | ($site.runtimeTargets[$accessTarget].runtimeOriginEgress // {}) as $runtimeOriginEgress
  | [
      "10.10.0.0/31",
      "10.10.0.2/31",
      "10.10.0.4/31",
      "10.10.0.6/31",
      "10.38.120.0/24"
    ] as $requiredNatPrefixes
  | [
      "mini-smt-\($trace)-access-vlan2",
      "mini-smt-\($trace)-core",
      "mini-smt-\($trace)-downstream-selector",
      "mini-smt-\($trace)-policy",
      "mini-smt-\($trace)-upstream-selector"
    ] as $expectedTargets
  | if $targets != $expectedTargets then
      error("runtime target mismatch: " + ($targets | join(",")))
    elif ([ $site.trafficPaths[]? | select(.relationId == $internet_relation and .nodePath == ["access-vlan2","downstream-selector","policy","upstream-selector","core"]) ] | length) != 1 then
      error("prod-like path missing from trafficPaths")
    elif (($site.ipv4.internetModes.privateNat44 // []) | length) != 1 then
      error("expected one privateNat44 internet mode")
    elif ($site.ipv4.internetModes.privateNat44[0].runtimeTarget != "mini-smt-\($trace)-core") then
      error("privateNat44 must be owned by core")
    elif ($site.ipv4.internetModes.privateNat44[0].uplinks != ["internet-vlan4"]) then
      error("privateNat44 must use only internet-vlan4")
    elif (($site.ipv4.internetModes.privateNat44[0].sourcePrefixes // []) | index("10.38.120.0/24")) == null then
      error("privateNat44 must include the client tenant source prefix")
    elif (($requiredNatPrefixes - ($site.ipv4.internetModes.privateNat44[0].sourcePrefixes // [])) | length) != 0 then
      error("privateNat44 must include routed fabric transit source prefixes")
    elif (($site.hostNat.hostMasqueradePrefixes4 // []) | index("10.38.120.0/24")) == null then
      error("hostNat must include the client tenant source prefix")
    elif (($requiredNatPrefixes - ($site.hostNat.hostMasqueradePrefixes4 // [])) | length) != 0 then
      error("hostNat must include routed fabric transit source prefixes")
    elif ($site.hostNat.egressBridge != "internet-vlan4") then
      error("hostNat egress bridge must be internet-vlan4")
    elif ($accessDns.forwarders != ["1.1.1.1","9.9.9.9"]) then
      error("access DNS must carry explicit IPv4 forwarders")
    elif ($accessDns.outgoingInterfaces != ["10.38.120.1"]) then
      error("access DNS must use the tenant gateway as its IPv4 recursive source")
    elif ($accessDns.roles.recursion.outgoingInterfaces != ["10.38.120.1"]) then
      error("access DNS recursion role must pin the IPv4 outgoing source")
    elif (($accessDns.allowedUpstreamClasses // []) | index("explicit-egress-default")) == null then
      error("access DNS must carry explicit-egress-default authority")
    elif ([($accessDns.routeContracts // [])[] | select(.source == "dns-service" and (.dst == "1.1.1.1" or .dst == "9.9.9.9"))] | length) != 2 then
      error("access DNS must carry modeled upstream route contracts")
    elif ($runtimeOriginEgress.enabled != true or $runtimeOriginEgress.source != "dns-service") then
      error("access DNS runtimeOriginEgress must be enabled for dns-service")
    elif ($runtimeOriginEgress.preferredSources.ipv4 != "10.38.120.1") then
      error("access DNS runtimeOriginEgress must prefer 10.38.120.1")
    elif ([($runtimeOriginEgress.sourcePrefixes // [])[] | select(.family == 4 and .prefix == "10.38.120.1/32")] | length) != 1 then
      error("access DNS runtimeOriginEgress must carry 10.38.120.1/32")
    elif (hasRuntimeOriginRule($site; $downstreamTarget; "p0"; "p1") | not) then
      error("downstream-selector must forward DNS runtime-origin source toward policy")
    elif (hasRuntimeOriginRule($site; $policyTarget; "p0"; "p1") | not) then
      error("policy must forward DNS runtime-origin source toward upstream-selector")
    elif (hasRuntimeOriginRule($site; $upstreamTarget; "p1"; "p0") | not) then
      error("upstream-selector must forward DNS runtime-origin source toward core")
    elif (hasCoreDnsEgressRule($site; $coreTarget) | not) then
      error("core must allow IPv4 DNS service egress from 10.38.120.1 to VLAN4")
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
  clabEndpoint = intentClients.control_plane_model.data.\"mini-smt\".\"${trace_id}\".endpointAssignment.\"prod-like-vlan4-clab-client01\";
  host = intentClients.control_plane_model.deployment.hosts.s-router-test-clients;
  inventoryHost = inventoryClients.deploymentHosts.s-router-test-clients;
}
" | jq -e '
  .endpoint.bridge == "client"
  and .endpoint.mode == "static"
  and .endpoint.static.address == "10.38.120.10"
  and .endpoint.static.gateway4 == "10.38.120.1"
  and .endpoint.static.prefixLength == 24
  and .clabEndpoint.bridge == "client-clab"
  and .clabEndpoint.mode == "static"
  and .clabEndpoint.static.address == "10.38.120.10"
  and .clabEndpoint.static.gateway4 == "10.38.120.1"
  and .clabEndpoint.static.prefixLength == 24
  and .host.bridgeNetworks.client.mode == "vlan"
  and .host.bridgeNetworks.client.vlan == 302
  and .host.bridgeNetworks."client-clab".mode == "vlan"
  and .host.bridgeNetworks."client-clab".vlan == 303
  and .inventoryHost.uplinks.management.vlan == 2
' >/dev/null || fail "test-client endpoint current-lab artifact failed"

echo "PASS ${trace_id} prod-like-vlan4-client-egress"
