#!/usr/bin/env bash
# GAMP-ID: FS-166-HDS-010-SDS-010-SMS-901
# GAMP-SCOPE: active-lab runtime entry marker; not HAT/SAT approval evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
trace_id="FS-166-HDS-010-SDS-010-SMS-901"
original_id="allow-client-to-testnet-host-isp"
tmp_root="$(mktemp -d "${repo_root}/.active-lab-emulated-sms-trace.XXXXXX")"
trap 'rm -rf "${tmp_root}"' EXIT
ln -s "${repo_root}/GAMP" "${tmp_root}/GAMP"
ln -s "${repo_root}/tests" "${tmp_root}/tests"

fail() {
  echo "FAIL active-lab-emulated-sms-trace: $*" >&2
  exit 1
}

select_into() {
  local name="$1"
  shift
  local current_dir="${tmp_root}/${name}"
  NETWORK_LABS_CURRENT_LAB_DIR="${current_dir}" \
    "${repo_root}/scripts/select-current-lab.sh" "$@" >/dev/null
  printf '%s\n' "${current_dir}"
}

default_current="$(select_into default default)"
hat_current="$(select_into hat HAT emulated-isp-residential-testnet)"
sat_current="$(select_into sat SAT)"

nix eval --impure --expr "
  let
    defaultSelection = import ${default_current}/metadata.nix;
    defaultIntent = import ${default_current}/intent.nix;
    hatSelection = import ${hat_current}/metadata.nix;
    hatClients = import ${hat_current}/clients.nix;
    hatInventoryNixos = import ${hat_current}/inventory-nixos.nix;
    hatInventoryClab = import ${hat_current}/inventory-clab.nix;
    satSelection = import ${sat_current}/metadata.nix;
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
    ids = collectIds defaultIntent;
    count = needle:
      builtins.length (builtins.filter (value: value == needle) ids);
    miniTraceOk =
      defaultSelection.layer == \"SMT\"
      && defaultSelection.selector == \"${trace_id}\"
      && count \"${trace_id}\" >= 1
      && count \"${original_id}\" == 0;
    hatSelectionOk =
      hatSelection.layer == \"HAT\"
      && hatSelection.selector == \"emulated-isp-residential-testnet\"
      && hatSelection.sourceRoot == \"GAMP/HAT/emulated-isp-residential-testnet\"
      && hatClients.activeLabClientStub.kind == \"hat-client-source\"
      && sorted hatClients.requiredEndpointClients == requiredNixosClients
      && sorted (builtins.attrNames hatClients.clients) == requiredNixosClients
      && hatInventoryNixos.deployment.hosts ? s-router-test-clients
      && sorted hatInventoryNixos.deployment.hosts.s-router-test-clients.hat.requiredEndpointClients == requiredNixosClients
      && hatInventoryClab.deployment.hosts ? s-router-clab
      && sorted hatInventoryClab.deployment.hosts.s-router-clab.hat.requiredEndpointClients == requiredClabClients;
    satSelectionOk =
      satSelection.layer == \"SAT\"
      && satSelection.sourceRoot == \"GAMP/SAT\";
  in
    require miniTraceOk
      \"default active-lab selection must expose the emulated FS/HDS/SDS/SMS trace ID without the original relation ID\"
    && require hatSelectionOk
      \"HAT active-lab selection must expose the selected HAT clients and inventories\"
    && require satSelectionOk
      \"SAT active-lab selection must expose the selected SAT source root\"
" >/dev/null || fail "active-lab intent did not expose ${trace_id}"

echo "PASS active-lab-emulated-sms-trace"
