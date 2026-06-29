#!/usr/bin/env bash
# GAMP-ID: FS-820-HDS-010-SDS-010-SMS-050
# GAMP-SCOPE: active HAT SOPS routing construction check
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
secret_file="${repo_root}/active-lab/secrets/sops-s-router-nixos.yaml"

fail() {
  echo "FAIL hat-sops-runtime-fact-bindings: $*" >&2
  exit 1
}

required_runtime_secrets=(
  access-node-ipv6-prefix-esp0xdeadbeef-hetz-c-router-access-client
  access-node-ipv6-prefix-esp-clab-router-access-client
  access-node-ipv6-prefix-esp-clab-router-access-hostile
  access-node-ipv6-prefix-esp-hetz-router-access-client
  access-node-ipv6-prefix-esp-nixos-router-access-hostile
  access-node-ipv6-prefix-espbranch-clab-b-router-access-hostile
  hetzner-lighthouse-public-ipv4
  hetzner-public-ipv4
  hetzner-public-ipv6
)

[[ -f "${secret_file}" ]] || fail "missing ${secret_file}"
for secret_name in "${required_runtime_secrets[@]}"; do
  rg -q "^${secret_name}:" "${secret_file}" \
    || fail "active-lab NixOS SOPS file is missing ${secret_name}"
done

nix eval --impure --expr "
  let
    repo = ${repo_root};
    routing = import (repo + \"/GAMP/HAT/emulated-isp-residential-testnet/sops-routing-s-router-nixos.nix\");
    base = import (repo + \"/GAMP/HAT/sops.nix\") {
      sopsFile = repo + \"/active-lab/secrets/sops-s-router-clab.yaml\";
    };
    required = [
      \"access-node-ipv6-prefix-esp0xdeadbeef-hetz-c-router-access-client\"
      \"access-node-ipv6-prefix-esp-clab-router-access-client\"
      \"access-node-ipv6-prefix-esp-clab-router-access-hostile\"
      \"access-node-ipv6-prefix-esp-hetz-router-access-client\"
      \"access-node-ipv6-prefix-esp-nixos-router-access-hostile\"
      \"access-node-ipv6-prefix-espbranch-clab-b-router-access-hostile\"
      \"hetzner-lighthouse-public-ipv4\"
      \"hetzner-public-ipv4\"
      \"hetzner-public-ipv6\"
    ];
    require = cond: msg: if cond then true else throw msg;
    secretOk = module: name:
      builtins.hasAttr name module.sops.secrets
      && module.sops.secrets.\${name}.key == name
      && module.sops.secrets.\${name}.mode == \"0400\"
      && builtins.match \".*active-lab/secrets/sops-s-router-nixos.yaml\" (toString module.sops.secrets.\${name}.sopsFile) != null;
  in
    require (builtins.all (secretOk routing) required)
      \"NixOS HAT SOPS routing must expose every runtime fact secret used by rendered /run/secrets bind mounts\"
    && require (!(builtins.hasAttr \"access-node-ipv6-prefix-esp-nixos-router-access-hostile\" base.sops.secrets))
      \"shared HAT SOPS module must not declare host-specific runtime fact secrets unless the routing shim passes them\"
" >/dev/null || fail "NixOS HAT runtime fact SOPS declarations are incomplete"

echo "PASS hat-sops-runtime-fact-bindings"
