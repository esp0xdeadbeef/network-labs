#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/labs/lab-s-sigma/s-router-test-three-site"
cpm_flake="${CPM_FLAKE:-github:esp0xdeadbeef/network-control-plane-model}"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

inventory_nix="${tmp_dir}/inventory.nix"
output_json="${tmp_dir}/cpm.json"

cat >"${inventory_nix}" <<EOF
import ${lab_dir}/getResolvedInventory.nix { renderer = "nixos"; }
EOF

nix run --show-trace "${cpm_flake}#compile-and-build-control-plane-model" -- \
  "${lab_dir}/intent.nix" \
  "${inventory_nix}" \
  "${output_json}" >/dev/null

jq -e '
  def expected_preference:
    [
      "service-dns",
      "overlay-core",
      "local-access",
      "explicit-egress-default"
    ];
  def public_resolver:
    . == "1.1.1.1"
    or . == "1.0.0.1"
    or . == "8.8.8.8"
    or . == "8.8.4.4"
    or . == "9.9.9.9"
    or . == "2606:4700:4700::1111"
    or . == "2606:4700:4700::1001"
    or . == "2001:4860:4860::8888"
    or . == "2001:4860:4860::8844"
    or . == "2620:fe::fe";
  def access_dns($site):
    $site.runtimeTargets
    | to_entries
    | map(select((.value.role // "") == "access" and (.value.services.dns // null) != null));
  def normal_access:
    [
      "esp-nixos-router-access-admin",
      "esp-nixos-router-access-client",
      "esp-nixos-router-access-dmz",
      "esp-nixos-router-access-streaming"
    ];
  .control_plane_model.data.esp.nixos as $site
  | access_dns($site) as $targets
  | ($targets | all(.value.services.dns.routePreference == expected_preference))
  and (
    normal_access
    | all(. as $name
      | ($site.runtimeTargets[$name].services.dns.forwarders // [])
      | index("10.20.10.1") != null
        and index("fd42:dead:beef:10::1") != null)
  )
  and ($targets | all((.value.services.dns.forwarders // []) | all(public_resolver | not)))
' "${output_json}" >/dev/null || {
  echo "FAIL lab-sigma-dns-intent-to-cpm: DNS lookup policy must be derived by CPM from intent/NFM, prefer modeled service DNS before core/local fallback, and avoid inventory/public resolver forwarders" >&2
  exit 1
}

echo "PASS lab-sigma-dns-intent-to-cpm"
