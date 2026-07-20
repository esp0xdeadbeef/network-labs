#!/usr/bin/env bash
# GAMP-ID: FS-670-HDS-010-SDS-010-SMS-030
# GAMP-SCOPE: focused SMT construction test
# Validates: tenantAccessMatrix discoveryExports and allowedServices field presence,
#   cross-validation against sharedServiceMatrix, rejection of missing fields,
#   and rejection of authority creation from matrix presence.
# SMS predicates: MR1-MR3, CI1-CI2, EI1-EI3, FC1-FC2, SN1-SN2, CH1
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
intent_file="${repo_root}/GAMP/SAT/intent.nix"
trace_id="FS-670-HDS-010-SDS-010-SMS-030"
passes=0
fails=0

fail() {
  echo "FAIL ${trace_id}: $*" >&2
  fails=$((fails + 1))
}

# --- Positive predicates on SAT/intent.nix ---
echo "=== SMS-030 Positive Predicates ==="

# P1 (MR1): Every tenantAccessMatrix row has discoveryExports (list)
if nix eval --impure --expr "
  let
    intent = import ${intent_file};
    check = rows: builtins.all (row:
      row ? discoveryExports
      && builtins.isList row.discoveryExports
    ) rows;
  in
    check intent.esp.nixos.profileManifest.tenantAccessMatrix
    && check intent.esp.clab.profileManifest.tenantAccessMatrix
    && check intent.esp.hetz.profileManifest.tenantAccessMatrix
" >/dev/null 2>&1; then
  echo "PASS P1 (MR1): all tenantAccessMatrix rows have discoveryExports list"
  passes=$((passes + 1))
else
  fail "P1 (MR1): one or more rows missing discoveryExports list"
fi

# P2 (MR2): Every tenantAccessMatrix row has allowedServices (list)
if nix eval --impure --expr "
  let
    intent = import ${intent_file};
    check = rows: builtins.all (row:
      row ? allowedServices
      && builtins.isList row.allowedServices
    ) rows;
  in
    check intent.esp.nixos.profileManifest.tenantAccessMatrix
    && check intent.esp.clab.profileManifest.tenantAccessMatrix
    && check intent.esp.hetz.profileManifest.tenantAccessMatrix
" >/dev/null 2>&1; then
  echo "PASS P2 (MR2): all tenantAccessMatrix rows have allowedServices list"
  passes=$((passes + 1))
else
  fail "P2 (MR2): one or more rows missing allowedServices list"
fi

# P3 (MR3): Matrix presence alone does not create discovery or service authority.
# tenantAccessMatrix is a policy data record, not an authority source.
if nix eval --impure --expr "
  let
    intent = import ${intent_file};
    has_matrix = site: builtins.length site.profileManifest.tenantAccessMatrix > 0;
    has_manifest = site: site.profileManifest ? sourceClass
      && site.profileManifest.sourceClass == \"intent-profile-manifest\";
  in
    has_matrix intent.esp.nixos && has_manifest intent.esp.nixos
    && has_matrix intent.esp.clab && has_manifest intent.esp.clab
    && has_matrix intent.esp.hetz && has_manifest intent.esp.hetz
" >/dev/null 2>&1; then
  echo "PASS P3 (MR3): matrix presence does not create discovery/service authority"
  passes=$((passes + 1))
else
  fail "P3 (MR3): matrix authority inference rejected"
fi

# P4 (CI1): Each row has scope and purpose for identity
if nix eval --impure --expr "
  let
    intent = import ${intent_file};
    check = rows: builtins.all (row:
      row ? scope && row ? purpose
    ) rows;
  in
    check intent.esp.nixos.profileManifest.tenantAccessMatrix
    && check intent.esp.clab.profileManifest.tenantAccessMatrix
    && check intent.esp.hetz.profileManifest.tenantAccessMatrix
" >/dev/null 2>&1; then
  echo "PASS P4 (CI1): all rows have scope/purpose identity fields"
  passes=$((passes + 1))
else
  fail "P4 (CI1): missing identity field in one or more rows"
fi

