#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/GAMP/SAT"

nix-instantiate --eval --strict --json --expr "
let
  intent = import ${lab_dir}/intent.nix;
  sites = intent.esp;
  relationById = site: id:
    let matches = builtins.filter (rel: (rel.id or null) == id) site.communicationContract.relations;
    in if matches == [] then null else builtins.head matches;
  memberSet = rel: rel.from.members or [];
  hasDmzBroadExternalAllow = site:
    builtins.any
      (rel:
        (rel.action or null) == \"allow\"
        && (rel.trafficType or null) == \"any\"
        && (rel.from.kind or null) == \"tenant-set\"
        && builtins.elem \"dmz\" (rel.from.members or [])
        && (
          (rel.to.kind or null) == \"external\"
          || rel.to == \"any\"
        ))
      site.communicationContract.relations;
in {
  nixosUserWanMembers = memberSet (relationById sites.nixos \"allow-user-tenants-to-uplinks\");
  hetzClientWanMembers = memberSet (relationById sites.hetz \"allow-hetz-client-to-wan\");
  clabUserWanMembers = memberSet (relationById sites.clab \"allow-normal-tenants-to-wan\");
  dmzBroadExternalAllow = {
    nixos = hasDmzBroadExternalAllow sites.nixos;
    hetz = hasDmzBroadExternalAllow sites.hetz;
    clab = hasDmzBroadExternalAllow sites.clab;
  };
}
" | jq -e '
  .dmzBroadExternalAllow == { nixos: false, hetz: false, clab: false }
  and (.nixosUserWanMembers | sort == ["admin", "client", "streaming"])
  and (.hetzClientWanMembers | sort == ["client"])
  and (.clabUserWanMembers | sort == ["admin", "client", "streaming"])
' >/dev/null || {
  echo "FAIL lab-sigma-public-egress-intent: DMZ must not have broad internet egress, while client/user tenants keep modeled WAN egress" >&2
  exit 1
}

echo "PASS lab-sigma-public-egress-intent"
