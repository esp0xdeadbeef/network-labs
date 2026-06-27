#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-010-SDS-012-SMS-010
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/network-labs-fs800-sds012.XXXXXX")"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL FS-800-HDS-010-SDS-012-SMS-010: $*" >&2
  exit 1
}

authority_filter='
  def route_source: (.route.derivedFrom.source? // "");
  def missing_or_empty($path): ((try getpath($path) catch null) == null or (try getpath($path) catch "") == "");
  if (route_source == "vlan" or route_source == "interface" or route_source == "fixture-name")
     and missing_or_empty(["routeAuthority"])
  then error("diagnostic.inferred-authority behavior=route inferredSource=\(route_source) missingExplicitAuthority=routeAuthority")
  elif (.providerFlags.enableDnsMasq? // false) == true
     and missing_or_empty(["dns", "resolver"])
  then error("diagnostic.side-channel-provider-authority behavior=dns inferredSource=providerFlags.enableDnsMasq missingExplicitAuthority=dns.resolver")
  elif (.providerFlags.enableNat? // false) == true
     and missing_or_empty(["nat", "source"])
     and missing_or_empty(["snat", "source"])
  then error("diagnostic.missing-provider-authority-source behavior=nat inferredSource=providerFlags.enableNat missingExplicitAuthority=nat.source-or-snat.source")
  else {
    accepted: true,
    downstreamEmission: {
      routeAuthority: .routeAuthority,
      dnsResolver: (.dns.resolver // null),
      natSource: (.nat.source // .snat.source // null)
    }
  }
  end
'

validate_profile() {
  local input="$1"
  jq -e "${authority_filter}" "${input}"
}

must_fail_profile() {
  local name="$1"
  local expected="$2"
  local input="$3"

  if validate_profile "${input}" >"${tmp_dir}/${name}.out" 2>"${tmp_dir}/${name}.err"; then
    fail "${name} unexpectedly passed"
  fi
  grep -F "${expected}" "${tmp_dir}/${name}.err" >/dev/null \
    || fail "${name} missing diagnostic ${expected}"
  if [[ -s "${tmp_dir}/${name}.out" ]]; then
    fail "${name} emitted downstream output despite rejection"
  fi
}

nix eval --impure --json --expr "
  let table = import ${repo_root}/GAMP/SAT/provider-access-fixture-table.nix;
  in table.attachments
" | jq -e '
  to_entries
  | all(.[]; .value as $row
      | $row.sourceClass == "provider-access-realization-fact"
        and $row.realizationAuthority == "inventory"
        and $row.sideChannelAuthority == false
        and $row.topologyAuthority == false
        and ([ "addressAuthority", "links", "policy", "policyAuthority",
               "providerAuthority", "routeAuthority", "routes", "sideChannel",
               "topology", "topologyClass", "uplinks", "upstreamEmulation" ]
             | all(. as $field | ($row | has($field) | not))))' >/dev/null \
  || fail "current provider-access attachment table carries authority side-channel fields"

cat >"${tmp_dir}/route-from-vlan.json" <<'JSON'
{
  "name": "pppoeNixos",
  "route": {"derivedFrom": {"source": "vlan", "value": 40}}
}
JSON
must_fail_profile route-from-vlan diagnostic.inferred-authority "${tmp_dir}/route-from-vlan.json"

cat >"${tmp_dir}/dns-from-flag.json" <<'JSON'
{
  "name": "pppoeClab",
  "providerFlags": {"enableDnsMasq": true}
}
JSON
must_fail_profile dns-from-flag diagnostic.side-channel-provider-authority "${tmp_dir}/dns-from-flag.json"

cat >"${tmp_dir}/nat-from-flag.json" <<'JSON'
{
  "name": "dhcpSlaacNixosClient",
  "providerFlags": {"enableNat": true}
}
JSON
must_fail_profile nat-from-flag diagnostic.missing-provider-authority-source "${tmp_dir}/nat-from-flag.json"

cat >"${tmp_dir}/explicit-recovery.json" <<'JSON'
{
  "name": "explicitProviderAccess",
  "routeAuthority": "provider-access-fixture-row",
  "route": {"derivedFrom": {"source": "vlan", "value": 40}},
  "providerFlags": {"enableDnsMasq": true, "enableNat": true},
  "dns": {"resolver": "explicit-follow-source"},
  "snat": {"source": "explicit-provider-access-row"}
}
JSON
validate_profile "${tmp_dir}/explicit-recovery.json" >"${tmp_dir}/explicit-recovery.out"
jq -e '.accepted == true and .downstreamEmission.routeAuthority == "provider-access-fixture-row"' \
  "${tmp_dir}/explicit-recovery.out" >/dev/null \
  || fail "explicit recovery did not emit bounded downstream authority"

echo "PASS FS-800-HDS-010-SDS-012-SMS-010 provider-access non-authority"
