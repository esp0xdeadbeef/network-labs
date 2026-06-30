#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
current_dir="${repo_root}/current-lab"
manifest_file="${repo_root}/GAMP/SMT/mini-smt/tests.nix"

usage() {
  cat <<'EOF'
Usage:
  scripts/select-current-lab.sh --list
  scripts/select-current-lab.sh default
  scripts/select-current-lab.sh SMT <mini-smt-id|FS-...-SMS-...>
  scripts/select-current-lab.sh SIT <FS-...-SDS-...>
  scripts/select-current-lab.sh HAT [emulated-isp-residential-testnet]
  scripts/select-current-lab.sh SAT
EOF
}

write_file() {
  local path="$1"
  shift
  local tmp
  mkdir -p "$(dirname "${path}")"
  tmp="$(mktemp "${path}.tmp.XXXXXX")"
  "$@" >"${tmp}"
  mv "${tmp}" "${path}"
}

write_import() {
  local target="$1"
  local source="$2"
  write_file "${current_dir}/${target}" printf 'import %s\n' "${source}"
}

write_current_host_entrypoints() {
  write_import "intent-s-router-nixos.nix" "./intent.nix"
  write_import "intent-s-router-clab.nix" "./intent.nix"
  write_import "intent-s-router-test-clients.nix" "./intent.nix"

  write_import "inventory-s-router-nixos.nix" "./inventory-nixos.nix"
  write_import "inventory-s-router-clab.nix" "./inventory-clab.nix"
  write_import "inventory-s-router-test-clients.nix" "./inventory-test-clients.nix"

  write_import "clients-s-router-test-clients.nix" "./clients.nix"
}

write_empty_sops() {
  local target="$1"
  local host="$2"
  write_file "${current_dir}/${target}" cat <<EOF
{ ... }:

{
  _module.args.activeLabSopsStub = {
    kind = "current-lab-empty-sops-stub";
    hostName = "${host}";
  };
}
EOF
}

write_default_nixos_inventory() {
  write_file "${current_dir}/inventory-nixos.nix" cat <<'EOF'
{
  activeLabInventoryStub = {
    kind = "mini-smt-renderer-input-stub";
    miniSmtId = "renderer-nixos";
    rendererTarget = "nixos";
    entryBoundary = "renderer-input";
    traceId = "FS-166-HDS-010-SDS-010-SMS-900__active-lab-mini-runtime";

    cpmInput = ../GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/runtime-nixos-cpm.nix;
    test = ../tests/test-active-lab-mini-smt-runtime-nixos-renderer-input.sh;
    runner = ../tests/run-active-lab-mini-smt.sh;

    note = "Inventory is provenance for the renderer-nixos SMS-owned mini SMT input. The source fixture carries the on-prem VLAN2 management adapter required by the s-router runtime consumers.";

    runtimeManagement = {
      vlan2 = "management-only";
      testDhcpUplinks = [
        "vlan4"
        "vlan5"
      ];
    };
  };
}
EOF
}

write_default_clab_inventory() {
  write_file "${current_dir}/inventory-clab.nix" cat <<'EOF'
let
  source = ../GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-clab-cpm.nix;
  cpm = import source;
in
{
  activeLabInventoryStub = {
    kind = "runtime-clab-inventory-stub";
    miniSmtId = "renderer-clab";
    rendererTarget = "clab";
    entryBoundary = "renderer-input";
    traceId = "FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-clab";
    inherit source;
    cpmInput = source;
    test = ../tests/test-active-lab-mini-smt-renderer-clab-only.sh;
    runner = ../tests/run-active-lab-mini-smt.sh;
    note = "Inventory is provenance for the renderer-clab SMS-owned mini SMT input. The source fixture carries the on-prem VLAN2 management adapter required by the s-router-clab runtime consumer.";
    runtimeManagement.vlan2 = "management-only";
  };

  deployment = cpm.control_plane_model.deployment;
  deploymentHosts = cpm.deploymentHosts;
}
EOF
}

write_default_hetz_inventory() {
  write_file "${current_dir}/inventory-hetz.nix" cat <<'EOF'
let
  source = ../GAMP/HAT/emulated-isp-residential-testnet/inventory-hetz.nix;
in
(import source)
// {
  activeLabInventoryStub = {
    kind = "runtime-hetz-inventory-stub";
    inherit source;
  };
}
EOF
}

write_default_clients() {
  write_file "${current_dir}/clients.nix" cat <<'EOF'
{
  activeLabClientStub = {
    kind = "runtime-client-source-stub";
    scope = "NixOS access-endpoint renderer input path";
    miniSmtId = "renderer-nixos-clients";
    source = ../GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-access-endpoint-cpm.nix;
    test = ../tests/test-active-lab-mini-smt-renderer-nixos-clients-only.sh;
  };

  clients = { };
}
EOF
}

