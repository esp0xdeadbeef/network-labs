#!/usr/bin/env bash
# GAMP-SCOPE: active-lab minimal entrypoint surface; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  echo "FAIL active-lab-minimal-entrypoints: $*" >&2
  exit 1
}

for forbidden in \
  clients.nix \
  inventory.nix \
  inventory-clab.nix \
  inventory-hetz.nix \
  sops-routing-s-router-clab.nix \
  sops-routing-s-router-hetz.nix \
  sops-routing-s-router-nixos.nix \
  sops-routing-s-router-test-clients.nix
do
  [[ ! -e "${repo_root}/active-lab/${forbidden}" ]] \
    || fail "active-lab/${forbidden} is not a mini-lab entrypoint stub"
done

[[ ! -d "${repo_root}/active-lab/inventories" ]] \
  || fail "active-lab/inventories is legacy host exposure; use row-local mini-lab sources"
[[ ! -d "${repo_root}/active-lab/mini-smt" ]] \
  || fail "active-lab/mini-smt is a GAMP SMT catalog, not an active-lab stub"
[[ ! -d "${repo_root}/active-lab/layer-entry-poc" ]] \
  || fail "active-lab/layer-entry-poc is a GAMP SMT catalog, not an active-lab stub"

[[ -d "${repo_root}/active-lab/secrets" ]] \
  || fail "active-lab/secrets must remain for the GAMP/HAT SOPS boundary"
[[ -f "${repo_root}/active-lab/secrets/sops-s-router-clab.yaml" ]] \
  || fail "GAMP/HAT SOPS boundary requires active-lab/secrets/sops-s-router-clab.yaml"
rg -q 'active-lab/secrets/sops-s-router-clab[.]yaml' "${repo_root}/GAMP/HAT/sops.nix" \
  || fail "GAMP/HAT/sops.nix must keep the active-lab SOPS source explicit"

REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  active = import (repoRoot + "/active-lab");
  inventory = import (repoRoot + "/active-lab/inventory-nixos.nix");
  manifest = import (repoRoot + "/GAMP/SMT/mini-smt/tests.nix");
  stub = inventory.activeLabInventoryStub or null;
  rendererNixos = manifest.tests.renderer-nixos;
  require = cond: msg: if cond then true else throw msg;
in
  require (!(active ? clients)) "active-lab default must not expose empty clients"
  && require (!(active ? inventoryFor)) "active-lab default must not expose legacy host inventory lookup"
  && require (!(active ? secretFileFor)) "active-lab default must not expose host secret file lookup"
  && require (!(active ? secretFiles)) "active-lab default must not expose broad secret files"
  && require (builtins.isFunction active.mkSource) "active-lab must keep mkSource for row-local intent stubs"
  && require (stub != null) "inventory-nixos.nix must be an explicit stub, not an empty attrset"
  && require (stub.kind == "mini-smt-renderer-input-stub") "inventory-nixos.nix must declare the stub kind"
  && require (stub.miniSmtId == "renderer-nixos") "inventory-nixos.nix must point at the renderer-nixos mini SMT"
  && require (stub.entryBoundary == "renderer-input") "inventory-nixos.nix must declare renderer-input boundary"
  && require (stub.traceId == rendererNixos.traceId) "inventory-nixos.nix trace must match the mini SMT row"
  && require (toString stub.cpmInput == toString rendererNixos.source.cpm) "inventory-nixos.nix must point at the mini SMT CPM input"
  && require (toString stub.test == repoRoot + "/tests/test-active-lab-mini-smt-runtime-nixos-renderer-input.sh") "inventory-nixos.nix must point at the focused test"
  && require (toString stub.runner == repoRoot + "/tests/run-active-lab-mini-smt.sh") "inventory-nixos.nix must point at the mini SMT runner"
  && require (stub.runtimeManagement.vlan2 == "management-only") "vlan2 must be documented as management-only"
  && require (stub.runtimeManagement.testDhcpUplinks == [ "vlan4" "vlan5" ]) "test DHCP uplinks must be vlan4/vlan5"
' >/dev/null || fail "active-lab minimal entrypoint contract failed"

echo "PASS active-lab-minimal-entrypoints"
