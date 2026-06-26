#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hat_dir="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet"
# SMS-020 CMC: cpm_flake removed — downstream entrypoint reference.
# CPM compile-and-build invocations, jq validation of CPM output,
# endpoint-fixture mutation tests, and missing-port rejection tests
# are downstream-dependent and must live in network-control-plane-model/tests/.
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

if rg -in 'dhcp(v[46])?|pppoe|xvlan|upstreamEmulation|providerAccess' "${hat_dir}/intent.nix" >&2; then
  fail "intent.nix must not carry HAT provider-access realization technology or side-channel fields"
fi

HAT_DIR="${hat_dir}" nix eval --impure --expr '
  let
    root = builtins.getEnv "HAT_DIR";
    intent = import (root + "/intent.nix");
    clab = import (root + "/inventory-clab.nix");
    nixos = import (root + "/inventory-nixos.nix");
    site = intent.esp0xdeadbeef.site-a;
    clabHost = clab.deployment.hosts.s-router-clab;
    nixosHost = nixos.deployment.hosts.s-router-nixos;
    clientHost = nixos.deployment.hosts.s-router-test-clients;
    clabEndpointClients = clabHost.hat.endpointClients or { };
    nixosEndpointClients = clientHost.hat.endpointClients or { };
    endpointClients = nixosEndpointClients // clabEndpointClients;
    nodeHostIs = inventory: nodeName: expectedHost:
      ((inventory.realization.nodes.${nodeName} or { }).host or null) == expectedHost;
    allLogicalPlacementsMatch = inventory: siteName: namePattern: expectedHost:
      builtins.all
        (node:
          let logicalNode = node.logicalNode or { };
          in
            (logicalNode.site or null) != siteName
            || builtins.match namePattern (logicalNode.name or "") == null
            || (node.host or null) == expectedHost)
        (builtins.attrValues (inventory.realization.nodes or { }));
    accessTenantPortOk = inventory: nodeName: tenantPort: bridgeName:
      let
        node = inventory.realization.nodes.${nodeName} or { };
        port = (node.ports or { }).${tenantPort} or { };
      in
        (port.logicalInterface or null) == tenantPort
        && (port.attach.kind or null) == "bridge"
        && (port.attach.bridge or null) == bridgeName;
    require = cond: msg: if cond then true else throw msg;
    stripTenantPrefix = name:
      let matched = builtins.match "tenant-(.*)" name;
      in if matched == null then name else builtins.head matched;
    advertisedDhcpTenants = builtins.concatMap
      (node:
        map stripTenantPrefix
          (builtins.attrNames ((node.advertisements or { }).dhcp4 or { })))
      (builtins.attrValues (nixos.realization.nodes or { }));
    dhcpEndpointTenants = map
      (name: endpointClients.${name}.tenant or null)
      (builtins.filter
        (name: (endpointClients.${name}.assignment or null) == "dhcp")
        (builtins.attrNames endpointClients));
    allDhcpEndpointsAdvertised =
      builtins.all
        (tenant: tenant != null && builtins.elem tenant advertisedDhcpTenants)
        dhcpEndpointTenants;
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
      builtins.hasAttr name endpointClients;
    endpointServiceSurface = endpoint: surface:
      ((endpointClients.${endpoint} or { }).serviceSurfaces or { }).${surface} or null;
    endpointHasPersistenceAndManagementBoundary = name:
      let
        endpoint = endpointClients.${name} or { };
        persistence = endpoint.persistenceExpectation or { };
        management = endpoint.managementBoundary or { };
      in
        (endpoint ? persistenceExpectation)
        && (persistence ? kind)
        && (persistence ? required)
        && (endpoint ? managementBoundary)
        && (management.fixturePlacementCreatesManagementAccess or null) == false
        && (management ? mode);
    endpointNames = builtins.attrNames endpointClients;
    trafficTypeHasPort = name: proto: port:
      builtins.any
        (match: (match.proto or null) == proto && builtins.elem port (match.dports or [ ]))
        (trafficTypes.${name}.match or [ ]);
    hasInventoryOnlyToken = text:
      let encoded = builtins.toJSON intent;
      in builtins.match (".*" + text + ".*") encoded != null;
    requiredProtectedBindingIds = [
      "FS-800-HDS-020-SDS-020"
      "FS-800-HDS-010-SDS-030-SMS-020"
    ];
    hasAllProtectedBindingIds = ids:
      builtins.all (id: builtins.elem id ids) requiredProtectedBindingIds;
    policyNeutral = policy:
      builtins.all
        (name: (policy.${name} or null) == false)
        [
          "createsRouteAuthority"
          "createsFirewallPolicy"
          "createsDnsPolicy"
          "createsPublicIngress"
          "createsTenantReachability"
          "createsTrustBoundary"
          "createsNetworkBehavior"
        ];
    oneMatching = rows: pred:
      builtins.length (builtins.filter pred rows) == 1;
    protectedCredentialBindingOk = inventory: harness: siteName: consumerNode:
      let
        declarations = inventory.secretDeclarations or [ ];
        sources = inventory.secretSources or [ ];
        bindings = inventory.sourceBindings or [ ];
        credentials = inventory.deployment.hosts.${harness}.hat.providerAccess.residentialPppoeHostTestnet.credentials or { };
        sourceFieldBase = "deployment.hosts.${harness}.hat.providerAccess.residentialPppoeHostTestnet.credentials";
        validPurpose = purpose: field:
          let
            declarationId = "hat-secret-pppoe-${siteName}-${field}";
            sourceId = "${declarationId}-source";
            bindingId = "${declarationId}-binding";
            sourceFieldPath = "${sourceFieldBase}.${field}File";
            runtimePath = credentials.${field + "File"} or null;
          in
            runtimePath == "hat-pppoe-${field}"
            && oneMatching declarations (row:
              (row.id or null) == declarationId
              && (row.credentialClass or null) == "provider-credential"
              && (row.site or null) == siteName
              && row ? tenant
              && row.tenant == null
              && (row.host or null) == harness
              && (row.consumer.kind or null) == "service"
              && (row.consumer.node or null) == consumerNode
              && (row.consumer.name or null) == "pppoe.client"
              && (row.purpose or null) == purpose
              && (row.lifecycle or null) == "hat-runtime"
              && (row.required or false)
              && (row.requiredness or null) == "mandatory"
              && (row.material or null) == "reference-only"
              && (row.plaintextMaterial or null) == false
              && (row.sourceSelected or null) == false
              && policyNeutral (row.policyAuthority or { })
              && hasAllProtectedBindingIds (row.gampIds or [ ]))
            && oneMatching sources (row:
              (row.id or null) == sourceId
              && (row.declarationId or null) == declarationId
              && (row.sourceClass or null) == "deployment-platform-secret-reference"
              && (row.reference.name or null) == "hat-pppoe-${field}"
              && (row.reference.runtimePath or null) == runtimePath
              && (row.reference.sourceFieldPath or null) == sourceFieldPath
              && (row.lifecycle or null) == "hat-runtime"
              && (row.materialAccess or null) == "not-supplied-by-source-record"
              && (row.plaintextMaterial or null) == false
              && (row.providerNeutral or null) == true
              && (row.fixedSecretManagerRequired or null) == false
              && hasAllProtectedBindingIds (row.gampIds or [ ]))
            && oneMatching bindings (row:
              (row.id or null) == bindingId
              && (row.declarationId or null) == declarationId
              && (row.sourceId or null) == sourceId
              && (row.sourceClass or null) == "deployment-platform-secret-reference"
              && (row.bindingKind or null) == "declaration-source"
              && (row.sourceFieldPath or null) == sourceFieldPath
              && policyNeutral (row.policyAuthority or { })
              && hasAllProtectedBindingIds (row.gampIds or [ ]));
      in
        builtins.length declarations >= 2
        && builtins.length sources >= 2
        && builtins.length bindings >= 2
        && validPurpose "pppoe-username" "username"
        && validPurpose "pppoe-password" "password";
  in
    require (hasRelation "allow-client-to-testnet-routed-isp")
      "shared intent must own client-to-routed-ISP behavior"
    && require (hasRelation "allow-client-to-testnet-host-isp")
      "shared intent must own client-to-host-ISP behavior"
    && require (!(hasInventoryOnlyToken "endpointClients"))
      "intent must not carry HAT endpoint fixture records"
    && require (!(hasInventoryOnlyToken "bridgeNetworks"))
      "intent must not carry host bridge realization records"
    && require (!(hasInventoryOnlyToken "providerAccess"))
      "intent must not carry HAT provider-access side-channel metadata"
    && require (!(hasInventoryOnlyToken "upstreamEmulation"))
      "intent must not carry legacy upstream emulation side-channel metadata"
    && require (!(hasInventoryOnlyToken "dhcp"))
      "intent must not carry DHCP realization technology"
    && require (!(hasInventoryOnlyToken "pppoe"))
      "intent must not carry PPPoE realization technology"
    && require (!(hasInventoryOnlyToken "xvlan"))
      "intent must not carry xVLAN realization technology"
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
    && require (clabHost.hat.providerAccess.residentialPppoeHostTestnet.harness == "s-router-clab")
      "CLAB inventory must bind PPPoE HAT realization to s-router-clab"
    && require (nixosHost.hat.providerAccess.residentialPppoeHostTestnet.harness == "s-router-nixos")
      "NixOS inventory must bind PPPoE HAT realization to s-router-nixos"
    && require (clabHost.hat.providerAccess.residentialPppoeHostTestnet.l2Surface.name != nixosHost.hat.providerAccess.residentialPppoeHostTestnet.l2Surface.name)
      "CLAB and NixOS HAT inventories must use separate PPPoE handoff surfaces"
    && require (clabHost.hat.providerAccess.residentialPppoeHostTestnet.distribution.mode == "endpoint-specific")
      "provider access may select endpoint-specific distribution independent of DHCP"
    && require (clabHost.hat.providerAccess.residentialPppoeHostTestnet.distribution.endpoint == "clab-core-testnet-host-isp")
      "CLAB provider access must target the CLAB host-ISP core endpoint"
    && require (nixosHost.hat.providerAccess.residentialPppoeHostTestnet.distribution.endpoint == "nixos-core-testnet-host-isp")
      "NixOS provider access must target the host-ISP core endpoint"
    && require (protectedCredentialBindingOk clab "s-router-clab" "clab" "esp0xdeadbeef-site-b-clab-core-testnet-host-isp")
      "CLAB HAT inventory must expose protected PPPoE credential declaration/source/binding records"
    && require (protectedCredentialBindingOk nixos "s-router-nixos" "nixos" "esp0xdeadbeef-site-a-nixos-core-testnet-host-isp")
      "NixOS HAT inventory must expose protected PPPoE credential declaration/source/binding records"
    && require (nodeHostIs nixos "esp0xdeadbeef-site-a-nixos-core-testnet-host-isp" "s-router-nixos")
      "NixOS inventory must place site-a/nixos host-ISP core on s-router-nixos"
    && require (nodeHostIs clab "esp0xdeadbeef-site-b-clab-core-testnet-host-isp" "s-router-clab")
      "CLAB inventory must place site-b/clab host-ISP core on s-router-clab"
    && require (allLogicalPlacementsMatch nixos "site-a" "nixos-.*" "s-router-nixos")
      "NixOS inventory must place every site-a/nixos runtime node on s-router-nixos"
    && require (allLogicalPlacementsMatch nixos "site-b" "clab-.*" "s-router-clab")
      "NixOS inventory must keep every site-b/clab runtime node assigned to s-router-clab"
    && require (allLogicalPlacementsMatch clab "site-a" "nixos-.*" "s-router-nixos")
      "CLAB inventory must keep every site-a/nixos runtime node assigned to s-router-nixos"
    && require (allLogicalPlacementsMatch clab "site-b" "clab-.*" "s-router-clab")
      "CLAB inventory must place every site-b/clab runtime node on s-router-clab"
    && require (accessTenantPortOk nixos "esp0xdeadbeef-site-a-nixos-access-client" "tenant-client" "client")
      "NixOS HAT access-client must realize tenant-client on the endpoint client bridge"
    && require (accessTenantPortOk clab "esp0xdeadbeef-site-b-clab-access-client" "tenant-client" "client")
      "CLAB HAT access-client must realize tenant-client on the endpoint client bridge"
    && require ((nixosHost.bridgeNetworks.client.mode or null) == "vlan")
      "NixOS HAT router client bridge must bind to the physical client VLAN substrate"
    && require ((nixosHost.bridgeNetworks.client.vlan or null) == 302)
      "NixOS HAT router client bridge must share VLAN 302 with endpoint clients"
    && require ((clientHost.bridgeNetworks.client.vlan or null) == 302)
      "HAT endpoint client bridge must remain on VLAN 302"
    && require allDhcpEndpointsAdvertised
      "DHCP endpoint fixtures must target only tenants with explicit DHCP advertisements"
    && require (builtins.hasAttr "clab-client01" clabEndpointClients && builtins.hasAttr "nixos-client01" nixosEndpointClients)
      "endpoint fixtures must live in their owning inventory HAT substrate, not shared intent"
    && require (!(builtins.hasAttr "clab-client01" nixosEndpointClients) && !(builtins.hasAttr "nixos-client01" clabEndpointClients))
      "CLAB and NixOS endpoint fixtures must not be cross-loaded into the wrong inventory"
    && require (hasEndpointFixture "nixos-printer01" && hasEndpointFixture "nixos-receiver01")
      "shared-service endpoint fixtures must live in inventory HAT substrate"
    && require (builtins.all endpointHasPersistenceAndManagementBoundary endpointNames)
      "HAT endpoint client fixtures must declare persistenceExpectation and managementBoundary without fixture-created management access"
    && require ((endpointServiceSurface "nixos-printer01" "ipp").service == "hat-printer-ipp")
      "printer IPP fixture surface must bind to modeled service"
    && require ((endpointServiceSurface "nixos-printer01" "admin").service == "hat-printer-admin")
      "printer admin fixture surface must bind to modeled service"
    && require ((endpointServiceSurface "nixos-receiver01" "control").service == "hat-receiver-control")
      "receiver control fixture surface must bind to modeled service"
    && require ((endpointServiceSurface "nixos-receiver01" "discovery").service == "hat-receiver-discovery")
      "receiver discovery fixture surface must bind to modeled service"
' >/dev/null

# SMS-020 CMC: Removed build_cpm(), CPM compile-and-build calls,
# jq validation of CPM output (DHCPv4 lease contracts, PPPoE
# client/server binding facts), endpoint-fixture surface comparison
# tests, and missing-realization-port rejection tests. These are
# downstream-dependent and must live in network-control-plane-model/tests/.

echo "PASS hat-fixture-source-boundaries"
