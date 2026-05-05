#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
labs_dir="${repo_root}/labs"

if [[ ! -d "${labs_dir}" ]]; then
  echo "PASS lab-runtime-secret-boundary (no labs/ directory yet)"
  exit 0
fi

suspicious_file="$(mktemp)"
candidate_file="$(mktemp)"
trap 'rm -f "${suspicious_file}" "${candidate_file}"' EXIT

rg -n \
  '([0-9]{1,3}\.){3}[0-9]{1,3}|20[0-9a-fA-F]{2}:|2[0-9a-fA-F]{3}:|([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}|unsafeRoutes|ip route|ip rule|iptables|ip6tables|nft |brctl|ip link add.*bridge|macvlan' \
  "${labs_dir}" \
  --glob '*.nix' \
  --glob '*.sh' \
  --glob '*.json' \
  --glob '!*.sops.yaml' \
  >"${candidate_file}" || true

ipv4_allowed() {
  local ip="$1"
  local a b c d
  IFS=. read -r a b c d <<<"${ip}"

  [[ "${a}" =~ ^[0-9]+$ && "${b}" =~ ^[0-9]+$ && "${c}" =~ ^[0-9]+$ && "${d}" =~ ^[0-9]+$ ]] || return 1
  (( a <= 255 && b <= 255 && c <= 255 && d <= 255 )) || return 1

  (( a == 10 )) && return 0
  (( a == 172 && b >= 16 && b <= 31 )) && return 0
  (( a == 192 && b == 168 )) && return 0
  (( a == 100 && b >= 64 && b <= 127 )) && return 0
  (( a == 127 )) && return 0
  (( a == 0 && b == 0 && c == 0 && d == 0 )) && return 0
  (( a == 169 && b == 254 )) && return 0
  (( a == 192 && b == 0 && c == 2 )) && return 0
  (( a == 198 && b == 51 && c == 100 )) && return 0
  (( a == 203 && b == 0 && c == 113 )) && return 0
  return 1
}

line_has_public_ipv4() {
  local line="$1"
  local ip

  while IFS= read -r ip; do
    [[ -z "${ip}" ]] && continue
    if ! ipv4_allowed "${ip}"; then
      return 0
    fi
  done < <(grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' <<<"${line}" || true)

  return 1
}

line_has_public_ipv6() {
  local line="$1"

  # ULA, link-local, multicast, loopback/unspecified, and RFC 3849 documentation
  # prefixes are allowed in reusable lab files. Other 2xxx/3xxx global unicast
  # addresses are deployment facts and must be SOPS/runtime injected.
  grep -Eiq '(^|[^0-9a-f])(2[0-9a-f]{3}|3[0-9a-f]{3}):' <<<"${line}" || return 1
  grep -Eiq '(^|[^0-9a-f])2001:0?db8:' <<<"${line}" && return 1
  return 0
}

line_has_runtime_glue() {
  local line="$1"

  grep -Eq 'unsafeRoutes|ip route|ip rule|iptables|ip6tables|nft |brctl|ip link add.*bridge|macvlan' <<<"${line}"
}

line_is_public_dns_forwarder_declaration() {
  local line="$1"

  grep -Eq 'publicDnsForwarders = \[ "1\.1\.1\.1" "9\.9\.9\.9" "2606:4700:4700::1111" "2620:fe::fe" \];' <<<"${line}"
}

while IFS= read -r line; do
  [[ -z "${line}" ]] && continue
  content="${line#*:}"
  content="${content#*:}"
  if line_is_public_dns_forwarder_declaration "${content}"; then
    continue
  fi
  if line_has_runtime_glue "${content}" || line_has_public_ipv4 "${content}" || line_has_public_ipv6 "${content}"; then
    printf '%s\n' "${line}" >>"${suspicious_file}"
  fi
done <"${candidate_file}"

if [[ -s "${suspicious_file}" ]]; then
  cat >&2 <<'EOF'
FATAL network-labs lab runtime secret boundary failed.

Regression this prevents:
  Real public IPv4/GUA IPv6 values, deployment MACs, overlay client addresses,
  overlay unsafe route policy, and local route/firewall/bridge glue leaked into
  prod-like lab files.

Rule:
  Plain lab files may describe intent and non-secret inventory bindings.
  Real deployment facts must be referenced by secret/runtime keys and supplied by
  getInventorySops/getResolvedInventory. Overlay unsafe route policy must come
  from CPM/model route contracts. Raw route/firewall/bridge/macvlan commands do
  not belong in network-labs lab files.

Allowed:
  - RFC documentation ranges
  - RFC1918, CGNAT, link-local, and ULA ranges
  - encrypted *.sops.yaml files
  - secret names/paths such as access-node-ipv6-prefix-...

Fix location:
  Move real values to SOPS/runtime inventory and keep topology/policy in the
  model pipeline. Do not hide these values in local NixOS modules or scripts.

Current suspicious lines:
EOF
  cat "${suspicious_file}" >&2
  exit 1
fi

echo "PASS lab-runtime-secret-boundary"
