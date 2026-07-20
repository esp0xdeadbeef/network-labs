#!/usr/bin/env bash
# GAMP-ID: FS-790-HDS-010-SDS-010-SMS-020
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
lab_dir="${repo_root}/GAMP/SAT"

nix eval --impure --expr '
  let
    fixtureTable = import '"${lab_dir}"'/public-ingress-fixture-table.nix;
    intent = import '"${lab_dir}"'/intent.nix;
    require = cond: msg: if cond then true else throw msg;
    expectedRows = {
      site-clab-tcp-4445 = {
        site = "site-clab";
        protocol = "tcp";
        publicPort = 4445;
        targetService = "clab-client-4445";
        targetEndpoint = "clab-client01";
        targetPort = 4445;
        translationBehavior = "provider-port-forward";
        returnPath = "hetz-east-west";
        trafficType = "tcp-udp-4445";
      };
      site-clab-udp-4445 = {
        site = "site-clab";
        protocol = "udp";
        publicPort = 4445;
        targetService = "clab-client-4445";
        targetEndpoint = "clab-client01";
        targetPort = 4445;
        translationBehavior = "provider-port-forward";
        returnPath = "hetz-east-west";
        trafficType = "tcp-udp-4445";
      };
      site-hetz-tcp-4446 = {
        site = "site-hetz";
        protocol = "tcp";
        publicPort = 4446;
        targetService = "hetz-client-4446";
        targetEndpoint = "hetz-client01";
        targetPort = 4446;
        translationBehavior = "provider-port-forward";
        returnPath = "hetz-local";
        trafficType = "tcp-udp-4446";
      };
      site-hetz-udp-4446 = {
        site = "site-hetz";
        protocol = "udp";
        publicPort = 4446;
        targetService = "hetz-client-4446";
        targetEndpoint = "hetz-client01";
        targetPort = 4446;
        translationBehavior = "provider-port-forward";
        returnPath = "hetz-local";
        trafficType = "tcp-udp-4446";
      };
      site-nixos-tcp-4444 = {
        site = "site-nixos";
        protocol = "tcp";
        publicPort = 4444;
        targetService = "nixos-hostile-4444";
        targetEndpoint = "nixos-hostile01";
        targetPort = 4444;
        translationBehavior = "provider-port-forward";
        returnPath = "hetz-east-west";
        trafficType = "tcp-udp-4444";
      };
      site-nixos-udp-4444 = {
        site = "site-nixos";
        protocol = "udp";
        publicPort = 4444;
        targetService = "nixos-hostile-4444";
        targetEndpoint = "nixos-hostile01";
        targetPort = 4444;
        translationBehavior = "provider-port-forward";
        returnPath = "hetz-east-west";
        trafficType = "tcp-udp-4444";
      };
    };
    expectedKeys = builtins.attrNames expectedRows;
    serviceProvidersMatch = serviceName: endpoint:
      let
        matches = builtins.filter
          (service: (service.name or null) == serviceName)
          intent.esp.hetz.communicationContract.services;
      in
        matches != [ ] && (builtins.head matches).providers == [ endpoint ];
    trafficTypeHas = trafficTypeName: proto: port:
      let
        matches = builtins.filter
          (trafficType: (trafficType.name or null) == trafficTypeName)
          intent.esp.hetz.communicationContract.trafficTypes;
      in
        matches != [ ]
        && builtins.any
          (match: (match.proto or null) == proto && builtins.elem port (match.dports or [ ]))
          ((builtins.head matches).match or [ ]);
    validatePortTargetRow = rowName: row:
      require (builtins.hasAttr rowName expectedRows)
        "public-ingress port/target validation must reject unknown row names"
      && (let
        expectedRow = builtins.getAttr rowName expectedRows;
      in
        require (row.site == expectedRow.site)
          "${rowName} site must stay explicit"
        && require (row.protocol == expectedRow.protocol)
          "${rowName} protocol must stay explicit"
        && require (row.publicPort == expectedRow.publicPort)
          "${rowName} publicPort must stay explicit"
        && require (row.targetService == expectedRow.targetService)
          "${rowName} targetService must stay explicit"
        && require (row.targetEndpoint == expectedRow.targetEndpoint)
          "${rowName} targetEndpoint must stay explicit"
        && require (row.targetPort == expectedRow.targetPort)
          "${rowName} targetPort must stay explicit"
        && require (row.translationBehavior == expectedRow.translationBehavior)
          "${rowName} translationBehavior must stay explicit"
        && require (row.returnPath == expectedRow.returnPath)
          "${rowName} returnPath must stay explicit"
        && require (serviceProvidersMatch expectedRow.targetService expectedRow.targetEndpoint)
          "${rowName} targetService must bind to the modeled hetz service provider"
        && require (trafficTypeHas expectedRow.trafficType expectedRow.protocol expectedRow.publicPort)
          "${rowName} protocol/publicPort must match the modeled hetz traffic type");
    expectValidationFailure = rowName: row: msg:
      require (!(builtins.tryEval (validatePortTargetRow rowName row)).success) msg;
  in
    require (builtins.attrNames fixtureTable == expectedKeys)
      "public-ingress port/target binding must emit one explicit row per public leg"
    && validatePortTargetRow "site-clab-tcp-4445" fixtureTable.site-clab-tcp-4445
    && validatePortTargetRow "site-clab-udp-4445" fixtureTable.site-clab-udp-4445
    && validatePortTargetRow "site-hetz-tcp-4446" fixtureTable.site-hetz-tcp-4446
    && validatePortTargetRow "site-hetz-udp-4446" fixtureTable.site-hetz-udp-4446
    && validatePortTargetRow "site-nixos-tcp-4444" fixtureTable.site-nixos-tcp-4444
    && validatePortTargetRow "site-nixos-udp-4444" fixtureTable.site-nixos-udp-4444
    && expectValidationFailure "site-nixos-tcp-4444" (fixtureTable.site-nixos-tcp-4444 // {
      protocol = "udp";
    })
      "public-ingress port/target binding must reject an unmodeled protocol"
    && expectValidationFailure "site-clab-tcp-4445" (fixtureTable.site-clab-tcp-4445 // {
      targetService = "site-clab";
    })
      "public-ingress port/target binding must reject target authority invented from fixture names"
    && expectValidationFailure "site-hetz-tcp-4446" (fixtureTable.site-hetz-tcp-4446 // {
      targetPort = 9999;
    })
      "public-ingress port/target binding must reject an unmodeled targetPort"
    && expectValidationFailure "site-hetz-udp-4446" (fixtureTable.site-hetz-udp-4446 // {
      translationBehavior = "direct";
    })
      "public-ingress port/target binding must reject an unmodeled translationBehavior"
    && expectValidationFailure "site-clab-udp-4445" (fixtureTable.site-clab-udp-4445 // {
      returnPath = "hetz-wan";
    })
      "public-ingress port/target binding must reject an unmodeled returnPath"
' >/dev/null

echo "PASS s-sigma-public-ingress-port-target-binding"
