#!/usr/bin/env bash
# GAMP-IDS: FS-770-HDS-010-SDS-020-SMS-040
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hat_dir="${repo_root}/HAT/emulated-isp-residential-testnet"
cpm_flake="${CPM_FLAKE:-github:esp0xdeadbeef/network-control-plane-model}"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL fs770-realization-mutation-rejection: $*" >&2
  exit 1
}

build_cpm() {
  local inventory_name="$1"
  local output_json="$2"

  nix run "${cpm_flake}#compile-and-build-control-plane-model" -- \
    "${hat_dir}/intent.nix" \
    "${inventory_name}" \
    "${output_json}" >/dev/null
}

build_cpm "${hat_dir}/inventory-nixos.nix" "${tmp_dir}/nixos.json"

jq -S '
  .control_plane_model.data.esp0xdeadbeef."site-a"
  | {
      communicationContract,
      forwardingIntent,
      trafficPaths,
      runtimeTargetNames: (.runtimeTargets | keys | sort)
    }
' "${tmp_dir}/nixos.json" > "${tmp_dir}/nixos-model-surface.json"

cat > "${tmp_dir}/inventory-nixos-no-endpoint-fixtures.nix" <<EOF
let
  base = import ${hat_dir}/inventory-nixos.nix;
  hosts = base.deployment.hosts;
  clientHost = hosts.s-router-test-clients;
in
base // {
  deployment = base.deployment // {
    hosts = hosts // {
      s-router-test-clients = clientHost // {
        hat = (clientHost.hat or { }) // {
          endpointClients = { };
        };
      };
    };
  };
}
EOF

build_cpm "${tmp_dir}/inventory-nixos-no-endpoint-fixtures.nix" "${tmp_dir}/nixos-no-endpoints.json"

jq -S '
  .control_plane_model.data.esp0xdeadbeef."site-a"
  | {
      communicationContract,
      forwardingIntent,
      trafficPaths,
      runtimeTargetNames: (.runtimeTargets | keys | sort)
    }
' "${tmp_dir}/nixos-no-endpoints.json" > "${tmp_dir}/nixos-no-endpoints-model-surface.json"

cmp -s "${tmp_dir}/nixos-model-surface.json" "${tmp_dir}/nixos-no-endpoints-model-surface.json" \
  || fail "inventory-side endpoint fixtures changed modeled behavior authority"

cat > "${tmp_dir}/inventory-clab-missing-port.nix" <<EOF
let
  base = import ${hat_dir}/inventory-clab.nix;
  nodeName = "esp0xdeadbeef-site-b-clab-core-testnet-host-isp";
  node = base.realization.nodes.\${nodeName};
in
base // {
  realization = base.realization // {
    nodes = base.realization.nodes // {
      \${nodeName} = node // {
        ports = builtins.removeAttrs node.ports [ "testnet-host-isp" ];
      };
    };
  };
}
EOF

if build_cpm "${tmp_dir}/inventory-clab-missing-port.nix" "${tmp_dir}/bad.json" >"${tmp_dir}/bad.out" 2>"${tmp_dir}/bad.err"; then
  fail "missing CLAB realization port was accepted"
fi

if ! rg -q 'inventory|realization|testnet-host-isp|requires explicit' "${tmp_dir}/bad.err" "${tmp_dir}/bad.out"; then
  fail "missing CLAB realization failure did not name the owning realization surface"
fi

echo "PASS fs770-realization-mutation-rejection"