write_default_inventory_test_clients() {
  write_file "${current_dir}/inventory-test-clients.nix" cat <<'EOF'
let
  managementVlan2 = {
    bridge = "vlan2";
    ipv4 = {
      dhcp = true;
      enable = true;
      method = "dhcp";
    };
    ipv6 = {
      acceptRA = false;
      dhcp = false;
      dhcpv6PD = false;
      enable = false;
      method = "none";
    };
    mode = "vlan";
    parent = "eth0";
    vlan = 2;
  };
in
{
  meta = {
    traceId = "FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-nixos-clients";
    renderer = "test-clients";
    scope = "active-lab-current-selection";
  };
  clients = { };
  deploymentHosts = {
    s-router-test-clients = {
      hat.endpointClients = { };
      uplinks.management = managementVlan2;
    };
  };
}
EOF
}

write_renderer_clients_inventory_test_clients() {
  local source_path="$1"

  write_file "${current_dir}/inventory-test-clients.nix" cat <<EOF
let
  source = import ../${source_path};
  managementVlan2 = {
    bridge = "vlan2";
    ipv4 = {
      dhcp = true;
      enable = true;
      method = "dhcp";
    };
    ipv6 = {
      acceptRA = false;
      dhcp = false;
      dhcpv6PD = false;
      enable = false;
      method = "none";
    };
    mode = "vlan";
    parent = "eth0";
    vlan = 2;
  };
  sourceHosts =
    (source.deploymentHosts or { })
    // (((source.control_plane_model or { }).deployment or { }).hosts or { });
  sourceTestClientHost = sourceHosts.s-router-test-clients or { };
  testClientHost = sourceTestClientHost // {
    uplinks = (sourceTestClientHost.uplinks or { }) // {
      management = managementVlan2;
    };
  };
in
{
  meta = {
    traceId = "FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-nixos-clients";
    renderer = "test-clients";
    scope = "active-lab-current-selection";
  };
  clients = { };
  deploymentHosts = {
    s-router-test-clients = testClientHost;
  };
  deployment.hosts = {
    s-router-test-clients = testClientHost;
  };
}
EOF
}

write_row_inventory_test_clients() {
  local row_dir="$1"

  write_file "${current_dir}/inventory-test-clients.nix" cat <<EOF
let
  source = import ../${row_dir}/inventory-test-clients.nix;
  managementVlan2 = {
    bridge = "vlan2";
    ipv4 = {
      dhcp = true;
      enable = true;
      method = "dhcp";
    };
    ipv6 = {
      acceptRA = false;
      dhcp = false;
      dhcpv6PD = false;
      enable = false;
      method = "none";
    };
    mode = "vlan";
    parent = "eth0";
    vlan = 2;
  };
  deployment = source.deployment or { };
  baseDeploymentHosts = (deployment.hosts or { }) // (source.deploymentHosts or { });
  testClientHost = baseDeploymentHosts.s-router-test-clients or { };
  managedTestClientHost = testClientHost // {
    uplinks = (testClientHost.uplinks or { }) // {
      management = managementVlan2;
    };
  };
  deploymentHosts = baseDeploymentHosts // {
    s-router-test-clients = managedTestClientHost;
  };
in
source // {
  inherit deploymentHosts;
  deployment = deployment // {
    hosts = (deployment.hosts or { }) // deploymentHosts;
  };
  realization = (source.realization or { }) // {
    nodes = ((source.realization or { }).nodes or { });
  };
}
EOF
}

row_test_clients_need_managed_realization() {
  local row_dir="$1"

  nix eval --impure --expr "
let
  source = import ${repo_root}/${row_dir}/inventory-test-clients.nix;
in
  (source.meta.managedRuntimeRealization or false)
" 2>/dev/null | grep -qx true
}

write_row_test_client_entrypoints() {
  local row_dir="$1"
  local forwarding_enterprise_json="${2:-}"

  if [[ -f "${repo_root}/${row_dir}/intent-test-clients.nix" ]]; then
    write_import "intent-s-router-test-clients.nix" "../${row_dir}/intent-test-clients.nix"
  else
    write_file "${current_dir}/intent-s-router-test-clients.nix" cat <<'EOF'
let
  inventory = import ./inventory-test-clients.nix;
  testClientHost = (inventory.deploymentHosts or { }).s-router-test-clients or { };
in
rec {
  control_plane_model = {
    meta = {
      traceId = "active-lab-test-clients-no-endpoints";
      source = "network-labs current-lab SMT/SIT client-host no-endpoint source";
    };
    deployment.hosts.s-router-test-clients = testClientHost // {
      bridgeNetworks = testClientHost.bridgeNetworks or { };
    };
    render.hosts.s-router-test-clients.deploymentHost = "s-router-test-clients";
    realization.nodes = { };
    data.active-lab.test-clients = {
      enterprise = "active-lab";
      siteName = "test-clients";
      runtimeTargets = { };
      endpointAssignment = { };
    };
  };
  deploymentHosts = control_plane_model.deployment.hosts;
  deployment = control_plane_model.deployment;
  realization = control_plane_model.realization;
}
EOF
  fi

  if [[ -n "${forwarding_enterprise_json}" ]] && row_test_clients_need_managed_realization "${row_dir}"; then
    write_smt_inventory_with_management "inventory-test-clients.nix" "../${row_dir}/inventory-test-clients.nix" "../${row_dir}/intent.nix" "${forwarding_enterprise_json}" "s-router-test-clients"
  else
    write_row_inventory_test_clients "${row_dir}"
  fi
  write_import "inventory-s-router-test-clients.nix" "./inventory-test-clients.nix"

  if [[ -f "${repo_root}/${row_dir}/clients.nix" ]]; then
    write_import "clients.nix" "../${row_dir}/clients.nix"
  else
    write_import "clients.nix" "./inventory-test-clients.nix"
  fi
  write_import "clients-s-router-test-clients.nix" "./clients.nix"
}

