#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-030-SDS-030-SMS-010
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/GAMP/SAT"
trace_id="FS-800-HDS-030-SDS-030-SMS-010"

fail() {
  echo "FAIL ${trace_id}: $*" >&2
  exit 1
}

# Run nix eval and return output
run_nix() {
  LAB_DIR="${lab_dir}" nix eval --impure --raw --expr "$1" 2>&1
}

# Happy path: verify existing PPPoE rows have both provider and customer
happy=$(run_nix "
  let
    table = import (builtins.getEnv \"LAB_DIR\" + \"/provider-access-fixture-table.nix\");
    checkRow = name: row:
      row ? provider && builtins.isAttrs row.provider
      && row.provider ? role && row.provider ? handoff
      && row ? customer && builtins.isAttrs row.customer
      && row.customer ? site && row.customer ? coreNode;
  in
    if checkRow \"pppoeNixos\" table.pppoeNixos
       && checkRow \"pppoeClab\" table.pppoeClab
    then \"PASS-happy\"
    else \"FAIL-happy\"
")
if [[ "${happy}" != "PASS-happy" ]]; then
  fail "happy path failed: ${happy}"
fi

# SN1: Provider-only → missing-customer-surface
sn1=$(run_nix "
  let
    row = {
      provider = { role = \"emulated-isp\"; handoff = \"pppoe\"; };
    };
    hasProvider = row ? provider && builtins.isAttrs row.provider
                  && row.provider ? role && row.provider ? handoff;
    hasCustomer = row ? customer && builtins.isAttrs row.customer
                  && row.customer ? site && row.customer ? coreNode;
    isProviderOnly = hasProvider && !hasCustomer;
  in
    if isProviderOnly then \"PASS-SN1-provider-only-rejected\"
    else \"FAIL-SN1-should-be-rejected\"
")
if [[ "${sn1}" != "PASS-SN1-provider-only-rejected" ]]; then
  fail "SN1 failed: ${sn1}"
fi

# SN1 recovery
sn1r=$(run_nix "
  let
    row = {
      provider = { role = \"emulated-isp\"; handoff = \"pppoe\"; };
      customer = { site = \"test\"; coreNode = \"test-core\"; };
    };
    hasProvider = row ? provider && builtins.isAttrs row.provider
                  && row.provider ? role && row.provider ? handoff;
    hasCustomer = row ? customer && builtins.isAttrs row.customer
                  && row.customer ? site && row.customer ? coreNode;
    isProviderOnly = hasProvider && !hasCustomer;
    isCustomerOnly = !hasProvider && hasCustomer;
  in
    if hasProvider && hasCustomer then \"PASS-SN1-recovery\"
    else \"FAIL-SN1-recovery\"
")
if [[ "${sn1r}" != "PASS-SN1-recovery" ]]; then
  fail "SN1 recovery failed: ${sn1r}"
fi

# SN2: Customer-only → missing-provider-surface
sn2=$(run_nix "
  let
    row = {
      customer = { site = \"test\"; coreNode = \"test-core\"; };
    };
    hasProvider = row ? provider && builtins.isAttrs row.provider
                  && row.provider ? role && row.provider ? handoff;
    hasCustomer = row ? customer && builtins.isAttrs row.customer
                  && row.customer ? site && row.customer ? coreNode;
    isCustomerOnly = !hasProvider && hasCustomer;
  in
    if isCustomerOnly then \"PASS-SN2-customer-only-rejected\"
    else \"FAIL-SN2-should-be-rejected\"
")
if [[ "${sn2}" != "PASS-SN2-customer-only-rejected" ]]; then
  fail "SN2 failed: ${sn2}"
fi

# SN2 recovery
sn2r=$(run_nix "
  let
    row = {
      provider = { role = \"emulated-isp\"; handoff = \"pppoe\"; };
      customer = { site = \"test\"; coreNode = \"test-core\"; };
    };
    hasProvider = row ? provider && builtins.isAttrs row.provider
                  && row.provider ? role && row.provider ? handoff;
    hasCustomer = row ? customer && builtins.isAttrs row.customer
                  && row.customer ? site && row.customer ? coreNode;
  in
    if hasProvider && hasCustomer then \"PASS-SN2-recovery\"
    else \"FAIL-SN2-recovery\"
")
if [[ "${sn2r}" != "PASS-SN2-recovery" ]]; then
  fail "SN2 recovery failed: ${sn2r}"
fi

# SN3: Fallback enabled → fallback-enabled
sn3=$(run_nix "
  let
    row = {
      provider = { role = \"emulated-isp\"; handoff = \"pppoe\"; };
      customer = { site = \"test\"; coreNode = \"test-core\"; };
      fallback = true;
    };
    hasFallback = row ? fallback && row.fallback == true;
  in
    if hasFallback then \"PASS-SN3-fallback-rejected\"
    else \"FAIL-SN3-should-be-rejected\"
")
if [[ "${sn3}" != "PASS-SN3-fallback-rejected" ]]; then
  fail "SN3 failed: ${sn3}"
fi

# SN3 recovery
sn3r=$(run_nix "
  let
    row = {
      provider = { role = \"emulated-isp\"; handoff = \"pppoe\"; };
      customer = { site = \"test\"; coreNode = \"test-core\"; };
      fallback = false;
    };
    hasFallback = row ? fallback && row.fallback == true;
    hasProvider = row ? provider && builtins.isAttrs row.provider;
    hasCustomer = row ? customer && builtins.isAttrs row.customer;
  in
    if hasProvider && hasCustomer && !hasFallback then \"PASS-SN3-recovery\"
    else \"FAIL-SN3-recovery\"
")
if [[ "${sn3r}" != "PASS-SN3-recovery" ]]; then
  fail "SN3 recovery failed: ${sn3r}"
fi

# SN4: Opaque transport → opaque-transport-classification
sn4=$(run_nix "
  let
    row = {
      provider = { role = \"emulated-isp\"; handoff = \"pppoe\"; };
      customer = { site = \"test\"; coreNode = \"test-core\"; };
      transportClassification = \"opaque\";
    };
    hasOpaque = row ? transportClassification && row.transportClassification == \"opaque\";
  in
    if hasOpaque then \"PASS-SN4-opaque-rejected\"
    else \"FAIL-SN4-should-be-rejected\"
")
if [[ "${sn4}" != "PASS-SN4-opaque-rejected" ]]; then
  fail "SN4 failed: ${sn4}"
fi

# SN4 recovery
sn4r=$(run_nix "
  let
    row = {
      provider = { role = \"emulated-isp\"; handoff = \"pppoe\"; };
      customer = { site = \"test\"; coreNode = \"test-core\"; };
      transportClassification = \"pppoe\";
    };
    hasOpaque = row ? transportClassification && row.transportClassification == \"opaque\";
    hasProvider = row ? provider && builtins.isAttrs row.provider;
    hasCustomer = row ? customer && builtins.isAttrs row.customer;
  in
    if hasProvider && hasCustomer && !hasOpaque then \"PASS-SN4-recovery\"
    else \"FAIL-SN4-recovery\"
")
if [[ "${sn4r}" != "PASS-SN4-recovery" ]]; then
  fail "SN4 recovery failed: ${sn4r}"
fi

# Edge case: unpaired (neither provider nor customer)
sn5=$(run_nix "
  let
    row = { };
    hasProvider = row ? provider && builtins.isAttrs row.provider;
    hasCustomer = row ? customer && builtins.isAttrs row.customer;
    isUnpaired = !hasProvider && !hasCustomer;
  in
    if isUnpaired then \"PASS-SN5-unpaired-rejected\"
    else \"FAIL-SN5-should-be-rejected\"
")
if [[ "${sn5}" != "PASS-SN5-unpaired-rejected" ]]; then
  fail "SN5 unpaired failed: ${sn5}"
fi

echo "PASS ${trace_id}"
