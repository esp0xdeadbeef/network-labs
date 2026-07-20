#!/usr/bin/env bash
# GAMP-ID: FS-200-HDS-010-SDS-010-SMS-010/020/030
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"

nix eval --impure --expr '
  let
    satIntent = import '"${repo_root}"'/GAMP/SAT/intent.nix;
    require = cond: msg: if cond then true else throw msg;
    hasNonEmptyString = record: name:
      record ? ${name} && builtins.isString record.${name} && record.${name} != "";
    hasNonEmptyList = record: name:
      record ? ${name} && builtins.isList record.${name} && record.${name} != [ ];
    hasPorts = payload:
      payload ? ports && builtins.isList payload.ports && payload.ports != [ ] && builtins.all builtins.isInt payload.ports;
    uniqueServices = matrix:
      let
        keys = map (entry: "${entry.service}|${entry.serviceClass}|${entry.responderScope}|${builtins.concatStringsSep "," entry.requesterScopes}") matrix;
      in
        builtins.length (builtins.attrNames (builtins.listToAttrs (map (key: { name = key; value = true; }) keys)))
          == builtins.length keys;
    serviceByName = matrix: service:
      let
        matches = builtins.filter (entry: entry.service == service) matrix;
      in
        if matches == [ ] then throw "missing shared service ${service}" else builtins.head matches;
    hasService = matrix: service:
      builtins.any (entry: entry.service == service) matrix;
    validateSharedService = siteName: entry:
      require (hasNonEmptyList entry "requesterScopes")
        "${siteName} shared-service entry must declare requester scopes"
      && require (hasNonEmptyString entry "responderScope")
        "${siteName} shared-service entry must declare responder scope"
      && require (hasNonEmptyString entry "serviceClass")
        "${siteName} shared-service entry must declare service class"
      && require (hasNonEmptyString entry "service")
        "${siteName} shared-service entry must declare service name"
      && require (entry ? discovery)
        "${siteName} shared-service entry must carry a discovery decision"
      && require (hasNonEmptyString entry.discovery "protocol")
        "${siteName} shared-service discovery must declare protocol"
      && require (hasNonEmptyString entry.discovery "direction")
        "${siteName} shared-service discovery must declare direction"
      && require (entry ? payload)
        "${siteName} shared-service entry must carry a payload decision"
      && require (hasNonEmptyString entry.payload "protocol")
        "${siteName} shared-service payload must declare protocol"
      && require (hasPorts entry.payload)
        "${siteName} shared-service payload must declare explicit ports"
      && require (hasNonEmptyString entry.payload "direction")
        "${siteName} shared-service payload must declare direction"
      && require (hasNonEmptyString entry.payload "returnBehavior")
        "${siteName} shared-service payload must declare return behavior"
      && require (hasNonEmptyString entry "exposure")
        "${siteName} shared-service entry must declare exposure class"
      && require (hasNonEmptyString entry "authenticationBoundary")
        "${siteName} shared-service entry must declare authentication boundary"
      && require (hasNonEmptyString entry "cloudDependency")
        "${siteName} shared-service entry must declare cloud dependency"
      && require (hasNonEmptyList entry "deniedByDesign")
        "${siteName} shared-service entry must preserve denied-by-design paths"
      && require (hasNonEmptyString entry "managementBoundary")
        "${siteName} shared-service entry must declare management boundary";
    validateSiteMatrix = siteName: site:
      let
        manifest = site.profileManifest;
        matrix = manifest.sharedServiceMatrix;
        tenantScopes = manifest.scopeManifest.tenants;
        publicRequesterScopes = [
          "external-wan"
          "external-east-west"
        ];
        allScopes = tenantScopes ++ publicRequesterScopes;
      in
        require (manifest ? sharedServiceMatrix && matrix != [ ])
          "${siteName} must declare sharedServiceMatrix"
        && require (uniqueServices matrix)
          "${siteName} sharedServiceMatrix must not collapse service/class/responder/requester rows"
        && require (builtins.all (validateSharedService siteName) matrix)
          "${siteName} sharedServiceMatrix entries must be complete"
        && require (builtins.all (entry:
          builtins.elem entry.responderScope tenantScopes
          && builtins.all (scope: builtins.elem scope allScopes) entry.requesterScopes
        ) matrix)
          "${siteName} sharedServiceMatrix scopes must stay requester/responder scoped"
        && require (builtins.all (entry:
          (entry.discovery.protocol == "none" && entry.discovery.direction == "not-discovered")
          || (entry.discovery.protocol != entry.payload.protocol)
          || (entry.discovery.direction != entry.payload.direction)
          || (entry.payload.returnBehavior != "discovery-response-only")
        ) matrix)
          "${siteName} shared-service discovery and payload decisions must remain separable"
        && require (builtins.all (entry:
          !(entry.managementBoundary == "not-management-authority")
          || entry.authenticationBoundary == "resolver-policy"
        ) matrix)
          "${siteName} management non-authority must be bound to resolver-policy service rows";
    expectFailure = value: msg:
      require (!(builtins.tryEval value).success) msg;
    nixosMatrix = satIntent.esp.nixos.profileManifest.sharedServiceMatrix;
    hetzMatrix = satIntent.esp.hetz.profileManifest.sharedServiceMatrix;
    clabMatrix = satIntent.esp.clab.profileManifest.sharedServiceMatrix;
    nixosCastDiscovery = serviceByName nixosMatrix "cast-discovery";
    nixosCastControl = serviceByName nixosMatrix "cast-control";
    nixosDns = serviceByName nixosMatrix "site-dns-mgmt";
    nixosPublic = serviceByName nixosMatrix "nixos-hostile-4444";
    clabCastDiscovery = serviceByName clabMatrix "cast-discovery";
    hetzDns = serviceByName hetzMatrix "hetz-dns-dmz";
  in
    validateSiteMatrix "esp.nixos" satIntent.esp.nixos
    && validateSiteMatrix "esp.hetz" satIntent.esp.hetz
    && validateSiteMatrix "esp.clab" satIntent.esp.clab
    && require (nixosCastDiscovery.requesterScopes == [ "client" ] && nixosCastDiscovery.responderScope == "streaming")
      "FS-200 source must preserve cast discovery requester/responder scope"
    && require (nixosCastDiscovery.discovery.protocol == "mdns-ssdp" && nixosCastDiscovery.discovery.direction == "client-to-streaming")
      "FS-200 source must preserve cast discovery decision"
    && require (nixosCastDiscovery.payload.protocol == "udp" && nixosCastDiscovery.payload.ports == [ 5353 1900 ] && nixosCastDiscovery.payload.returnBehavior == "discovery-response-only")
      "FS-200 source must preserve discovery payload and return behavior separately"
    && require (nixosCastDiscovery.exposure == "site-local" && nixosCastDiscovery.authenticationBoundary == "device-pairing")
      "FS-200 source must preserve shared-service exposure/auth boundary"
    && require (nixosCastDiscovery.deniedByDesign == [ "streaming-reverse-initiation" ] && nixosCastDiscovery.managementBoundary == "no-administration")
      "FS-200 source must preserve denied path and management non-authority"
    && require (nixosCastControl.discovery.protocol == "none" && nixosCastControl.payload.protocol == "tcp" && nixosCastControl.payload.ports == [ 8008 8009 ] && nixosCastControl.payload.returnBehavior == "stateful-return")
      "FS-200 source must keep cast control payload separate from discovery"
    && require (nixosDns.requesterScopes == [ "admin" "client" "streaming" "dmz" ] && nixosDns.responderScope == "mgmt" && nixosDns.authenticationBoundary == "resolver-policy")
      "FS-200 source must preserve resolver shared-service scope/auth"
    && require (nixosPublic.exposure == "public-ingress" && nixosPublic.requesterScopes == [ "external-east-west" ] && nixosPublic.deniedByDesign == [ "hostile-to-local-tenants" ])
      "FS-200 source must preserve public exposure and denied path metadata"
    && require (hasService clabMatrix "cast-control" && clabCastDiscovery.requesterScopes == [ "client" ] && clabCastDiscovery.responderScope == "streaming")
      "FS-200 source must carry shared-service atoms for CLAB"
    && require (hetzDns.serviceClass == "dns" && hetzDns.deniedByDesign == [ "direct-public-dns" ])
      "FS-200 source must carry shared-service atoms for Hetzner DNS"
    && expectFailure (validateSharedService "negative" (builtins.removeAttrs nixosCastDiscovery [ "discovery" ]))
      "FS-200 source validation must reject missing discovery decision"
    && expectFailure (validateSharedService "negative" (builtins.removeAttrs nixosCastDiscovery [ "payload" ]))
      "FS-200 source validation must reject missing payload decision"
    && expectFailure (validateSharedService "negative" (builtins.removeAttrs nixosCastDiscovery [ "deniedByDesign" ]))
      "FS-200 source validation must reject missing denied-by-design paths"
    && expectFailure (validateSharedService "negative" (builtins.removeAttrs nixosCastDiscovery [ "requesterScopes" ]))
      "FS-200 source validation must reject missing requester scope"
    && expectFailure (validateSharedService "negative" (builtins.removeAttrs nixosCastDiscovery [ "responderScope" ]))
      "FS-200 source validation must reject missing responder scope"
    && expectFailure (validateSharedService "negative" (builtins.removeAttrs nixosCastDiscovery [ "authenticationBoundary" ]))
      "FS-200 source validation must reject missing authentication boundary"
    && expectFailure (validateSharedService "negative" (nixosCastDiscovery // { payload = builtins.removeAttrs nixosCastDiscovery.payload [ "returnBehavior" ]; }))
      "FS-200 source validation must reject missing return behavior"
' >/dev/null

echo "PASS fs200-shared-service-source-matrix"