forwarding_enterprise_json_for_intent() {
  local intent_source="$1"
  local intent_path="${intent_source#../}"
  local nfm_root="${NETWORK_FORWARDING_MODEL_ROOT:-${repo_root}/../network-forwarding-model}"

  [[ -d "${nfm_root}" ]] || {
    echo "network-forwarding-model repo not found: ${nfm_root}" >&2
    return 2
  }

  NETWORK_FORWARDING_MODEL_ROOT="${nfm_root}" nix eval --impure --raw --expr "
let
  nfmRoot = builtins.getEnv \"NETWORK_FORWARDING_MODEL_ROOT\";
  nfm = builtins.getFlake (\"path:\" + nfmRoot);
  system = builtins.currentSystem;
  input = import ${repo_root}/${intent_path};
  fm = nfm.libBySystem.\${system}.buildFromCompilerInputs { inherit input; };
in
  builtins.toJSON fm.enterprise
"
}

write_managed_inventory_content() {
  local source="$1"
  local intent_source="$2"
  local forwarding_enterprise_json="$3"
  local realization_host="$4"
  shift 4

  cat <<EOF
let
  source = import ${source};
  rowIntent = import ${intent_source};
  forwardingEnterprise = builtins.fromJSON ''
${forwarding_enterprise_json}
  '';
  managementVlan2 = {
    bridge = "vlan2";
    ipv4 = {
      dhcp = true;
      enable = true;
      method = "dhcp";
    };
    ipv6 = {
      acceptRA = false;
      dhcp = false;
      dhcpv6PD = false;
      enable = false;
      method = "none";
    };
    mode = "vlan";
    parent = "eth0";
    vlan = 2;
  };
  deployment = source.deployment or { };
  deploymentHosts = (deployment.hosts or { }) // (source.deploymentHosts or { });
  realization = source.realization or { };
  sanitize = value: builtins.replaceStrings [ "." "_" ":" "/" " " ] [ "-" "-" "-" "-" "-" ] value;
  indexedMap = f: values:
    builtins.genList (index: f index (builtins.elemAt values index)) (builtins.length values);
  linksForSite = enterpriseName: siteName:
    (((forwardingEnterprise.\${enterpriseName} or { }).site or { }).\${siteName} or { }).links or { };
  nodeForSite = enterpriseName: siteName: nodeName:
    ((((forwardingEnterprise.\${enterpriseName} or { }).site or { }).\${siteName} or { }).nodes or { }).\${nodeName} or { };
  bridgeForLink = linkName: "br-\${linkName}";
  normalizeUplink = uplinkName: uplink:
    uplink // {
      bridge = uplink.bridge or uplinkName;
    };
  normalizeUplinks = uplinks:
    builtins.mapAttrs normalizeUplink uplinks;
  mergeFamily = generated: existing: familyName:
    let
      generatedFamily = generated.\${familyName} or null;
      existingFamily = existing.\${familyName} or null;
    in
    if builtins.isAttrs generatedFamily || builtins.isAttrs existingFamily then
      {
        \${familyName} =
          (if builtins.isAttrs generatedFamily then generatedFamily else { })
          // (if builtins.isAttrs existingFamily then existingFamily else { });
      }
    else
      { };
  mergeUplink = existingUplinks: uplinkName:
    let
      generated = generatedUplinks.\${uplinkName} or { };
      existing = existingUplinks.\${uplinkName} or { };
    in
    generated
    // existing
    // mergeFamily generated existing "ipv4"
    // mergeFamily generated existing "ipv6";
  mergeUplinks = existingUplinks:
    let
      names = builtins.attrNames (generatedUplinks // existingUplinks // { management = managementVlan2; });
    in
    normalizeUplinks (
      builtins.listToAttrs (
        builtins.map
          (uplinkName: {
            name = uplinkName;
            value =
              if uplinkName == "management" then
                managementVlan2
              else
                mergeUplink existingUplinks uplinkName;
          })
          names
      )
    );
  uplinkNamesForNode = enterpriseName: siteName: nodeName:
    builtins.sort (left: right: left < right) (builtins.attrNames ((nodeForSite enterpriseName siteName nodeName).uplinks or { }));
  linkNamesForNode = enterpriseName: siteName: nodeName:
    let
      links = linksForSite enterpriseName siteName;
    in
    builtins.filter
      (linkName: builtins.hasAttr nodeName (links.\${linkName}.endpoints or { }))
      (builtins.sort (left: right: left < right) (builtins.attrNames links));
  portForLink = enterpriseName: siteName: nodeName: index: linkName:
    let
      endpoint = (linksForSite enterpriseName siteName).\${linkName}.endpoints.\${nodeName};
    in
    {
      name = linkName;
      value = {
        link = linkName;
        adapterName = sanitize "\${linkName}-\${nodeName}";
        attach = {
          kind = "bridge";
          bridge = bridgeForLink linkName;
        };
        interface = {
          name = "p\${toString index}";
        }
        // (if endpoint ? addr4 then { addr4 = endpoint.addr4; } else { })
        // (if endpoint ? addr6 then { addr6 = endpoint.addr6; } else { });
      };
    };
  tenantBridgeFor = enterpriseName: siteName: tenantName:
    "br-\${sanitize enterpriseName}-\${sanitize siteName}-tenant-\${sanitize tenantName}";
  portForTenantInterface = enterpriseName: siteName: nodeName: index: interfaceName:
    let
      iface = (nodeForSite enterpriseName siteName nodeName).interfaces.\${interfaceName};
      tenantName = iface.tenant;
    in
    {
      name = interfaceName;
      value = {
        logicalInterface = interfaceName;
        attach = {
          kind = "bridge";
          bridge = tenantBridgeFor enterpriseName siteName tenantName;
        };
        interface = {
          name = "t\${toString index}";
        };
      };
    };
  portsForNode = enterpriseName: siteName: nodeName:
    let
      linkPorts = builtins.listToAttrs (
        indexedMap
          (index: linkName: portForLink enterpriseName siteName nodeName index linkName)
          (linkNamesForNode enterpriseName siteName nodeName)
      );
      tenantPorts = builtins.listToAttrs (
        indexedMap
          (index: interfaceName: portForTenantInterface enterpriseName siteName nodeName index interfaceName)
          (tenantInterfaceNamesForNode enterpriseName siteName nodeName)
      );
      uplinkPorts = builtins.listToAttrs (
        indexedMap
          (index: uplinkName: {
            name = "uplink-\${uplinkName}";
            value = {
              uplink = uplinkName;
              interface = {
                name = "u\${toString index}";
              };
            };
          })
          (uplinkNamesForNode enterpriseName siteName nodeName)
      );
    in
    linkPorts // tenantPorts // uplinkPorts;
  tenantInterfaceNamesForNode = enterpriseName: siteName: nodeName:
    let
      interfaces = (nodeForSite enterpriseName siteName nodeName).interfaces or { };
    in
    builtins.filter
      (interfaceName: (interfaces.\${interfaceName}.kind or null) == "tenant")
      (builtins.sort (left: right: left < right) (builtins.attrNames interfaces));
  advertisementEntriesForNode = enterpriseName: siteName: nodeName:
    let
      tenantInterfaceNames = tenantInterfaceNamesForNode enterpriseName siteName nodeName;
    in
    {
      dhcp4 = builtins.listToAttrs (
        builtins.map
          (interfaceName: {
            name = interfaceName;
            value = {
              dnsServers = [ "router-self" ];
              domain = "lan.";
            };
          })
          tenantInterfaceNames
      );
      ipv6Ra = builtins.listToAttrs (
        builtins.map
          (interfaceName: {
            name = interfaceName;
            value = {
              dnssl = [ "lan." ];
              rdnss = [ "router-self" ];
            };
          })
          tenantInterfaceNames
      );
    };
  servicesForNode = enterpriseName: siteName: nodeName:
    if tenantInterfaceNamesForNode enterpriseName siteName nodeName == [ ] then
      { }
    else
      {
        dns = { };
      };
  bridgeEntriesForSite = enterpriseName: siteName:
    let
      linkBridgeEntries =
        builtins.map
          (linkName: {
            name = bridgeForLink linkName;
            value = { };
          })
          (builtins.attrNames (linksForSite enterpriseName siteName));
      tenantBridgeEntries =
        builtins.concatMap
          (nodeName:
            builtins.map
              (interfaceName:
                let
                  iface = (nodeForSite enterpriseName siteName nodeName).interfaces.\${interfaceName};
                in
                {
                  name = tenantBridgeFor enterpriseName siteName iface.tenant;
                  value = { };
                })
              (tenantInterfaceNamesForNode enterpriseName siteName nodeName))
          (builtins.attrNames ((((forwardingEnterprise.\${enterpriseName} or { }).site or { }).\${siteName} or { }).nodes or { }));
    in
    linkBridgeEntries ++ tenantBridgeEntries;
  generatedBridgeNetworks =
    builtins.listToAttrs (
      builtins.concatMap
        (enterpriseName:
          builtins.concatMap
            (siteName: bridgeEntriesForSite enterpriseName siteName)
            (builtins.attrNames rowIntent.\${enterpriseName}))
        (builtins.attrNames rowIntent)
    );
  uplinkEntriesForSite = enterpriseName: siteName:
    let
      nodes = (((forwardingEnterprise.\${enterpriseName} or { }).site or { }).\${siteName} or { }).nodes or { };
      names = builtins.concatMap
        (nodeName: uplinkNamesForNode enterpriseName siteName nodeName)
        (builtins.attrNames nodes);
      vlanForUplink = uplinkName:
        if builtins.match ".*vlan4$" uplinkName != null then 4
        else if builtins.match ".*vlan5$" uplinkName != null then 5
        else null;
    in
    builtins.map
      (uplinkName:
        let
          vlan = vlanForUplink uplinkName;
        in
        {
          name = uplinkName;
          value = {
            bridge = uplinkName;
            ipv4 = {
              dhcp = true;
              enable = true;
              method = "dhcp";
            };
            ipv6 = {
              acceptRA = true;
              dhcp = false;
              dhcpv6PD = false;
              enable = true;
              method = "slaac";
            };
            mode = if vlan == null then "dhcp" else "vlan";
            parent = "eth0";
          } // (if vlan == null then { } else { inherit vlan; });
        })
      names;
  generatedUplinks =
    builtins.listToAttrs (
      builtins.concatMap
        (enterpriseName:
          builtins.concatMap
            (siteName: uplinkEntriesForSite enterpriseName siteName)
            (builtins.attrNames rowIntent.\${enterpriseName}))
        (builtins.attrNames rowIntent)
    );
  mkRealizationNode = enterpriseName: siteName: nodeName: {
    name = sanitize "\${enterpriseName}-\${siteName}-\${nodeName}";
    value = {
      host = "${realization_host}";
      logicalNode = {
        enterprise = enterpriseName;
        site = siteName;
        name = nodeName;
      };
      platform = "nixos-container";
      ports = portsForNode enterpriseName siteName nodeName;
      advertisements = advertisementEntriesForNode enterpriseName siteName nodeName;
      services = servicesForNode enterpriseName siteName nodeName;
    };
  };
  nodesForSite = enterpriseName: siteName:
    let
      site = rowIntent.\${enterpriseName}.\${siteName};
      nodes = (site.topology or { }).nodes or { };
    in
    builtins.map (nodeName: mkRealizationNode enterpriseName siteName nodeName) (builtins.attrNames nodes);
  generatedRealizationNodes =
    builtins.listToAttrs (
      builtins.concatMap
        (enterpriseName:
          builtins.concatMap
            (siteName: nodesForSite enterpriseName siteName)
            (builtins.attrNames rowIntent.\${enterpriseName}))
        (builtins.attrNames rowIntent)
    );
  mergeHost = existing:
    existing // {
      uplinks = mergeUplinks (existing.uplinks or { });
      bridgeNetworks = (existing.bridgeNetworks or { }) // generatedBridgeNetworks;
    };
  managedDeploymentHosts = deploymentHosts // {
EOF

  local host
  for host in "${realization_host}" "$@"; do
    printf '    "%s" = mergeHost (deploymentHosts."%s" or { });\n' "${host}" "${host}"
  done

  cat <<'EOF'
  };
  managedDeployment = deployment // {
    hosts = (deployment.hosts or { }) // managedDeploymentHosts;
  };
