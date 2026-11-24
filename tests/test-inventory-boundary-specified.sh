#!/usr/bin/env bash
# GAMP-SCOPE: specification-coverage test; the inventory/intent content boundary has an owner
#
# A TEST CANNOT ASSERT A BOUNDARY THAT NOBODY HAS SPECIFIED.
#
# The chain already owns two inventory subjects, and neither is this one:
#
#   FS-040  Public Inventory Boundary      -- whether inventory may be public
#   FS-050  Protected Inventory Boundary   -- whether inventory may carry plaintext secrets
#
# Neither states what inventory may CONTAIN. So "inventory carries hardware facts and
# sops references, intent carries everything derived" is a rule this pipeline depends
# on, is enforced in places, and has no owner: the only place it is written down is an
# error message in the control-plane model, and the only place it is exercised is test
# fixtures that put overlay topology, roles and addresses into `inventory-*.nix`.
#
# That is why attempts to assert the rule behaviourally keep failing: a downloaded
# WireGuard profile (addresses, keys, endpoints the model must preserve) and a
# self-hosted overlay (a VPS, endpoints the model could derive) are both legitimate,
# and only a stated provenance rule can tell them apart. Without one, any test either
# guesses or freezes whatever the implementation happens to do today.
#
# So this test asserts the SPECIFICATION, not a behaviour:
#
#   S1  A GAMP row states the content boundary: it names both carriers (`inventory`
#       and `intent`) and describes what inventory may hold.
#   S2  The same row states how provenance is decided -- an imported provider profile
#       versus a generated overlay -- because that, not the field's shape, is what
#       puts a fact on one side.
#
# STATUS: expected RED. The row does not exist. Write it in the owning layer, then
# behaviour tests can cite it instead of inventing it.
#
# Evidence boundary: construction. Documentation reads only.
set -euo pipefail

if [[ -n "${SMS_TEST_REPO_ROOT:-}" ]]; then
  repo_root="${SMS_TEST_REPO_ROOT}"
else
  repo_root="$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel 2>/dev/null || true)"
  [[ -n "${repo_root}" ]] || repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi

echo "--- INVENTORY-BOUNDARY-SPEC: the content boundary has an owner ---"
echo ""

gamp_root="${GAMP_ROOT:-${repo_root}/GAMP}"
if [[ ! -d "${gamp_root}" ]]; then
  echo "SKIP INVENTORY-BOUNDARY-SPEC: no GAMP tree at ${gamp_root}"
  exit 0
fi

# The rows that could own it: every SDS and SMS row. HDS is included because the
# substrate facts live there, and a boundary stated about equipment belongs to it.
mapfile -t rows < <(
  find "${gamp_root}/SDS" "${gamp_root}/SMS" "${gamp_root}/HDS" \
    -name 'README.md' -type f 2>/dev/null | LC_ALL=C sort
)

