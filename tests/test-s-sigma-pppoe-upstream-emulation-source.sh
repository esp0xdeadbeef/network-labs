#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-010-SDS-010-SMS-010
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/sat"

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
      def fixture_ok($row):
        $row.gampId == "FS-800-HDS-010-SDS-010-SMS-010"
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
      and $realization.pppoeNixos.host == "s-router-test"
      and $realization.pppoeNixos.fixtureRef.customerCoreNode == $nixosFixture.customer.coreNode
      and $realization.pppoeNixos.substrate.ispHandoff.bridge == "br-nix-pppoe"
      and $realization.pppoeClab.scenarioId == $clabFixture.scenarioId
      and $realization.pppoeClab.backend == "clab"
      and $realization.pppoeClab.host == "s-router-clab"
      and $realization.pppoeClab.fixtureRef.customerCoreNode == $clabFixture.customer.coreNode
      and $realization.pppoeClab.substrate.ispHandoff.bridge == "br-clab-pppoe"
      and $realization.pppoeNixos.substrate.ispHandoff.bridge != $realization.pppoeClab.substrate.ispHandoff.bridge
      and .inventory.deployment.hosts."s-router-test".bridgeNetworks."br-nix-pppoe".isolated == true
      and .inventory.deployment.hosts."s-router-clab".bridgeNetworks."br-clab-pppoe".isolated == true
      and (.inventory.deployment.hosts."s-router-test".bridgeNetworks."br-nix-pppoe" | has("vlan") | not)
      and (.inventory.deployment.hosts."s-router-clab".bridgeNetworks."br-clab-pppoe" | has("vlan") | not)
  ' >/dev/null

echo "PASS s-sigma-pppoe-upstream-emulation-source-boundary"