in
source // {
  deploymentHosts = managedDeploymentHosts;
  deployment = managedDeployment;
  realization = realization // {
    nodes = (realization.nodes or { }) // generatedRealizationNodes;
  };
}
EOF
}

write_smt_inventory_with_management() {
  local target="$1"
  local source="$2"
  local intent_source="$3"
  local forwarding_enterprise_json="$4"
  local realization_host="$5"
  shift 5
  write_file "${current_dir}/${target}" write_managed_inventory_content "${source}" "${intent_source}" "${forwarding_enterprise_json}" "${realization_host}" "$@"
}

write_default_hetz_sops() {
  write_file "${current_dir}/sops-routing-s-router-hetz.nix" cat <<'EOF'
{ ... }:

let
  sharedSopsFile = ../active-lab/secrets/shared.yaml;
in
{
  sops.secrets = {
    "clients/client-01/identity/mac" = {
      sopsFile = sharedSopsFile;
    };

    "clients/client-01/identity/pppoeUsername" = {
      sopsFile = sharedSopsFile;
    };

    "clients/client-01/credentials/pppoePassword" = {
      sopsFile = sharedSopsFile;
    };
  };
}
EOF
}

write_default_sops() {
  write_import "sops.nix" "../GAMP/HAT/emulated-isp-residential-testnet/sops.nix"
  write_import "sops-routing-s-router-clab.nix" "../GAMP/HAT/emulated-isp-residential-testnet/sops-routing-s-router-clab.nix"
  write_empty_sops "sops-routing-s-router-nixos.nix" "s-router-nixos"
  write_import "sops-routing-s-router-test-clients.nix" "../GAMP/HAT/emulated-isp-residential-testnet/sops-routing-s-router-test-clients.nix"
  write_default_hetz_sops
}

