#!/usr/bin/env bash
# GAMP-ID: FS-210-HDS-010-SDS-010-SMS-030
# GAMP-SCOPE: software-module-test
#
# FS-210-HDS-010-SDS-010-SMS-030: Public Ingress Authority Separation Module
# Construction test: validates that public-ingress fixture rows do NOT reference
# policyRefs drawn from management, DNS, overlay, provider-egress, or tenant
# authority records that lack explicit publicIngressTupleAuthority.
# Exercises seeded negatives per SMS-030.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/GAMP/SAT"

nix eval --impure --expr '
  let
    fixtureTable = import '"${lab_dir}"'/public-ingress-fixture-table.nix;
    intent = import '"${lab_dir}"'/intent.nix;
    require = c: msg: if c then true else throw msg;

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

    # Relations that DO NOT carry publicIngressTupleAuthority (the "other" set)
    nonIngressRelations = builtins.filter
      (rel: !(rel ? publicIngressTupleAuthority))
      allRelations;

    # ── SMS-030 authority classifiers ──
    # These identify relations whose authority type should NOT be used
    # as a public-ingress policyRef unless they ALSO carry explicit
    # publicIngressTupleAuthority.

    # Management-like: to.kind or to.name targets mgmt scope
    isManagement = rel:
      let
        toKind = rel.to.kind or "";
        toName = rel.to.name or "";
        fromKind = rel.from.kind or "";
        fromName = rel.from.name or "";
      in
        toKind == "mgmt" || toName == "mgmt" || fromKind == "mgmt" || fromName == "mgmt";

    # DNS-like: trafficType is "dns" or to.name includes "dns"
    isDns = rel:
      rel.trafficType or "" == "dns" ||
      (builtins.match ".*dns.*" (rel.to.name or "")) != null;

    # Overlay-like: trafficType is nebula/wireguard/overlay
    isOverlay = rel:
      let tt = rel.trafficType or ""; in
      tt == "nebula" || tt == "wireguard" || tt == "overlay";

    # Provider-egress-like: from.uplinks non-empty AND generic egress trafficType
    isProviderEgress = rel:
      let
        uplinks = rel.from.uplinks or [];
        tt = rel.trafficType or "";
      in
        uplinks != [] && (tt == "any" || tt == "internet" || tt == "wan");

    # Tenant-only: to.kind is "tenant" or "tenant-set" AND from.kind is not external
    isTenantOnly = rel:
      let
        toKind = rel.to.kind or "";
        fromKind = rel.from.kind or "";
      in
        (toKind == "tenant" || toKind == "tenant-set") &&
        fromKind != "external";

    # ── SMS-030 MR1: All fixture policyRefs must reference ingress-authorized relations ──
    # (Shared with SMS-010 but re-verified here for row-local completeness)
    checkPolicyRef = rowName: row:
      let
        refs = row.policyRefs or [];
        missing = builtins.filter (ref: !(builtins.elem ref ingressRelationIds)) refs;
      in
        require (missing == [])
          "fixture row \"${rowName}\": policyRefs ${builtins.toJSON missing} do not reference relations with publicIngressTupleAuthority — UNRESOLVED_TARGET_ENDPOINT";

    # ── SMS-030 MR2-MR5: No fixture policyRef references a non-ingress relation
    #    that matches management/DNS/overlay/provider-egress/tenant authority patterns ──
    classifyUnauthorizedRefs = rowName: row:
      let
        refs = row.policyRefs or [];
        nonIngressRefs = builtins.filter
          (ref: !(builtins.elem ref ingressRelationIds))
          refs;
        # For each non-ingress ref, check if it matches an authority pattern
        classifyRef = ref:
          let
            rel = builtins.getAttr ref relById;
            classes = []
              ++ (if isManagement rel then [ "management" ] else [])
              ++ (if isDns rel then [ "DNS" ] else [])
              ++ (if isOverlay rel then [ "overlay" ] else [])
              ++ (if isProviderEgress rel then [ "provider-egress" ] else [])
              ++ (if isTenantOnly rel then [ "tenant" ] else []);
          in
            if classes != [] then "${ref} (${builtins.concatStringsSep ", " classes})" else null;

        classified = builtins.filter (s: s != null)
          (builtins.map classifyRef nonIngressRefs);
      in
        require (classified == [])
          "fixture row \"${rowName}\": policyRef(s) ${builtins.toJSON classified} reference non-ingress relations with conflicting authority types — public ingress must not reuse management/DNS/overlay/provider-egress/tenant authority";

    # ── SMS-030 SN1: Ingress reuses management reachability ──
    # Synthetic fixture row whose policyRefs point to a management-only relation
    # (one without publicIngressTupleAuthority). Must REJECT with diagnostic
    # naming the unauthorized authority source (management).
    sn1ManagementRef = builtins.filter
      (rel: isManagement rel && !(rel ? publicIngressTupleAuthority))
      nonIngressRelations;

    sn1 = if sn1ManagementRef == [] then true else
      !(builtins.tryEval
        (let
          mgmtRel = builtins.head sn1ManagementRef;
          syntheticRow = {
            site = "site-nixos";
            publicSurface = "wan";
            sourceScope = "internet";
            protocol = "tcp";
            publicPort = 9999;
            targetService = "mgmt";
            targetEndpoint = "mgmt-endpoint";
            targetPort = 22;
            policyRefs = [ mgmtRel.id ];
          };
        in
          classifyUnauthorizedRefs "SN1-ingress-reuses-management" syntheticRow
          || throw "SN1 must not pass"
        )).success;

    # ── SMS-030 SN2: Ingress authorized from DNS/overlay/provider-egress authority ──
    # Synthetic fixture rows whose policyRefs point to DNS/overlay/provider-egress
    # relations without publicIngressTupleAuthority. Must REJECT with diagnostic
    # naming the incorrect authority source.

    sn2DnsRef = builtins.filter
      (rel: isDns rel && !(rel ? publicIngressTupleAuthority))
      nonIngressRelations;

    sn2_dns = if sn2DnsRef == [] then true else
      !(builtins.tryEval
        (let
          dnsRel = builtins.head sn2DnsRef;
          syntheticRow = {
            site = "site-nixos";
            publicSurface = "wan";
            sourceScope = "internet";
            protocol = "udp";
            publicPort = 53;
            targetService = "dns-service";
            targetEndpoint = "dns-endpoint";
            targetPort = 53;
            policyRefs = [ dnsRel.id ];
          };
        in
          classifyUnauthorizedRefs "SN2-ingress-reuses-dns" syntheticRow
          || throw "SN2 DNS must not pass"
        )).success;

    sn2OverlayRef = builtins.filter
      (rel: isOverlay rel && !(rel ? publicIngressTupleAuthority))
      nonIngressRelations;

    sn2_overlay = if sn2OverlayRef == [] then true else
      !(builtins.tryEval
        (let
          ovRel = builtins.head sn2OverlayRef;
          syntheticRow = {
            site = "site-nixos";
            publicSurface = "wan";
            sourceScope = "internet";
            protocol = "udp";
            publicPort = 4242;
            targetService = "nebula-service";
            targetEndpoint = "nebula-endpoint";
            targetPort = 4242;
            policyRefs = [ ovRel.id ];
          };
        in
          classifyUnauthorizedRefs "SN2-ingress-reuses-overlay" syntheticRow
          || throw "SN2 overlay must not pass"
        )).success;

    # SN2-correct: A fixture row referencing a valid ingress relation
    # (one WITH publicIngressTupleAuthority) must PASS.
    sn2_correct = if ingressRelationIds == [] then
      false
    else
      let
        correctRel = builtins.head ingressRelationIds;
        correctRow = {
          site = "site-nixos";
          publicSurface = "wan";
          sourceScope = "internet";
          protocol = "tcp";
          publicPort = 8080;
          targetService = "my-service";
          targetEndpoint = "my-endpoint";
          targetPort = 8080;
          policyRefs = [ correctRel ];
        };
      in
        builtins.tryEval
          (checkPolicyRef "SN2-correct-ingress" correctRow
           && classifyUnauthorizedRefs "SN2-correct-ingress" correctRow
          );

    # ── Enumerate all fixture rows ──
    fixtureRowNames = builtins.attrNames fixtureTable;
    expectedKeys = [
      "site-clab-tcp-4445"
      "site-clab-udp-4445"
      "site-hetz-tcp-4446"
      "site-hetz-udp-4446"
      "site-nixos-tcp-4444"
      "site-nixos-udp-4444"
    ];
  in
    # Baseline: fixture table shape
    require (fixtureRowNames == expectedKeys)
      "public-ingress fixture table must contain exactly the expected rows"

    # MR1: Every fixture row policyRef must reference a relation with publicIngressTupleAuthority
    && builtins.all
        (rowName:
          checkPolicyRef rowName (builtins.getAttr rowName fixtureTable))
        fixtureRowNames

    # MR2-MR5: No fixture row policyRef references non-ingress authority
    && builtins.all
        (rowName:
          classifyUnauthorizedRefs rowName (builtins.getAttr rowName fixtureTable))
        fixtureRowNames

    # SN1: must reject management authority reuse
    && require sn1
      "SN1 must reject public-ingress policyRef that references management-only relation (diagnostic must name management authority)"

    # SN2-DNS: must reject DNS authority reuse
    && require sn2_dns
      "SN2-DNS must reject public-ingress policyRef that references DNS-only relation (diagnostic must name DNS authority)"

    # SN2-OVERLAY: must reject overlay authority reuse
    && require sn2_overlay
      "SN2-OVERLAY must reject public-ingress policyRef that references overlay-only relation (diagnostic must name overlay authority)"

    # SN2-CORRECT: valid ingress policyRef must pass
    && require sn2_correct.success
      "SN2-CORRECT must pass: fixture row referencing a relation with publicIngressTupleAuthority must satisfy all separation checks"
' >/dev/null

echo "PASS FS-210-HDS-010-SDS-010-SMS-030 public-ingress-authority-separation"
