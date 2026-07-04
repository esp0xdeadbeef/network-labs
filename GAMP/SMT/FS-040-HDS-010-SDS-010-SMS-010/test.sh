#!/usr/bin/env bash
set -euo pipefail

trace="FS-040-HDS-010-SDS-010-SMS-010"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
row_dir="${repo_root}/GAMP/SMT/${trace}"

nix eval --impure --expr "
let
  trace = \"${trace}\";
  rowDir = \"${row_dir}\";
  intent = import (rowDir + \"/intent.nix\");
  nixos = import (rowDir + \"/inventory-nixos.nix\");
  clab = import (rowDir + \"/inventory-clab.nix\");
  testClients = import (rowDir + \"/inventory-test-clients.nix\");
  mini = intent.\"mini-smt\".\${trace};
  relationIds = map (relation: relation.id) mini.communicationContract.relations;
  nodeRoles = builtins.mapAttrs (_: node: node.role) mini.topology.nodes;
  bridges = nixos.deploymentHosts.s-router-nixos.bridgeNetworks;
  require = cond: msg: if cond then true else throw msg;
in
  require (builtins.elem (trace + \"__mini-verify\") relationIds)
    \"missing full trace mini verify relation\"
  && require (mini.communicationContract.services == [])
    \"public inventory boundary source must not add DNS or service behavior\"
  && require (mini.ownership.prefixes == [{
    kind = \"tenant\";
    name = \"client\";
    ipv4 = \"10.0.40.0/24\";
    ipv6 = \"fd42:0028:50::/64\";
  }])
    \"tenant ownership prefix mismatch\"
  && require (nodeRoles.client-edge == \"access\")
    \"client-edge must stay access\"
  && require (nodeRoles.downstream-selector == \"downstream-selector\")
    \"downstream-selector role mismatch\"
  && require (nodeRoles.policy == \"policy\")
    \"policy role mismatch\"
  && require (nodeRoles.upstream-selector == \"upstream-selector\")
    \"upstream-selector role mismatch\"
  && require (nodeRoles.testnet-edge == \"core\")
    \"testnet-edge must stay core\"
  && require (nixos.meta.traceId == trace && clab.meta.traceId == trace && testClients.meta.traceId == trace)
    \"inventory trace metadata mismatch\"
  && require (bridges ? admin && bridges ? branch && bridges ? client)
    \"nixos inventory must keep admin, branch, and client bridge networks\"
" >/dev/null

echo "PASS ${trace} network-labs row source contract"
