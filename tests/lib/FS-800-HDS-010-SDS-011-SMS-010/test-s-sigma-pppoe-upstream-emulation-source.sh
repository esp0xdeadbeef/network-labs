#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-010-SDS-011-SMS-010
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
lab_dir="${repo_root}/GAMP/SAT"
split_gamp_id="FS-800-HDS-010-SDS-011-SMS-010"

fail() {
  echo "FAIL s-sigma-pppoe-upstream-emulation-source-boundary: $*" >&2
  exit 1
}

nix eval --impure --json --expr "{
  intent = import ${lab_dir}/intent.nix;
  inventory = import ${lab_dir}/inventory.nix;
  providerAccessFixtureTable = import ${lab_dir}/provider-access-fixture-table.nix;
}" \
  | jq -e '
    .providerAccessFixtureTable.pppoeNixos as $nixosFixture
    | .providerAccessFixtureTable.pppoeClab as $clabFixture
    | .inventory.controlPlane.providerAccess.scenarios as $realization
    | def side_channel_path:
        .intent
        | paths
        | select(
          .[-1] == "upstreamEmulation"
          or .[-1] == "providerAccess"
          or .[-1] == "failureExpectation"
          or .[-1] == "probeIntent"
          or .[-1] == "accessConcentrator"
          or .[-1] == "credentials"
        );
      def intent_technology_string:
        .intent
        | ..
        | strings
        | select(test("pppoe|wan-dhcp|wan-slaac|access-concentrator|accel-ppp"; "i"));
      def has_required_field($row; $path):
        any($row.requiredFields[]; . == $path);
      def fixture_ok($row):
        $row.gampId == "FS-800-HDS-010-SDS-011-SMS-010"
        and has_required_field($row; ["provider", "role"])
        and has_required_field($row; ["publicFacing", "ipv4", "sessionPrefix"])
        and has_required_field($row; ["dns", "resolver", "upstreamSource"])
        and has_required_field($row; ["probeIntent"])
        and $row.provider.role == "emulated-isp"
        and $row.provider.handoff == "pppoe"
        and $row.provider.addressDelivery.ipv4 == "pppoe-session-address"
        and $row.provider.addressDelivery.ipv6 == "pppoe-delegated-prefix"
        and ($row.provider.addressDelivery.excluded | index("wan-dhcp") != null)
        and ($row.provider.addressDelivery.excluded | index("wan-slaac") != null)
        and ($row.publicFacing.ipv4.sessionPrefix | test("^203[.]0[.]113[.]"))
        and $row.publicFacing.ipv4.snatPrivateTenants == true
        and ($row.publicFacing.ipv6.delegatedAggregate | test("^2001:db8:800:"))
        and $row.publicFacing.ipv6.childPrefixLength == 64
        and $row.publicFacing.ipv6.nat66 == false
        and $row.firewall.defaultInbound == "deny"
        and $row.firewall.allowEstablishedRelated == true
        and $row.firewall.allowPppoeControl == true
        and ($row.firewall.leakPrevention | index("deny-direct-public-dns-from-tenants") != null)
        and ($row.firewall.leakPrevention | index("deny-ula-to-emulated-isp") != null)
        and $row.dns.followSource == true
        and $row.dns.resolver.consumer == "site-resolver"
        and $row.dns.resolver.implementationClass == "unbound-or-equivalent"
        and $row.dns.resolver.upstreamSource == "follow-source"
        and ($row.dns | has("advertisedBy") | not)
        and ($row.dns | has("recursiveForwarders") | not)
        and ($row.probeIntent | index("pppoe-session-up") != null)
        and ($row.probeIntent | index("pppoe-ipv6-delegated-prefix") != null)
        and ($row.probeIntent | index("no-wan-dhcp") != null)
        and ($row.probeIntent | index("no-wan-slaac") != null)
        and ($row.probeIntent | index("no-nat66-routed-gua") != null);
      def realization_ok($row):
        ($row | has("publicFacing") | not)
        and ($row | has("firewall") | not)
        and ($row | has("dns") | not)
        and ($row | has("probeIntent") | not)
        and ($row | has("prefixes") | not)
        and $row.substrate.labUplink.vlan == 4
        and $row.substrate.ispHandoff.kind == "isolated-bridge"
        and $row.substrate.ispHandoff.physical == false
        and ($row.substrate.ispHandoff | has("vlan") | not)
        and ($row.substrate.ispHandoff.bridge | length) <= 15
        and $row.substrate.mtu == 1492
        and $row.accessConcentrator.implementation == "accel-ppp"
        and $row.accessConcentrator.side == "provider"
        and $row.credentials.labOnly == true
        and ($row.credentials.usernameFile | test("^/run/secrets/sat-pppoe-"))
        and ($row.credentials.passwordFile | test("^/run/secrets/sat-pppoe-"));
      def runtime_contract_ok($fixture; $row; $inventory):
        $row.runtime as $runtime
        | $inventory.realization.nodes[$runtime.providerRuntimeNode] as $provider
        | $inventory.realization.nodes[$runtime.customerRuntimeNode] as $customer
        | $provider != null
        and $customer != null
        and $row.accessConcentrator.node == $runtime.providerRuntimeNode
        and $runtime.servicePlacement.server.node == $runtime.providerRuntimeNode
        and $runtime.servicePlacement.client.node == $runtime.customerRuntimeNode
        and $runtime.servicePlacement.server.service == "pppoe.server"
        and $runtime.servicePlacement.client.service == "pppoe.client"
        and $provider.host == $row.host
        and $customer.host == $row.host
        and $provider.logicalNode.name == $runtime.providerLogicalNode
        and $customer.logicalNode.name == $fixture.customer.coreNode
        and $runtime.providerRuntimeNode != $runtime.customerRuntimeNode
        and $runtime.handoff.bridge == $row.substrate.ispHandoff.bridge
        and ($runtime.handoff.link | test("^sat-pppoe-.*-handoff$"))
        and $runtime.handoff.providerPort == "pppoe-server"
        and $runtime.handoff.providerInterface == "pppoe-server"
        and $runtime.handoff.customerPort == "pppoe-wan"
        and $runtime.handoff.customerInterface == $fixture.customer.coreInterface
        and $runtime.servicePlacement.server.interface == $runtime.handoff.providerInterface
        and $runtime.servicePlacement.client.interface == $runtime.handoff.customerInterface
        and $runtime.servicePlacement.client.runtimeInterface == "ppp0"
        and $runtime.servicePlacement.client.defaultRoute == true
        and $runtime.servicePlacement.client.usePeerDns == true;
      ([side_channel_path] == [])
      and ([intent_technology_string] == [])
      and fixture_ok($nixosFixture)
      and fixture_ok($clabFixture)
      and $nixosFixture.scenarioId == "SAT-SCEN-EMULATED-ISP-NIXOS-001"
      and $nixosFixture.customer.site == "nixos"
      and $nixosFixture.customer.coreNode == "nixos-router-core-isp-a"
      and .intent.esp.nixos.topology.nodes[$nixosFixture.customer.coreNode].role == "core"
      and $clabFixture.scenarioId == "SAT-SCEN-EMULATED-ISP-CLAB-001"
      and $clabFixture.customer.site == "clab"
      and $clabFixture.customer.coreNode == "clab-router-core-simulated-isp"
      and .intent.esp.clab.topology.nodes[$clabFixture.customer.coreNode].role == "core"
      and realization_ok($realization.pppoeNixos)
      and realization_ok($realization.pppoeClab)
      and $realization.pppoeNixos.scenarioId == $nixosFixture.scenarioId
      and $realization.pppoeNixos.backend == "nixos"
      and $realization.pppoeNixos.host == "s-router-nixos"
      and $realization.pppoeNixos.fixtureRef.customerCoreNode == $nixosFixture.customer.coreNode
      and $realization.pppoeNixos.substrate.ispHandoff.bridge == "br-nix-pppoe"
      and $realization.pppoeNixos.runtime.customerRuntimeNode == "esp-nixos-router-core-isp-a"
      and $realization.pppoeNixos.runtime.providerRuntimeNode == "esp-nixos-router-upstream"
      and $realization.pppoeClab.scenarioId == $clabFixture.scenarioId
      and $realization.pppoeClab.backend == "clab"
      and $realization.pppoeClab.host == "s-router-clab"
      and $realization.pppoeClab.fixtureRef.customerCoreNode == $clabFixture.customer.coreNode
      and $realization.pppoeClab.substrate.ispHandoff.bridge == "br-clab-pppoe"
      and $realization.pppoeClab.runtime.customerRuntimeNode == "esp-clab-router-core-simulated-isp"
      and $realization.pppoeClab.runtime.providerRuntimeNode == "esp-clab-router-upstream"
      and runtime_contract_ok($nixosFixture; $realization.pppoeNixos; .inventory)
      and runtime_contract_ok($clabFixture; $realization.pppoeClab; .inventory)
      and $realization.pppoeNixos.substrate.ispHandoff.bridge != $realization.pppoeClab.substrate.ispHandoff.bridge
      and .inventory.deployment.hosts[$realization.pppoeNixos.host].bridgeNetworks[$realization.pppoeNixos.substrate.ispHandoff.bridge].isolated == true
      and .inventory.deployment.hosts[$realization.pppoeClab.host].bridgeNetworks[$realization.pppoeClab.substrate.ispHandoff.bridge].isolated == true
      and (.inventory.deployment.hosts[$realization.pppoeNixos.host].bridgeNetworks[$realization.pppoeNixos.substrate.ispHandoff.bridge] | has("vlan") | not)
      and (.inventory.deployment.hosts[$realization.pppoeClab.host].bridgeNetworks[$realization.pppoeClab.substrate.ispHandoff.bridge] | has("vlan") | not)
  ' >/dev/null

