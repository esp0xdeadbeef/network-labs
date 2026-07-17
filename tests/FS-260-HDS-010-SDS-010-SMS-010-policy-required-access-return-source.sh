#!/usr/bin/env bash
# GAMP-ID: FS-260-HDS-010-SDS-010-SMS-010
# GAMP-SCOPE: row-local source and cross-layer construction integration
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
trace_id="FS-260-HDS-010-SDS-010-SMS-010"
row="${repo_root}/GAMP/SMT/${trace_id}"
nfm_repo="${NETWORK_FORWARDING_MODEL_ROOT:-${repo_root}/../network-forwarding-model}"
cpm_repo="${NETWORK_CONTROL_PLANE_MODEL_ROOT:-${repo_root}/../network-control-plane-model}"
relation="${trace_id}__policy-required-access-return"
reverse_deny="${trace_id}__deny-reverse-new-flow"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL ${trace_id}: $*" >&2
  exit 1
}

for required in \
  "${row}/intent.nix" \
  "${row}/inventory-nixos.nix" \
  "${row}/inventory-clab.nix" \
  "${row}/inventory-test-clients.nix" \
  "${row}/intent-test-clients.nix"; do
  [[ -f "${required}" ]] || fail "missing row source ${required}"
done
[[ -d "${nfm_repo}/.git" ]] || fail "missing canonical NFM repo ${nfm_repo}"
[[ -d "${cpm_repo}/.git" ]] || fail "missing canonical CPM repo ${cpm_repo}"

FS260_ROW="${row}" nix eval --impure --expr '
  let
    row = builtins.getEnv "FS260_ROW";
    nixos = import (row + "/inventory-nixos.nix");
    clab = import (row + "/inventory-clab.nix");
    clients = import (row + "/intent-test-clients.nix");
    require = condition: message: if condition then true else throw message;
    routerVlans = inventory:
      builtins.filter (vlan: vlan != null) (builtins.concatLists (
        map
          (host: map (bridge: bridge.vlan or null)
            (builtins.attrValues (host.bridgeNetworks or { })))
          (builtins.attrValues inventory.deployment.hosts)
      ));
    clientAssignments = builtins.attrValues clients.endpointAssignment;
  in
    require (routerVlans nixos == [ 394 393 ])
      "NixOS router inventory must use only isolated VLANs 393 and 394"
    && require (routerVlans clab == [ 396 395 ])
      "CLAB router inventory must use only isolated VLANs 395 and 396"
    && require (builtins.length (builtins.attrNames nixos.realization.nodes) == 6)
      "NixOS inventory must explicitly realize all six runtime nodes"
    && require (builtins.length (builtins.attrNames clab.realization.nodes) == 6)
      "CLAB inventory must explicitly realize all six runtime nodes"
    && require (builtins.length clientAssignments == 4)
      "test-client intent must define four substrate-specific endpoints"
    && require (builtins.all
      (endpoint:
        endpoint.family == "dual"
        && endpoint.mode == "static"
        && endpoint.owningSubstrate == "s-router-test-clients"
        && endpoint.static ? address
        && endpoint.static ? address6
        && endpoint.static ? gateway4
        && endpoint.static ? gateway6)
      clientAssignments)
      "every test endpoint must carry explicit dual-stack static addressing"
' >/dev/null || fail "row-local inventory and test-client contract failed"

nix run --no-warn-dirty --no-write-lock-file \
  "path:${nfm_repo}#compile-and-build-forwarding-model" -- \
  "${row}/intent.nix" >"${tmp_dir}/nfm.json"

jq -e --arg relation "${relation}" '
  [.enterprise[].site[].trafficPaths[] | select(.relationId == $relation)] as $paths
  | ($paths | length) == 1
  and ($paths[0].action == "allow")
  and ($paths[0].requiresPolicy == true)
  and ($paths[0].nodePath == [
    "access-source",
    "downstream-selector",
    "policy",
    "downstream-selector",
    "access-destination"
  ])
' "${tmp_dir}/nfm.json" >/dev/null \
  || fail "NFM did not preserve the policy-required access-to-access path"

for substrate in nixos clab; do
  output="${tmp_dir}/cpm-${substrate}.json"
  nix run --no-warn-dirty --no-write-lock-file \
    "path:${cpm_repo}#debug" -- \
    "${tmp_dir}/nfm.json" "${row}/inventory-${substrate}.nix" "${output}" \
    >/dev/null

  jq -e \
    --arg trace "${trace_id}" \
    --arg relation "${relation}" \
    --arg reverseDeny "${reverse_deny}" '
      .control_plane_model.data["mini-smt"][$trace].runtimeTargets as $targets
      | [$targets[] | select(.role == "downstream-selector")
          | .forwardingIntent.rules[]] as $selectorRules
      | [$targets[] | select(.role == "policy")
          | .forwardingIntent.rules[]] as $policyRules
      | ([$targets | to_entries[]] | length) == 6
      and ([$selectorRules[] | select(.relationId == $relation)] | length) == 0
      and ([$selectorRules[]
        | select(
            .relationId == "selector-handoff-forward--access-source--access-to-selector-to-selector-to-policy--fabric"
            and .action == "accept"
            and .fromInterface == "access-source"
            and .toInterface == "policy-source"
            and .policyPointTraversal.nonBypass == true
          )] | length) == 1
      and ([$selectorRules[]
        | select(
            .relationId == "selector-handoff-reverse--access-destination--selector-to-policy-to-access-to-selector--fabric"
            and .action == "accept"
            and .fromInterface == "dst-policy"
            and .toInterface == "dst-access"
            and .policyPointTraversal.nonBypass == true
          )] | length) == 1
      and ([$selectorRules[]
        | select(.relationId == $reverseDeny and .action == "deny")]
        | length) == 1
      and ([$policyRules[]
        | select(
            .relationId == $relation
            and .action == "accept"
            and .direction == "relation-forward"
            and .fromInterface == "source"
            and .toInterface == "destination"
          )] | length) == 1
      and ([$policyRules[]
        | select(
            .relationId == $relation
            and .action == "accept"
            and .direction == "relation-reverse"
            and .fromInterface == "destination"
            and .toInterface == "source"
          )] | length) == 1
    ' "${output}" >/dev/null \
    || fail "${substrate} CPM output bypassed policy or lost stateful return semantics"
done

NETWORK_REPO_DIRECT_TEST_OK=1 \
  "${cpm_repo}/tests/FS-260-HDS-010-SDS-010-SMS-010-policy-required-access-to-access.sh" \
  >/dev/null

echo "PASS ${trace_id}: isolated NixOS and CLAB sources preserve policy-required stateful access return"
