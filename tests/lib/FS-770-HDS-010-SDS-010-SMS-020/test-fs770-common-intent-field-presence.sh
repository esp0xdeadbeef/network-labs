#!/usr/bin/env bash
# GAMP-IDS: FS-770-HDS-010-SDS-010-SMS-020
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
hat_dir="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet"

fail() {
  echo "FAIL fs770-common-intent-field-presence: $*" >&2
  exit 1
}

HAT_DIR="${hat_dir}" nix eval --impure --expr '
  let
    root = builtins.getEnv "HAT_DIR";
    intent = import (root + "/intent.nix");
    siteA = intent.esp0xdeadbeef.site-a;
    siteB = intent.esp0xdeadbeef.site-b;
    require = cond: msg: if cond then true else throw msg;
    hasKey = set: key: builtins.hasAttr key set;
    siteShapeOk = site:
      hasKey site "communicationContract"
      && hasKey site "hostManagement"
      && hasKey site "ownership"
      && hasKey site "pools"
      && hasKey site "topology";
    ccShapeOk = site:
      hasKey site.communicationContract "interfaceTags"
      && hasKey site.communicationContract "relations"
      && hasKey site.communicationContract "services"
      && hasKey site.communicationContract "sharedServicePolicyAtoms"
      && hasKey site.communicationContract "trafficTypes";
    hasNamedService = site: name:
      builtins.any (service: (service.name or null) == name)
        (site.communicationContract.services or [ ]);
    hasNamedTrafficType = site: name:
      builtins.any (trafficType: (trafficType.name or null) == name)
        (site.communicationContract.trafficTypes or [ ]);
    hasNamedRelation = site: name:
      builtins.any (relation: (relation.id or null) == name)
        (site.communicationContract.relations or [ ]);
    hasRole = site: role:
      builtins.any (node: (node.role or null) == role)
        (builtins.attrValues (site.topology.nodes or { }));
    hasInterfaceTag = site: key:
      hasKey (site.communicationContract.interfaceTags or { }) key;
  in
    require (siteShapeOk siteA && siteShapeOk siteB)
      "both HAT sites must carry communicationContract, hostManagement, ownership, pools, and topology"
    && require (ccShapeOk siteA && ccShapeOk siteB)
      "both HAT sites must carry interfaceTags, relations, services, sharedServicePolicyAtoms, and trafficTypes"
    && require ((builtins.attrNames (siteA.pools or { })) == [ "loopback" "p2p" ])
      "site-a must carry common address-mode pools"
    && require ((builtins.attrNames (siteB.pools or { })) == [ "loopback" "p2p" ])
      "site-b must carry common address-mode pools"
    && require (siteA.hostManagement.required or false)
      "site-a must carry management policy in the common behavior source"
    && require (siteB.hostManagement.required or false)
      "site-b must carry management policy in the common behavior source"
    && require (hasRole siteA "access" && hasRole siteA "core" && hasRole siteA "downstream-selector" && hasRole siteA "policy" && hasRole siteA "upstream-selector")
      "site-a common behavior source must carry staged routing-path roles"
    && require (hasRole siteB "access" && hasRole siteB "core" && hasRole siteB "downstream-selector" && hasRole siteB "policy" && hasRole siteB "upstream-selector")
      "site-b common behavior source must carry staged routing-path roles"
    && require (hasNamedService siteA "hat-printer-ipp" && hasNamedService siteA "hat-printer-admin" && hasNamedService siteA "hat-receiver-control" && hasNamedService siteA "hat-receiver-discovery")
      "site-a common behavior source must carry shared services"
    && require (hasNamedTrafficType siteA "ipp" && hasNamedTrafficType siteA "printer-admin" && hasNamedTrafficType siteA "cast-control" && hasNamedTrafficType siteA "cast-discovery" && hasNamedTrafficType siteA "overlay-control")
      "site-a common behavior source must carry service, discovery, and overlay traffic types"
    && require (hasNamedRelation siteA "allow-client-to-testnet-host-isp" && hasNamedRelation siteA "allow-client-to-testnet-routed-isp")
      "site-a common behavior source must carry provider-access relations"
    && require (hasNamedRelation siteA "allow-iot-underlay-to-nebula-egress" && hasNamedRelation siteA "allow-iot-underlay-to-wireguard-egress")
      "site-a common behavior source must carry overlay-policy relations"
    && require (hasInterfaceTag siteA "tenant-client" && hasInterfaceTag siteA "service-hat-printer-ipp" && hasInterfaceTag siteA "external-testnet-host-isp" && hasInterfaceTag siteA "external-nebula-egress")
      "site-a interface tags must carry tenant, service, provider-access, and overlay classes"
' >/dev/null || fail "required common behavior field validation failed"

echo "PASS fs770-common-intent-field-presence"
