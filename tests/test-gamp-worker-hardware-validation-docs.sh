#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  echo "FAIL gamp-worker-hardware-validation-docs: $*" >&2
  exit 1
}

require_phrase() {
  local file="$1"
  local phrase="$2"
  grep -Fq "${phrase}" "${repo_root}/${file}" \
    || fail "${file} missing required phrase: ${phrase}"
}

for file in GAMP/AGENTS.md GAMP/SMT/README.md GAMP/SIT/README.md; do
  [[ -f "${repo_root}/${file}" ]] || fail "missing ${file}"
done

require_phrase GAMP/AGENTS.md "/home/deadbeef/github/network-labs/GAMP/*"
require_phrase GAMP/AGENTS.md 'Executable repo tests that prove those rows belong in `../tests/`'
require_phrase GAMP/AGENTS.md "Dry-run output, parser success, static grep, renderer JSON, or"
require_phrase GAMP/AGENTS.md "close a hardware-related SMT or SIT row"
require_phrase GAMP/AGENTS.md "s-router-nixos"
require_phrase GAMP/AGENTS.md "s-router-clab"
require_phrase GAMP/AGENTS.md "s-router-test-clients"

require_phrase GAMP/SMT/README.md "Hardware-related SMT is not a dry-run bucket"
require_phrase GAMP/SMT/README.md "/home/deadbeef/github/network-labs/GAMP/*"
require_phrase GAMP/SMT/README.md 'Put the `network-labs` side of that test under `../../tests/`'
require_phrase GAMP/SMT/README.md 'Static parsing, `nix-instantiate --parse`, renderer-only JSON inspection, and'
require_phrase GAMP/SMT/README.md "evidence for hardware-related SMT"

require_phrase GAMP/SIT/README.md "Hardware-related SIT must integrate the controlled source with a real"
require_phrase GAMP/SIT/README.md "/home/deadbeef/github/network-labs/GAMP/*"
require_phrase GAMP/SIT/README.md 'Put the `network-labs` integration test under `../../tests/`'
require_phrase GAMP/SIT/README.md "s-router-nixos"
require_phrase GAMP/SIT/README.md "s-router-clab"
require_phrase GAMP/SIT/README.md "s-router-test-clients"
require_phrase GAMP/SIT/README.md "row remains blocked until the real VM/harness command and observed result are"

if rg -n 'network-labs/(sat|HAT)(/|`|$)' "${repo_root}/GAMP/AGENTS.md" "${repo_root}/GAMP/SMT/README.md" "${repo_root}/GAMP/SIT/README.md"; then
  fail "worker docs must not point workers at legacy root sat/HAT paths"
fi

echo "PASS gamp-worker-hardware-validation-docs"
