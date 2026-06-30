#!/usr/bin/env bash
# GAMP-ID: FS-166-HDS-010-SDS-010-SMS-901
# GAMP-SCOPE: active-lab runtime entry marker; not HAT/SAT approval evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
trace_id="FS-166-HDS-010-SDS-010-SMS-901"
original_id="allow-client-to-testnet-host-isp"

fail() {
  echo "FAIL active-lab-emulated-sms-trace: $*" >&2
  exit 1
}

nix eval --impure --expr "
  let
    current = import ${repo_root}/current-lab;
    intent = import ${repo_root}/active-lab/intent.nix;
    clients = import ${repo_root}/active-lab/clients.nix;
    inventoryNixos = import ${repo_root}/active-lab/inventory-nixos.nix;
    inventoryClab = import ${repo_root}/active-lab/inventory-clab.nix;
    require = cond: msg: if cond then true else throw msg;
    sorted = builtins.sort (a: b: a < b);
    requiredNixosClients = [
      \"nixos-branch-node01\"
      \"nixos-client01\"
      \"nixos-client02\"
      \"nixos-emulated-sigma\"
      \"nixos-printer01\"
      \"nixos-receiver01\"
      \"nixos-streaming-test\"
    ];
    requiredClabClients = [
      \"clab-client01\"
      \"clab-client02\"
      \"clab-emulated-sigma\"
    ];
    collectIds =
      value:
      if builtins.isAttrs value then
        (if value ? id then [ value.id ] else [ ])
        ++ (if value ? traceId then [ value.traceId ] else [ ])
        ++ builtins.concatLists (map collectIds (builtins.attrValues value))
      else if builtins.isList value then
        builtins.concatLists (map collectIds value)
      else
        [ ];
    ids = collectIds intent;
    count = needle:
      builtins.length (builtins.filter (value: value == needle) ids);
    miniTraceOk =
      count \"${trace_id}\" >= 1
      && count \"${original_id}\" == 0;
    hatSelectionOk =
      current.selection.layer == \"HAT\"
      && current.selection.selector == \"emulated-isp-residential-testnet\"
      && current.selection.sourceRoot == \"GAMP/HAT/emulated-isp-residential-testnet\"
      && clients.activeLabClientStub.kind == \"hat-client-source\"
      && sorted clients.requiredEndpointClients == requiredNixosClients
      && sorted (builtins.attrNames clients.clients) == requiredNixosClients
      && inventoryNixos.deployment.hosts ? s-router-test-clients
      && sorted inventoryNixos.deployment.hosts.s-router-test-clients.hat.requiredEndpointClients == requiredNixosClients
      && inventoryClab.deployment.hosts ? s-router-clab
      && sorted inventoryClab.deployment.hosts.s-router-clab.hat.requiredEndpointClients == requiredClabClients;
    satSelectionOk =
      current.selection.layer == \"SAT\"
      && current.selection.sourceRoot == \"GAMP/SAT\";
  in
    if current.selection.layer == \"HAT\" then
      require hatSelectionOk
        \"HAT active-lab selection must expose the selected HAT clients and inventories\"
    else if current.selection.layer == \"SAT\" then
      require satSelectionOk
        \"SAT active-lab selection must expose the selected SAT source root\"
    else
      require miniTraceOk
        \"active-lab intent must expose the emulated FS/HDS/SDS/SMS trace ID without the original relation ID\"
" >/dev/null || fail "active-lab intent did not expose ${trace_id}"

echo "PASS active-lab-emulated-sms-trace"