write_wireguard_sops_nixos() {
  write_file "${current_dir}/sops-routing-s-router-nixos.nix" cat <<'EOF'
import ../GAMP/HAT/sops.nix {
  sopsFile = ../active-lab/secrets/sops-s-router-nixos.yaml;
  runtimeFactSecrets = [
    "wireguard-mini-provider-private-key"
  ];
}
EOF
}

write_nebula_sops_nixos() {
  write_file "${current_dir}/sops-routing-s-router-nixos.nix" cat <<'EOF'
{ ... }:

let
  sopsFile = ../active-lab/secrets/sops-s-router-nixos.yaml;
  mkProfileSecret = nodeName: fileName: {
    inherit sopsFile;
    owner = "root";
    mode = "0400";
    path = "/persist/nebula-runtime/profiles/${nodeName}/${fileName}";
  };
in
{
  sops.secrets = {
    "nebula-profile-lab-lighthouse-ca-crt" = mkProfileSecret "lab-lighthouse" "ca.crt";
    "nebula-profile-lab-lighthouse-crt" = mkProfileSecret "lab-lighthouse" "lab-lighthouse.crt";
    "nebula-profile-lab-lighthouse-key" = mkProfileSecret "lab-lighthouse" "lab-lighthouse.key";
    "nebula-profile-lab-client-nebula-ca-crt" = mkProfileSecret "lab-client-nebula" "ca.crt";
    "nebula-profile-lab-client-nebula-crt" = mkProfileSecret "lab-client-nebula" "lab-client-nebula.crt";
    "nebula-profile-lab-client-nebula-key" = mkProfileSecret "lab-client-nebula" "lab-client-nebula.key";
  };
}
EOF
}

