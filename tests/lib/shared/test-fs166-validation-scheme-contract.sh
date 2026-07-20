#!/usr/bin/env bash
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
trace_id="${SMS_TEST_TRACE_ID:-}"

case "${trace_id}" in
  FS-166-HDS-010-SDS-010-SMS-020)
    case_prefix="NS-FLOW-"
    expected_count=8
    ;;
  FS-166-HDS-010-SDS-010-SMS-030)
    case_prefix="NS-EVID-"
    expected_count=8
    ;;
  *)
    printf 'FAIL: unsupported FS-166 validation trace: %s\n' "${trace_id:-<unset>}" >&2
    exit 2
    ;;
esac

results="$(nix build --no-link --print-out-paths "${repo_root}#validation-scheme-results")"
runner="$(nix build --no-link --print-out-paths "${repo_root}#validation-scheme")/bin/network-validation-scheme"
mapfile -t case_ids < <(
  jq -r --arg prefix "${case_prefix}" \
    '.seededNegativeCaseNames[] | select(startswith($prefix))' "${results}"
)

[[ "${#case_ids[@]}" -eq "${expected_count}" ]] || {
  printf 'FAIL %s: expected %d cases with prefix %s, observed %d\n' \
    "${trace_id}" "${expected_count}" "${case_prefix}" "${#case_ids[@]}" >&2
  exit 1
}

for case_id in "${case_ids[@]}"; do
  expected_diagnostic="$(jq -er --arg caseId "${case_id}" \
    '.seededNegativeCases[$caseId].expectedDiagnostic' "${results}")"
  stderr_file="$(mktemp -t "${case_id}.stderr.XXXXXX")"
  trap 'rm -f "${stderr_file}"' EXIT

  if "${runner}" --negative-case "${case_id}" \
    > /dev/null 2>"${stderr_file}"; then
    printf 'FAIL %s: %s unexpectedly succeeded\n' "${trace_id}" "${case_id}" >&2
    exit 1
  else
    observed_exit="$?"
  fi
  [[ "${observed_exit}" -eq 2 ]] || {
    printf 'FAIL %s: %s exited %s instead of 2\n' \
      "${trace_id}" "${case_id}" "${observed_exit}" >&2
    exit 1
  }
  jq -e --arg code "${expected_diagnostic}" '.code == $code' \
    "${stderr_file}" >/dev/null
  "${runner}" --recover-case "${case_id}" \
    | jq -e '.accepted == true and .exit == 0 and .diagnostic == null' >/dev/null
  rm -f "${stderr_file}"
  trap - EXIT
done

if [[ "${trace_id}" == FS-166-HDS-010-SDS-010-SMS-020 ]]; then
  jq -e '
    .flowBoundaryCaseNames == [
      "compiler-input",
      "cpm-input",
      "nfm-input",
      "realization-input"
    ]
    and all(.flowBoundaryCases[];
      .accepted == true and .exit == 0 and .diagnostic == null
    )
  ' "${results}" >/dev/null
fi

printf 'PASS %s: %d exact negative diagnostics and recoveries validated\n' \
  "${trace_id}" "${#case_ids[@]}"
