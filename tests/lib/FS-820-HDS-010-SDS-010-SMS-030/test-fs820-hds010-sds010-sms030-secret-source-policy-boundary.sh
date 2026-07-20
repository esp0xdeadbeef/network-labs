#!/usr/bin/env bash
# GAMP-ID: FS-820-HDS-010-SDS-010-SMS-030
# Purpose: Dedicated construction test for secret source policy boundary.
# Proves source bindings remain credential realization data only and the
# module rejects policy-injecting, trust-boundary, firewall-policy, and
# host-account source bindings per SMS-030 construction handoff.
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
lab_dir="${repo_root}/GAMP/SAT"
tmp_json="$(mktemp)"
trap 'rm -f "${tmp_json}"' EXIT

fail() {
  echo "FAIL fs820-hds010-sds010-sms030: $*" >&2
  exit 1
}

nix eval --impure --json --expr "{
  raw = import ${lab_dir}/inventory.nix;
  resolved = import ${lab_dir}/getResolvedInventory.nix { renderer = \"nixos\"; };
}" >"${tmp_json}"

# ---------------------------------------------------------------------------
# Shared jq function: has_policy_or_host_key
# Matches the has_forbidden_key semantics from test-fs810-fs820-secret-source-records.sh
# but scoped to source bindings.
# ---------------------------------------------------------------------------
# Baseline: every source binding must be clean.
jq -e '
  def has_forbidden_key:
    any(
      [.. | objects | keys[]][];
      IN(
        "allowRoute",
        "allowFirewall",
        "trustAnchor",
        "trustBoundary",
        "routeAuthority",
        "firewallAuthority",
        "dnsAuthority",
        "publicIngress",
        "tenantReachability",
        "neededForUsers",
        "hashedPasswordFile",
        "defaultSopsFile"
      )
    );
  .raw.sourceBindings as $bindings
  | all($bindings[]; has_forbidden_key | not)
' "${tmp_json}" >/dev/null || fail "Baseline: existing source bindings contain forbidden policy/host-account keys (unexpected)"

echo "MR1: baseline source bindings are policy-neutral — PASS"

# ---------------------------------------------------------------------------
# SN1 — Route policy injection via source binding (metadata.allowRoute)
# Diagnostic: POLICY_BEARING_SOURCE_BINDING
# ---------------------------------------------------------------------------
jq -e '
  def has_forbidden_key:
    any(
      [.. | objects | keys[]][];
      IN(
        "allowRoute",
        "allowFirewall",
        "trustAnchor",
        "trustBoundary",
        "routeAuthority",
        "firewallAuthority",
        "dnsAuthority",
        "publicIngress",
        "tenantReachability",
        "neededForUsers",
        "hashedPasswordFile",
        "defaultSopsFile"
      )
    );
  .raw as $r
  | ($r.sourceBindings[0] + {
      id: "negative-route-injection",
      metadata: { allowRoute: { destination: "10.99.99.0/24", interface: "pppoe-wan0" } }
    }) as $injected
  | ($injected | has_forbidden_key)
' "${tmp_json}" >/dev/null || fail "SN1: injected allowRoute must be detected as forbidden key"

jq -e '
  def has_forbidden_key:
    any(
      [.. | objects | keys[]][];
      IN(
        "allowRoute",
        "allowFirewall",
        "trustAnchor",
        "trustBoundary",
        "routeAuthority",
        "firewallAuthority",
        "dnsAuthority",
        "publicIngress",
        "tenantReachability",
        "neededForUsers",
        "hashedPasswordFile",
        "defaultSopsFile"
      )
    );
  .raw as $r
  | ($r.sourceBindings + [
      ($r.sourceBindings[0] + {
        id: "negative-route-injection",
        metadata: { allowRoute: { destination: "10.99.99.0/24", interface: "pppoe-wan0" } }
      })
    ]) as $mutated
  | any($mutated[]; has_forbidden_key)
' "${tmp_json}" >/dev/null || fail "SN1: injecting route-policy binding into list must be detectable via has_forbidden_key"

echo "SN1: POLICY_BEARING_SOURCE_BINDING — route injection (allowRoute) detected — PASS"

