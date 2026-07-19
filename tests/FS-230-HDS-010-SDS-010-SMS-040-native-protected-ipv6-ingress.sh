#!/usr/bin/env bash
# GAMP-ID: FS-230-HDS-010-SDS-010-SMS-040
# GAMP-SCOPE: cross-repo construction proof; not live SMT/SIT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
github_root="$(dirname "${repo_root}")"
row="${repo_root}/GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040"
cpm="${github_root}/network-control-plane-model"
nixos_renderer="${github_root}/network-renderer-nixos"
clab_renderer="${github_root}/network-renderer-containerlab-linux-backend"

cpm_revision="4a28239803ec91a71fb4f244ce5f00eb32c50981"
nixos_revision="e665b9475b7e03fe736ac2a58e368c3b8188ad08"
clab_revision="1ebfa486465ceb9602eee0ec4df116880c7ab5ca"

fail() {
  echo "FAIL FS-230-HDS-010-SDS-010-SMS-040: $*" >&2
  exit 1
}

for spec in \
  "${cpm}:${cpm_revision}" \
  "${nixos_renderer}:${nixos_revision}" \
  "${clab_renderer}:${clab_revision}"
do
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
    relation = builtins.head intent.communicationContract.relations;
    authority = relation.publicIngressTupleAuthority;
    router = nixos.realization;
    endpoint = builtins.head (builtins.head router.services).providerEndpoints;
    prefix = builtins.head router.routedPrefixesByTenant.lab-dmz;
  in
  assert !(authority ? publicSurface);
  assert !(authority ? targetEndpoint);
  assert !(authority ? runtimePrefix);
  assert relation.from == { kind = "external"; uplinks = [ "lab-wan" ]; };
  assert relation.to == { kind = "service"; name = "nebula-lab"; };
  assert authority.family == "ipv6";
  assert authority.tuples == [ { protocol = "udp"; publicPort = 4242; } ];
  assert authority.targetPort == 4242;
  assert authority.translationMode == "none";
  assert authority.sourcePreservation == "preserve-source";
  assert authority.returnBehavior == "stateful-return";
  assert nixos.realization == clab.realization;
  assert router.providerSurface.name == "lab-wan";
  assert endpoint.name == "nebula-lab-endpoint";
  assert endpoint.ipv6 == [ "fd00:230::4242" ];
  assert prefix.sourceClass == "protected";
  assert prefix.sourceFile == "/run/secrets/fs230-lab-dmz-ipv6-prefix";
  assert clients.clients.public-nebula-probe.protocol == "udp";
  true
' >/dev/null || fail "row-local intent/inventory ownership contract failed"

(
  cd "${cpm}"
  NETWORK_REPO_DIRECT_TEST_OK=1 \
    tests/FS-230-HDS-010-SDS-010-SMS-040-nebula-ipv6-public-ingress.sh
)
(
  cd "${nixos_renderer}"
  NETWORK_REPO_DIRECT_TEST_OK=1 \
    tests/FS-230-HDS-010-SDS-010-SMS-040-nebula-ipv6-public-ingress.sh
)
(
  cd "${clab_renderer}"
  NETWORK_REPO_DIRECT_TEST_OK=1 \
    bash tests/test-fs230-hds010-sds010-sms040-nebula-ipv6-public-ingress.sh
)

echo "PASS FS-230-HDS-010-SDS-010-SMS-040 native protected IPv6 ingress construction candidate"
