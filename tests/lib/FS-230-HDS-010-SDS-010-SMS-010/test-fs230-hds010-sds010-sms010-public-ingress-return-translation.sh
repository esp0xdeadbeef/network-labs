#!/usr/bin/env bash
# GAMP-ID: FS-230-HDS-010-SDS-010-SMS-010
# GAMP-SCOPE: software-module-test
# SMS: Public Ingress Return And Translation Module
# Construction Handoff: Validate that every public-ingress fixture row binds
# explicit return behavior, and fail closed when return behavior or hairpin
# authorization is missing.
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
lab_dir="${repo_root}/GAMP/SAT"

nix eval --impure --expr '
  let
    fixtureTable = import '"${lab_dir}"'/public-ingress-fixture-table.nix;
    require = cond: msg: if cond then true else throw msg;
    failForwarding = path: message: throw "${path}: ${message}";

    # ── SMS-010 Module Responsibilities ──

    # P1: Every fixture row must declare an explicit return path.
    validateReturnPath = rowName: row:
      let
        rp = row.returnPath or null;
      in
      if rp == null || rp == "" then
        failForwarding "${rowName}.returnPath"
          "MISSING_RETURN_BEHAVIOR: public-ingress fixture row must bind explicit return behavior (returnPath)"
      else
        true;

    # P2: Every fixture row must declare an explicit translation behavior.
    validateTranslationBehavior = rowName: row:
      let
        tb = row.translationBehavior or null;
      in
      if tb == null || tb == "" then
        failForwarding "${rowName}.translationBehavior"
          "MISSING_TRANSLATION_BEHAVIOR: public-ingress fixture row must declare explicit translation behavior"
      else
        true;

    # P3: translationBehavior must be one of the known modes.
    knownTranslationBehaviors = [
      "provider-port-forward"
      "direct"
      "hairpin"
      "none"
    ];
    validateTranslationMode = rowName: row:
      let
        tb = row.translationBehavior or "";
      in
      if !builtins.elem tb knownTranslationBehaviors then
        failForwarding "${rowName}.translationBehavior"
          "AMBIGUOUS_TRANSLATION_MODE: translationBehavior must be a known mode, got \"${tb}\""
      else
        true;

    # ── SMS-010 Seeded Negative 1: Missing return behavior ──
    # Construct a fixture row with returnPath omitted.
    sn1Input = {
      site = "site-nixos";
      publicSurface = "hetz-wan";
      sourceScope = "internet";
      protocol = "tcp";
      publicPort = 9999;
      targetService = "nixos-hostile-4444";
      targetEndpoint = "nixos-hostile01";
      targetPort = 9999;
      translationBehavior = "provider-port-forward";
      # returnPath intentionally omitted
      deniedVariants = [ "wrong-source-scope" "missing-return-path" ];
      externalProviderRequired = true;
      localEmulationAllowed = false;
      policyRefs = [ "allow-wan-to-nixos-hostile-4444" ];
    };
    sn1Rejected = !(builtins.tryEval (validateReturnPath "SN1-missing-return" sn1Input)).success;

    # Recovery: Same row with returnPath shall pass.
    sn1RecoveryInput = sn1Input // { returnPath = "hetz-east-west"; };
    sn1RecoveryPass = (builtins.tryEval (validateReturnPath "SN1-recovery" sn1RecoveryInput)).success;

    # ── SMS-010 Seeded Negative 2: Hairpin required but not modeled ──
    # Construct a fixture row where translationBehavior = "hairpin" but
    # the fixture lacks a hairpin authorization record (simulated by
    # requiring that hairpin mode is not accepted without an explicit
    # hairpin authorization flag).
    hairpinAuthorizationRequired = row:
      row.translationBehavior or "" == "hairpin"
      && !((row.hairpinAuthorized or false) == true);

    validateHairpinAuthorization = rowName: row:
      if hairpinAuthorizationRequired row then
        failForwarding "${rowName}.translationBehavior"
          "HAIRPIN_RETURN_NOT_MODELED: hairpin translation requires explicit hairpin authorization"
      else
        true;

    sn2Input = {
      site = "site-clab";
      publicSurface = "hetz-wan";
      sourceScope = "internet";
      protocol = "tcp";
      publicPort = 8888;
      targetService = "clab-client-4445";
      targetEndpoint = "clab-client01";
      targetPort = 8888;
      translationBehavior = "hairpin";
      returnPath = "hetz-east-west";
      # hairpinAuthorized intentionally omitted
      deniedVariants = [ "wrong-source-scope" "missing-return-path" ];
      externalProviderRequired = false;
      localEmulationAllowed = true;
      policyRefs = [ "allow-wan-to-clab-client-4445" ];
    };
    sn2Rejected = !(builtins.tryEval (validateHairpinAuthorization "SN2-hairpin-unauthorized" sn2Input)).success;

    # Recovery: Same row with hairpinAuthorized = true shall pass.
    sn2RecoveryInput = sn2Input // { hairpinAuthorized = true; };
    sn2RecoveryPass = (builtins.tryEval (validateHairpinAuthorization "SN2-recovery" sn2RecoveryInput)).success;

    # ── Cross-check: all real fixture rows must pass validation ──
    expectedKeys = [
      "site-clab-tcp-4445"
      "site-clab-udp-4445"
      "site-hetz-tcp-4446"
      "site-hetz-udp-4446"
      "site-nixos-tcp-4444"
      "site-nixos-udp-4444"
    ];

    validateRow = rowName: row:
      validateReturnPath rowName row
      && validateTranslationBehavior rowName row
      && validateTranslationMode rowName row;
  in
    # Baseline: fixture table must have expected keys
    require (builtins.attrNames fixtureTable == expectedKeys)
      "public-ingress return translation: fixture table must contain exactly the expected rows"

    # P1+P2+P3: Every real fixture row must have valid return and translation
    && validateRow "site-clab-tcp-4445" fixtureTable.site-clab-tcp-4445
    && validateRow "site-clab-udp-4445" fixtureTable.site-clab-udp-4445
    && validateRow "site-hetz-tcp-4446" fixtureTable.site-hetz-tcp-4446
    && validateRow "site-hetz-udp-4446" fixtureTable.site-hetz-udp-4446
    && validateRow "site-nixos-tcp-4444" fixtureTable.site-nixos-tcp-4444
    && validateRow "site-nixos-udp-4444" fixtureTable.site-nixos-udp-4444

    # SN1: Missing return behavior must reject
    && require sn1Rejected
      "SN1 must reject fixture row with missing returnPath (MISSING_RETURN_BEHAVIOR)"

    # SN1 recovery: Same row with returnPath must pass
    && require sn1RecoveryPass
      "SN1 recovery must accept fixture row after adding returnPath"

    # SN2: Hairpin without authorization must reject
    && require sn2Rejected
      "SN2 must reject fixture row with hairpin translation without authorization (HAIRPIN_RETURN_NOT_MODELED)"

    # SN2 recovery: Same row with hairpinAuthorized must pass
    && require sn2RecoveryPass
      "SN2 recovery must accept fixture row after adding hairpinAuthorized"

    # Boundary: non-hairpin translationBehavior with missing hairpinAuthorized is fine
    && require ((builtins.tryEval (validateHairpinAuthorization "non-hairpin" (fixtureTable.site-nixos-tcp-4444))).success)
      "non-hairpin translationBehavior must not require hairpin authorization"
' >/dev/null

echo "PASS FS-230-HDS-010-SDS-010-SMS-010 public ingress return translation"
