#!/usr/bin/env bash
# GAMP-ID: FS-880-HDS-010-SDS-010
# GAMP-ID: FS-880-HDS-010-SDS-010-SMS-010
# GAMP-ID: FS-880-HDS-010-SDS-010-SMS-020
# GAMP-ID: FS-880-HDS-010-SDS-010-SMS-030
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
sat_dir="${repo_root}/sat"
hat_dir="${repo_root}/HAT/emulated-isp-residential-testnet"

fail() {
  echo "FAIL fs880-lease-namespace-source-contract: $*" >&2
  exit 1
}

nix eval --impure --raw --expr "
  let
    sat = import ${sat_dir}/inventory.nix;
    resolvedSat = import ${sat_dir}/getResolvedInventory.nix { renderer = \"nixos\"; };
    hatNixos = import ${hat_dir}/inventory-nixos.nix;
    hatClab = import ${hat_dir}/inventory-clab.nix;
    deniedClasses = [
      \"recursive-dns-authority\"
      \"payload-reachability\"
      \"management-reachability\"
      \"public-egress\"
    ];
    hasAll = expected: actual:
      builtins.all (value: builtins.elem value actual) expected;
    validRecord = expectedClass: record:
      (record.namespaceOwner or null) == \"tenant-client\"
      && (record.requesterScope or null) == \"tenant-client\"
      && (record.recordClass or null) == expectedClass
      && (record.conflictBehavior or null) == \"fail-closed\"
      && (record.staleRecordBehavior or null) == \"fail-closed-deny-answer\"
      && (record.fallbackBehavior or null) == \"blocked-no-public-recursion\"
      && hasAll deniedClasses (record.deniedClasses or [ ])
      && (record.leaseRevocationBehavior or null) == \"remove-lease-name-on-client-revocation\";
    satDhcp4 = builtins.head sat.realization.nodes.esp-nixos-router-access-client.advertisements.dhcp4.tenant-client.reservations;
    satDhcp6 = builtins.head sat.realization.nodes.esp-nixos-router-access-client.advertisements.dhcpv6.tenant-client.reservations;
    resolvedDhcp4 = builtins.head resolvedSat.realization.nodes.esp-nixos-router-access-client.advertisements.dhcp4.tenant-client.reservations;
    resolvedDhcp6 = builtins.head resolvedSat.realization.nodes.esp-nixos-router-access-client.advertisements.dhcpv6.tenant-client.reservations;
    hatNixosDhcp4 =
      hatNixos.realization.nodes.esp0xdeadbeef-site-a-nixos-access-client.advertisements.dhcp4.tenant-client.namespaceContract;
    hatClabNixosDhcp4 =
      hatClab.realization.nodes.esp0xdeadbeef-site-a-nixos-access-client.advertisements.dhcp4.tenant-client.namespaceContract;
    hatClabDhcp4 =
      hatClab.realization.nodes.esp0xdeadbeef-site-b-clab-access-client.advertisements.dhcp4.tenant-client.namespaceContract;
  in
    if validRecord "dhcp4-lease-name" satDhcp4
      && validRecord "dhcpv6-lease-name" satDhcp6
      && validRecord "dhcp4-lease-name" resolvedDhcp4
      && validRecord "dhcpv6-lease-name" resolvedDhcp6
      && validRecord \"dhcp4-lease-name\" hatNixosDhcp4
      && validRecord \"dhcp4-lease-name\" hatClabNixosDhcp4
      && validRecord \"dhcp4-lease-name\" hatClabDhcp4
    then \"true\"
    else throw \"FS-880 lease namespace source records must carry owner, requester scope, record class, denied classes, and fail-closed conflict/stale/revocation/fallback behavior\"
" >/dev/null || fail "HAT/SAT source lacks required value-bearing FS-880 fields"

echo "PASS fs880-lease-namespace-source-contract"
