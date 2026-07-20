#!/usr/bin/env bash
# GAMP-ID: FS-560-HDS-010-SDS-010-SMS-050
# GAMP-SCOPE: cross-repo construction proof; not live SMT/SIT evidence
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
github_root="$(dirname "${repo_root}")"
row="${repo_root}/GAMP/SMT/FS-560-HDS-010-SDS-010-SMS-050"
cpm="${github_root}/network-control-plane-model"
nixos_renderer="${github_root}/network-renderer-nixos"
clab_renderer="${github_root}/network-renderer-containerlab-linux-backend"

cpm_revision="0684468ba9824e01545a22f526bc2c79c294ac7f"
nixos_revision="1761fc229c44d3c9fd927059ae04d249d16529ed"
clab_revision="15264eb1e7e598cbce270f494b6b275b6a1d021c"

fail() {
  printf 'FAIL FS-560-HDS-010-SDS-010-SMS-050: %s\n' "$*" >&2
  exit 1
}

for spec in \
  "${cpm}:${cpm_revision}" \
  "${nixos_renderer}:${nixos_revision}" \
  "${clab_renderer}:${clab_revision}"; do
  repo="${spec%%:*}"
  revision="${spec##*:}"
  [[ "$(git -C "${repo}" branch --show-current)" == "main" ]] \
    || fail "$(basename "${repo}") is not on main"
  git -C "${repo}" merge-base --is-ancestor "${revision}" refs/remotes/origin/main \
    || fail "$(basename "${repo}") candidate is not on GitHub main"
done

locked_cpm_revision() {
  local lock_file="$1"
  jq -r \
    '.nodes.root.inputs["network-control-plane-model"] as $node | .nodes[$node].locked.rev' \
    "${lock_file}"
}

[[ "$(locked_cpm_revision "${nixos_renderer}/flake.lock")" == "${cpm_revision}" ]] \
  || fail "NixOS renderer does not pin the candidate CPM revision"
[[ "$(locked_cpm_revision "${clab_renderer}/flake.lock")" == "${cpm_revision}" ]] \
  || fail "CLAB renderer does not pin the candidate CPM revision"

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

(
  cd "${cpm}"
  NETWORK_REPO_DIRECT_TEST_OK=1 \
    tests/FS-560-HDS-010-SDS-010-SMS-050.sh
)
(
  cd "${nixos_renderer}"
  NETWORK_REPO_DIRECT_TEST_OK=1 \
    tests/FS-560-HDS-010-SDS-010-SMS-050.sh
)
(
  cd "${clab_renderer}"
  NETWORK_REPO_DIRECT_TEST_OK=1 \
    tests/test-fs560-hds010-sds010-sms050-protected-reservation-name-materialization.sh
)

printf '%s\n' 'PASS FS-560-HDS-010-SDS-010-SMS-050 native protected name-publication construction candidate'
