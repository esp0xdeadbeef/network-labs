#!/usr/bin/env bash
# GAMP-ID: FS-210-HDS-010-SDS-010-SMS-010/020/030, FS-220-HDS-010-SDS-010-SMS-010, FS-230-HDS-010-SDS-010-SMS-010/020/030
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

nix eval --impure --expr '
  let
    satIntent = import '"${repo_root}"'/sat/intent.nix;
    fixtureTable = import '"${repo_root}"'/sat/public-ingress-fixture-table.nix;
    overlayDnsExample = import '"${repo_root}"'/examples/s-router-overlay-dns-lane-policy/intent.nix;
    publicOverlayExample = import '"${repo_root}"'/examples/s-router-public-overlay-service/intent.nix;
    require = cond: msg: if cond then true else throw msg;
    relationById = relations: id:
      let
        matches = builtins.filter (relation: relation.id == id) relations;
      in
        if matches == [ ] then throw "missing relation ${id}" else builtins.head matches;
    tupleKey = auth: tuple:
      "${auth.sourceScope}|${auth.publicSurface}|${tuple.protocol}|${toString tuple.publicPort}|${auth.targetService}|${auth.targetEndpoint}|${toString auth.targetPort}|${auth.returnBehavior}|${auth.sourcePreservation}|${auth.translationMode}|${auth.hairpin}|${auth.asymmetricRouting}";
    uniqueTupleKeys = auth:
      let
        keys = map (tuple: tupleKey auth tuple) auth.tuples;
      in
        builtins.length (builtins.attrNames (builtins.listToAttrs (map (key: { name = key; value = true; }) keys)))
          == builtins.length keys;
    hasProtocolPort = auth: protocol: publicPort:
      builtins.any
        (tuple: tuple.protocol == protocol && tuple.publicPort == publicPort)
        auth.tuples;
    validateAuthority = name: relation:
      require (relation ? publicIngressTupleAuthority)
        "${name} must declare publicIngressTupleAuthority on the source relation"
      && (let
        auth = relation.publicIngressTupleAuthority;
      in
        require (auth ? sourceScope && auth.sourceScope != "")
          "${name} must declare source scope"
        && require (auth ? publicSurface && auth.publicSurface != "")
          "${name} must declare public ingress surface"
        && require (auth ? targetService && auth.targetService != "")
          "${name} must declare target service"
        && require (auth ? targetEndpoint && auth.targetEndpoint != "")
          "${name} must declare target endpoint"
        && require (auth ? targetPort && builtins.isInt auth.targetPort)
          "${name} must declare target port"
        && require (auth ? returnBehavior && auth.returnBehavior != "")
          "${name} must declare return behavior"
        && require (auth ? sourcePreservation && auth.sourcePreservation != "")
          "${name} must declare source preservation"
        && require (auth ? translationMode && auth.translationMode != "")
          "${name} must declare translation mode"
        && require (auth ? hairpin && auth.hairpin != "")
          "${name} must declare hairpin authority"
        && require (auth ? asymmetricRouting && auth.asymmetricRouting != "")
          "${name} must declare asymmetric-routing authority"
        && require (auth ? tuples && auth.tuples != [ ])
          "${name} must declare one or more protocol/public-port tuples"
        && require (builtins.all (tuple: tuple ? protocol && tuple.protocol != "" && tuple ? publicPort && builtins.isInt tuple.publicPort) auth.tuples)
          "${name} tuples must declare protocol and public port"
        && require (uniqueTupleKeys auth)
          "${name} must reject duplicate or overlapping protocol/public-port tuple authority");
    validateFixturePolicyRef = rowName: row: relation:
      validateAuthority rowName relation
      && (let
        auth = relation.publicIngressTupleAuthority;
      in
        require (auth.sourceScope == row.sourceScope)
          "${rowName} relation sourceScope must match fixture row"
        && require (auth.publicSurface == row.publicSurface)
          "${rowName} relation publicSurface must match fixture row"
        && require (auth.targetService == row.targetService)
          "${rowName} relation targetService must match fixture row"
        && require (auth.targetEndpoint == row.targetEndpoint)
          "${rowName} relation targetEndpoint must match fixture row"
        && require (auth.targetPort == row.targetPort)
          "${rowName} relation targetPort must match fixture row"
        && require (auth.translationMode == row.translationBehavior)
          "${rowName} relation translationMode must match fixture row"
        && require (hasProtocolPort auth row.protocol row.publicPort)
          "${rowName} relation must explicitly authorize the fixture protocol/publicPort");
    expectFailure = value: msg:
      require (!(builtins.tryEval value).success) msg;
    nixosRelations = satIntent.esp.nixos.communicationContract.relations;
    hetzRelations = satIntent.esp.hetz.communicationContract.relations;
    clabRelations = satIntent.esp.clab.communicationContract.relations;
    sourceRelation = relationById publicOverlayExample.esp0xdeadbeef.site-c.communicationContract.relations "allow-sitec-wan-to-dmz-nebula";
  in
    validateAuthority "example allow-sitec-wan-to-dmz-nebula" sourceRelation
    && validateAuthority "overlay-dns allow-sitec-wan-to-dmz-nebula"
      (relationById overlayDnsExample.esp0xdeadbeef.site-c.communicationContract.relations "allow-sitec-wan-to-dmz-nebula")
    && validateAuthority "sat nixos allow-wan-to-dmz-nebula" (relationById nixosRelations "allow-wan-to-dmz-nebula")
    && validateAuthority "sat hetz allow-wan-to-dmz-nebula" (relationById hetzRelations "allow-wan-to-dmz-nebula")
    && validateFixturePolicyRef "site-nixos-tcp-4444" fixtureTable.site-nixos-tcp-4444 (relationById hetzRelations "allow-wan-to-nixos-hostile-4444")
    && validateFixturePolicyRef "site-nixos-udp-4444" fixtureTable.site-nixos-udp-4444 (relationById hetzRelations "allow-wan-to-nixos-hostile-4444")
    && validateFixturePolicyRef "site-clab-tcp-4445" fixtureTable.site-clab-tcp-4445 (relationById hetzRelations "allow-wan-to-clab-client-4445")
    && validateFixturePolicyRef "site-clab-udp-4445" fixtureTable.site-clab-udp-4445 (relationById hetzRelations "allow-wan-to-clab-client-4445")
    && validateFixturePolicyRef "site-hetz-tcp-4446" fixtureTable.site-hetz-tcp-4446 (relationById hetzRelations "allow-wan-to-hetz-client-4446")
    && validateFixturePolicyRef "site-hetz-udp-4446" fixtureTable.site-hetz-udp-4446 (relationById hetzRelations "allow-wan-to-hetz-client-4446")
    && validateFixturePolicyRef "clab relation mirror" fixtureTable.site-clab-tcp-4445 (relationById clabRelations "allow-hetz-public-4445-to-clab-client")
    && expectFailure (validateAuthority "missing tuple authority" (builtins.removeAttrs sourceRelation [ "publicIngressTupleAuthority" ]))
      "source tuple validation must reject relations that omit publicIngressTupleAuthority"
    && expectFailure (validateAuthority "missing target endpoint" (sourceRelation // {
      publicIngressTupleAuthority = builtins.removeAttrs sourceRelation.publicIngressTupleAuthority [ "targetEndpoint" ];
    }))
      "source tuple validation must reject missing target endpoint"
    && expectFailure (validateAuthority "missing return behavior" (sourceRelation // {
      publicIngressTupleAuthority = builtins.removeAttrs sourceRelation.publicIngressTupleAuthority [ "returnBehavior" ];
    }))
      "source tuple validation must reject missing return behavior"
    && expectFailure (validateAuthority "duplicate tuple" (sourceRelation // {
      publicIngressTupleAuthority = sourceRelation.publicIngressTupleAuthority // {
        tuples = sourceRelation.publicIngressTupleAuthority.tuples ++ [ (builtins.head sourceRelation.publicIngressTupleAuthority.tuples) ];
      };
    }))
      "source tuple validation must reject duplicate protocol/public-port authority"
    && expectFailure (validateFixturePolicyRef "adjacent public port" (fixtureTable.site-nixos-tcp-4444 // {
      publicPort = 4445;
    }) (relationById hetzRelations "allow-wan-to-nixos-hostile-4444"))
      "source tuple validation must reject adjacent public ports that lack explicit authority"
    && expectFailure (validateFixturePolicyRef "ambiguous translation" (fixtureTable.site-hetz-tcp-4446 // {
      translationBehavior = "ambiguous-provider-default";
    }) (relationById hetzRelations "allow-wan-to-hetz-client-4446"))
      "source tuple validation must reject ambiguous translation behavior"
' >/dev/null

echo "PASS public-ingress-source-tuple-authority"
