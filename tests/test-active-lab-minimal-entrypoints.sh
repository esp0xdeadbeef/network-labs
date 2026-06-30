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
  clients-s-router-test-clients.nix \
  intent-s-router-clab.nix \
  intent-s-router-nixos.nix \
  intent-s-router-test-clients.nix \
  inventory-clab.nix \
  inventory-hetz.nix \
  inventory-nixos.nix \
  inventory-s-router-clab.nix \
  inventory-s-router-nixos.nix \
  inventory-s-router-test-clients.nix \
  sops.nix \
  sops-routing-s-router-clab.nix \
  sops-routing-s-router-hetz.nix \
  sops-routing-s-router-nixos.nix \
  sops-routing-s-router-test-clients.nix
do
  [[ -f "${repo_root}/active-lab/${required}" ]] \
    || fail "active-lab/${required} must exist because NixOS runtime modules import it"
done

if [[ -d "${repo_root}/active-lab/secrets" ]] \
  && find "${repo_root}/active-lab/secrets" -type f \( -name '*.yaml' -o -name '*.yml' \) | rg -q .; then
  fail "active-lab/secrets must not own encrypted SOPS payloads"
fi
rg -q 'emulated-isp-residential-testnet/secrets/sops-s-router-clab[.]yaml' "${repo_root}/GAMP/HAT/sops.nix" \
  || fail "GAMP/HAT/sops.nix must keep the HAT-owned SOPS source explicit"
rg -q '[.]?/secrets/sops-s-router-nixos[.]yaml' "${repo_root}/GAMP/HAT/emulated-isp-residential-testnet/sops-routing-s-router-nixos.nix" \
  || fail "HAT s-router-nixos SOPS routing must bind to the HAT-owned s-router-nixos encrypted file"
rg -q '[.]?/secrets/sops-s-router-clab[.]yaml' "${repo_root}/GAMP/HAT/emulated-isp-residential-testnet/sops-routing-s-router-clab.nix" \
  || fail "HAT s-router-clab SOPS routing must bind to the HAT-owned s-router-clab encrypted file"
rg -q '[.]?/secrets/sops-s-router-test[.]yaml' "${repo_root}/GAMP/HAT/emulated-isp-residential-testnet/sops-routing-s-router-test-clients.nix" \
  || fail "HAT s-router-test-clients SOPS routing must bind to the HAT-owned s-router-test encrypted file"

REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  active = import (repoRoot + "/active-lab");
  current = import (repoRoot + "/current-lab");
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
  sorted = builtins.sort (a: b: a < b);
  stub = inventory.activeLabInventoryStub or null;
  clabStub = inventoryClab.activeLabInventoryStub or null;
  hetzStub = inventoryHetz.activeLabInventoryStub or null;
  clientStub = clients.activeLabClientStub or null;
  rendererNixos = manifest.tests."FS-166-HDS-010-SDS-010-SMS-901";
  require = cond: msg: if cond then true else throw msg;
  requiredNixosClients = [
    "nixos-branch-node01"
    "nixos-client01"
    "nixos-client02"
    "nixos-emulated-sigma"
    "nixos-printer01"
    "nixos-receiver01"
    "nixos-streaming-test"
  ];
  requiredClabClients = [
    "clab-client01"
    "clab-client02"
    "clab-emulated-sigma"
  ];
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
  activeNixosHosts = inventory.deployment.hosts or { };
  activeClabHosts = inventoryClab.deployment.hosts or { };
  activeHetzHosts = inventoryHetz.deployment.hosts or { };
  selectedDefaultMini =
    current.selection.layer == "SMT"
    && current.selection.selector == "FS-166-HDS-010-SDS-010-SMS-901";
  defaultMiniOk =
    clientStub != null
    && clabStub != null
    && hetzStub != null
    && stub != null
    && clientStub.kind == "runtime-client-source-stub"
    && clabStub.kind == "runtime-clab-inventory-stub"
    && hetzStub.kind == "runtime-hetz-inventory-stub"
    && stub.kind == "mini-smt-renderer-input-stub"
    && stub.miniSmtId == rendererNixos.traceId
    && stub.entryBoundary == "renderer-input"
    && stub.traceId == rendererNixos.traceId
    && toString stub.cpmInput == toString rendererNixos.source.cpm
    && toString stub.test == repoRoot + "/tests/test-active-lab-mini-smt-runtime-nixos-renderer-input.sh"
    && toString stub.runner == repoRoot + "/tests/run-active-lab-mini-smt.sh"
    && stub.runtimeManagement.vlan2 == "management-only"
    && stub.runtimeManagement.testDhcpUplinks == [ "vlan4" "vlan5" ];
  hatOk =
    current.selection.layer == "HAT"
    && current.selection.selector == "emulated-isp-residential-testnet"
    && current.selection.sourceRoot == "GAMP/HAT/emulated-isp-residential-testnet"
    && (clientStub.kind or null) == "hat-client-source"
    && sorted (clients.requiredEndpointClients or [ ]) == requiredNixosClients
    && sorted (builtins.attrNames (clients.clients or { })) == requiredNixosClients
    && builtins.hasAttr "s-router-nixos" activeNixosHosts
    && builtins.hasAttr "s-router-test-clients" activeNixosHosts
    && sorted (activeNixosHosts.s-router-test-clients.hat.requiredEndpointClients or [ ]) == requiredNixosClients
    && builtins.hasAttr "s-router-clab" activeClabHosts
    && sorted (activeClabHosts.s-router-clab.hat.requiredEndpointClients or [ ]) == requiredClabClients
    && builtins.hasAttr "s-router-hetz" activeHetzHosts;
  satOk =
    current.selection.layer == "SAT"
    && current.selection.sourceRoot == "GAMP/SAT"
    && builtins.hasAttr "s-router-nixos" activeNixosHosts
    && builtins.hasAttr "s-router-clab" activeClabHosts;
  selectedSourceExplicit =
    (current.selection.sourceRoot or "") != ""
    && (current.selection.sourcePath or "") != "";
  selectedEntrypointsOk =
    if current.selection.layer == "HAT" then hatOk
    else if current.selection.layer == "SAT" then satOk
    else if selectedDefaultMini then defaultMiniOk
    else selectedSourceExplicit;
in
  require (!(active ? clients)) "active-lab default must not expose clients through default.nix"
  && require (!(active ? inventoryFor)) "active-lab default must not expose legacy host inventory lookup"
  && require (!(active ? secretFileFor)) "active-lab default must not expose host secret file lookup"
  && require (!(active ? secretFiles)) "active-lab default must not expose broad secret files"
  && require (builtins.isFunction active.mkSource) "active-lab must keep mkSource for row-local intent stubs"
  && require (protectedSecretRows != [ ]) "protected PPPoE secret rows must exist"
  && require (builtins.all hasRequiredSecretIds protectedSecretRows) "HAT SOPS material must stay tied to the protected PPPoE FS IDs"
  && require selectedEntrypointsOk "active-lab entrypoint content must match the selected current-lab layer"
' >/dev/null || fail "active-lab minimal entrypoint contract failed"

echo "PASS active-lab-minimal-entrypoints"
