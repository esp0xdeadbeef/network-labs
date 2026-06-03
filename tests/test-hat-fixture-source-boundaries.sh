#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hat_dir="${repo_root}/HAT/emulated-isp-residential-testnet"
cpm_flake="${CPM_FLAKE:-github:esp0xdeadbeef/network-control-plane-model}"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL hat-fixture-source-boundaries: $*" >&2
  exit 1
}

require_file() {
  local path="$1"
  [[ -f "${path}" ]] || fail "missing required file: ${path}"
}

for required in intent.nix inventory-clab.nix inventory-nixos.nix; do
  require_file "${hat_dir}/${required}"
done

HAT_DIR="${hat_dir}" nix eval --impure --expr '
  let
    root = builtins.getEnv "HAT_DIR";
    intent = import (root + "/intent.nix");
    clab = import (root + "/inventory-clab.nix");
    nixos = import (root + "/inventory-nixos.nix");
    site = intent.esp0xdeadbeef.site-a;
    clabHost = clab.deployment.hosts.s-router-clab;
    nixosHost = nixos.deployment.hosts.lab-host;
    clientHost = nixos.deployment.hosts.s-router-test-clients;
    require = cond: msg: if cond then true else throw msg;
    hasRelation = id:
      builtins.any (relation: (relation.id or null) == id)
        site.communicationContract.relations;
    trafficTypes = builtins.listToAttrs (
      map (trafficType: { name = trafficType.name; value = trafficType; })
        (site.communicationContract.trafficTypes or [ ])
    );
    services = builtins.listToAttrs (
      map (service: { name = service.name; value = service; })
        (site.communicationContract.services or [ ])
    );
    hasEndpointFixture = name:
      builtins.hasAttr name (clientHost.hat.endpointClients or { });
    endpointServiceSurface = endpoint: surface:
      ((clientHost.hat.endpointClients.${endpoint} or { }).serviceSurfaces or { }).${surface} or null;
    trafficTypeHasPort = name: proto: port:
      builtins.any
        (match: (match.proto or null) == proto && builtins.elem port (match.dports or [ ]))
        (trafficTypes.${name}.match or [ ]);
    hasInventoryOnlyToken = text:
      let encoded = builtins.toJSON intent;
      in builtins.match (".*" + text + ".*") encoded != null;
  in
    require (hasRelation "allow-client-to-testnet-routed-isp")
      "shared intent must own client-to-routed-ISP behavior"
    && require (hasRelation "allow-client-to-testnet-host-isp")
      "shared intent must own client-to-host-ISP behavior"
    && require (!(hasInventoryOnlyToken "endpointClients"))
      "intent must not carry HAT endpoint fixture records"
    && require (!(hasInventoryOnlyToken "bridgeNetworks"))
      "intent must not carry host bridge realization records"
    && require (!(hasInventoryOnlyToken "accessConcentrator"))
      "intent must not carry PPPoE access-concentrator implementation"
    && require (!(hasInventoryOnlyToken "usernameFile"))
      "intent must not carry PPP credential source references"
    && require (trafficTypeHasPort "ipp" "tcp" 631)
      "shared intent must model IPP printer traffic"
    && require (trafficTypeHasPort "printer-admin" "tcp" 80)
      "shared intent must model printer administration traffic"
    && require (trafficTypeHasPort "cast-control" "tcp" 8008 && trafficTypeHasPort "cast-control" "tcp" 8009)
      "shared intent must model receiver controller traffic"
    && require (trafficTypeHasPort "cast-discovery" "udp" 5353 && trafficTypeHasPort "cast-discovery" "udp" 1900)
      "shared intent must model receiver discovery traffic"
    && require ((services.hat-printer-ipp.providers or [ ]) == [ "nixos-printer01" ])
      "shared intent must bind printer IPP service to modeled printer provider"
    && require ((services.hat-printer-admin.providers or [ ]) == [ "nixos-printer01" ])
      "shared intent must bind printer admin service to modeled printer provider"
    && require ((services.hat-receiver-control.providers or [ ]) == [ "nixos-receiver01" ])
      "shared intent must bind receiver control service to modeled receiver provider"
    && require ((services.hat-receiver-discovery.providers or [ ]) == [ "nixos-receiver01" ])
      "shared intent must bind receiver discovery service to modeled receiver provider"
    && require (clabHost.hat.upstreamEmulation.residentialPppoeHostTestnet.harness == "s-router-clab")
      "CLAB inventory must bind PPPoE HAT realization to s-router-clab"
    && require (nixosHost.hat.upstreamEmulation.residentialPppoeHostTestnet.harness == "s-router-nixos")
      "NixOS inventory must bind PPPoE HAT realization to s-router-nixos"
    && require (clabHost.hat.upstreamEmulation.residentialPppoeHostTestnet.l2Surface.name != nixosHost.hat.upstreamEmulation.residentialPppoeHostTestnet.l2Surface.name)
      "CLAB and NixOS HAT inventories must use separate PPPoE handoff surfaces"
    && require (hasEndpointFixture "clab-client01" && hasEndpointFixture "nixos-client01")
      "endpoint fixtures must live in inventory HAT substrate, not shared intent"
    && require (hasEndpointFixture "nixos-printer01" && hasEndpointFixture "nixos-receiver01")
      "shared-service endpoint fixtures must live in inventory HAT substrate"
    && require ((endpointServiceSurface "nixos-printer01" "ipp").service == "hat-printer-ipp")
      "printer IPP fixture surface must bind to modeled service"
    && require ((endpointServiceSurface "nixos-printer01" "admin").service == "hat-printer-admin")
      "printer admin fixture surface must bind to modeled service"
    && require ((endpointServiceSurface "nixos-receiver01" "control").service == "hat-receiver-control")
      "receiver control fixture surface must bind to modeled service"
    && require ((endpointServiceSurface "nixos-receiver01" "discovery").service == "hat-receiver-discovery")
      "receiver discovery fixture surface must bind to modeled service"
