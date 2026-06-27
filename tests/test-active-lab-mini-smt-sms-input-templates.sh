#!/usr/bin/env bash
# GAMP-ID: FS-166-HDS-010-SDS-010-SMS-900
# GAMP-SCOPE: SMS renderer-entry source template contract; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  echo "FAIL active-lab-mini-smt-sms-input-templates: $*" >&2
  exit 1
}

if rg -n 'GAMP/HAT/emulated-isp-residential-testnet|base[[:space:]]*//|base[.]deployment|host[.]uplinks' \
  "${repo_root}/active-lab/inventory-clab.nix"
then
  fail "active-lab/inventory-clab.nix must be an SMS source shim, not a HAT import or post-import overlay"
fi

REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  sms = import (repoRoot + "/GAMP/SMS/FS-166-HDS-010-SDS-010-SMS-900/default.nix");
  sds = import (repoRoot + "/GAMP/SDS/FS-166-HDS-010-SDS-010/default.nix");
  sit = import (repoRoot + "/GAMP/SIT/FS-166-HDS-010-SDS-010/default.nix");
  manifest = import (repoRoot + "/GAMP/SMT/mini-smt/tests.nix");
  active = import (repoRoot + "/active-lab");
  activeIntent = import (repoRoot + "/active-lab/intent.nix");
  activeNixosInventory = import (repoRoot + "/active-lab/inventory-nixos.nix");
  activeClabInventory = import (repoRoot + "/active-lab/inventory-clab.nix");
  activeClients = import (repoRoot + "/active-lab/clients.nix");

  require = cond: msg: if cond then true else throw msg;
  pathExistsRel = rel: builtins.pathExists (repoRoot + "/" + rel);
  importRel = rel: import (repoRoot + "/" + rel);

  expectedIds = [
    "renderer-nixos"
    "renderer-nixos-p2p"
    "renderer-nixos-clients"
    "renderer-clab"
    "renderer-wireguard"
    "renderer-nebula"
  ];
  expectedSortedIds = [
    "renderer-clab"
    "renderer-nebula"
    "renderer-nixos"
    "renderer-nixos-clients"
    "renderer-nixos-p2p"
    "renderer-wireguard"
  ];
  sourceNames = builtins.attrNames sms.sourceInputs;

  sourceTrace = value:
    if value ? control_plane_model
       && value.control_plane_model ? meta
       && value.control_plane_model.meta ? traceId
    then value.control_plane_model.meta.traceId
    else if value ? controlPlane
            && value.controlPlane ? control_plane_model
            && value.controlPlane.control_plane_model ? meta
            && value.controlPlane.control_plane_model.meta ? traceId
    then value.controlPlane.control_plane_model.meta.traceId
    else if value ? provenance
            && value.provenance ? requested
            && value.provenance.requested ? scope
            && value.provenance.requested.scope ? traceId
    then value.provenance.requested.scope.traceId
    else null;

  deploymentHostsFor = value:
    if value ? deploymentHosts then value.deploymentHosts
    else if value ? controlPlane && value.controlPlane ? deploymentHosts then value.controlPlane.deploymentHosts
    else if value ? control_plane_model
            && value.control_plane_model ? deployment
            && value.control_plane_model.deployment ? hosts
    then value.control_plane_model.deployment.hosts
    else if value ? controlPlane
            && value.controlPlane ? control_plane_model
            && value.controlPlane.control_plane_model ? deployment
            && value.controlPlane.control_plane_model.deployment ? hosts
    then value.controlPlane.control_plane_model.deployment.hosts
    else { };

  validManagement = management:
    management != null
    && (management.bridge or null) == "vlan2"
    && (management.mode or null) == "vlan"
    && (management.parent or null) == "eth0"
    && (management.vlan or null) == 2
    && ((management.ipv4 or { }).enable or false) == true
    && ((management.ipv4 or { }).dhcp or false) == true
    && ((management.ipv4 or { }).method or null) == "dhcp"
    && ((management.ipv6 or { }).enable or true) == false
    && ((management.ipv6 or { }).acceptRA or true) == false
    && ((management.ipv6 or { }).dhcp or true) == false
    && ((management.ipv6 or { }).dhcpv6PD or true) == false
    && ((management.ipv6 or { }).method or null) == "none";

  requiredManagementHosts = {
    renderer-nixos = [
      "s-router-nixos"
      "s-router-clab"
      "s-router-test-clients"
    ];
    renderer-nixos-p2p = [
      "s-router-nixos"
      "s-router-clab"
      "s-router-test-clients"
    ];
    renderer-nixos-clients = [ "s-router-test-clients" ];
    renderer-clab = [ "s-router-clab" ];
  };

  sourceValue = name: importRel sms.sourceInputs.${name}.sourcePath;
  sourceDeploymentHosts = name: deploymentHostsFor (sourceValue name);
  sourceHasManagement = name:
    builtins.all
      (host: validManagement ((sourceDeploymentHosts name).${host}.uplinks.management or null))
      requiredManagementHosts.${name};

  sourceMatchesRow = name:
    let
      row = sms.sourceInputs.${name};
      entry = manifest.tests.${name};
    in
      pathExistsRel row.sourcePath
      && pathExistsRel row.test
      && entry.traceId == row.traceId
      && entry.script == row.test
      && (toString entry.source.cpm) == repoRoot + "/" + row.sourcePath
      && sourceTrace (sourceValue name) == row.traceId;

  sitSourcePaths = sit.evidence.sourcePaths or [ ];

  nixosStub = activeNixosInventory.activeLabInventoryStub;
  clabStub = activeClabInventory.activeLabInventoryStub;
  clientStub = activeClients.activeLabClientStub;
