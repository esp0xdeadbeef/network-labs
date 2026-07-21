#!/usr/bin/env bash
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
selector="${repo_root}/scripts/select-current-lab.sh"
current_dir="${repo_root}/current-lab"
restore_dir="$(mktemp -d)"

cp -a "${current_dir}/." "${restore_dir}/"

cleanup() {
  cp -a "${restore_dir}/." "${current_dir}/"
  rm -rf "${restore_dir}"
}
trap cleanup EXIT

assert_hetz_nop() {
  local expected_layer="$1"
  local expected_selector="$2"
  local expected_trace="$3"

  REPO_ROOT="${repo_root}" \
  EXPECTED_LAYER="${expected_layer}" \
  EXPECTED_SELECTOR="${expected_selector}" \
  EXPECTED_TRACE="${expected_trace}" \
    nix eval --impure --expr '
      let
        repoRoot = builtins.getEnv "REPO_ROOT";
        expectedLayer = builtins.getEnv "EXPECTED_LAYER";
        expectedSelector = builtins.getEnv "EXPECTED_SELECTOR";
        expectedTrace = builtins.getEnv "EXPECTED_TRACE";
        current = import (repoRoot + "/current-lab");
        consumerIntentPath = repoRoot + "/active-lab/intent.nix";
        consumerInventoryPath = repoRoot + "/active-lab/inventory-hetz.nix";
        inventory = import consumerInventoryPath;
        intent = import consumerIntentPath;
        cpmLib = (builtins.getFlake ("path:" + repoRoot + "/../network-control-plane-model")).libBySystem.${builtins.currentSystem};
        built = cpmLib.compileAndBuildFromPaths {
          inputPath = consumerIntentPath;
          inventoryPath = consumerInventoryPath;
        };
        host = inventory.deploymentHosts.s-router-hetz;
      in
      assert current.selection.layer == expectedLayer;
      assert current.selection.selector == expectedSelector;
      assert inventory.realization.nodes == {};
      assert inventory.activeLabInventoryStub == {
        kind = "unsupported-runtime-host-stub";
        traceId = expectedTrace;
        hostName = "s-router-hetz";
      };
      assert builtins.attrNames host.uplinks == [ "management" ];
      assert host.uplinks.management.vlan == 2;
      assert host.bridgeNetworks == {};
      assert intent.control_plane_model.realization.nodes == {};
      assert intent.control_plane_model.data.active-lab.hetz.runtimeTargets == {};
      assert built.control_plane_model.realization.nodes == {};
      assert built.control_plane_model.data.active-lab.hetz.runtimeTargets == {};
      true
    ' >/dev/null
}

"${selector}" SMT FS-560-HDS-010-SDS-010-SMS-050 >/dev/null
assert_hetz_nop \
  SMT \
  FS-560-HDS-010-SDS-010-SMS-050 \
  FS-560-HDS-010-SDS-010-SMS-050

"${selector}" SIT FS-540-HDS-010-SDS-010 >/dev/null
assert_hetz_nop \
  SIT \
  FS-540-HDS-010-SDS-010 \
  FS-540-HDS-010-SDS-010-SMS-020

for layer in HAT SAT; do
  "${selector}" "${layer}" >/dev/null
  REPO_ROOT="${repo_root}" EXPECTED_LAYER="${layer}" \
    nix eval --impure --expr '
      let
        repoRoot = builtins.getEnv "REPO_ROOT";
        expectedLayer = builtins.getEnv "EXPECTED_LAYER";
        current = import (repoRoot + "/current-lab");
        inventory = import (repoRoot + "/active-lab/inventory-hetz.nix");
      in
      assert current.selection.layer == expectedLayer;
      assert !(inventory ? activeLabInventoryStub);
      true
    ' >/dev/null
done

cleanup
trap - EXIT

echo "PASS canonical s-router-hetz consumer is NOP only for SMT/SIT selections"