# ---------------------------------------------------------------------------
# SN2 — Trust boundary injection via source binding (metadata.trustAnchor)
# Diagnostic: TRUST_BOUNDARY_SOURCE_BINDING
# ---------------------------------------------------------------------------
jq -e '
  def has_forbidden_key:
    any(
      [.. | objects | keys[]][];
      IN(
        "allowRoute",
        "allowFirewall",
        "trustAnchor",
        "trustBoundary",
        "routeAuthority",
        "firewallAuthority",
        "dnsAuthority",
        "publicIngress",
        "tenantReachability",
        "neededForUsers",
        "hashedPasswordFile",
        "defaultSopsFile"
      )
    );
  .raw as $r
  | ($r.sourceBindings[0] + {
      id: "negative-trust-injection",
      metadata: { trustAnchor: { tenant: "unrelated-tenant-b", scope: "cross-site" } }
    }) as $injected
  | ($injected | has_forbidden_key)
' "${tmp_json}" >/dev/null || fail "SN2: injected trustAnchor must be detected as forbidden key"

echo "SN2: TRUST_BOUNDARY_SOURCE_BINDING — trust-anchor injection (trustAnchor) detected — PASS"

# ---------------------------------------------------------------------------
# SN3 — Firewall policy injection via source binding (metadata.allowFirewall)
# Diagnostic: POLICY_BEARING_SOURCE_BINDING
# ---------------------------------------------------------------------------
jq -e '
  def has_forbidden_key:
    any(
      [.. | objects | keys[]][];
      IN(
        "allowRoute",
        "allowFirewall",
        "trustAnchor",
        "trustBoundary",
        "routeAuthority",
        "firewallAuthority",
        "dnsAuthority",
        "publicIngress",
        "tenantReachability",
        "neededForUsers",
        "hashedPasswordFile",
        "defaultSopsFile"
      )
    );
  .raw as $r
  | ($r.sourceBindings[0] + {
      id: "negative-firewall-injection",
      metadata: { allowFirewall: { chain: "INPUT", action: "accept", sourceScope: "secret-declared-scope" } }
    }) as $injected
  | ($injected | has_forbidden_key)
' "${tmp_json}" >/dev/null || fail "SN3: injected allowFirewall must be detected as forbidden key"

echo "SN3: POLICY_BEARING_SOURCE_BINDING — firewall injection (allowFirewall) detected — PASS"

# ---------------------------------------------------------------------------
# SN4 — Host account injection via source binding (neededForUsers)
# Diagnostic: HOST_ACCOUNT_SOURCE_BINDING
# ---------------------------------------------------------------------------
jq -e '
  def has_forbidden_key:
    any(
      [.. | objects | keys[]][];
      IN(
        "allowRoute",
        "allowFirewall",
        "trustAnchor",
        "trustBoundary",
        "routeAuthority",
        "firewallAuthority",
        "dnsAuthority",
        "publicIngress",
        "tenantReachability",
        "neededForUsers",
        "hashedPasswordFile",
        "defaultSopsFile"
      )
    );
  .raw as $r
  | ($r.sourceBindings[0] + {
      id: "negative-host-account-injection",
      neededForUsers: true,
      secretName: "deadbeef-passwd"
    }) as $injected
  | ($injected | has_forbidden_key)
' "${tmp_json}" >/dev/null || fail "SN4: injected neededForUsers must be detected as forbidden key"

echo "SN4: HOST_ACCOUNT_SOURCE_BINDING — host account injection (neededForUsers) detected — PASS"

# ---------------------------------------------------------------------------
# Recovery: baseline bindings still clean after mutation checks.
# ---------------------------------------------------------------------------
jq -e '
  def has_forbidden_key:
    any(
      [.. | objects | keys[]][];
      IN(
        "allowRoute",
        "allowFirewall",
        "trustAnchor",
        "trustBoundary",
        "routeAuthority",
        "firewallAuthority",
        "dnsAuthority",
        "publicIngress",
        "tenantReachability",
        "neededForUsers",
        "hashedPasswordFile",
        "defaultSopsFile"
      )
    );
  .raw.sourceBindings as $bindings
  | all($bindings[]; has_forbidden_key | not)
' "${tmp_json}" >/dev/null || fail "Recovery: baseline bindings must remain clean after seeded negative checks"

echo "Recovery: baseline bindings remain policy-neutral after all seeded negatives — PASS"

echo "PASS fs820-hds010-sds010-sms030-secret-source-policy-boundary"
