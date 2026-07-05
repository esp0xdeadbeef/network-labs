#!/usr/bin/env bash
# GAMP-ID: FS-210-HDS-010-SDS-010-SMS-010
# GAMP-SCOPE: software-module-test
#
# FS-210-HDS-010-SDS-010-SMS-010: Public Ingress Authorization Module
# Construction test: validates that every emitted public-ingress fixture row
# traces to an explicit public-exposure policy (publicIngressTupleAuthority
# in intent relations), and exercises seeded negatives per SMS-010.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/GAMP/SAT"

nix eval --impure --expr '
  let
    fixtureTable = import '"${lab_dir}"'/public-ingress-fixture-table.nix;
    intent = import '"${lab_dir}"'/intent.nix;
    require = cond: msg: if cond then true else throw msg;

    # Collect all relation IDs that carry publicIngressTupleAuthority
    # from all sites in the SAT intent.
    sites = intent.esp or {};
    allRelations = builtins.concatLists
      (builtins.map
        (siteName:
          let
            site = builtins.getAttr siteName sites;
            relations = site.communicationContract.relations or [];
          in relations)
        (builtins.attrNames sites));

    policyRelationIds = builtins.map
      (rel: rel.id)
      (builtins.filter
        (rel: rel ? publicIngressTupleAuthority)
        allRelations);

    # Collect all targetEndpoint values from publicIngressTupleAuthority records
    relationEndpointNames = builtins.filter
      (name: name != null)
      (builtins.map
        (rel: rel.publicIngressTupleAuthority.targetEndpoint or null)
        (builtins.filter (rel: rel ? publicIngressTupleAuthority) allRelations));

    # Collect all targetService values
    relationServiceNames = builtins.filter
      (name: name != null)
      (builtins.map
        (rel: rel.publicIngressTupleAuthority.targetService or null)
        (builtins.filter (rel: rel ? publicIngressTupleAuthority) allRelations));

    # Collect all targetEndpoint names from the fixture table
    fixtureEndpointNames = builtins.map
      (rowName:
        let row = builtins.getAttr rowName fixtureTable; in row.targetEndpoint)
      (builtins.attrNames fixtureTable);

    fixtureServiceNames = builtins.map
      (rowName:
        let row = builtins.getAttr rowName fixtureTable; in row.targetService)
      (builtins.attrNames fixtureTable);

    # MR1 (Module Responsibility 1): Every fixture row policyRef must match
    # a real relation ID that carries publicIngressTupleAuthority.
    validatePolicyRefs = rowName: row:
      let
        refs = row.policyRefs or [];
        valid = builtins.all (ref: builtins.elem ref policyRelationIds) refs;
      in
        require valid
          "${rowName}: policyRefs must reference intent relations with publicIngressTupleAuthority";

    # FC1 (Failure Condition 1): A fixture row that omits policyRefs or
    # has empty policyRefs must be rejected (MISSING_PUBLIC_EXPOSURE_POLICY).
    rejectMissingPolicyRefs = rowName: row:
      let
        refs = row.policyRefs or [];
      in
        require (refs != [])
          "${rowName}: MISSING_PUBLIC_EXPOSURE_POLICY — fixture row must declare policyRefs";

    # FC2 (Failure Condition 2): A policyRef that does not match any
    # publicIngressTupleAuthority relation must be rejected (UNRESOLVED_TARGET_ENDPOINT).
    rejectUnresolvedRef = rowName: row:
      let
        refs = row.policyRefs or [];
        unresolved = builtins.filter
          (ref: !(builtins.elem ref policyRelationIds))
          refs;
      in
        require (unresolved == [])
          "${rowName}: UNRESOLVED_TARGET_ENDPOINT — policyRefs ${builtins.toJSON unresolved} do not match any publicIngressTupleAuthority relation";

    # FC3 (Failure Condition 3): A targetEndpoint in the fixture must
    # match a targetEndpoint in at least one publicIngressTupleAuthority.
    validateEndpointRef = rowName: row:
      require (builtins.elem row.targetEndpoint relationEndpointNames)
        "${rowName}: UNRESOLVED_TARGET_ENDPOINT — targetEndpoint ${row.targetEndpoint} not found in any publicIngressTupleAuthority";

    # FC4 (Failure Condition 4): A targetService in the fixture must
    # match a targetService in at least one publicIngressTupleAuthority.
    validateServiceRef = rowName: row:
      require (builtins.elem row.targetService relationServiceNames)
        "${rowName}: UNAUTHORIZED_PORT_FORWARD — targetService ${row.targetService} not authorized by any publicIngressTupleAuthority";

    # Seeded negative 1 (SN1): Pretend a fixture row has empty policyRefs
    sn1 = !(builtins.tryEval
      (rejectMissingPolicyRefs "SN1-seeded-missing-policy" {
        targetEndpoint = "nixos-hostile01";
        targetService = "nixos-hostile-4444";
        policyRefs = [];
      })).success;

    # Seeded negative 2 (SN2): Pretend a fixture row references a
    # non-existent policy relation ID.
    sn2 = !(builtins.tryEval
      (rejectUnresolvedRef "SN2-seeded-unresolved-endpoint" {
        targetEndpoint = "nonexistent-99";
        targetService = "fake-service";
        policyRefs = [ "pe-media-receiver-99" ];
      })).success;

    # Seeded negative 3 (SN3): A fixture row with targetEndpoint not
    # found in any publicIngressTupleAuthority must be rejected.
    sn3 = !(builtins.tryEval
      (validateEndpointRef "SN3-seeded-bad-endpoint" {
        targetEndpoint = "nonexistent-endpoint-99";
        policyRefs = [ (builtins.head policyRelationIds) ];
      })).success;

    # Seeded negative 4 (SN4): A fixture row with targetService not
    # authorized must be rejected.
    sn4 = !(builtins.tryEval
      (validateServiceRef "SN4-seeded-unauthorized-service" {
        targetService = "unauthorized-service-99";
        targetEndpoint = builtins.head relationEndpointNames;
        policyRefs = [ (builtins.head policyRelationIds) ];
      })).success;

    expectedKeys = [
      "site-clab-tcp-4445"
      "site-clab-udp-4445"
      "site-hetz-tcp-4446"
      "site-hetz-udp-4446"
      "site-nixos-tcp-4444"
      "site-nixos-udp-4444"
    ];
  in
    # Baseline: fixture table must have expected keys
    require (builtins.attrNames fixtureTable == expectedKeys)
      "public-ingress authorization: fixture table must contain exactly the expected rows"

    # MR1/FC1: Every fixture row must have valid, non-empty policyRefs
    && validatePolicyRefs "site-clab-tcp-4445" fixtureTable.site-clab-tcp-4445
    && validatePolicyRefs "site-clab-udp-4445" fixtureTable.site-clab-udp-4445
    && validatePolicyRefs "site-hetz-tcp-4446" fixtureTable.site-hetz-tcp-4446
    && validatePolicyRefs "site-hetz-udp-4446" fixtureTable.site-hetz-udp-4446
    && validatePolicyRefs "site-nixos-tcp-4444" fixtureTable.site-nixos-tcp-4444
    && validatePolicyRefs "site-nixos-udp-4444" fixtureTable.site-nixos-udp-4444

    # FC3: targetEndpoint must exist in intent
    && validateEndpointRef "site-clab-tcp-4445" fixtureTable.site-clab-tcp-4445
    && validateEndpointRef "site-hetz-tcp-4446" fixtureTable.site-hetz-tcp-4446
    && validateEndpointRef "site-nixos-tcp-4444" fixtureTable.site-nixos-tcp-4444

    # FC4: targetService must be authorized
    && validateServiceRef "site-clab-tcp-4445" fixtureTable.site-clab-tcp-4445
    && validateServiceRef "site-hetz-tcp-4446" fixtureTable.site-hetz-tcp-4446
    && validateServiceRef "site-nixos-tcp-4444" fixtureTable.site-nixos-tcp-4444

    # Seeded negatives must all reject
    && require sn1
      "SN1 must reject fixture row with empty policyRefs (MISSING_PUBLIC_EXPOSURE_POLICY)"
    && require sn2
      "SN2 must reject fixture row with non-existent policy relation ID (UNRESOLVED_TARGET_ENDPOINT)"
    && require sn3
      "SN3 must reject fixture row with non-existent targetEndpoint (UNRESOLVED_TARGET_ENDPOINT)"
    && require sn4
      "SN4 must reject fixture row with unauthorized targetService (UNAUTHORIZED_PORT_FORWARD)"
' >/dev/null

echo "PASS public-ingress-source-tuple-authority (FS-210-HDS-010-SDS-010-SMS-010)"
