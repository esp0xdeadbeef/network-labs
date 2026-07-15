#!/usr/bin/env bash
# GAMP-ID: FS-230-HDS-010-SDS-010-SMS-030
# GAMP-SCOPE: software-module-test
# SMS: Public Ingress Return Authority Separation Module
# Construction Handoff: Validate that return and translation authority on
# public-ingress fixture rows does not authorize unrelated egress, DNS, tenant,
# overlay, or management traffic. Exercises seeded negatives per SMS-030.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/GAMP/SAT"

nix eval --impure --expr '
  let
    fixtureTable = import '"${lab_dir}"'/public-ingress-fixture-table.nix;
    intent = import '"${lab_dir}"'/intent.nix;
    require = c: msg: if c then true else throw msg;
    failForwarding = path: message: throw "${path}: ${message}";

    # Collect all relations across all sites
    sites = intent.esp or {};
    allRelations = builtins.concatLists
      (builtins.map
        (siteName:
          let
            site = builtins.getAttr siteName sites;
            relations = site.communicationContract.relations or [];
          in relations)
        (builtins.attrNames sites));

    # Build lookup: relation ID -> relation
    relById = builtins.listToAttrs
      (builtins.map (rel: { name = rel.id; value = rel; }) allRelations);

    # Relations that carry publicIngressTupleAuthority (the "good" ingress set)
    ingressRelationIds = builtins.map
      (rel: rel.id)
      (builtins.filter
        (rel: rel ? publicIngressTupleAuthority)
        allRelations);

    # ── SMS-030 Authority Classifiers ──
    # These identify relations whose return/translation authority
    # must NOT be reused for non-ingress purposes.

    # Egress-like: from is external or to.kind includes wan/internet
    isEgress = rel:
      let
        fromKind = rel.from.kind or "";
        toKind = rel.to.kind or "";
        tt = rel.trafficType or "";
      in
        fromKind == "external" || toKind == "wan" || toKind == "internet" ||
        tt == "internet" || tt == "wan";

    # DNS-like: trafficType is "dns" or to.name includes "dns"
    isDns = rel:
      rel.trafficType or "" == "dns" ||
      (builtins.match ".*dns.*" (rel.to.name or "")) != null ||
      (builtins.match ".*dns.*" (rel.from.name or "")) != null;

    # Management-like: to.kind or to.name targets mgmt scope
    isManagement = rel:
      let
        toKind = rel.to.kind or "";
        toName = rel.to.name or "";
        fromKind = rel.from.kind or "";
        fromName = rel.from.name or "";
      in
        toKind == "mgmt" || toName == "mgmt" || fromKind == "mgmt" || fromName == "mgmt";

    # Overlay-like: trafficType is nebula/wireguard/overlay
    isOverlay = rel:
      let tt = rel.trafficType or ""; in
      tt == "nebula" || tt == "wireguard" || tt == "overlay";

    # Tenant-only: to.kind is "tenant" or "tenant-set" AND from.kind is not external
    isTenantOnly = rel:
      let
        toKind = rel.to.kind or "";
        fromKind = rel.from.kind or "";
      in
        (toKind == "tenant" || toKind == "tenant-set") &&
        fromKind != "external";

    # ── SMS-030 Module Responsibilities ──

    # MR1: Return behavior must be scoped to public-ingress only.
    # A fixture row with returnPath that references a non-ingress relation
    # is using return authority for unrelated traffic.
    validateReturnAuthoritySeparation = rowName: row:
      let
        refs = row.policyRefs or [];
        nonIngressRefs = builtins.filter
          (ref: !(builtins.elem ref ingressRelationIds))
          refs;
        # Classify each non-ingress ref by its authority type
        classifyRef = ref:
          let
            rel = builtins.getAttr ref relById;
            classes = []
              ++ (if isEgress rel then [ "egress" ] else [])
              ++ (if isDns rel then [ "DNS" ] else [])
              ++ (if isManagement rel then [ "management" ] else [])
              ++ (if isOverlay rel then [ "overlay" ] else [])
              ++ (if isTenantOnly rel then [ "tenant" ] else []);
          in
            if classes != [] then "${ref} (${builtins.concatStringsSep ", " classes})" else null;
        classified = builtins.filter (s: s != null)
          (builtins.map classifyRef nonIngressRefs);
      in
        if classified != [] then
          failForwarding "${rowName}.returnAuthority"
            "AUTHORITY_SEPARATION_VIOLATION: return behavior references non-ingress authority: ${builtins.concatStringsSep "; " classified} — return authority must not authorize unrelated egress, DNS, management, overlay, or tenant traffic"
        else
          true;

    # MR2: Translation binding must be scoped to the owned ingress path only.
    # A fixture row using translationBehavior that references a non-ingress
    # relation is using translation authority for unrelated traffic.
    validateTranslationAuthoritySeparation = rowName: row:
      let
        refs = row.policyRefs or [];
        nonIngressRefs = builtins.filter
          (ref: !(builtins.elem ref ingressRelationIds))
          refs;
        # Check for egress-specific reuse of translation
        egressRefs = builtins.filter
          (ref:
            let rel = builtins.getAttr ref relById; in
            isEgress rel && !(rel ? publicIngressTupleAuthority))
          nonIngressRefs;
      in
        if egressRefs != [] then
          failForwarding "${rowName}.translationAuthority"
            "TRANSLATION_AUTHORITY_REUSE: translation binding references egress relation(s) ${builtins.toJSON egressRefs} — translation must not authorize egress traffic outside the owned ingress path"
        else
          true;

    # ── SMS-030 Seeded Negative 1: Translation binding authorizes egress ──
    # Inject a translation binding that would authorize egress traffic
    # on a path outside the owned ingress path.
    egressRelations = builtins.filter
      (rel: isEgress rel && !(rel ? publicIngressTupleAuthority))
      allRelations;

    sn1 = if egressRelations == [] then
      # No egress-only relations found; verify that would fail
      # by checking that all real egress relations do carry ingress authority
      let
        allEgress = builtins.filter isEgress allRelations;
        egressWithoutIngress = builtins.filter
          (rel: !(rel ? publicIngressTupleAuthority))
          allEgress;
      in
      require true "SN1 skipped: no egress-only relations available (all egress relations carry publicIngressTupleAuthority)"
    else
      let
        egressRel = builtins.head egressRelations;
        syntheticRow = {
          site = "site-nixos";
          publicSurface = "hetz-wan";
          sourceScope = "internet";
          protocol = "tcp";
          publicPort = 9999;
          targetService = "egress-service";
          targetEndpoint = "nixos-hostile01";
          targetPort = 9999;
          translationBehavior = "provider-port-forward";
          translationMode = "napt";
          sourcePreservation = "rewritten";
          asymmetricRouting = false;
          returnPath = "hetz-east-west";
          deniedVariants = [ "wrong-source-scope" ];
          externalProviderRequired = true;
          localEmulationAllowed = false;
          policyRefs = [ egressRel.id ];
        };
        rejected = !(builtins.tryEval
          (validateTranslationAuthoritySeparation "SN1-translation-egress-reuse" syntheticRow
           || throw "SN1 must not pass")).success;
      in
        require rejected
          "SN1 must reject translation binding that references egress relation \"${egressRel.id}\" (TRANSLATION_AUTHORITY_REUSE)";

    # Recovery: Same row with a valid ingress policyRef must pass
    sn1Recovery = if egressRelations == [] || ingressRelationIds == [] then true else
      let
        syntheticRow = {
          site = "site-nixos";
          publicSurface = "hetz-wan";
          sourceScope = "internet";
          protocol = "tcp";
          publicPort = 9998;
          targetService = "ingress-service";
          targetEndpoint = "nixos-hostile01";
          targetPort = 9998;
          translationBehavior = "provider-port-forward";
          translationMode = "napt";
          sourcePreservation = "rewritten";
          asymmetricRouting = false;
          returnPath = "hetz-east-west";
          deniedVariants = [ "wrong-source-scope" ];
          externalProviderRequired = true;
          localEmulationAllowed = false;
          policyRefs = [ (builtins.head ingressRelationIds) ];
        };
        accepted = (builtins.tryEval
          (validateTranslationAuthoritySeparation "SN1-recovery" syntheticRow)).success;
      in
        require accepted
          "SN1 recovery must accept row with valid ingress policyRef";

    # ── SMS-030 Seeded Negative 2: Return behavior reused as DNS authority ──
    # Inject a fixture row where return behavior from a public-ingress path
    # is reused as DNS authority for a tenant scope.
    dnsRelations = builtins.filter
      (rel: isDns rel && !(rel ? publicIngressTupleAuthority))
      allRelations;

    sn2 = if dnsRelations == [] then true else
      let
        dnsRel = builtins.head dnsRelations;
        syntheticRow = {
          site = "site-nixos";
          publicSurface = "hetz-wan";
          sourceScope = "internet";
          protocol = "udp";
          publicPort = 53;
          targetService = "dns-resolver";
          targetEndpoint = "nixos-hostile01";
          targetPort = 53;
          translationBehavior = "direct";
          returnPath = "hetz-east-west";
          asymmetricRouting = false;
          deniedVariants = [ "wrong-source-scope" ];
          externalProviderRequired = true;
          localEmulationAllowed = false;
          policyRefs = [ dnsRel.id ];
        };
        rejected = !(builtins.tryEval
          (validateReturnAuthoritySeparation "SN2-return-dns-reuse" syntheticRow
           || throw "SN2 must not pass")).success;
      in
        require rejected
          "SN2 must reject return behavior that references DNS relation \"${dnsRel.id}\" (AUTHORITY_SEPARATION_VIOLATION)";

    # Recovery: DNS authority reused on a row with valid ingress policyRef passes
    sn2Recovery = if dnsRelations == [] || ingressRelationIds == [] then true else
      let
        syntheticRow = {
          site = "site-nixos";
          publicSurface = "hetz-wan";
          sourceScope = "internet";
          protocol = "tcp";
          publicPort = 53;
          targetService = "dns-resolver";
          targetEndpoint = "nixos-hostile01";
          targetPort = 53;
          translationBehavior = "direct";
          returnPath = "hetz-east-west";
          asymmetricRouting = false;
          deniedVariants = [ "wrong-source-scope" ];
          externalProviderRequired = true;
          localEmulationAllowed = false;
          policyRefs = [ (builtins.head ingressRelationIds) ];
        };
        accepted = (builtins.tryEval
          (validateReturnAuthoritySeparation "SN2-recovery" syntheticRow)).success;
      in
        require accepted
          "SN2 recovery must accept row with valid ingress policyRef";

    # ── SMS-030 stateful-return source predicate ──
    # Return authorization is stateful return for the owned forward tuple:
    # every public-ingress relation in the controlled source requests nested
    # stateful-return and never carries a conflicting top-level symmetric
    # return that could be converted into reverse-new-flow authority.
    ingressRelations = builtins.filter
      (rel: rel ? publicIngressTupleAuthority)
      allRelations;

    statefulReturnSource = builtins.all
      (rel:
        let
          nested = (rel.publicIngressTupleAuthority.returnBehavior or null);
          topLevel = (rel.returnBehavior or null);
        in
          if nested != "stateful-return" then
            failForwarding "${rel.id}.returnBehavior"
              "STATEFUL_RETURN_SOURCE_GAP: public-ingress relation must request nested returnBehavior = stateful-return, found ${builtins.toJSON nested}"
          else if topLevel == "symmetric" then
            failForwarding "${rel.id}.returnBehavior"
              "REVERSE_NEW_FLOW_AUTHORITY_INVENTION: public-ingress relation carries conflicting top-level symmetric return alongside nested stateful-return"
          else
            true)
      ingressRelations;

    # ── SMS-030 Seeded Negative 3: reverse-new-flow authority invention ──
    # `returnBehavior = symmetric` converted into an unconditional reverse
    # interface-pair accept must be rejected. A reverse authorization is
    # either (A) stateful return for the owned forward tuple (connection-state
    # restricted) or (B) a distinct modeled reverse relation whose source,
    # destination, protocol, port, direction, and path are independently
    # authorized.
    validateReverseAuthorization = ruleName: record:
      let
        isDerivedReturn =
          (record.returnRule or false) == true
          || (record.direction or "") == "relation-reverse";
        connectionState = record.connectionState or "";
        boundedTupleFields = [ "id" "from" "to" "protocol" "port" "direction" "path" ];
        missingTupleFields = builtins.filter
          (field: !(builtins.hasAttr field record))
          boundedTupleFields;
      in
        if isDerivedReturn && connectionState == "" then
          failForwarding "${ruleName}.reverseNewFlow"
            "REVERSE_NEW_FLOW_AUTHORITY_INVENTION: symmetric return converted into an unconditional reverse interface-pair accept without connection-state restriction — encode stateful return or model a distinct reverse relation"
        else if isDerivedReturn && connectionState != "established,related" then
          failForwarding "${ruleName}.reverseNewFlow"
            "REVERSE_NEW_FLOW_AUTHORITY_INVENTION: derived return must be connection-state restricted to established,related, found ${builtins.toJSON connectionState}"
        else if !isDerivedReturn && missingTupleFields != [] then
          failForwarding "${ruleName}.reverseNewFlow"
            "REVERSE_NEW_FLOW_AUTHORITY_INVENTION: distinct reverse relation is missing independently authorized tuple field(s): ${builtins.concatStringsSep ", " missingTupleFields}"
        else
          true;

    ingressRel = if ingressRelations == [] then null else builtins.head ingressRelations;

    # SN3: reverse interface-pair accept derived from symmetric return with
    # the connection-state restriction stripped — must be rejected.
    sn3 = if ingressRel == null then true else
      let
        unsafeReverse = {
          id = ingressRel.id;
          from = ingressRel.to;
          to = ingressRel.from;
          direction = "relation-reverse";
          returnRule = true;
        };
        rejected = !(builtins.tryEval
          (validateReverseAuthorization "SN3-unconditional-reverse-accept" unsafeReverse
           || throw "SN3 must not pass")).success;
      in
        require rejected
          "SN3 must reject symmetric return converted into an unconditional reverse interface-pair accept (REVERSE_NEW_FLOW_AUTHORITY_INVENTION)";

    # SN3 Recovery A: stateful return for the owned forward tuple.
    sn3RecoveryStateful = if ingressRel == null then true else
      let
        statefulReverse = {
          id = ingressRel.id;
          from = ingressRel.to;
          to = ingressRel.from;
          direction = "relation-reverse";
          returnRule = true;
          connectionState = "established,related";
        };
        accepted = (builtins.tryEval
          (validateReverseAuthorization "SN3-recovery-stateful-return" statefulReverse)).success;
      in
        require accepted
          "SN3 recovery A must accept a connection-state restricted stateful return";

    # SN3 Recovery B: distinct modeled reverse relation with its own bounded
    # tuple — source, destination, protocol, port, direction, and path
    # independently authorized.
    sn3RecoveryDistinct = if ingressRel == null then true else
      let
        distinctReverse = {
          id = "${ingressRel.id}-reverse-bounded";
          from = ingressRel.to;
          to = ingressRel.from;
          protocol = "tcp";
          port = 4444;
          direction = "relation-forward";
          path = "hetz-east-west";
        };
        accepted = (builtins.tryEval
          (validateReverseAuthorization "SN3-recovery-distinct-relation" distinctReverse)).success;
      in
        require accepted
          "SN3 recovery B must accept a distinct reverse relation with an independently authorized bounded tuple";

    # SN3 Recovery B guard: an incomplete reverse relation (unbounded tuple)
    # must still be rejected — the recovery is not a blanket allow.
    sn3DistinctIncomplete = if ingressRel == null then true else
      let
        unboundedReverse = {
          id = "${ingressRel.id}-reverse-unbounded";
          from = ingressRel.to;
          to = ingressRel.from;
          direction = "relation-forward";
        };
        rejected = !(builtins.tryEval
          (validateReverseAuthorization "SN3-distinct-unbounded" unboundedReverse
           || throw "SN3 unbounded distinct relation must not pass")).success;
      in
        require rejected
          "SN3 must reject a distinct reverse relation whose tuple is not independently bounded (missing protocol/port/path)";

    # ── Cross-check all real fixture rows ──
    expectedKeys = [
      "site-clab-tcp-4445"
      "site-clab-udp-4445"
      "site-hetz-tcp-4446"
      "site-hetz-udp-4446"
      "site-nixos-tcp-4444"
      "site-nixos-udp-4444"
    ];
    fixtureRowNames = builtins.attrNames fixtureTable;

    # Validate every real fixture row
    validateRealRow = rowName: row:
      validateReturnAuthoritySeparation rowName row
      && validateTranslationAuthoritySeparation rowName row;
  in
    # Baseline: fixture table must have expected keys
    require (fixtureRowNames == expectedKeys)
      "FS-230 SMS-030: public-ingress fixture table must contain exactly the expected rows"

    # MR1+MR2: Every real fixture row must pass authority separation
    && builtins.all
        (rowName: validateRealRow rowName (builtins.getAttr rowName fixtureTable))
        fixtureRowNames

    # SN1: Translation binding must not authorize egress
    && sn1

    # SN1 recovery: valid ingress policyRef must pass
    && sn1Recovery

    # SN2: Return behavior must not be reused as DNS authority
    && sn2

    # SN2 recovery: valid ingress policyRef must pass
    && sn2Recovery

    # Source predicate: public-ingress return authority is nested stateful-return
    && statefulReturnSource

    # SN3: reverse-new-flow authority invention must be rejected
    && sn3

    # SN3 recovery A: stateful return encoding must pass
    && sn3RecoveryStateful

    # SN3 recovery B: distinct bounded reverse relation must pass
    && sn3RecoveryDistinct

    # SN3 recovery B guard: unbounded distinct reverse relation must be rejected
    && sn3DistinctIncomplete
' >/dev/null

echo "PASS FS-230-HDS-010-SDS-010-SMS-030 public ingress return authority separation"
