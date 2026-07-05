#!/usr/bin/env bash
set -euo pipefail

trace="FS-030-HDS-010-SDS-050-SMS-010"
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
  require = cond: msg: if cond then true else throw msg;
in
  require (builtins.elem (trace + \"__mini-verify\") relationIds)
    \"missing full trace mini verify relation\"
  && require (nodeRoles.client-edge == \"access\")
    \"client-edge must stay access\"
  && require (nodeRoles.downstream-selector == \"downstream-selector\")
    \"downstream-selector role mismatch\"
  && require (nodeRoles.policy == \"policy\")
    \"policy role mismatch\"
  && require (nodeRoles.upstream-selector == \"upstream-selector\")
    \"upstream-selector role mismatch\"
  && require (nodeRoles.core-vlan4-client-dhcp-slaac == \"core\")
    \"core-vlan4-client-dhcp-slaac must stay core\"
  && require (nixos.meta.traceId == trace && nixos.meta.renderer == \"nixos\")
    \"nixos inventory metadata mismatch\"
  && require (clab.meta.traceId == trace && clab.meta.renderer == \"clab\")
    \"clab inventory metadata mismatch\"
  && require (testClients.meta.traceId == trace && testClients.meta.renderer == \"test-clients\")
    \"test-clients inventory metadata mismatch\"
" >/dev/null

echo "PASS ${trace} network-labs row source contract"
