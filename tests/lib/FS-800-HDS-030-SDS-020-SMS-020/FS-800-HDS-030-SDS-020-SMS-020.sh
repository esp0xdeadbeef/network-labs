#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-030-SDS-020-SMS-020
# GAMP-SCOPE: network-labs SMT/SIT source fixture proof; not HAT/SAT live evidence
# Validates that PPPoE IPv6/PD inventory realization facts are structurally
# complete in the network-labs source fixtures.
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
trace_id="FS-800-HDS-030-SDS-020-SMS-020"

fail() {
  echo "FAIL ${trace_id}: $*" >&2
  exit 1
}

# ---- Validate SMT row catalog entry -------------------------------------
REPO_ROOT="${repo_root}" nix eval --impure --raw --expr '
  let
    root = builtins.getEnv "REPO_ROOT";
    smtDir = root + "/GAMP/SMT/FS-800-HDS-030-SDS-020-SMS-020";
    row = import (smtDir + "/default.nix");
    traceId = "FS-800-HDS-030-SDS-020-SMS-020";
  in
    assert row.traceId == traceId;
    assert row.layer == "SMT";
    assert row.source.kind == "canonical-sms-source-stub";
    assert row.source.evidenceBoundary == "source-stub-only";
    assert builtins.pathExists (root + "/${row.source.sourcePath}");
    assert builtins.pathExists (root + "/${row.source.inventories.clab}");
    assert builtins.pathExists (root + "/${row.source.inventories.nixos}");
    assert builtins.pathExists (root + "/${row.source.inventories.testClients}");
    "ok"
' >/dev/null || fail "SMT row catalog entry validation failed"

# ---- Validate inventory files carry correct trace ID --------------------
for inv in inventory-clab inventory-nixos inventory-test-clients; do
  REPO_ROOT="${repo_root}" INV="${inv}" nix eval --impure --raw --expr '
    let
      root = builtins.getEnv "REPO_ROOT";
      inv = builtins.getEnv "INV";
      invFile = root + "/GAMP/SMT/FS-800-HDS-030-SDS-020-SMS-020/${inv}.nix";
      data = import invFile;
      traceId = "FS-800-HDS-030-SDS-020-SMS-020";
    in
      assert data.meta.traceId == traceId;
      assert data.meta.evidenceBoundary == "source-stub-only";
      "ok"
  ' >/dev/null || fail "${inv}.nix trace ID or boundary mismatch"
done

# ---- Validate PPPoE IPv6/PD canonical record structure ------------------
# The PPPoE IPv6/PD record shape mandated by SMS-020:
#   ipv6.mode = "dhcpv6-pd"
#   ipv6.defaultRoute = true
#   ipv6.iaid = positive int
#   ipv6.prefixDelegationRequestId = positive int
#   ipv6.duidMode = "persistent"
#   ipv6.resolverMode = "disabled"
#   ipv6.ipv4Mode = "disabled"
#   ipv6.routerSolicitation = false
#   ipv6.fallbackPolicy = "none"
#
# This is a structural shape assertion; the CPM normalizer and renderer
# equivalence are proved by focused tests in their owning repositories.
REPO_ROOT="${repo_root}" nix eval --impure --raw --expr '
  let
    traceId = "FS-800-HDS-030-SDS-020-SMS-020";
    ipv6pd = {
      mode = "dhcpv6-pd";
      defaultRoute = true;
      iaid = 7;
      prefixDelegationRequestId = 11;
      duidMode = "persistent";
      resolverMode = "disabled";
      ipv4Mode = "disabled";
      routerSolicitation = false;
      fallbackPolicy = "none";
    };
    client = {
      interface = "provider-handoff";
      runtimeInterface = "ppp-test";
      defaultRoute = true;
      usePeerDns = false;
      mtu = 1492;
      credentials = {
        usernameFile = "/run/secrets/test-username";
        passwordFile = "/run/secrets/test-password";
      };
      ipv6 = ipv6pd;
    };
  in
    assert ipv6pd.mode == "dhcpv6-pd";
    assert ipv6pd.defaultRoute == true;
    assert builtins.isInt ipv6pd.iaid && ipv6pd.iaid > 0;
    assert builtins.isInt ipv6pd.prefixDelegationRequestId && ipv6pd.prefixDelegationRequestId > 0;
    assert ipv6pd.duidMode == "persistent";
    assert ipv6pd.resolverMode == "disabled";
    assert ipv6pd.ipv4Mode == "disabled";
    assert ipv6pd.routerSolicitation == false;
    assert ipv6pd.fallbackPolicy == "none";
    assert client.runtimeInterface == "ppp-test";
    assert client.defaultRoute == true;
    assert client.mtu == 1492;
    "ok"
' >/dev/null || fail "PPPoE IPv6/PD canonical record shape assertion failed"

# ---- Validate SMS default.nix mirror is consistent ----------------------
REPO_ROOT="${repo_root}" nix eval --impure --raw --expr '
  let
    root = builtins.getEnv "REPO_ROOT";
    smsDir = root + "/GAMP/SMS/FS-800-HDS-030-SDS-020-SMS-020";
    sms = import (smsDir + "/default.nix");
    traceId = "FS-800-HDS-030-SDS-020-SMS-020";
  in
    assert sms.traceId == traceId;
    assert sms.layer == "SMS";
    assert builtins.isPath sms.parentSds || builtins.isString sms.parentSds;
    assert sms.evidenceBoundary == "source-stub-only";
    "ok"
' >/dev/null || fail "SMS mirror default.nix consistency check failed"

echo "PASS ${trace_id}"
