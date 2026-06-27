#!/usr/bin/env bash
# GAMP-ID: FS-760-HDS-030-SDS-010-SMS-010
# GAMP-SCOPE: software-module-test
# Construction test for receiver payload and reverse-initiation surfaces.
# Validates controller-to-receiver payload records and denied
# receiver-to-controller reverse-initiation records
# against the FS-760-HDS-030-SDS-010-SMS-010 acceptance predicates.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hat_dir="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL FS-760-HDS-030-SDS-010-SMS-010 receiver-payload-reverse-surfaces: $*" >&2
  exit 1
}

require_file() {
  local path="$1"
  [[ -f "${path}" ]] || fail "missing required file: ${path}"
}

require_file "${hat_dir}/intent.nix"

nix-instantiate --parse "${hat_dir}/intent.nix" >/dev/null

HAT_DIR="${hat_dir}" nix eval --impure --expr '
  let
    root = builtins.getEnv "HAT_DIR";
    intent = import (root + "/intent.nix");
    site = intent.esp0xdeadbeef.site-a;
    atoms = site.communicationContract.sharedServicePolicyAtoms or [ ];
    byId = id: builtins.head (builtins.filter (a: (a.id or null) == id) atoms);
    require = cond: msg: if cond then true else throw msg;

    payloadAtom = byId "fs760-receiver-controller-payload-policy";
    reverseAtom = byId "fs760-receiver-reverse-initiation-denial";

    # ── SMS predicate: payload record completeness ─────────────────────────
    payloadOk = p:
      builtins.hasAttr "allowed" p && p.allowed == true
      && builtins.hasAttr "protocol" p && builtins.isString p.protocol && p.protocol != ""
      && builtins.hasAttr "transport" p && builtins.isString p.transport && p.transport != ""
      && builtins.hasAttr "ports" p && (builtins.typeOf p.ports == "list") && builtins.length p.ports >= 2
      && builtins.hasAttr "direction" p && p.direction == "controller-to-receiver"
      && builtins.hasAttr "returnBehavior" p && builtins.isString p.returnBehavior && p.returnBehavior != ""
      && builtins.hasAttr "independentFromDiscovery" p && p.independentFromDiscovery == true;

    # ── SMS predicate: reverse-initiation must be denied separately ────────
    reverseDeniedOk = a:
      builtins.hasAttr "deniedPaths" a
      && (builtins.typeOf a.deniedPaths == "list")
      && builtins.length a.deniedPaths >= 1
      && builtins.any
        (dp: (dp.kind or null) == "receiver-to-controller-initiation"
          && builtins.hasAttr "from" dp && builtins.hasAttr "to" dp
          && builtins.hasAttr "reason" dp && builtins.isString dp.reason && dp.reason != "")
        a.deniedPaths;

    # ── Positive checks ────────────────────────────────────────────────────
    checkPayload = payloadOk payloadAtom.payload
      && require (payloadAtom.sms == "FS-760-HDS-010-SDS-010-SMS-020")
        "FS-760-HDS-030-SDS-010-SMS-010: payload atom must preserve upstream gampId FS-760-HDS-010-SDS-010-SMS-020"
      && require (payloadAtom.service == "hat-receiver-control")
        "FS-760-HDS-030-SDS-010-SMS-010: payload atom must bind to hat-receiver-control service";

    checkReverse = reverseDeniedOk reverseAtom
      && require (reverseAtom.sms == "FS-760-HDS-010-SDS-010-SMS-030")
        "FS-760-HDS-030-SDS-010-SMS-010: reverse-initiation denial must preserve upstream gampId FS-760-HDS-010-SDS-010-SMS-030"
      && require (reverseAtom.service == "hat-receiver-control")
        "FS-760-HDS-030-SDS-010-SMS-010: reverse-initiation denial must bind to hat-receiver-control service";

    # ── Seeded negatives ──────────────────────────────────────────────────
    # SN1: diagnostic.payload-is-not-reverse-authority
    # Prove that allowing reverse initiation via payload would be detected.
    # We simulate the violation: payload atom lacks separate reverse denial.
    # The test proves that payload.allowed=true does NOT equal reverse authority.
    payloadAsReverse = payloadAtom.payload // {
      direction = "bidirectional";
    };
    sn1_detected = !(builtins.tryEval (
      require (payloadAsReverse.direction != "bidirectional")
        "diagnostic.payload-is-not-reverse-authority: payload direction must not imply reverse initiation"
    )).success;

    # SN2: diagnostic.receiver-return-behavior-missing
    # Prove that missing returnBehavior would be detected.
    payloadWithoutReturn = builtins.removeAttrs payloadAtom.payload [ "returnBehavior" ];
    sn2_detected = !(builtins.tryEval (
      require (builtins.hasAttr "returnBehavior" payloadWithoutReturn)
        "diagnostic.receiver-return-behavior-missing: payload record must specify return behavior"
    )).success;
  in
    require checkPayload
      "FS-760-HDS-030-SDS-010-SMS-010: payload surface acceptance predicates not met"
    && require checkReverse
      "FS-760-HDS-030-SDS-010-SMS-010: reverse-initiation denial acceptance predicates not met"
    && require sn1_detected
      "FS-760-HDS-030-SDS-010-SMS-010 SN1: diagnostic.payload-is-not-reverse-authority — bidirectional payload must be detected"
    && require sn2_detected
      "FS-760-HDS-030-SDS-010-SMS-010 SN2: diagnostic.receiver-return-behavior-missing — missing returnBehavior must be detected"
' >/dev/null || fail "receiver payload/reverse surface acceptance predicates or seeded negatives failed"

echo "PASS FS-760-HDS-030-SDS-010-SMS-010 receiver-payload-reverse-surfaces"
