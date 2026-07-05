#!/usr/bin/env bash
# GAMP-ID: FS-210-HDS-010-SDS-010-SMS-020
# GAMP-SCOPE: software-module-test
#
# FS-210-HDS-010-SDS-010-SMS-020: Public Ingress Tuple Binding Module
# Construction test: validates that every publicIngressTupleAuthority record
# carries all required binding fields and that fixture rows resolve target
# endpoints. Exercises seeded negatives per SMS-020.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/GAMP/SAT"

nix eval --impure --expr '
  let
    fixtureTable = import '"${lab_dir}"'/public-ingress-fixture-table.nix;
    intent = import '"${lab_dir}"'/intent.nix;
    require = cond: msg: if cond then true else throw msg;

    sites = intent.esp or {};
    allRelations = builtins.concatLists
      (builtins.map
        (siteName:
          let
            site = builtins.getAttr siteName sites;
            relations = site.communicationContract.relations or [];
          in relations)
        (builtins.attrNames sites));

    tupleAuthorityRelations = builtins.filter
      (rel: rel ? publicIngressTupleAuthority)
      allRelations;

    tupleAuthorities = builtins.map
      (rel: rel.publicIngressTupleAuthority // {
        owningService = rel.to.name or null;
      })
      tupleAuthorityRelations;

    # Set of known targetEndpoint values from tuple authorities
    knownEndpoints = builtins.map
      (auth: auth.targetEndpoint or null)
      tupleAuthorities;

    # Set of known targetService values from tuple authorities
    knownServices = builtins.map
      (auth: auth.targetService or null)
      tupleAuthorities;

    # Check a single field presence in a tuple authority
    checkField = auth: idx: field:
      require (auth ? ${field} && auth.${field} != null)
        "tuple-authority #${toString idx}: missing required field \"${field}\"";

    # SMS-020 MR1+MR2: Every tuple authority must carry all required fields
    # and have a non-empty tuples list with protocol/publicPort
    checkAuthority = idx: auth:
      checkField auth idx "sourceScope"
      && checkField auth idx "publicSurface"
      && checkField auth idx "targetService"
      && checkField auth idx "targetEndpoint"
      && checkField auth idx "targetPort"
      && checkField auth idx "owningService"
      && require ((auth.tuples or []) != [])
        "tuple-authority #${toString idx}: missing required \"tuples\" list"
      && builtins.all
        (tuple:
          require (tuple ? protocol && tuple.protocol != null)
            "tuple-authority #${toString idx}: tuple entry missing required \"protocol\""
          && require (tuple ? publicPort && tuple.publicPort != null)
            "tuple-authority #${toString idx}: tuple entry missing required \"publicPort\"")
        (auth.tuples or []);

    # Check a single field presence in a fixture row
    checkFixtureField = row: rowName: field:
      require (row ? ${field} && row.${field} != null)
        "fixture row \"${rowName}\": missing required field \"${field}\"";

    # SMS-020 MR3: Every fixture row must carry all required fields AND
    # the targetEndpoint must resolve to a known endpoint in tuple authorities
    checkFixtureRow = rowName: row:
      checkFixtureField row rowName "site"
      && checkFixtureField row rowName "publicSurface"
      && checkFixtureField row rowName "sourceScope"
      && checkFixtureField row rowName "protocol"
      && checkFixtureField row rowName "publicPort"
      && checkFixtureField row rowName "targetService"
      && checkFixtureField row rowName "targetEndpoint"
      && checkFixtureField row rowName "targetPort"
      # SMS-020 FC2 (Failure Condition 2): targetEndpoint must reference a
      # known endpoint from at least one tuple authority
      && require (builtins.elem row.targetEndpoint knownEndpoints)
        "fixture row \"${rowName}\": targetEndpoint \"${row.targetEndpoint}\" not found in any publicIngressTupleAuthority"
      # targetService must also be known
      && require (builtins.elem row.targetService knownServices)
        "fixture row \"${rowName}\": targetService \"${row.targetService}\" not authorized by any publicIngressTupleAuthority";

    # SMS-020 SN1: Missing targetPort in tuple authority must reject
    # with diagnostic naming "targetPort"
    sn1 = !(builtins.tryEval
      (checkField {
        sourceScope = "internet";
        publicSurface = "wan";
        targetService = "some-service";
        targetEndpoint = "some-endpoint";
        owningService = "some-service";
        tuples = [{ protocol = "tcp"; publicPort = 8080; }];
      } 0 "targetPort")).success;

    # SMS-020 SN2: Non-existent targetEndpoint "non-existent-endpoint-42"
    # in fixture row must fail closed
    sn2 = !(builtins.tryEval
      (checkFixtureRow "SN2-seeded-non-existent-endpoint" {
        site = "site-clab";
        publicSurface = "wan";
        sourceScope = "internet";
        protocol = "tcp";
        publicPort = 9999;
        targetService = "fake-service";
        targetEndpoint = "non-existent-endpoint-42";
        targetPort = 9999;
      })).success;

    # SN3: Missing targetPort in fixture row must reject
    sn3 = !(builtins.tryEval
      (checkFixtureRow "SN3-seeded-missing-targetPort" {
        site = "site-clab";
        publicSurface = "wan";
        sourceScope = "internet";
        protocol = "tcp";
        publicPort = 9999;
        targetService = "fake-service";
        targetEndpoint = "fake-endpoint";
        # targetPort intentionally missing
      })).success;

    # Enumerate authority checks per index
    authorityCount = builtins.length tupleAuthorities;
    authIndices = builtins.genList (i: i) authorityCount;
    allAuthoritiesComplete =
      builtins.all
        (i: checkAuthority i (builtins.elemAt tupleAuthorities i))
        authIndices;

    # Enumerate fixture row checks
    fixtureRowNames = builtins.attrNames fixtureTable;
    allFixturesComplete =
      builtins.all
        (rowName:
          checkFixtureRow rowName (builtins.getAttr rowName fixtureTable))
        fixtureRowNames;

    expectedFixtureKeys = [
      "site-clab-tcp-4445"
      "site-clab-udp-4445"
      "site-hetz-tcp-4446"
      "site-hetz-udp-4446"
      "site-nixos-tcp-4444"
      "site-nixos-udp-4444"
    ];
  in
    require (tupleAuthorities != [])
      "must find at least one publicIngressTupleAuthority relation"

    && require allAuthoritiesComplete
      "every publicIngressTupleAuthority must carry all required tuple-binding fields"

    && require allFixturesComplete
      "every public-ingress fixture row must carry all required fields with resolved endpoints"

    && require (fixtureRowNames == expectedFixtureKeys)
      "public-ingress fixture table must contain exactly the expected rows"

    && require sn1
      "SN1 must reject tuple authority with missing targetPort (diagnostic must name \"targetPort\")"

    && require sn2
      "SN2 must reject fixture row where targetEndpoint is \"non-existent-endpoint-42\" (must name missing endpoint)"

    && require sn3
      "SN3 must reject fixture row with missing targetPort (diagnostic must name \"targetPort\")"
' >/dev/null

echo "PASS FS-210-HDS-010-SDS-010-SMS-020 public-ingress-tuple-binding"
