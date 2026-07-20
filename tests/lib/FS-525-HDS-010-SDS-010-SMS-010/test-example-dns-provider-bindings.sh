#!/usr/bin/env bash
# GAMP-ID: FS-525-HDS-010-SDS-010-SMS-010
# GAMP-SCOPE: network-labs construction source gate
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

failures=0
while IFS= read -r -d '' intent_path; do
  example_dir="$(dirname "${intent_path}")"
  inventory_path="${example_dir}/inventory-nixos.nix"
  [[ -f "${inventory_path}" ]] || continue

  label="$(basename "${example_dir}")"
  intent_json="${tmp_dir}/${label}-intent.json"
  inventory_json="${tmp_dir}/${label}-inventory.json"
  nix eval --json --file "${intent_path}" >"${intent_json}"
  nix eval --json --file "${inventory_path}" >"${inventory_json}"

  invalid="$(
    jq -nr \
      --slurpfile intent "${intent_json}" \
      --slurpfile inventory "${inventory_json}" '
        $intent[0] as $intent |
        $inventory[0] as $inventory |
        $intent | to_entries[] | .value | to_entries[] |
        .key as $siteName |
        .value as $site |
        $site.communicationContract.services[]? |
        select((.trafficType // "") == "dns") |
        . as $service |
        ($service.providers // []) as $providers |
        [
          $providers[] as $provider |
          {
            owned: any($site.ownership.endpoints[]?; (.name // "") == $provider),
            addressed: (
              (($inventory.endpoints[$provider].ipv4 // []) | length) > 0 or
              (($inventory.endpoints[$provider].ipv6 // []) | length) > 0
            )
          }
        ] as $bindings |
        select(
          ($providers | length) == 0 or
          any($bindings[]; (.owned and .addressed) | not)
        ) |
        "site=\($siteName) service=\($service.name // "<missing>")"
      '
  )"

  if [[ -n "${invalid}" ]]; then
    printf 'FAIL %s: incomplete named DNS provider binding\n%s\n' \
      "${label}" "${invalid}" >&2
    failures=$((failures + 1))
  fi
done < <(find "${repo_root}/examples" -mindepth 2 -maxdepth 2 -type f -name intent.nix -print0 | sort -z)

if ((failures > 0)); then
  exit 1
fi

echo "PASS FS-525 example named DNS provider bindings"
