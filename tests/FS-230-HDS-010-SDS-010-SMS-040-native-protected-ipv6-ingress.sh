#!/usr/bin/env bash
# GAMP-ID: FS-230-HDS-010-SDS-010-SMS-040
# GAMP-SCOPE: cross-repo construction proof; not live SMT/SIT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
github_root="$(dirname "${repo_root}")"
row="${repo_root}/GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040"
cpm="${github_root}/network-control-plane-model"
nfm="${github_root}/network-forwarding-model"
compiler="${github_root}/network-compiler"
nixos_renderer="${github_root}/network-renderer-nixos"
clab_renderer="${github_root}/network-renderer-containerlab-linux-backend"
access_endpoint_renderer="${github_root}/network-renderer-access-endpoint-nixos"

compiler_revision="6dea1cd4315da82036fa46b68382586c9c01eda0"
nfm_revision="a114b33ae5555485f3e5b49a9d586ad8bf67bfa5"
cpm_revision="0684468ba9824e01545a22f526bc2c79c294ac7f"
nixos_revision="1761fc229c44d3c9fd927059ae04d249d16529ed"
clab_revision="15264eb1e7e598cbce270f494b6b275b6a1d021c"
access_endpoint_revision="d2d78859130a14f0bfc5261a9dd29cc1fce3a251"
router_fixture_revision="109c3dfe8eee79688629d5c2d01a8485494a7257"
endpoint_fixture_revision="562f749038ef08b840ce95615acfa595cae60943"

fail() {
  echo "FAIL FS-230-HDS-010-SDS-010-SMS-040: $*" >&2
  exit 1
}

for spec in \
  "${compiler}:${compiler_revision}" \
  "${nfm}:${nfm_revision}" \
  "${cpm}:${cpm_revision}" \
  "${nixos_renderer}:${nixos_revision}" \
  "${clab_renderer}:${clab_revision}" \
  "${access_endpoint_renderer}:${access_endpoint_revision}" \
  "${repo_root}:${endpoint_fixture_revision}"
do
  repo="${spec%%:*}"
  revision="${spec##*:}"
  [[ "$(git -C "${repo}" branch --show-current)" == "main" ]] \
    || fail "$(basename "${repo}") is not on main"
  git -C "${repo}" merge-base --is-ancestor "${revision}" refs/remotes/origin/main \
    || fail "$(basename "${repo}") candidate is not on GitHub main"
done

locked_input_revision() {
  local lock_file="$1"
  local input_name="$2"
  jq -r --arg input "${input_name}" \
    '.nodes.root.inputs[$input] as $node | .nodes[$node].locked.rev' \
    "${lock_file}"
}

[[ "$(locked_input_revision "${nixos_renderer}/flake.lock" network-control-plane-model)" == "${cpm_revision}" ]] \
  || fail "NixOS renderer does not pin the candidate CPM revision"
[[ "$(locked_input_revision "${clab_renderer}/flake.lock" network-control-plane-model)" == "${cpm_revision}" ]] \
  || fail "CLAB renderer does not pin the candidate CPM revision"
for renderer in "${nixos_renderer}" "${clab_renderer}"; do
  [[ "$(locked_input_revision "${renderer}/flake.lock" network-forwarding-model)" == "${nfm_revision}" ]] \
    || fail "$(basename "${renderer}") does not pin the candidate NFM revision"
  [[ "$(locked_input_revision "${renderer}/flake.lock" network-labs)" == "${router_fixture_revision}" ]] \
    || fail "$(basename "${renderer}") does not pin the isolated row fixture"
done
[[ "$(locked_input_revision "${access_endpoint_renderer}/flake.lock" network-labs)" == "${endpoint_fixture_revision}" ]] \
  || fail "access-endpoint renderer does not pin the protected endpoint fixture"

ROW="${row}" nix eval --impure --expr '
  let
    row = builtins.getEnv "ROW";
    rowDefault = import (row + "/default.nix");
    intent = import (row + "/intent.nix");
    nixos = import (row + "/inventory-nixos.nix");
    clab = import (row + "/inventory-clab.nix");
    clients = import (row + "/intent-test-clients.nix");
    siteIntent = intent."mini-smt"."FS-230-HDS-010-SDS-010-SMS-040";
    relation = builtins.head siteIntent.communicationContract.relations;
    authority = relation.publicIngressTupleAuthority;
    endpoint = nixos.endpoints.nebula-lab-endpoint;
    prefix = builtins.head (builtins.head siteIntent.ownership.prefixes).routedPrefixes;
    nixosNodes = nixos.realization.nodes;
    clabNodes = clab.realization.nodes;
    nodeNames = builtins.attrNames nixosNodes;
    logicalNames = nodes: map (name: nodes.${name}.logicalNode.name) (builtins.attrNames nodes);
    protectedClientAddress = {
      family = "ipv6";
      sourceClass = "protected";
      sourceFile = "/run/secrets/fs230-lab-dmz-ipv6-prefix";
      delegatedPrefixLength = 48;
      perTenantPrefixLength = 64;
      slot = 35;
      interfaceIdentifier = "0000:0000:0000:4242";
      prefixLength = 128;
      interfaceName = "eth0";
    };
  in
  assert rowDefault.runtimeHosts == [
    "s-router-nixos"
    "s-router-clab"
    "s-router-test-clients"
  ];
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
  assert builtins.length nodeNames == 5;
  assert nodeNames == builtins.attrNames clabNodes;
  assert logicalNames nixosNodes == logicalNames clabNodes;
  assert builtins.attrNames nixos.deployment.hosts == [ "s-router-nixos" ];
  assert builtins.attrNames clab.deployment.hosts == [ "s-router-clab" ];
  assert endpoint.ipv6 == [ "fd00:230::4242" ];
  assert prefix.allocation == "runtime";
  assert prefix.sourceFile == "/run/secrets/fs230-lab-dmz-ipv6-prefix";
  assert prefix.slot == 35;
  assert clients.control_plane_model.meta.traceId == "FS-230-HDS-010-SDS-010-SMS-040";
  assert clients.endpointAssignment.fs230-nixos-service.runtimeAddressAssignments == [ protectedClientAddress ];
  assert clients.endpointAssignment.fs230-clab-service.runtimeAddressAssignments == [ protectedClientAddress ];
  assert !(clients.endpointAssignment.fs230-nixos-public ? runtimeAddressAssignments);
  assert !(clients.endpointAssignment.fs230-clab-public ? runtimeAddressAssignments);
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
(
  cd "${access_endpoint_renderer}"
  bash tests/FS-230-HDS-010-SDS-010-SMS-040-protected-runtime-service-address.sh
)

echo "PASS FS-230-HDS-010-SDS-010-SMS-040 native protected IPv6 ingress construction candidate"
