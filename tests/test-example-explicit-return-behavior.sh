#!/usr/bin/env bash
# LAB-SMT-026
# FS-180-HDS-010-SDS-010-SMS-010: every runnable example and HAT allow
# relation makes its return-flow decision explicit before entering the
# compiler/model pipeline. Canonical SMS source stubs are intentionally outside
# this construction gate.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
failures=0

while IFS= read -r -d '' intent; do
  invalid="$({
    nix eval --json --file "${intent}" |
      jq -r '
        def recognized($value):
          $value == "one-way" or
          $value == "symmetric" or
          $value == "stateful-return";
        .. | objects |
        select(has("communicationContract")) |
        .communicationContract.relations[]? |
        select((.action // "allow") == "allow") |
        . as $relation |
        ($relation.returnBehavior // "") as $top |
        ($relation.publicIngressTupleAuthority.returnBehavior // "") as $nested |
        select(
          ($top == "" and $nested == "") or
          ($top != "" and (recognized($top) | not)) or
          ($nested != "" and (recognized($nested) | not)) or
          ($top != "" and $nested != "" and $top != $nested)
        ) |
        "\(.id // "<missing-id>") top=\($top) nested=\($nested)"
      '
  } 2>&1)" || {
    printf 'FAIL %s: could not evaluate return-flow contract\n%s\n' \
      "${intent#"${repo_root}/"}" "${invalid}" >&2
    failures=$((failures + 1))
    continue
  }

  if [[ -n "${invalid}" ]]; then
    printf 'FAIL %s: invalid or missing allow returnBehavior\n%s\n' \
      "${intent#"${repo_root}/"}" "${invalid}" >&2
    failures=$((failures + 1))
  fi
done < <(
  find \
    "${repo_root}/examples" \
    "${repo_root}/GAMP/HAT" \
    -type f -name intent.nix -print0 |
    sort -z
)

if ((failures > 0)); then
  exit 1
fi

echo "PASS LAB-SMT-026 explicit runnable source return behavior"
