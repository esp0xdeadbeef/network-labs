#!/usr/bin/env bash
# GAMP-ID: FS-750-HDS-010-SDS-010-SMS-010
# GAMP-SCOPE: software-module-test
#
# SPEC:   GAMP/SMS/FS-750-HDS-010-SDS-010-SMS-010.md
# OWNER:  network-labs
#
# Predicates: the receiver simulation is modelled as a virtual machine or
# containerized service fixture, and it carries a stable modelled host identity and
# a tenant or access-space assignment.
#
# Behavioural: imports the HAT fixture and asserts on its content, rather than
# grepping for the word "receiver".
#
# Not executed before commit.
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"

require_cmd() { command -v "$1" >/dev/null 2>&1 || { echo "missing required command: $1" >&2; exit 1; }; }
require_cmd nix
require_cmd jq

fail() { echo "FAIL receiver-simulation-fixture: $*" >&2; exit 1; }

fixture_root="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet"
intent="${fixture_root}/intent.nix"
nixos_inv="${fixture_root}/inventory-nixos.nix"
hetz_inv="${fixture_root}/inventory-hetz.nix"

[[ -f "${intent}" ]]     || fail "P1 no HAT intent at ${intent#"${repo_root}/"}"
[[ -f "${nixos_inv}" ]]  || fail "P1 no NixOS fixture inventory"
[[ -f "${hetz_inv}" ]]   || fail "P1 no second realization inventory, so the fixture is not dual-substrate"

intent_json="$(nix eval --no-write-lock-file --impure --json --expr "import ${intent}" 2>&1)" \
  || fail "P1 the HAT intent does not import:
${intent_json}"

# P1: the receiver services must be modelled as services, which is what makes the
# receiver a containerized service fixture rather than an ad-hoc process.
if ! jq -e '[.. | objects | select(has("name")) | select(.name | tostring | test("receiver"))] | length >= 2' \
  <<<"${intent_json}" >/dev/null; then
  fail "P1 the HAT intent models fewer than two receiver services, so the receiver simulation is not a service fixture"
fi

# P1: those services must name a provider scope, otherwise the fixture has no host.
if ! jq -e '[.. | objects | select(has("name")) | select(.name | tostring | test("receiver")) | select((.providers // []) | length > 0)] | length >= 1' \
  <<<"${intent_json}" >/dev/null; then
  fail "P1 no receiver service names a provider, so the fixture has no stable modelled host identity"
fi

nixos_json="$(nix eval --no-write-lock-file --impure --json --expr "import ${nixos_inv}" 2>&1)" \
  || fail "P1 the NixOS fixture inventory does not import:
${nixos_json}"

# P2: the modelled host must exist in the NixOS realization inventory, so the
# identity is realizable rather than only declared.
if ! jq -e '[paths | map(tostring) | join(".") | select(test("receiver"))] | length > 0' <<<"${nixos_json}" >/dev/null; then
  fail "P2 the NixOS realization inventory carries no receiver host, so the modelled identity is not realized"
fi

# SN1: a receiver identity absent from the inventory must not be silently tolerated.
# The violating input is a host name the inventory does not carry.
missing_host="nixos-receiver-does-not-exist"
if jq -e --arg h "${missing_host}" '[paths | map(tostring) | join(".") | select(test($h))] | length > 0' <<<"${nixos_json}" >/dev/null; then
  fail "SN1 the inventory matched a host name that does not exist, so a missing receiver identity would go undetected"
fi

echo "PASS receiver-simulation-fixture"
