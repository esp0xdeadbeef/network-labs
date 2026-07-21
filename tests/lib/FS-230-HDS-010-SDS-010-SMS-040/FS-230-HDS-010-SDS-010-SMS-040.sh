#!/usr/bin/env bash
# GAMP-ID: FS-230-HDS-010-SDS-010-SMS-040
# GAMP-SCOPE: cross-repo construction proof; not live SMT/SIT evidence
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
github_root="$(dirname "${repo_root}")"
row="${repo_root}/GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040"
cpm="${github_root}/network-control-plane-model"
nfm="${github_root}/network-forwarding-model"
compiler="${github_root}/network-compiler"
nixos_renderer="${github_root}/network-renderer-nixos"
clab_renderer="${github_root}/network-renderer-containerlab-linux-backend"
access_endpoint_renderer="${github_root}/network-renderer-access-endpoint-nixos"

compiler_revision="76a2ae6c8c59512ae5ce5c0568af5f1dae074c0d"
nfm_revision="46853d5fb8c7458fedf90ed6f9a39967b25736f7"
cpm_revision="7f3377372eeb4919920799498037d8365e4e2afc"
nixos_revision="4e30350b1d7f7eb2fc954f19230f44941d21a610"
clab_revision="5cb2a5bf1ee782b0a761186e285638142d5b5b4f"
access_endpoint_revision="c95b3dd20538b9cf7853f3ce67be3eaffaf759ee"
repo_root_revision="03e76b64c00adc3ffc845c5fbc88197653ce62b9"

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
  "${repo_root}:${repo_root_revision}"
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
done
# Each renderer may carry a different network-labs fixture revision; verify
# they are resolvable commits rather than requiring a single shared pin.
for renderer in "${nixos_renderer}" "${clab_renderer}" "${access_endpoint_renderer}"; do
  labs_pin="$(locked_input_revision "${renderer}/flake.lock" network-labs)"
  [[ -n "${labs_pin}" ]] || fail "$(basename "${renderer}") missing network-labs input"
  git -C "${github_root}/network-labs" merge-base --is-ancestor "${labs_pin}" refs/remotes/origin/main \
    || fail "$(basename "${renderer}") network-labs pin ${labs_pin} is not on GitHub main"
done

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
    tests/FS-230-HDS-010-SDS-010-SMS-040.sh
)
(
  cd "${nixos_renderer}"
  NETWORK_REPO_DIRECT_TEST_OK=1 \
    tests/FS-230-HDS-010-SDS-010-SMS-040.sh
)
(
  cd "${clab_renderer}"
  NETWORK_REPO_DIRECT_TEST_OK=1 \
    bash tests/FS-230-HDS-010-SDS-010-SMS-040.sh
)
(
  cd "${access_endpoint_renderer}"
  bash tests/FS-230-HDS-010-SDS-010-SMS-040.sh
)

echo "PASS FS-230-HDS-010-SDS-010-SMS-040 native protected IPv6 ingress construction candidate"