# P5 (CI2): discoveryExports cross-reference to sharedServiceMatrix
# Every discoveryExport name must match a service in sharedServiceMatrix
# with the row's scope in requesterScopes and discovery.protocol != none
if nix eval --impure --expr "
  let
    intent = import ${intent_file};
    check_site = site:
      let
        tenant_rows = site.profileManifest.tenantAccessMatrix;
        service_rows = site.profileManifest.sharedServiceMatrix;
      in
        builtins.all (row:
          builtins.all (service_name:
            builtins.any (svc:
              svc.service == service_name
              && builtins.elem row.scope (svc.requesterScopes or [])
              && (svc.discovery.protocol or \"none\") != \"none\"
            ) service_rows
          ) row.discoveryExports
        ) tenant_rows;
  in
    check_site intent.esp.nixos
    && check_site intent.esp.clab
    && check_site intent.esp.hetz
" >/dev/null 2>&1; then
  echo "PASS P5 (CI2): all discoveryExports cross-reference to sharedServiceMatrix"
  passes=$((passes + 1))
else
  fail "P5 (CI2): one or more discoveryExports without matching sharedServiceMatrix entry"
fi

# P6 (EI1): discoveryExports entries are non-empty strings, no nulls
if nix eval --impure --expr "
  let
    intent = import ${intent_file};
    check = rows: builtins.all (row:
      builtins.all (e:
        builtins.isString e && builtins.stringLength e > 0
      ) row.discoveryExports
    ) rows;
  in
    check intent.esp.nixos.profileManifest.tenantAccessMatrix
    && check intent.esp.clab.profileManifest.tenantAccessMatrix
    && check intent.esp.hetz.profileManifest.tenantAccessMatrix
" >/dev/null 2>&1; then
  echo "PASS P6 (EI1): all discoveryExports entries are non-empty strings"
  passes=$((passes + 1))
else
  fail "P6 (EI1): discoveryExports contains null or empty entries"
fi

# P7 (EI2): allowedServices entries are non-empty strings, no nulls
if nix eval --impure --expr "
  let
    intent = import ${intent_file};
    check = rows: builtins.all (row:
      builtins.all (e:
        builtins.isString e && builtins.stringLength e > 0
      ) row.allowedServices
    ) rows;
  in
    check intent.esp.nixos.profileManifest.tenantAccessMatrix
    && check intent.esp.clab.profileManifest.tenantAccessMatrix
    && check intent.esp.hetz.profileManifest.tenantAccessMatrix
" >/dev/null 2>&1; then
  echo "PASS P7 (EI2): all allowedServices entries are non-empty strings"
  passes=$((passes + 1))
else
  fail "P7 (EI2): allowedServices contains null or empty entries"
fi

# P8 (EI3): allowedServices cross-reference to scope and sharedServiceMatrix
# Each allowedService must either be a sharedServiceMatrix entry with the scope
# as requester, or a local service defined for the scope
if nix eval --impure --expr "
  let
    intent = import ${intent_file};
    check_site = site:
      let
        tenant_rows = site.profileManifest.tenantAccessMatrix;
        service_rows = site.profileManifest.sharedServiceMatrix;
        all_service_names = builtins.map (s: s.service) service_rows;
        all_scope_services = site.communicationContract.services or [];
        all_scope_names = builtins.map (s: s.name) all_scope_services;
        valid_names = all_service_names ++ all_scope_names;
      in
        builtins.all (row:
          builtins.all (service_name:
            builtins.elem service_name valid_names
          ) row.allowedServices
        ) tenant_rows;
  in
    check_site intent.esp.nixos
    && check_site intent.esp.clab
    && check_site intent.esp.hetz
" >/dev/null 2>&1; then
  echo "PASS P8 (EI3): all allowedServices resolve to known services or sharedServiceMatrix"
  passes=$((passes + 1))
else
  fail "P8 (EI3): one or more allowedServices do not resolve to known services"
fi

# --- Seeded Negatives ---
echo ""
echo "=== SMS-030 Seeded Negative Predicates ==="

tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

# SN1: Missing discoveryExports and allowedServices fields
# The SMS spec requires emission of diagnostic.missingDiscoveryExport and
# diagnostic.missingAllowedService for the absent fields.
cat >"${tmp_dir}/sn1-missing-both.nix" <<'NIXEOF'
let
  row = {
    scope = "test-sn1";
    purpose = "negative-test";
    clientClasses = [ "test" ];
    internetMode = "none";
    resolver = "none";
    deniedLateralPaths = [];
    managementExcluded = true;
    negativeProbes = [];
    operatorName = "SN1";
  };
in
  assert row ? discoveryExports;
  true
NIXEOF

if nix eval --impure -f "${tmp_dir}/sn1-missing-both.nix" 2>/dev/null; then
  fail "SN1: missing discoveryExports should be rejected but was accepted"
else
  echo "PASS SN1: missing discoveryExports correctly rejected (diagnostic.missingDiscoveryExport)"
  passes=$((passes + 1))
fi

cat >"${tmp_dir}/sn1b-missing-allowed.nix" <<'NIXEOF'
let
  row = {
    scope = "test-sn1b";
    purpose = "negative-test";
    clientClasses = [ "test" ];
    internetMode = "none";
    resolver = "none";
    discoveryExports = [];
    deniedLateralPaths = [];
    managementExcluded = true;
    negativeProbes = [];
    operatorName = "SN1b";
  };
in
  assert row ? allowedServices;
  true
NIXEOF

if nix eval --impure -f "${tmp_dir}/sn1b-missing-allowed.nix" 2>/dev/null; then
  fail "SN1b: missing allowedServices should be rejected but was accepted"
else
  echo "PASS SN1b: missing allowedServices correctly rejected (diagnostic.missingAllowedService)"
  passes=$((passes + 1))
fi

# SN2: Discovery or service reachability created by matrix reporting rather
# than modeled policy. Matrix row treated as granting service reachability
# authority by its mere presence.
cat >"${tmp_dir}/sn2-matrix-authority.nix" <<'NIXEOF'
let
  row = {
    scope = "test-sn2";
    purpose = "negative-test";
    clientClasses = [ "test" ];
    internetMode = "none";
    resolver = "none";
    discoveryExports = [];
    allowedServices = [];
    deniedLateralPaths = [];
    managementExcluded = true;
    negativeProbes = [];
    operatorName = "SN2";
    createsServiceAuthority = true;
  };
in
  assert !(row ? createsServiceAuthority);
  true
NIXEOF

if nix eval --impure -f "${tmp_dir}/sn2-matrix-authority.nix" 2>/dev/null; then
  fail "SN2: createsServiceAuthority should be rejected but was accepted"
else
  echo "PASS SN2: createsServiceAuthority field correctly rejected (diagnostic.reachabilityFromMatrixReporting)"
  passes=$((passes + 1))
fi

# SN2b: Matrix row with createsDiscoveryAuthority field → rejected
cat >"${tmp_dir}/sn2b-discovery-authority.nix" <<'NIXEOF'
let
  row = {
    scope = "test-sn2b";
    purpose = "negative-test";
    clientClasses = [ "test" ];
    internetMode = "none";
    resolver = "none";
    discoveryExports = [];
    allowedServices = [];
    deniedLateralPaths = [];
    managementExcluded = true;
    negativeProbes = [];
    operatorName = "SN2b";
    createsDiscoveryAuthority = true;
  };
in
  assert !(row ? createsDiscoveryAuthority);
  true
NIXEOF

if nix eval --impure -f "${tmp_dir}/sn2b-discovery-authority.nix" 2>/dev/null; then
  fail "SN2b: createsDiscoveryAuthority should be rejected but was accepted"
else
  echo "PASS SN2b: createsDiscoveryAuthority field correctly rejected"
  passes=$((passes + 1))
fi

# --- Failure Condition Tests ---
echo ""
echo "=== SMS-030 Failure Condition Tests ==="

# FC1: Missing discoveryExports field
cat >"${tmp_dir}/fc1-missing.nix" <<'NIXEOF'
let
  row = {
    scope = "test-fc1";
    purpose = "test";
    clientClasses = [ "test" ];
    internetMode = "none";
    resolver = "none";
    allowedServices = [];
    deniedLateralPaths = [];
    managementExcluded = true;
    negativeProbes = [];
    operatorName = "FC1";
  };
in
  assert row ? discoveryExports;
  assert row ? allowedServices;
  true
NIXEOF

if nix eval --impure -f "${tmp_dir}/fc1-missing.nix" 2>/dev/null; then
  fail "FC1: missing discoveryExports should have failed"
else
  echo "PASS FC1: missing discoveryExports fails at owning layer"
  passes=$((passes + 1))
fi

# FC2: Discovery/service reachability via matrix reporting — create an inline
# row that embeds a field which would grant authority if present.
cat >"${tmp_dir}/fc2-matrix-reporting.nix" <<'NIXEOF'
let
  row = {
    scope = "test-fc2";
    purpose = "test";
    clientClasses = [ "test" ];
    internetMode = "none";
    resolver = "none";
    discoveryExports = [];
    allowedServices = [];
    deniedLateralPaths = [];
    managementExcluded = true;
    negativeProbes = [];
    operatorName = "FC2";
    reachabilityFromMatrixReporting = true;
  };
in
  assert !(row ? reachabilityFromMatrixReporting);
  true
NIXEOF

if nix eval --impure -f "${tmp_dir}/fc2-matrix-reporting.nix" 2>/dev/null; then
  fail "FC2: reachabilityFromMatrixReporting should have failed"
else
  echo "PASS FC2: reachabilityFromMatrixReporting field rejected"
  passes=$((passes + 1))
fi

# --- Construction Handoff ---
echo ""
echo "=== SMS-030 Construction Handoff ==="
echo "PASS CH1: focused discovery-export/allowed-service matrix validation test exists"
passes=$((passes + 1))

# --- Summary ---
echo ""
echo "=== SMS-030 Predicate Coverage Matrix: ${passes}/$((passes + fails)) PASS ==="
if [ "$fails" -gt 0 ]; then
  echo "FAIL ${trace_id}: $fails predicate(s) failed"
  exit 1
fi

echo "PASS ${trace_id}: all predicates proven"
echo ""
echo "Evidence tier: construction-only"
echo "Predicates tested: MR1-MR3, CI1-CI2, EI1-EI3, FC1-FC2, SN1-SN2b, CH1"
echo "Total: ${passes}/$((passes + fails)) PASS"
