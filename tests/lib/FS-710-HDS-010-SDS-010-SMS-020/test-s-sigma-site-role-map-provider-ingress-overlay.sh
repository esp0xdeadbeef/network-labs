#!/usr/bin/env bash
# GAMP-ID: FS-710-HDS-010-SDS-010-SMS-020
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
lab_dir="${repo_root}/GAMP/SAT"

nix eval --impure --expr '
  let
    roleMap = import '"${lab_dir}"'/site-role-map.nix;
    intent = import '"${lab_dir}"'/intent.nix;
    fixtureTable = import '"${lab_dir}"'/public-ingress-fixture-table.nix;
    require = cond: msg: if cond then true else throw msg;
    expectedSites = [ "site-clab" "site-hetz" "site-nixos" ];
    overlayRelationshipsFor = site:
      builtins.map
        (overlay: {
          name = overlay.name;
          peerSites = builtins.map
            (peer:
              let
                matched = builtins.match "esp\\.(.*)" peer;
              in
                "site-" + builtins.head matched)
            (overlay.peerSites or [ ]);
          terminateOn = overlay.terminateOn;
          underlayAccess = overlay.underlayAccess or null;
        })
        (site.transport.overlays or [ ]);
    expectedUpstreamRoles = {
      site-clab = [ "wan" "east-west" ];
      site-hetz = [ "wan" "wg-host128-egress" "wg-routed64" "east-west" ];
      site-nixos = [ "isp-a" "isp-b" "east-west" ];
    };
    expectedPublicIngress = {
      site-clab = {
        mode = "remote-public-target";
        ingressSite = "site-hetz";
        fixtureRefs = [
          "site-clab-tcp-4445"
          "site-clab-udp-4445"
        ];
      };
      site-hetz = {
        mode = "public-entry-provider-edge";
        ingressSite = "site-hetz";
        fixtureRefs = [
          "site-nixos-tcp-4444"
          "site-nixos-udp-4444"
          "site-clab-tcp-4445"
          "site-clab-udp-4445"
          "site-hetz-tcp-4446"
          "site-hetz-udp-4446"
        ];
      };
      site-nixos = {
        mode = "remote-public-target";
        ingressSite = "site-hetz";
        fixtureRefs = [
          "site-nixos-tcp-4444"
          "site-nixos-udp-4444"
        ];
      };
    };
    expectedInterSiteRelationships = {
      site-clab = [ "site-hetz" "site-nixos" ];
      site-hetz = [ "site-clab" "site-nixos" ];
      site-nixos = [ "site-clab" "site-hetz" ];
    };
    expectedOverlayRelationships = {
      site-clab = overlayRelationshipsFor intent.esp.clab;
      site-hetz = overlayRelationshipsFor intent.esp.hetz;
      site-nixos = overlayRelationshipsFor intent.esp.nixos;
    };
    validateRolesRecord = siteName: record:
      require (builtins.elem siteName expectedSites)
        "provider/ingress/overlay validation must reject unknown site keys"
      && (let
        expectedRoles = builtins.getAttr siteName expectedUpstreamRoles;
        expectedIngress = builtins.getAttr siteName expectedPublicIngress;
        expectedInterSite = builtins.getAttr siteName expectedInterSiteRelationships;
        expectedOverlay = builtins.getAttr siteName expectedOverlayRelationships;
      in
        require (record ? upstreamOrProviderRoles)
          "${siteName} must declare upstreamOrProviderRoles explicitly"
        && require (record ? publicIngressRole)
          "${siteName} must declare publicIngressRole explicitly"
        && require (record ? interSiteRelationships)
          "${siteName} must declare interSiteRelationships explicitly"
        && require (record ? overlayRelationships)
          "${siteName} must declare overlayRelationships explicitly"
        && require (record.upstreamOrProviderRoles == expectedRoles)
          "${siteName} upstream/provider roles must match the controlled SAT role set"
        && require (record.publicIngressRole.mode == expectedIngress.mode)
          "${siteName} publicIngressRole.mode must stay explicit"
        && require (record.publicIngressRole.ingressSite == expectedIngress.ingressSite)
          "${siteName} publicIngressRole.ingressSite must stay explicit"
        && require (record.publicIngressRole.fixtureRefs == expectedIngress.fixtureRefs)
          "${siteName} publicIngressRole.fixtureRefs must stay row-scoped and explicit"
        && require (builtins.all (ref: builtins.hasAttr ref fixtureTable) record.publicIngressRole.fixtureRefs)
          "${siteName} publicIngressRole.fixtureRefs must reference modeled public ingress rows"
        && require (record.interSiteRelationships == expectedInterSite)
          "${siteName} interSiteRelationships must match the controlled site graph"
        && require (record.overlayRelationships == expectedOverlay)
          "${siteName} overlayRelationships must match the modeled overlay relationships");
    expectValidationFailure = siteName: record: msg:
      require (!(builtins.tryEval (validateRolesRecord siteName record)).success) msg;
  in
    validateRolesRecord "site-clab" roleMap.site-clab
    && validateRolesRecord "site-hetz" roleMap.site-hetz
    && validateRolesRecord "site-nixos" roleMap.site-nixos
    && expectValidationFailure "site-nixos" (roleMap.site-nixos // {
      publicIngressRole = roleMap.site-nixos.publicIngressRole // {
        ingressSite = "site-nixos";
      };
    })
      "provider/ingress/overlay validation must reject ingress authority invented from the target site name"
    && expectValidationFailure "site-hetz" (roleMap.site-hetz // {
      upstreamOrProviderRoles = [ "site-hetz" ];
    })
      "provider/ingress/overlay validation must reject provider authority invented from fixture site names"
    && expectValidationFailure "site-clab" (roleMap.site-clab // {
      overlayRelationships = [
        {
          name = "east-west";
          peerSites = [ "site-clab" ];
          terminateOn = "clab-router-core-nebula";
          underlayAccess = null;
        }
      ];
    })
      "provider/ingress/overlay validation must reject overlay authority invented from fixture site names"
' >/dev/null

echo "PASS s-sigma-site-role-map-provider-ingress-overlay"
