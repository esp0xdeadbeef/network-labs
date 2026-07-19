#!/usr/bin/env bash
# GAMP-ID: FS-560-HDS-010-SDS-010-SMS-050
# GAMP-SCOPE: cross-repo construction proof; not live SMT/SIT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
github_root="$(dirname "${repo_root}")"
row="${repo_root}/GAMP/SMT/FS-560-HDS-010-SDS-010-SMS-050"
cpm="${github_root}/network-control-plane-model"
nixos_renderer="${github_root}/network-renderer-nixos"
clab_renderer="${github_root}/network-renderer-containerlab-linux-backend"

cpm_revision="f130cdc6f4c1932944fffb0d007f10087af9c87c"
nixos_revision="4055fbb489b720ea8b197a3a780ae870676e9089"
clab_revision="7c0ec1132f607806b0cbf653914cb7a6218cb789"

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

[[ "$(jq -r '.nodes["network-control-plane-model"].locked.rev' "${nixos_renderer}/flake.lock")" == "${cpm_revision}" ]] \
  || fail "NixOS renderer does not pin the candidate CPM revision"
[[ "$(jq -r '.nodes["network-control-plane-model"].locked.rev' "${clab_renderer}/flake.lock")" == "${cpm_revision}" ]] \
  || fail "CLAB renderer does not pin the candidate CPM revision"

ROW="${row}" nix eval --impure --expr '
  let
    row = builtins.getEnv "ROW";
    intent = import (row + "/intent.nix");
    nixos = import (row + "/inventory-nixos.nix");
    clab = import (row + "/inventory-clab.nix");
    clients = import (row + "/inventory-test-clients.nix");
    source = nixos.realization.reservationSource;
    publication = source.namePublication;
  in
  assert nixos.realization == clab.realization;
  assert source.schema == "gamp-protected-reservation-set-v1";
  assert source.sourceClass == "protected";
  assert source.sourceFile == "/run/secrets/fs560-lab-client-reservations.json";
  assert !(publication ? source);
  assert !(publication ? sourceFamily);
  assert publication.ownerScope == nixos.realization.scopeId;
  assert publication.requesterScopes == [ nixos.realization.scopeId ];
  assert publication.recordClasses == [ "A" "AAAA" "PTR" ];
  assert publication.fallbackBehavior == "local-only";
  assert intent.communicationContract.recursionAuthority == "unchanged";
  assert intent.communicationContract.publicEgressAuthority == false;
  assert intent.communicationContract.transitiveEgress == false;
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
    tests/FS-560-HDS-010-SDS-010-SMS-050-protected-reservation-name-materialization.sh
)
(
  cd "${nixos_renderer}"
  NETWORK_REPO_DIRECT_TEST_OK=1 \
    tests/FS-560-HDS-010-SDS-010-SMS-050-protected-reservation-name-materialization.sh
)
(
  cd "${clab_renderer}"
  NETWORK_REPO_DIRECT_TEST_OK=1 \
    tests/test-fs560-hds010-sds010-sms050-protected-reservation-name-materialization.sh
)

printf '%s\n' 'PASS FS-560-HDS-010-SDS-010-SMS-050 native protected name-publication construction candidate'