write_metadata() {
  local layer="$1"
  local selector="$2"
  local trace_id="$3"
  local source_kind="$4"
  local source_root="$5"
  local source_path="$6"
  local selected_by="$7"
  write_file "${current_dir}/metadata.nix" cat <<EOF
{
  layer = "${layer}";
  selector = "${selector}";
  traceId = "${trace_id}";
  sourceKind = "${source_kind}";
  sourceRoot = "${source_root}";
  sourcePath = "${source_path}";
  selectedBy = "${selected_by}";
}
EOF
}

select_default() {
  mkdir -p "${current_dir}"
  write_import "intent.nix" "../GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/runtime-nixos-cpm.nix"
  write_default_nixos_inventory
  write_default_clab_inventory
  write_default_hetz_inventory
  write_default_inventory_test_clients
  write_default_clients
  write_default_sops
  write_current_host_entrypoints
  write_metadata \
    "SMT" \
    "renderer-nixos" \
    "FS-166-HDS-010-SDS-010-SMS-900__active-lab-mini-runtime" \
    "renderer-input" \
    "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900" \
    "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/runtime-nixos-cpm.nix" \
    "scripts/select-current-lab.sh default"
}

mini_attr() {
  local id="$1"
  local expr="$2"
  nix eval --impure --raw --expr "let manifest = import ${manifest_file}; row = manifest.tests.\"${id}\"; in ${expr}"
}

mini_exists() {
  local id="$1"
  nix eval --impure --expr "let manifest = import ${manifest_file}; in manifest.tests ? \"${id}\"" 2>/dev/null | grep -qx true
}

trace_for_mini_or_trace() {
  local requested="$1"
  if mini_exists "${requested}"; then
    mini_attr "${requested}" "row.traceId"
    return 0
  fi
  if [[ "${requested}" =~ ^FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+-SMS-[0-9]+$ ]]; then
    printf '%s\n' "${requested}"
    return 0
  fi
  echo "Unknown SMT selector: ${requested}" >&2
  return 2
}

source_kind_for_mini_or_trace() {
  local requested="$1"
  if mini_exists "${requested}"; then
    mini_attr "${requested}" "row.source.kind or \"unspecified\""
  else
    printf 'trace-row\n'
  fi
}

renderer_target_for_mini_or_trace() {
  local requested="$1"
  if mini_exists "${requested}"; then
    mini_attr "${requested}" "if (row.rendererTarget or null) == null then \"\" else row.rendererTarget"
  else
    printf '\n'
  fi
}

source_path_for_mini_or_trace() {
  local requested="$1"
  if mini_exists "${requested}"; then
    mini_attr "${requested}" "let source = row.source or {}; in if source ? cpm then toString source.cpm else if source ? intent then toString source.intent else \"\""
  else
    printf 'GAMP/SMT/%s/intent.nix\n' "${requested}"
  fi
}

