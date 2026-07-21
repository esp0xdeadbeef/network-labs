#!/usr/bin/env bash
# GAMP-ID: FS-982-HDS-010-SDS-010-SMS-110
# GAMP-SCOPE: deterministic canonical renderer-boundary construction
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
results="$(nix build --no-link --print-out-paths "${repo_root}#validation-scheme-results")"
runner="$(nix build --no-link --print-out-paths "${repo_root}#validation-scheme")/bin/network-validation-scheme"

jq -e '
  . as $root
  | .rendererBoundaryConformance.validation.accepted == true
  and .rendererBoundaryConformance.validation.exit == 0
  and .rendererBoundaryConformance.targets == [
    "access-endpoint-nixos",
    "clab",
    "nebula",
    "nixos",
    "openconfig",
    "wireguard"
  ]
  and all(.rendererBoundaryConformance.inputBundleIdentities[];
    . == $root.rendererBoundaryConformance.bundleIdentity
  )
' "${results}" >/dev/null

for case_id in RV-N{1..8}; do
  expected_code="$(jq -r --arg caseId "${case_id}" \
    '.seededNegativeCases[$caseId].expectedDiagnostic' "${results}")"
  stdout_file="$(mktemp "/tmp/${case_id}.stdout.XXXXXX")"
  stderr_file="$(mktemp "/tmp/${case_id}.stderr.XXXXXX")"

  if "${runner}" --negative-case "${case_id}" >"${stdout_file}" 2>"${stderr_file}"; then
    echo "FAIL ${case_id}: seeded negative unexpectedly succeeded" >&2
    exit 1
  else
    observed_exit="$?"
  fi
  [[ "${observed_exit}" -eq 2 ]]
  [[ ! -s "${stdout_file}" ]]
  jq -e --arg code "${expected_code}" '.code == $code' "${stderr_file}" >/dev/null
  "${runner}" --recover-case "${case_id}" \
    | jq -e '.accepted == true and .exit == 0 and .diagnostic == null' >/dev/null
done

echo "PASS FS-982-HDS-010-SDS-010-SMS-110: canonical APIs and RV-N1 through RV-N8"