' >/dev/null

build_cpm() {
  local inventory_name="$1"
  local output_json="$2"
  nix run "${cpm_flake}#compile-and-build-control-plane-model" -- \
    "${hat_dir}/intent.nix" \
    "${hat_dir}/${inventory_name}" \
    "${output_json}" >/dev/null
}

build_cpm inventory-clab.nix "${tmp_dir}/clab.json"
build_cpm inventory-nixos.nix "${tmp_dir}/nixos.json"

jq -S '
  .control_plane_model.data.esp0xdeadbeef."site-a"
  | {
      trafficPaths,
      forwardingIntent,
      runtimeTargetNames: (.runtimeTargets | keys | sort)
    }
' "${tmp_dir}/clab.json" > "${tmp_dir}/clab-model-surface.json"

jq -S '
  .control_plane_model.data.esp0xdeadbeef."site-a"
  | {
      trafficPaths,
      forwardingIntent,
      runtimeTargetNames: (.runtimeTargets | keys | sort)
    }
' "${tmp_dir}/nixos.json" > "${tmp_dir}/nixos-model-surface.json"

cmp -s "${tmp_dir}/clab-model-surface.json" "${tmp_dir}/nixos-model-surface.json" \
  || fail "CLAB and NixOS inventories changed shared behavior surface"

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

nix run "${cpm_flake}#compile-and-build-control-plane-model" -- \
  "${hat_dir}/intent.nix" \
  "${tmp_dir}/inventory-nixos-no-endpoint-fixtures.nix" \
  "${tmp_dir}/nixos-no-endpoints.json" >/dev/null

jq -S '
  .control_plane_model.data.esp0xdeadbeef."site-a"
  | {
      trafficPaths,
      forwardingIntent,
      runtimeTargetNames: (.runtimeTargets | keys | sort)
    }
' "${tmp_dir}/nixos-no-endpoints.json" > "${tmp_dir}/nixos-no-endpoints-model-surface.json"

cmp -s "${tmp_dir}/nixos-model-surface.json" "${tmp_dir}/nixos-no-endpoints-model-surface.json" \
  || fail "endpoint fixture presence changed CPM behavior authority"

cat > "${tmp_dir}/inventory-clab-missing-port.nix" <<EOF
let
  base = import ${hat_dir}/inventory-clab.nix;
  nodeName = "esp0xdeadbeef-site-a-s-router-core-testnet-host-isp";
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

if nix run "${cpm_flake}#compile-and-build-control-plane-model" -- \
  "${hat_dir}/intent.nix" \
  "${tmp_dir}/inventory-clab-missing-port.nix" \
  "${tmp_dir}/bad.json" >"${tmp_dir}/bad.out" 2>"${tmp_dir}/bad.err"; then
  fail "missing CLAB realization port was accepted"
fi

if ! rg -q 'inventory|realization|testnet-host-isp|requires explicit' "${tmp_dir}/bad.err" "${tmp_dir}/bad.out"; then
  fail "missing CLAB realization failure did not name inventory/realization surface"
fi

echo "PASS hat-fixture-source-boundaries"
