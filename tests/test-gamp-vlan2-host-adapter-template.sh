#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
template="${repo_root}/GAMP/templates/on-prem-vlan2-host-adapter/inventory.nix"

fail() {
  echo "FAIL gamp-vlan2-host-adapter-template: $*" >&2
  exit 1
}

for required_dir in GAMP/SMT GAMP/SIT GAMP/HAT GAMP/SAT GAMP/templates/on-prem-vlan2-host-adapter; do
  [[ -d "${repo_root}/${required_dir}" ]] || fail "missing required directory ${required_dir}"
done

[[ -f "${template}" ]] || fail "missing ${template}"

for doc in GAMP/AGENTS.md GAMP/SMT/README.md GAMP/SIT/README.md GAMP/templates/on-prem-vlan2-host-adapter/README.md; do
  [[ -f "${repo_root}/${doc}" ]] || fail "missing ${doc}"
  grep -Fq "GAMP/templates/on-prem-vlan2-host-adapter/inventory.nix" "${repo_root}/${doc}" \
    || fail "${doc} must reference the VLAN2 host-adapter template"
done

for layer in SMT SIT HAT SAT; do
  if ! rg -q 'vlan2|vlan = 2|eth0\.2|GAMP/templates/on-prem-vlan2-host-adapter/inventory\.nix' "${repo_root}/GAMP/${layer}"; then
    fail "GAMP/${layer} does not carry or reference the VLAN2 host-adapter requirement"
  fi
done

nix eval --impure --expr "
  let
    inv = import ${template};
    host = inv.deployment.hosts.template-on-prem-host;
    uplinks = host.uplinks or { };
    management = uplinks.management or { };
    ipv4 = management.ipv4 or { };
    ipv6 = management.ipv6 or { };
    onlyManagement = builtins.attrNames uplinks == [ \"management\" ];
    bridgeNetworksEmpty = (host.bridgeNetworks or null) == { };
    ok =
      onlyManagement
      && bridgeNetworksEmpty
      && (management.bridge or null) == \"vlan2\"
      && (management.mode or null) == \"vlan\"
      && (management.parent or null) == \"eth0\"
      && (management.vlan or null) == 2
      && (ipv4.enable or false) == true
      && (ipv4.dhcp or false) == true
      && (ipv4.method or null) == \"dhcp\"
      && (ipv6.enable or true) == false
      && (ipv6.acceptRA or true) == false
      && (ipv6.dhcp or true) == false
      && (ipv6.dhcpv6PD or true) == false
      && (ipv6.method or null) == \"none\";
  in
    if ok then \"ok\" else throw \"GAMP VLAN2 host-adapter template is not the minimal eth0 VLAN 2 DHCP management uplink\"
" >/dev/null || fail "template did not evaluate to the required VLAN2-only host adapter"

echo "PASS gamp-vlan2-host-adapter-template"