nix eval --impure --raw --expr "
  let
    table = import ${lab_dir}/provider-access-fixture-table.nix;
    require = cond: msg: if cond then true else throw msg;
    splitGampId = \"${split_gamp_id}\";
    joinPath = builtins.concatStringsSep \".\";
    pathPresent = value: path:
      if path == [ ] then true
      else
        let
          key = builtins.head path;
          rest = builtins.tail path;
        in
          builtins.isAttrs value && builtins.hasAttr key value && pathPresent value.\${key} rest;
    removePath = value: path:
      if path == [ ] then value
      else
        let
          key = builtins.head path;
          rest = builtins.tail path;
        in
          if rest == [ ]
          then builtins.removeAttrs value [ key ]
          else value // { \${key} = removePath value.\${key} rest; };
    validateProviderAccessRow = name: row:
      let
        requiredPaths = row.requiredFields;
        missing = builtins.filter (path: !(pathPresent row path)) requiredPaths;
        firstMissing = if missing == [ ] then null else builtins.head missing;
      in
        require (row.gampId == splitGampId)
          \"\${splitGampId}: provider-access \${name} must carry the split SDS-011/SMS-010 GAMP ID before downstream inference\"
        && require (row.requiredFields != [ ])
          \"\${splitGampId}: provider-access \${name} must declare required fields before downstream inference\"
        && require (missing == [ ])
          \"\${splitGampId}: provider-access \${name} missing required field \${joinPath firstMissing} before downstream inference\";
    expectMissingRejected = name: path:
      let
        row = removePath table.\${name} path;
        result = builtins.tryEval (validateProviderAccessRow name row);
      in
        require (!result.success)
          \"\${splitGampId}: missing required provider-access field \${name}.\${joinPath path} was accepted before downstream inference\";
  in
    if validateProviderAccessRow \"pppoeNixos\" table.pppoeNixos
      && validateProviderAccessRow \"pppoeClab\" table.pppoeClab
      && expectMissingRejected \"pppoeNixos\" [ \"provider\" \"role\" ]
      && expectMissingRejected \"pppoeNixos\" [ \"publicFacing\" \"ipv4\" \"sessionPrefix\" ]
      && expectMissingRejected \"pppoeNixos\" [ \"dns\" \"resolver\" \"upstreamSource\" ]
      && expectMissingRejected \"pppoeClab\" [ \"provider\" \"addressDelivery\" \"ipv6\" ]
      && expectMissingRejected \"pppoeClab\" [ \"firewall\" \"leakPrevention\" ]
      && expectMissingRejected \"pppoeClab\" [ \"probeIntent\" ]
    then \"true\"
    else throw \"${split_gamp_id}: provider-access required-field validation did not complete\"
" >/dev/null || fail "split-ID required-field validation failed"

echo "PASS s-sigma-pppoe-upstream-emulation-source-boundary"
