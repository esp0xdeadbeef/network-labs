#!/usr/bin/env bash
# GAMP-SCOPE: active-lab minimal entrypoint surface; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  echo "FAIL active-lab-minimal-entrypoints: $*" >&2
  exit 1
}

for forbidden in \
  inventory.nix \
  inventories
do
  [[ ! -e "${repo_root}/active-lab/${forbidden}" ]] \
    || fail "active-lab/${forbidden} is not a mini-lab entrypoint stub"
done

[[ ! -d "${repo_root}/active-lab/mini-smt" ]] \
  || fail "active-lab/mini-smt is a GAMP SMT catalog, not an active-lab stub"
[[ ! -d "${repo_root}/active-lab/layer-entry-poc" ]] \
  || fail "active-lab/layer-entry-poc is a GAMP SMT catalog, not an active-lab stub"

for required in \
  clients.nix \
  inventory-clab.nix \
  inventory-hetz.nix \
  inventory-nixos.nix \
  sops.nix \
  sops-routing-s-router-clab.nix \
  sops-routing-s-router-hetz.nix \
  sops-routing-s-router-nixos.nix \
  sops-routing-s-router-test-clients.nix
do
  [[ -f "${repo_root}/active-lab/${required}" ]] \
    || fail "active-lab/${required} must exist because NixOS runtime modules import it"
done

[[ -d "${repo_root}/active-lab/secrets" ]] \
  || fail "active-lab/secrets must remain as controlled FS/GAMP SOPS source material"
[[ -f "${repo_root}/active-lab/secrets/sops-s-router-clab.yaml" ]] \
  || fail "GAMP/HAT SOPS boundary requires active-lab/secrets/sops-s-router-clab.yaml"
rg -q 'active-lab/secrets/sops-s-router-clab[.]yaml' "${repo_root}/GAMP/HAT/sops.nix" \
  || fail "GAMP/HAT/sops.nix must keep the active-lab SOPS source explicit"

REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  active = import (repoRoot + "/active-lab");
  clients = import (repoRoot + "/active-lab/clients.nix");
  inventoryClab = import (repoRoot + "/active-lab/inventory-clab.nix");
  inventoryHetz = import (repoRoot + "/active-lab/inventory-hetz.nix");
  inventory = import (repoRoot + "/active-lab/inventory-nixos.nix");
  manifest = import (repoRoot + "/GAMP/SMT/mini-smt/tests.nix");
  protectedSecretBindings = import (repoRoot + "/GAMP/HAT/emulated-isp-residential-testnet/protected-pppoe-credential-bindings.nix") {
    consumerNode = "esp0xdeadbeef-site-b-clab-core-testnet-host-isp";
    harness = "s-router-clab";
    site = "clab";
  };
  stub = inventory.activeLabInventoryStub or null;
  rendererNixos = manifest.tests.renderer-nixos;
  require = cond: msg: if cond then true else throw msg;
  requiredSecretGampIds = [
    "FS-800-HDS-020-SDS-020"
    "FS-800-HDS-010-SDS-030-SMS-020"
  ];
  hasRequiredSecretIds = row:
    builtins.all (id: builtins.elem id (row.gampIds or [ ])) requiredSecretGampIds;
  protectedSecretRows =
    (protectedSecretBindings.secretDeclarations or [ ])
    ++ (protectedSecretBindings.secretSources or [ ])
    ++ (protectedSecretBindings.sourceBindings or [ ]);
in
  require (!(active ? clients)) "active-lab default must not expose clients through default.nix"
  && require (!(active ? inventoryFor)) "active-lab default must not expose legacy host inventory lookup"
  && require (!(active ? secretFileFor)) "active-lab default must not expose host secret file lookup"
  && require (!(active ? secretFiles)) "active-lab default must not expose broad secret files"
  && require (builtins.isFunction active.mkSource) "active-lab must keep mkSource for row-local intent stubs"
  && require (clients.activeLabClientStub.kind == "runtime-client-source-stub") "clients.nix must be an explicit runtime stub"
  && require (inventoryClab.activeLabInventoryStub.kind == "runtime-clab-inventory-stub") "inventory-clab.nix must be an explicit runtime stub"
  && require (inventoryHetz.activeLabInventoryStub.kind == "runtime-hetz-inventory-stub") "inventory-hetz.nix must be an explicit runtime stub"
  && require (protectedSecretRows != [ ]) "protected PPPoE secret rows must exist"
  && require (builtins.all hasRequiredSecretIds protectedSecretRows) "active-lab SOPS material must stay tied to the protected PPPoE FS IDs"
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
