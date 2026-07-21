#!/usr/bin/env bash
# GAMP-ID: FS-560-HDS-010-SDS-010-SMS-050
# GAMP-SCOPE: cross-repo construction proof; not live SMT/SIT evidence
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
row="${repo_root}/GAMP/SMT/FS-560-HDS-010-SDS-010-SMS-050"

fail() {
  printf 'FAIL FS-560-HDS-010-SDS-010-SMS-050: %s\n' "$*" >&2
  exit 1
}

ROW="${row}" nix eval --impure --expr '
  let
    row = builtins.getEnv "ROW";
    intent = import (row + "/intent.nix");
    nixos = import (row + "/inventory-nixos.nix");
    clab = import (row + "/inventory-clab.nix");
    clients = import (row + "/inventory-test-clients.nix");
    intentSite = intent.mini-smt.FS-560-HDS-010-SDS-010-SMS-050;
    nixosNode = builtins.head (builtins.attrValues nixos.realization.nodes);
    clabNode = builtins.head (builtins.attrValues clab.realization.nodes);
    nixos4 = nixosNode.advertisements.dhcp4.tenant-client.reservationSource;
    nixos6 = nixosNode.advertisements.dhcpv6.tenant-client.reservationSource;
    clab4 = clabNode.advertisements.dhcp4.tenant-client.reservationSource;
    clab6 = clabNode.advertisements.dhcpv6.tenant-client.reservationSource;
    publication = nixos4.namePublication;
    inventoryPublication = source: builtins.removeAttrs source [ "sourceFile" ];
  in
  assert inventoryPublication nixos4 == inventoryPublication clab4;
  assert inventoryPublication nixos6 == inventoryPublication clab6;
  assert nixos4.schema == "gamp-protected-reservation-set-v1";
  assert nixos4.sourceClass == "protected";
  assert nixos4.sourceFile == "/run/secrets/fs560-protected-reservations.json";
  assert clab4.sourceFile == "/run/secrets/fs560-clab-protected-reservations.json";
  assert !(nixos4 ? source);
  assert !(nixos4 ? sourceFamily);
  assert !(publication ? source);
  assert !(publication ? sourceFamily);
  assert publication.ownerScope == "client";
  assert publication.requesterScopes == [ "client" ];
  assert publication.recordClasses == [ "A" "AAAA" "PTR" ];
  assert publication.fallbackBehavior == "local-only";
  assert builtins.length intentSite.communicationContract.relations == 1;
  assert (builtins.head intentSite.communicationContract.relations).id ==
    "FS-560-HDS-010-SDS-010-SMS-050__mini-verify";
  assert (builtins.head intentSite.communicationContract.relations).to.kind == "external";
  assert (builtins.head intentSite.communicationContract.relations).action == "allow";
  assert clients.clients.lab-client.identifiersToEnroll == [
    "mac"
    "stable-ipv6-iid"
    "duid"
    "iaid"
  ];
  assert clients.clients.lab-client.assertions.unknownNamespaceNameTerminatesLocally;
  true
' >/dev/null || fail "row-local intent/inventory ownership contract failed"

printf '%s\n' 'PASS FS-560-HDS-010-SDS-010-SMS-050 row-local protected name-publication source'
