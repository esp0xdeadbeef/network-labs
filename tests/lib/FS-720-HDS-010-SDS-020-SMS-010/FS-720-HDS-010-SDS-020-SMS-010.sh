#!/usr/bin/env bash
# GAMP-ID: FS-720-HDS-010-SDS-020-SMS-010
# GAMP-SCOPE: software-module-test
#
# SPEC:   GAMP/SMS/FS-720-HDS-010-SDS-020-SMS-010.md
# OWNER:  network-labs
#
# Predicates: parse NixOS endpoint fixture declarations from the NixOS HAT
# inventory, and Containerlab/Linux access-client fixture declarations from the CLAB
# HAT inventory.
#
# Behavioural: both inventories are imported and their declaration surfaces
# asserted, so the case fails if an inventory stops being importable or stops
# carrying the facts the HAT derives endpoints from.
#
# Not executed before commit.
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
require_cmd() { command -v "$1" >/dev/null 2>&1 || { echo "missing required command: $1" >&2; exit 1; }; }
require_cmd nix
require_cmd jq

fail() { echo "FAIL hat-inventory-fixture-parse: $*" >&2; exit 1; }

example="${EXAMPLE:-single-wan}"
nixos_inv="${repo_root}/examples/${example}/inventory-nixos.nix"
clab_inv="${repo_root}/examples/${example}/inventory-clab.nix"

[[ -f "${nixos_inv}" ]] || fail "P1 no NixOS HAT inventory at examples/${example}/inventory-nixos.nix"
[[ -f "${clab_inv}"  ]] || fail "P1 no CLAB HAT inventory at examples/${example}/inventory-clab.nix"

# P1: the NixOS inventory imports and carries endpoint declarations.
nixos_json="$(nix eval --no-write-lock-file --impure --json --expr "import ${nixos_inv}" 2>&1)" \
  || fail "P1 the NixOS inventory does not import:
${nixos_json}"

if ! jq -e '[.. | objects | select(has("endpoints") or has("interfaces"))] | length > 0' <<<"${nixos_json}" >/dev/null; then
  fail "P1 the NixOS inventory carries no endpoints or interfaces, so no endpoint fixture can be parsed from it"
fi

# P2: the CLAB inventory imports and carries access-client declarations.
clab_json="$(nix eval --no-write-lock-file --impure --json --expr "import ${clab_inv}" 2>&1)" \
  || fail "P2 the CLAB inventory does not import:
${clab_json}"

if ! jq -e '[.. | objects | select(has("endpoints") or has("containerlab") or has("realization"))] | length > 0' <<<"${clab_json}" >/dev/null; then
  fail "P2 the CLAB inventory carries no endpoint, containerlab or realization data, so no access-client fixture can be parsed from it"
fi

# SN1: a missing inventory must fail, not be silently skipped. The violating input
# is a path that does not exist.
if nix eval --no-write-lock-file --impure --json --expr "import ${repo_root}/examples/${example}/inventory-does-not-exist.nix" >/dev/null 2>&1; then
  fail "SN1 a non-existent inventory path resolved instead of failing, so a missing fixture would be hidden"
fi

echo "PASS hat-inventory-fixture-parse"
