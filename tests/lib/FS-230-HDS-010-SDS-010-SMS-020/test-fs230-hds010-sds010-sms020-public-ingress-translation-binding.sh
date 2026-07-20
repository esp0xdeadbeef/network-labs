#!/usr/bin/env bash
# GAMP-ID: FS-230-HDS-010-SDS-010-SMS-020
# GAMP-SCOPE: software-module-test
# SMS: Public Ingress Translation Binding Module
# Construction Handoff: Validate that every public-ingress fixture row using
# translation binds explicit translationMode, sourcePreservation, and hairpin
# expectations. Fail closed when translation binding fields are missing or
# ambiguous, per FS-230.
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
lab_dir="${repo_root}/GAMP/SAT"

nix eval --impure --expr '
  let
    fixtureTable = import '"${lab_dir}"'/public-ingress-fixture-table.nix;
    require = cond: msg: if cond then true else throw msg;
    failForwarding = path: message: throw "${path}: ${message}";

    # ── SMS-020 Module Responsibilities ──

    # P1: Every fixture row with translationBehavior in a set that uses
    # translation must declare an explicit translationMode (NAPT, NAT, NAT66).
    translationUsesMode = tb:
      builtins.elem tb [ "provider-port-forward" "hairpin" ];

    knownTranslationModes = [
      "napt"
      "nat"
      "nat66"
      "passthrough"
    ];

    validateTranslationMode = rowName: row:
      if translationUsesMode (row.translationBehavior or "") then
        let
          tm = row.translationMode or null;
        in
        if tm == null || tm == "" then
          failForwarding "${rowName}.translationMode"
            "AMBIGUOUS_TRANSLATION_MODE: translation is used (translationBehavior=${row.translationBehavior or ""}) but translationMode is missing; must specify napt, nat, nat66, or passthrough"
        else if !builtins.elem tm knownTranslationModes then
          failForwarding "${rowName}.translationMode"
            "AMBIGUOUS_TRANSLATION_MODE: translationMode must be a known mode (napt/nat/nat66/passthrough), got \"${tm}\""
        else
          true
      else
        true;

    # P2: Every fixture row using translation must declare explicit
    # sourcePreservation (whether source address is preserved or rewritten).
    validateSourcePreservation = rowName: row:
      if translationUsesMode (row.translationBehavior or "") then
        let
          sp = row.sourcePreservation or null;
        in
        if sp == null || sp == "" then
          failForwarding "${rowName}.sourcePreservation"
            "MISSING_SOURCE_PRESERVATION: translation is used but sourcePreservation is not declared; must be \"preserved\" or \"rewritten\""
        else if !builtins.elem sp [ "preserved" "rewritten" ] then
          failForwarding "${rowName}.sourcePreservation"
            "AMBIGUOUS_SOURCE_PRESERVATION: sourcePreservation must be \"preserved\" or \"rewritten\", got \"${sp}\""
        else
          true
      else
        true;

    # P3: When translationBehavior is "hairpin", hairpin binding must be
    # explicitly modeled (hairpinAuthorized = true).
    validateHairpinBinding = rowName: row:
      if (row.translationBehavior or "") == "hairpin" then
        if !((row.hairpinAuthorized or false) == true) then
          failForwarding "${rowName}.translationBehavior"
            "HAIRPIN_TRANSLATION_NOT_MODELED: translationBehavior=hairpin requires explicit hairpinAuthorized=true"
        else
          true
      else
        true;

    # P4: asymmetricRouting expectation must be explicit when translation is used.
    validateAsymmetricRouting = rowName: row:
      if translationUsesMode (row.translationBehavior or "") then
        let
          ar = row.asymmetricRouting or null;
        in
        if ar == null then
          failForwarding "${rowName}.asymmetricRouting"
            "MISSING_ASYMMETRIC_ROUTING_BINDING: translation is used but asymmetricRouting expectation is not declared"
        else if !(builtins.isBool ar) then
          failForwarding "${rowName}.asymmetricRouting"
            "INVALID_ASYMMETRIC_ROUTING: asymmetricRouting must be true or false, got \"${builtins.typeOf ar}\""
        else
          true
      else
        true;

    # ── SMS-020 Seeded Negative 1: Translation mode is ambiguous ──
    # Construct a row with translationBehavior=provider-port-forward but
    # no translationMode → must fail closed.
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
      returnPath = "hetz-east-west";
      sourcePreservation = "rewritten";
      asymmetricRouting = false;
      # translationMode intentionally omitted
      deniedVariants = [ "wrong-source-scope" "missing-return-path" ];
      externalProviderRequired = true;
      localEmulationAllowed = false;
      policyRefs = [ "allow-wan-to-nixos-hostile-4444" ];
    };
    sn1Rejected = !(builtins.tryEval (validateTranslationMode "SN1-ambiguous-mode" sn1Input)).success;

    # Recovery: Same row with translationMode = "napt" shall pass.
    sn1RecoveryInput = sn1Input // { translationMode = "napt"; };
    sn1RecoveryPass = (builtins.tryEval (validateTranslationMode "SN1-recovery" sn1RecoveryInput)).success;

    # ── SMS-020 Seeded Negative 2: Hairpin translation required but not modeled ──
    # Construct a row with translationBehavior=hairpin targeting same-site
    # endpoint, but hairpinAuthorized omitted → must fail closed.
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
      translationMode = "napt";
      returnPath = "hetz-east-west";
      sourcePreservation = "rewritten";
      asymmetricRouting = false;
      # hairpinAuthorized intentionally omitted
      deniedVariants = [ "wrong-source-scope" "missing-return-path" ];
      externalProviderRequired = false;
      localEmulationAllowed = true;
      policyRefs = [ "allow-wan-to-clab-client-4445" ];
    };
    sn2Rejected = !(builtins.tryEval (validateHairpinBinding "SN2-hairpin-not-modeled" sn2Input)).success;

    # Recovery: Same row with hairpinAuthorized = true shall pass.
    sn2RecoveryInput = sn2Input // { hairpinAuthorized = true; };
    sn2RecoveryPass = (builtins.tryEval (validateHairpinBinding "SN2-recovery" sn2RecoveryInput)).success;

    # ── SMS-020 translation decision emission ──
    # Module emission surface for the explicit no-translation decision and the
    # tuple-owned translation contract. translationMode = "none" is an explicit
    # no-translation decision: no DNAT, SNAT, or masquerade primitive may be
    # requested for that tuple. A DNAT-capable mode emits a translation
    # contract only when the tuple supplies the translated endpoint,
    # sourcePreservation, and return fields.
    dnatCapableModes = [ "napt" "nat" "nat66" ];

    emitTranslationDecision = rowName: row:
      let
        tm = row.translationMode or null;
      in
      if tm == "none" then
        {
          decision = "no-translation";
          ingressPath = rowName;
          owner = rowName;
          translationPrimitives = [ ];
        }
      else if builtins.elem tm dnatCapableModes then
        let
          te = row.translatedEndpoint or null;
          sp = row.sourcePreservation or null;
          rp = row.returnPath or null;
        in
        if te == null then
          failForwarding "${rowName}.translatedEndpoint"
            "MISSING_TRANSLATED_ENDPOINT: translationMode=${tm} requires an explicit translated endpoint before a translation contract may be emitted"
        else if sp == null || !builtins.elem sp [ "preserved" "rewritten" ] then
          failForwarding "${rowName}.sourcePreservation"
            "MISSING_SOURCE_PRESERVATION: translationMode=${tm} requires explicit sourcePreservation before a translation contract may be emitted"
        else if rp == null || rp == "" then
          failForwarding "${rowName}.returnPath"
            "MISSING_RETURN_FIELDS: translationMode=${tm} requires explicit return fields before a translation contract may be emitted"
        else
          {
            decision = "translation-contract";
            ingressPath = rowName;
            owner = rowName;
            mode = tm;
            sourcePreservation = sp;
            returnPath = rp;
            translatedEndpoint = te;
            translationPrimitives =
              [ "dnat" ] ++ (if sp == "rewritten" then [ "snat" ] else [ ]);
          }
      else
        failForwarding "${rowName}.translationMode"
          "AMBIGUOUS_TRANSLATION_MODE: cannot emit a translation decision without an explicit translationMode (none or a DNAT-capable mode)";

    translationPrimitiveNames = [ "dnat" "snat" "masquerade" ];

    validateNoTranslationEmission = rowName: row: emitted:
      if (row.translationMode or null) == "none" then
        if builtins.any (p: builtins.elem p translationPrimitiveNames)
          (emitted.translationPrimitives or [ ]) then
          failForwarding "${rowName}.translationMode"
            "NO_TRANSLATION_DECISION_VIOLATED: translationMode=none for ingress path ${rowName} but a DNAT/SNAT/masquerade primitive was emitted"
        else if (emitted.decision or null) != "no-translation" then
          failForwarding "${rowName}.translationMode"
            "NO_TRANSLATION_DECISION_VIOLATED: translationMode=none for ingress path ${rowName} requires an explicit no-translation decision"
        else
          true
      else
        true;

    # ── SMS-020 Seeded Negative 3: Explicit no-translation mode emits DNAT ──
    # Otherwise complete public-ingress tuple with translationMode = "none".
    sn3Input = {
      site = "site-hetz";
      publicSurface = "hetz-wan";
      sourceScope = "internet";
      protocol = "tcp";
      publicPort = 7777;
      targetService = "hetz-client-7777";
      targetEndpoint = "hetz-client01";
      targetPort = 7777;
      translationBehavior = "direct";
      translationMode = "none";
      returnPath = "hetz-local";
      asymmetricRouting = false;
      deniedVariants = [ "wrong-source-scope" "missing-return-path" ];
      externalProviderRequired = false;
      localEmulationAllowed = true;
      policyRefs = [ "allow-wan-to-hetz-client-7777" ];
    };

    # Good emission: explicit no-translation decision, zero primitives.
    sn3Decision = emitTranslationDecision "SN3-no-translation" sn3Input;
    sn3DecisionExplicit =
      sn3Decision.decision == "no-translation"
      && sn3Decision.translationPrimitives == [ ]
      && sn3Decision.ingressPath == "SN3-no-translation";
    sn3GoodAccepted =
      (builtins.tryEval
        (validateNoTranslationEmission "SN3-no-translation" sn3Input sn3Decision)).success;

    # Active negative: a contaminated artifact set that carries a DNAT request
    # under translationMode=none must be rejected with a diagnostic naming the
    # ingress path (any translation artifact is a failure).
    sn3ContaminatedDnat = sn3Decision // { translationPrimitives = [ "dnat" ]; };
    sn3DnatRejected =
      !(builtins.tryEval
        (validateNoTranslationEmission "SN3-no-translation" sn3Input sn3ContaminatedDnat)).success;
    sn3ContaminatedMasq = sn3Decision // { translationPrimitives = [ "masquerade" ]; };
    sn3MasqRejected =
      !(builtins.tryEval
        (validateNoTranslationEmission "SN3-no-translation" sn3Input sn3ContaminatedMasq)).success;
    sn3ContaminatedContract = sn3Decision // { decision = "translation-contract"; };
    sn3ContractRejected =
      !(builtins.tryEval
        (validateNoTranslationEmission "SN3-no-translation" sn3Input sn3ContaminatedContract)).success;

    # Recovery: change only the translation mode of the same tuple to an
    # explicit DNAT-capable mode and supply translated endpoint,
    # sourcePreservation, and return fields. Only then may the tuple-owned
    # translation contract emit.
    sn3RecoveryInput = sn3Input // {
      translationBehavior = "provider-port-forward";
      translationMode = "napt";
      translatedEndpoint = "hetz-client01";
      sourcePreservation = "rewritten";
      returnPath = "hetz-local";
    };
    sn3RecoveryDecision = emitTranslationDecision "SN3-recovery" sn3RecoveryInput;
    sn3RecoveryContract =
      sn3RecoveryDecision.decision == "translation-contract"
      && sn3RecoveryDecision.mode == "napt"
      && sn3RecoveryDecision.owner == "SN3-recovery"
      && sn3RecoveryDecision.sourcePreservation == "rewritten"
      && sn3RecoveryDecision.returnPath == "hetz-local"
      && builtins.elem "dnat" sn3RecoveryDecision.translationPrimitives;

    # Guard: explicit selection alone is not enough — a DNAT-capable mode
    # without the translated endpoint must fail closed, not emit a contract.
    sn3IncompleteRejected =
      !(builtins.tryEval
        (builtins.deepSeq
          (emitTranslationDecision "SN3-incomplete"
            (builtins.removeAttrs sn3RecoveryInput [ "translatedEndpoint" ]))
          true)).success;

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
      validateTranslationMode rowName row
      && validateSourcePreservation rowName row
      && validateHairpinBinding rowName row
      && validateAsymmetricRouting rowName row;
  in
    # Baseline: fixture table must have expected keys
    require (builtins.attrNames fixtureTable == expectedKeys)
      "public-ingress translation binding: fixture table must contain exactly the expected rows"

    # P1+P2+P3+P4: Every real fixture row using translation must have valid binding
    && validateRow "site-clab-tcp-4445" fixtureTable.site-clab-tcp-4445
    && validateRow "site-clab-udp-4445" fixtureTable.site-clab-udp-4445
    && validateRow "site-hetz-tcp-4446" fixtureTable.site-hetz-tcp-4446
    && validateRow "site-hetz-udp-4446" fixtureTable.site-hetz-udp-4446
    && validateRow "site-nixos-tcp-4444" fixtureTable.site-nixos-tcp-4444
    && validateRow "site-nixos-udp-4444" fixtureTable.site-nixos-udp-4444

    # SN1: Missing translationMode must reject
    && require sn1Rejected
      "SN1 must reject fixture row with translation but missing translationMode (AMBIGUOUS_TRANSLATION_MODE)"

    # SN1 recovery: Same row with translationMode must pass
    && require sn1RecoveryPass
      "SN1 recovery must accept fixture row after adding translationMode=napt"

    # SN2: Hairpin without hairpinAuthorized must reject
    && require sn2Rejected
      "SN2 must reject fixture row with hairpin translation without explicit hairpinAuthorized (HAIRPIN_TRANSLATION_NOT_MODELED)"

    # SN2 recovery: Same row with hairpinAuthorized must pass
    && require sn2RecoveryPass
      "SN2 recovery must accept fixture row after adding hairpinAuthorized=true"

    # SN3: translationMode=none must emit an explicit no-translation decision
    # with zero translation primitives
    && require sn3DecisionExplicit
      "SN3 must emit an explicit no-translation decision with no translation primitives for translationMode=none"

    && require sn3GoodAccepted
      "SN3 no-translation decision with zero primitives must be accepted"

    # SN3 active negative: any DNAT/SNAT/masquerade artifact under
    # translationMode=none is a failure (NO_TRANSLATION_DECISION_VIOLATED)
    && require sn3DnatRejected
      "SN3 must reject a DNAT request emitted for translationMode=none (NO_TRANSLATION_DECISION_VIOLATED)"

    && require sn3MasqRejected
      "SN3 must reject a masquerade request emitted for translationMode=none (NO_TRANSLATION_DECISION_VIOLATED)"

    && require sn3ContractRejected
      "SN3 must reject a translation contract emitted for translationMode=none (NO_TRANSLATION_DECISION_VIOLATED)"

    # SN3 recovery: explicit DNAT-capable mode plus translated endpoint,
    # sourcePreservation, and return fields emits the tuple-owned contract
    && require sn3RecoveryContract
      "SN3 recovery must emit tuple-owned translation contract only after explicit DNAT-capable mode with translated endpoint, sourcePreservation, and return fields"

    # SN3 guard: DNAT-capable mode without translated endpoint fails closed
    && require sn3IncompleteRejected
      "SN3 guard must fail closed when a DNAT-capable mode lacks the translated endpoint (MISSING_TRANSLATED_ENDPOINT)"

    # Boundary: rows with translationBehavior that does NOT use translation
    # (e.g. "direct" or "none") must not require translationMode or sourcePreservation
    && require ((builtins.tryEval (validateTranslationMode "no-translation" {
      translationBehavior = "direct";
      returnPath = "some-path";
      asymmetricRouting = false;
    })).success)
      "rows with translationBehavior=direct must not require translationMode"

    && require ((builtins.tryEval (validateSourcePreservation "no-translation" {
      translationBehavior = "none";
      returnPath = "some-path";
      asymmetricRouting = false;
    })).success)
      "rows with translationBehavior=none must not require sourcePreservation"
' >/dev/null

echo "PASS FS-230-HDS-010-SDS-010-SMS-020 public ingress translation binding"