in
  require (sms.layer == "SMS") "FS-166 SMS row must declare SMS layer"
  && require (sms.traceId == "FS-166-HDS-010-SDS-010-SMS-900") "FS-166 SMS row trace mismatch"
  && require (sourceNames == expectedSortedIds) "FS-166 SMS row must enumerate every renderer-entry source"
  && require (sds.smsInputs."FS-166-HDS-010-SDS-010-SMS-900".miniSmtIds == expectedIds) "SDS row must enumerate all FS-166 mini SMT IDs"
  && require (builtins.all (id: builtins.hasAttr id sms.sourceInputs) expectedIds) "SMS row missing an SDS mini SMT input"
  && require (builtins.all sourceMatchesRow expectedIds) "SMS source input path, test, manifest, or emitted trace does not match"
  && require (builtins.all (id: builtins.elem sms.sourceInputs.${id}.sourcePath sitSourcePaths) expectedIds) "SIT row must list every renderer-entry source path"
  && require (activeIntent.control_plane_model.meta.traceId == sms.sourceInputs.renderer-nixos.traceId) "global active-lab intent must point at renderer-nixos SMS source"
  && require (builtins.isFunction active.mkSource) "active-lab default must keep mkSource for row-local shims"
  && require (nixosStub.miniSmtId == "renderer-nixos") "inventory-nixos shim must point at renderer-nixos"
  && require (toString nixosStub.cpmInput == repoRoot + "/" + sms.sourceInputs.renderer-nixos.sourcePath) "inventory-nixos shim must point at renderer-nixos CPM input"
  && require (toString nixosStub.test == repoRoot + "/" + sms.sourceInputs.renderer-nixos.test) "inventory-nixos shim must point at renderer-nixos test"
  && require (clientStub.miniSmtId == "renderer-nixos-clients") "clients shim must point at renderer-nixos-clients"
  && require (toString clientStub.source == repoRoot + "/" + sms.sourceInputs.renderer-nixos-clients.sourcePath) "clients shim must point at renderer-nixos-clients source"
  && require (clabStub.miniSmtId == "renderer-clab") "inventory-clab shim must point at renderer-clab"
  && require (clabStub.traceId == sms.sourceInputs.renderer-clab.traceId) "inventory-clab shim trace must match renderer-clab SMS source"
  && require (toString clabStub.cpmInput == repoRoot + "/" + sms.sourceInputs.renderer-clab.sourcePath) "inventory-clab shim must point at renderer-clab CPM input"
  && require (toString clabStub.test == repoRoot + "/" + sms.sourceInputs.renderer-clab.test) "inventory-clab shim must point at renderer-clab test"
  && require (builtins.all sourceHasManagement (builtins.attrNames requiredManagementHosts)) "on-prem renderer-entry sources must carry VLAN2 management for their s-router hosts"
' >/dev/null || fail "SMS input template contract failed"

echo "PASS active-lab-mini-smt-sms-input-templates"
