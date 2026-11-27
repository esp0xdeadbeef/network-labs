#!/usr/bin/env bash
# Report fixtures that encode a SUPERSEDED contract. Warns; never fails.
#
# The owning layer is network-labs: the fixtures are its examples, and when it retires or
# reshapes one, every consumer that tests against it goes stale. That has happened twice --
# 4ffce424 removed the tri-site fixtures and 622c96b3 removed twenty more example
# directories -- and both times the consumers' tests were marked retired (GAMP-SKIP) rather
# than the fixtures being migrated.
#
# Migrating them is content work with a modelling question per fixture (which tenant
# legitimately has default egress, which scope owns an exit), so this does not attempt it.
# It makes the debt visible and names the owner, which is what "fix it upstream" needs to
# be actionable.
#
# The constructs below are exactly the ones the CPM rejects today, each taken from a real
# validator message:
#
#   E_SUPERSEDED_CONTRACT   relations carrying `uplinks` on `to` or `from`; reachability is
#                           a scope property now: { kind = "external"; scope = "<node>"; }
#   FS-180-HDS-010-SDS-010-SMS-010
#                           an `action = "allow"` relation without `returnBehavior`
#   E_CONTRACT_UNKNOWN_EXTERNAL
#                           `{ kind = "external"; name = "<x>"; }` where <x> is not a
#                           declared overlay -- an exit scope needs `scope`, not `name`
#
# Exit status is always 0. Output uses the workflow-command form so GitHub shows it as an
# annotation on the run, and it is greppable in the log.
set -uo pipefail

root="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
examples="${root}/examples"
found=0
scanned=0

[[ -d "${examples}" ]] || { echo "PASS FIXTURE-CONTRACT: no examples directory; nothing to scan"; exit 0; }

for intent in "${examples}"/*/intent.nix; do
  [[ -f "${intent}" ]] || continue
  scanned=$((scanned + 1))
  name="$(basename "$(dirname "${intent}")")"

  if grep -qE 'uplinks = \[' "${intent}"; then
    found=$((found + 1))
    printf '::warning title=superseded-fixture::%s/intent.nix still selects exits with `uplinks`; the model wants { kind = "external"; scope = "<node>" } (E_SUPERSEDED_CONTRACT, FS-322 Scope Reachability). Owning layer: network-labs.\n' "${name}"
  fi

  if grep -qE 'action = "allow"' "${intent}" && ! grep -q 'returnBehavior' "${intent}"; then
    found=$((found + 1))
    printf '::warning title=superseded-fixture::%s/intent.nix has allow relation(s) without `returnBehavior` (FS-180-HDS-010-SDS-010-SMS-010). Owning layer: network-labs.\n' "${name}"
  fi

  # `name = "<x>"` on an external is only valid when <x> is a declared overlay.
  overlays="$(grep -oE 'overlays = \[' "${intent}" >/dev/null 2>&1; grep -oE 'name = "[A-Za-z0-9._-]+"' "${intent}" | sed 's/name = //; s/"//g' | sort -u | tr '\n' ' ')"
  while read -r ext; do
    [[ -n "${ext}" ]] || continue
    if ! grep -qE "overlays = \[|name = \"${ext}\"; *\}|peerSite" "${intent}"; then :; fi
    if grep -qE "\{ kind = \"external\"; name = \"${ext}\"; \}" "${intent}" \
       && ! grep -qE "overlays = \[.*\"${ext}\"" "${intent}"; then
      found=$((found + 1))
      printf '::warning title=superseded-fixture::%s/intent.nix names external `%s` that is not a declared overlay; an exit scope needs scope, not name (E_CONTRACT_UNKNOWN_EXTERNAL). Owning layer: network-labs.\n' "${name}" "${ext}"
    fi
  done < <(grep -oE '\{ kind = "external"; name = "[A-Za-z0-9._-]+"; \}' "${intent}" | sed -E 's/.*name = "([^"]+)".*/\1/' | sort -u)

  # inventory files are part of the same contract surface
  for inv in "$(dirname "${intent}")"/inventory*.nix; do
    [[ -f "${inv}" ]] || continue
    if grep -qE 'uplinks = \[' "${inv}" 2>/dev/null; then
      found=$((found + 1))
      printf '::warning title=superseded-fixture::%s/%s still carries `uplinks` (E_SUPERSEDED_CONTRACT). Owning layer: network-labs.\n' "${name}" "$(basename "${inv}")"
    fi
  done
done

if (( found == 0 )); then
  printf 'PASS FIXTURE-CONTRACT: %s example fixture(s) scanned, none on a superseded contract\n' "${scanned}"
else
  printf 'FIXTURE-CONTRACT: %s superseded construct(s) across %s example fixture(s). Not a failure: the fix belongs upstream in network-labs (migrate the fixture, then restore the consumer test that was retired for it).\n' "${found}" "${scanned}"
fi
exit 0