if ((${#rows[@]} == 0)); then
  echo "SKIP INVENTORY-BOUNDARY-SPEC: no SDS/SMS/HDS rows to search"
  exit 0
fi

echo "  rows searched: ${#rows[@]}"
echo ""

# classify_row <file>: prints
#   content     when the row states the inventory CONTENT boundary
#   provenance  when it also states how provenance is decided
#   protection  when it only talks about disclosure (FS-040/FS-050 shape)
#
# Word counts, not vibes: a row has to name both carriers, and then describe what
# inventory may hold in the vocabulary of the boundary (equipment/hardware/derived).
classify_row() {
  local file="$1" lower
  lower="$(tr '[:upper:]' '[:lower:]' <"${file}")"

  grep -q 'inventory' <<<"${lower}" || return 0
  grep -q 'intent' <<<"${lower}" || return 0

  local hits=0 term
  for term in equipment hardware device provenance 'derived' 'derive' supplied authored 'must not' 'may not'; do
    grep -q "${term}" <<<"${lower}" && hits=$((hits + 1))
  done
  ((hits >= 2)) || return 0

  # Disclosure-only rows do not count: they are about whether inventory may be seen,
  # not what it may say.
  if grep -qE 'plaintext|disclos|protected inventory|public inventory' <<<"${lower}" &&
    ! grep -qE 'equipment|hardware|derived|provenance' <<<"${lower}"; then
    printf 'protection\t%s\n' "${file}"
    return 0
  fi

  printf 'content\t%s\n' "${file}"
  for term in imported generated 'self-hosted' provenance origin; do
    if grep -q "${term}" <<<"${lower}"; then
      printf 'provenance\t%s\n' "${file}"
      return 0
    fi
  done
}

issues=0
report_issue() {
  local id="$1" finding="$2" why="$3" read="$4"
  issues=$((issues + 1))
  {
    echo "ISSUE ${id}: ${finding}"
    echo "  why:  ${why}"
    echo "  read: ${read}"
  } >&2
}

mapfile -t classified < <(for row in "${rows[@]}"; do classify_row "${row}"; done)

content_rows=()
provenance_rows=()
for line in ${classified[@]+"${classified[@]}"}; do
  kind="${line%%$'\t'*}"
  file="${line#*$'\t'}"
  case "${kind}" in
    content) content_rows+=("${file}") ;;
    provenance) content_rows+=("${file}"); provenance_rows+=("${file}") ;;
  esac
done

read_pointer="record it in the owning layer first: an SDS row under GAMP/SDS/ whose text
         states (a) what inventory may contain -- facts the operator supplies that the model
         must preserve (device identity, keys, sops references, a downloaded provider
         profile), (b) what intent may contain -- everything the model decides (topology,
         the addressing it allocates, roles), and (c) how PROVENANCE is decided, because an
         imported profile and a self-hosted overlay carry the same fields and belong on
         opposite sides. FS-040 and FS-050 own disclosure, not content."

# ---------------------------------------------------------------------------
# S1 -- the content boundary is stated somewhere in the chain.
# ---------------------------------------------------------------------------
if ((${#content_rows[@]} == 0)); then
  report_issue "S1" "no GAMP row states what inventory may CONTAIN" \
    "the pipeline enforces a content boundary -- 'inventory realizes the concrete /32, NFM
       owns the pool' is the control-plane model's own error message -- and no row owns the
       statement. Every attempt to test the boundary therefore has to guess it, and a guess
       either freezes today's implementation or invents a rule." \
    "${read_pointer}"
else
  echo "PASS S1: the content boundary is stated in:"
  printf '    %s\n' "${content_rows[@]}" | sed "s|${repo_root}/||"
fi

# ---------------------------------------------------------------------------
# S2 -- the row decides provenance, not just shape.
# ---------------------------------------------------------------------------
if ((${#provenance_rows[@]} == 0)); then
  report_issue "S2" "the row describes the boundary but not how provenance is decided" \
    "an address, a key and an endpoint are on both sides of this boundary. A downloaded
       WireGuard profile must be preserved; a self-hosted one is derivable. A rule stated
       only in terms of field shapes cannot separate them, which is exactly the ambiguity
       that makes behavioural tests unstable here." \
    "${read_pointer}"
else
  echo "PASS S2: provenance is decided in:"
  printf '    %s\n' "${provenance_rows[@]}" | sed "s|${repo_root}/||"
fi

# ---------------------------------------------------------------------------
# Seeded negatives -- the classifier must reject a disclosure-only row and accept a
# boundary row, or S1 would pass on FS-040/FS-050 and mean nothing.
# ---------------------------------------------------------------------------
seeded_root="$(mktemp -d)"
trap 'rm -rf "${seeded_root}"' EXIT
mkdir -p "${seeded_root}/SDS/seed-protection" "${seeded_root}/SDS/seed-boundary"

cat >"${seeded_root}/SDS/seed-protection/README.md" <<'MD'
# Public Inventory Boundary

This row records whether inventory may be disclosed. It proves the protected
inventory path hides plaintext, and that public inventory is shareable.
MD

cat >"${seeded_root}/SDS/seed-boundary/README.md" <<'MD'
# Inventory content boundary

`intent` carries what the model decides. `inventory` carries equipment and
hardware facts the operator supplies, plus sops references, and the model must
not derive them. An imported provider profile is inventory; a self-hosted overlay
is derived from intent. Provenance decides which side a fact is on.
MD

protection_kind="$(GAMP_ROOT="${seeded_root}" bash -c '
  source /dev/stdin <<< "$(sed -n "/^classify_row()/,/^}/p" "$1")"
  classify_row "$2"
' _ "${BASH_SOURCE[0]}" "${seeded_root}/SDS/seed-protection/README.md" | cut -f1)"

boundary_kind="$(GAMP_ROOT="${seeded_root}" bash -c '
  source /dev/stdin <<< "$(sed -n "/^classify_row()/,/^}/p" "$1")"
  classify_row "$2"
' _ "${BASH_SOURCE[0]}" "${seeded_root}/SDS/seed-boundary/README.md" | cut -f1)"

# A boundary row prints two lines ("content" then "provenance"); the disclosure-only
# row must print none.
if [[ -n "${protection_kind}" ]] || [[ "${boundary_kind}" != *provenance* ]]; then
  issues=$((issues + 1))
  {
    echo "ISSUE SEED: the classifier did not separate the seeded rows"
    echo "  disclosure-only row classified as: '${protection_kind}' (expected: not content)"
    echo "  boundary row classified as:        '${boundary_kind}' (expected: provenance)"
    echo "  every PASS above is therefore not evidence"
  } >&2
else
  echo "PASS SEED: rejected the disclosure-only row, classified the boundary row with provenance"
fi

echo ""
if ((issues > 0)); then
  echo "FAIL INVENTORY-BOUNDARY-SPEC: ${issues} issue(s)." >&2
  echo "  Write the row before writing tests that depend on it. The tests then cite the" >&2
  echo "  row instead of restating it, which is the one-owner-per-fact rule that stops" >&2
  echo "  a fixture and a document from disagreeing." >&2
  exit 1
fi

echo "PASS INVENTORY-BOUNDARY-SPEC: the content boundary is specified, with provenance"
exit 0
