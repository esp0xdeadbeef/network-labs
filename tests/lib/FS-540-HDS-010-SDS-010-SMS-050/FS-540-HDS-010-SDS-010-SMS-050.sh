#!/usr/bin/env bash
# GAMP-ID: FS-540-HDS-010-SDS-010-SMS-050
# GAMP-SCOPE: deterministic canonical DNS peer-posture construction
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
trace="FS-540-HDS-010-SDS-010-SMS-050"
results="$(nix build --no-link --print-out-paths "${repo_root}#validation-scheme-results")"
runner="$(nix build --no-link --print-out-paths "${repo_root}#validation-scheme")/bin/network-validation-scheme"
work_dir="$(mktemp -d)"
trap 'rm -rf "${work_dir}"' EXIT

jq -e '
  . as $root
  | .fs540PeerComparison.traceId == "FS-540-HDS-010-SDS-010-SMS-050"
  and .fs540PeerComparison.sourceTraceId == "FS-540-HDS-010-SDS-010-SMS-045"
  and .fs540PeerComparison.canonicalPortable == true
  and .fs540PeerComparison.openConfigModelComplete == false
  and .fs540PeerComparison.networkAccess == false
  and .fs540PeerComparison.warningCount == 0
  and all(.fs540PeerComparison.inputBundleIdentities[];
    . == $root.fs540PeerComparison.bundleIdentity
  )
  and (.fs540PeerComparison.postures.nixos == .fs540PeerComparison.postures.clab)
  and (.fs540PeerComparison.postures.nixos == .fs540PeerComparison.postures.openconfig)
  and .fs540PeerComparison.postures.openconfig == {
    requesterService: "recursive-dns",
    providerService: "core-dns",
    providerNode: "core-primary",
    recursionMode: "iterative",
    listenerScope: {
      relationId: "FS-540-HDS-010-SDS-010-SMS-045__recursive-dns-to-core",
      terminalAttachmentId: "link::mini-smt.FS-540-HDS-010-SDS-010-SMS-045::p2p-core-primary-upstream-selector"
    },
    selectedEgress: "isp-primary",
    addressFamilies: ["ipv4", "ipv6"],
    transports: ["tcp", "udp"],
    publicFallback: false,
    localOnly: {
      action: "refuse_non_local",
      localData: true,
      publicFallback: false,
      recursion: false,
      transitiveEgress: false
    }
  }
  and (.fs540PeerComparison.limitations | length) == 1
  and .fs540PeerComparison.limitations[0].code == "OC_DNS_MODEL_LIMITATION"
' "${results}" >/dev/null

jq -e '
  .seededNegativeCases as $cases
  | ($cases["OC-DNS-N4"].result.diagnostic.context.candidates | length) == 2
  and all($cases["OC-DNS-N4"].result.diagnostic.context.candidates[];
    test("^[0-9a-f]{64}$")
  )
  and $cases["OC-DNS-N5"].result.diagnostic.context.missingCoverage == [
    {family: "ipv6", proto: "tcp"}
  ]
  and $cases["OC-DNS-N7"].result.diagnostic.context == {
    destinationRenderer: "openconfig",
    sourceRenderer: "network-renderer-nixos"
  }
  and $cases["OC-DNS-N10"].result.diagnostic.context.divergentPeerCount == 1
' "${results}" >/dev/null

for sequence in $(seq 1 10); do
  case_id="OC-DNS-N${sequence}"
  expected_code="$(jq -r --arg caseId "${case_id}" \
    '.seededNegativeCases[$caseId].expectedDiagnostic' "${results}")"
  stdout_file="${work_dir}/${case_id}.stdout"
  stderr_file="${work_dir}/${case_id}.stderr"

  if "${runner}" --negative-case "${case_id}" >"${stdout_file}" 2>"${stderr_file}"; then
    echo "FAIL ${case_id}: seeded negative unexpectedly succeeded" >&2
    exit 1
  else
    observed_exit="$?"
  fi

  [[ "${observed_exit}" -eq 2 ]]
  [[ ! -s "${stdout_file}" ]]
  jq -e --arg code "${expected_code}" '.code == $code' "${stderr_file}" >/dev/null

  if "${runner}" --negative-case "${case_id}" \
    >"${stdout_file}.rerun" 2>"${stderr_file}.rerun"; then
    echo "FAIL ${case_id}: deterministic rerun unexpectedly succeeded" >&2
    exit 1
  else
    rerun_exit="$?"
  fi

  [[ "${rerun_exit}" -eq 2 ]]
  [[ ! -s "${stdout_file}.rerun" ]]
  cmp "${stderr_file}" "${stderr_file}.rerun"
  "${runner}" --recover-case "${case_id}" \
    | jq -e '.accepted == true and .exit == 0 and .diagnostic == null' >/dev/null
done

echo "PASS ${trace}: shared DNS posture and OC-DNS-N1 through OC-DNS-N10"