sit_command_for() {
  local sds="$1"
  nix eval --impure --raw --expr "
let
  row = import ${repo_root}/GAMP/SIT/${sds}/default.nix;
in
  row.evidence.command or \"\"
"
}

first_manifest_mini_for_sit() {
  local sds="$1"
  local command rest mini_id
  command="$(sit_command_for "${sds}")"
  case "${command}" in
    "tests/run-active-lab-mini-smt.sh "*) ;;
    *)
      echo "SIT row is not a current active-lab SIT shim: ${sds}" >&2
      echo "SIT row command: ${command:-<none>}" >&2
      return 2
      ;;
  esac

  rest="${command#tests/run-active-lab-mini-smt.sh }"
  for mini_id in ${rest}; do
    if mini_exists "${mini_id}"; then
      printf '%s\n' "${mini_id}"
      return 0
    fi
  done

  echo "SIT row has no registered mini-SMT selector in ${manifest_file}: ${sds}" >&2
  echo "SIT row command: ${command}" >&2
  return 2
}

list_sit_sources() {
  nix eval --impure --raw --expr "
let
  manifest = import ${manifest_file};
  ids = builtins.attrNames manifest.tests;
  traceFor = id: (builtins.getAttr id manifest.tests).traceId;
  sdsFor = trace: builtins.elemAt (builtins.match \"(FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+)-SMS-[0-9]+.*\" trace) 0;
  addUnique = acc: value: if builtins.elem value acc then acc else acc ++ [ value ];
  unique = builtins.foldl' addUnique [ ] (map (id: sdsFor (traceFor id)) ids);
in
  builtins.concatStringsSep \"\n\" (builtins.sort (left: right: left < right) unique)
"
}

select_smt() {
  local requested="$1"
  local trace row_trace source_kind source_path renderer_target row_dir selected_by
  trace="$(trace_for_mini_or_trace "${requested}")"
  row_trace="${trace%%__*}"
  source_kind="$(source_kind_for_mini_or_trace "${requested}")"
  source_path="$(source_path_for_mini_or_trace "${requested}")"
  renderer_target="$(renderer_target_for_mini_or_trace "${requested}")"
  if [[ "${source_path}" == "${repo_root}/"* ]]; then
    source_path="${source_path#"${repo_root}/"}"
  fi
  row_dir="GAMP/SMT/${row_trace}"
  selected_by="scripts/select-current-lab.sh SMT ${requested}"

  [[ -d "${repo_root}/${row_dir}" ]] || {
    echo "SMT row directory not found: ${row_dir}" >&2
    exit 2
  }

  if [[ "${source_kind}" == "renderer-input" ]]; then
    if [[ "${renderer_target}" == "nixos" ]]; then
      write_import "intent.nix" "../${source_path}"
    else
      write_import "intent.nix" "../GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/runtime-nixos-cpm.nix"
    fi
    write_default_nixos_inventory
    write_default_clab_inventory
    write_default_inventory_test_clients
    write_default_clients
  else
    local forwarding_enterprise_json
    forwarding_enterprise_json="$(forwarding_enterprise_json_for_intent "../${row_dir}/intent.nix")"
    write_import "intent.nix" "../${row_dir}/intent.nix"
    write_smt_inventory_with_management "inventory-nixos.nix" "../${row_dir}/inventory-nixos.nix" "../${row_dir}/intent.nix" "${forwarding_enterprise_json}" "s-router-nixos"
    write_smt_inventory_with_management "inventory-clab.nix" "../${row_dir}/inventory-clab.nix" "../${row_dir}/intent.nix" "${forwarding_enterprise_json}" "s-router-clab"
  fi
  write_default_hetz_inventory
  write_default_sops
  write_current_host_entrypoints
  if [[ "${source_kind}" == "renderer-input" && "${renderer_target}" == "clab" ]]; then
    write_import "intent-s-router-clab.nix" "../${source_path}"
    write_import "inventory-s-router-clab.nix" "./inventory-clab.nix"
  fi
  if [[ "${source_kind}" == "renderer-input" && "${renderer_target}" == "wireguard" ]]; then
    write_import "intent-s-router-nixos.nix" "../${source_path}"
    write_import "inventory-s-router-nixos.nix" "./inventory-nixos.nix"
    write_wireguard_sops_nixos
  fi
  if [[ "${source_kind}" == "renderer-input" && "${renderer_target}" == "nebula" ]]; then
    write_import "intent-s-router-nixos.nix" "../${source_path}"
    write_import "inventory-s-router-nixos.nix" "./inventory-nixos.nix"
    write_nebula_sops_nixos
  fi
  if [[ "${source_kind}" == "renderer-input" && "${renderer_target}" == "nixos-clients" ]]; then
    write_import "intent-s-router-test-clients.nix" "../${source_path}"
    write_renderer_clients_inventory_test_clients "${source_path}"
    write_import "inventory-s-router-test-clients.nix" "./inventory-test-clients.nix"
    write_import "clients-s-router-test-clients.nix" "./clients.nix"
  fi
  if [[ "${source_kind}" != "renderer-input" ]]; then
    write_row_test_client_entrypoints "${row_dir}" "${forwarding_enterprise_json}"
  fi
  write_metadata "SMT" "${requested}" "${trace}" "${source_kind}" "${row_dir}" "${source_path}" "${selected_by}"
}

select_sit() {
  local sds="$1"
  local sit_dir="GAMP/SIT/${sds}"
  local mini_id

  [[ "${sds}" =~ ^FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+$ ]] || {
    echo "SIT selector must be an SDS trace ID: ${sds}" >&2
    exit 2
  }
  [[ -d "${repo_root}/${sit_dir}" ]] || {
    echo "SIT row directory not found: ${sit_dir}" >&2
    exit 2
  }

  mini_id="$(first_manifest_mini_for_sit "${sds}")"
  select_smt "${mini_id}"
  write_metadata "SIT" "${sds}" "${sds}" "sds-integration-source" "${sit_dir}" "${sit_dir}/default.nix" "scripts/select-current-lab.sh SIT ${sds}"
}

select_hat() {
  local name="${1:-emulated-isp-residential-testnet}"
  local root="GAMP/HAT/${name}"

  [[ -d "${repo_root}/${root}" ]] || {
    echo "HAT source not found: ${root}" >&2
    exit 2
  }

  write_import "intent.nix" "../${root}/intent.nix"
  write_import "inventory-nixos.nix" "../${root}/inventory-nixos.nix"
  write_import "inventory-clab.nix" "../${root}/inventory-clab.nix"
  write_import "inventory-hetz.nix" "../${root}/inventory-hetz.nix"
  write_import "inventory-test-clients.nix" "../${root}/inventory-nixos.nix"
  write_import "clients.nix" "../${root}/clients.nix"
  write_import "sops.nix" "../${root}/sops.nix"
  write_import "sops-routing-s-router-clab.nix" "../${root}/sops-routing-s-router-clab.nix"
  write_import "sops-routing-s-router-nixos.nix" "../${root}/sops-routing-s-router-nixos.nix"
  write_import "sops-routing-s-router-test-clients.nix" "../${root}/sops-routing-s-router-test-clients.nix"
  write_default_hetz_sops
  write_current_host_entrypoints
  write_metadata "HAT" "${name}" "${name}" "hat-source" "${root}" "${root}/intent.nix" "scripts/select-current-lab.sh HAT ${name}"
}

select_sat() {
  local root="GAMP/SAT"
  write_import "intent.nix" "../${root}/intent.nix"
  write_import "inventory-nixos.nix" "../${root}/inventory-nixos.nix"
  write_import "inventory-clab.nix" "../${root}/inventory-clab.nix"
  write_import "inventory-hetz.nix" "../${root}/inventory-hetz.nix"
  write_import "inventory-test-clients.nix" "../${root}/inventory-nixos.nix"
  write_import "clients.nix" "../${root}/clients.nix"
  write_import "sops.nix" "../${root}/sops.nix"
  write_import "sops-routing-s-router-clab.nix" "../${root}/sops-routing-s-router-clab.nix"
  write_import "sops-routing-s-router-nixos.nix" "../${root}/sops-routing-s-router-nixos.nix"
  write_import "sops-routing-s-router-test-clients.nix" "../${root}/sops-routing-s-router-test-clients.nix"
  write_import "sops-routing-s-router-hetz.nix" "../${root}/sops-routing-s-router-hetz.nix"
  write_current_host_entrypoints
  write_metadata "SAT" "SAT" "SAT" "sat-source" "${root}" "${root}/intent.nix" "scripts/select-current-lab.sh SAT"
}

list_sources() {
  echo "default"
  echo "SAT"
  echo "HAT emulated-isp-residential-testnet"
  while IFS= read -r id || [[ -n "${id}" ]]; do
    printf 'SMT %s\n' "${id}"
  done < <(tests/run-active-lab-mini-smt.sh --list)
  while IFS= read -r sds || [[ -n "${sds}" ]]; do
    printf 'SIT %s\n' "${sds}"
  done < <(list_sit_sources)
}

if [[ "$#" -eq 0 ]]; then
  usage >&2
  exit 2
fi

case "$1" in
  --list)
    list_sources
    ;;
  default)
    [[ "$#" -eq 1 ]] || { usage >&2; exit 2; }
    select_default
    ;;
  SMT)
    [[ "$#" -eq 2 ]] || { usage >&2; exit 2; }
    select_smt "$2"
    ;;
  SIT)
    [[ "$#" -eq 2 ]] || { usage >&2; exit 2; }
    select_sit "$2"
    ;;
  HAT)
    [[ "$#" -le 2 ]] || { usage >&2; exit 2; }
    select_hat "${2:-emulated-isp-residential-testnet}"
    ;;
  SAT)
    [[ "$#" -eq 1 ]] || { usage >&2; exit 2; }
    select_sat
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac
