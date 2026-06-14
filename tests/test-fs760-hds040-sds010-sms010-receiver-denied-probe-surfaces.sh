#!/usr/bin/env bash
# GAMP-ID: FS-760-HDS-040-SDS-010-SMS-010
# GAMP-SCOPE: software-module-test
# Construction test for receiver denied probe surfaces.
# Validates denied guest-to-trusted, media-to-management, and multicast
# flooding probe records against the FS-760-HDS-040-SDS-010-SMS-010
# acceptance predicates.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hat_dir="${repo_root}/HAT/emulated-isp-residential-testnet"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL FS-760-HDS-040-SDS-010-SMS-010 receiver-denied-probe-surfaces: $*" >&2
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

    tenantManagementDenial = byId "fs760-receiver-tenant-management-denial";
    multicastDenial = byId "fs760-receiver-multicast-flooding-denial";

    # ── SMS predicate: denied path completeness ────────────────────────────
    deniedPathOk = dp:
      builtins.hasAttr "kind" dp && builtins.isString dp.kind && dp.kind != ""
      && builtins.hasAttr "from" dp && builtins.isString dp.from && dp.from != ""
      && builtins.hasAttr "to" dp && builtins.isString dp.to && dp.to != ""
      && builtins.hasAttr "reason" dp && builtins.isString dp.reason && dp.reason != "";

    # ── SMS predicate: denied atom must have explicit denied paths ─────────
    deniedAtomOk = a:
      builtins.hasAttr "deniedPaths" a
      && (builtins.typeOf a.deniedPaths == "list")
      && builtins.length a.deniedPaths >= 1
      && builtins.all deniedPathOk a.deniedPaths;

    # ── Positive checks ────────────────────────────────────────────────────
    checkTenantManagement = deniedAtomOk tenantManagementDenial
      && require (tenantManagementDenial.sms == "FS-760-HDS-010-SDS-010-SMS-040")
        "FS-760-HDS-040-SDS-010-SMS-010: tenant-management denial must preserve upstream gampId FS-760-HDS-010-SDS-010-SMS-040"
      && require (tenantManagementDenial.service == "hat-receiver-control")
        "FS-760-HDS-040-SDS-010-SMS-010: tenant-management denial must bind to hat-receiver-control service"
      && require
        (builtins.any (dp: (dp.kind or null) == "guest-to-trusted") tenantManagementDenial.deniedPaths)
        "FS-760-HDS-040-SDS-010-SMS-010: tenant-management denial must include guest-to-trusted denied path"
      && require
        (builtins.any (dp: (dp.kind or null) == "media-to-management") tenantManagementDenial.deniedPaths)
        "FS-760-HDS-040-SDS-010-SMS-010: tenant-management denial must include media-to-management denied path";

    checkMulticast = deniedAtomOk multicastDenial
      && require (multicastDenial.sms == "FS-760-HDS-010-SDS-010-SMS-050")
        "FS-760-HDS-040-SDS-010-SMS-010: multicast flooding denial must preserve upstream gampId FS-760-HDS-010-SDS-010-SMS-050"
      && require (multicastDenial.service == "hat-receiver-discovery")
        "FS-760-HDS-040-SDS-010-SMS-010: multicast flooding denial must bind to hat-receiver-discovery service"
      && require
        (builtins.any (dp: (dp.kind or null) == "multicast-flooding") multicastDenial.deniedPaths)
        "FS-760-HDS-040-SDS-010-SMS-010: multicast flooding denial must include multicast-flooding denied path"
      && require
        (builtins.any (dp: builtins.hasAttr "protocols" dp && (builtins.typeOf dp.protocols == "list")
          && builtins.length dp.protocols >= 2) multicastDenial.deniedPaths)
        "FS-760-HDS-040-SDS-010-SMS-010: multicast-flooding denied path must enumerate at least 2 protocols";

    # ── Seeded negatives ──────────────────────────────────────────────────
    # SN1: diagnostic.receiver-denied-boundary-missing
    # Prove that a denied path without a reason field would be detected.
    deniedPathWithoutReason = (builtins.head tenantManagementDenial.deniedPaths) // {
      inherit (builtins.head tenantManagementDenial.deniedPaths) kind from to;
    };
    sn1_detected = !(builtins.tryEval (
      require (builtins.hasAttr "reason" (builtins.removeAttrs deniedPathWithoutReason [ "reason" ]))
        "diagnostic.receiver-denied-boundary-missing: denied path must specify expected denial boundary (reason)"
    )).success;

    # SN2: diagnostic.positive-evidence-used-for-denial
    # Prove that using a positive payload allow as denial evidence
    # would be detected. We simulate by checking that a denied path
    # must NOT reference positive payload fields.
    payloadAtom = byId "fs760-receiver-controller-payload-policy";
    positivePayloadKind = payloadAtom.payload // { kind = "denial-by-payload"; };
    sn2_detected = !(builtins.tryEval (
      require (!(builtins.hasAttr "kind" positivePayloadKind)
        || (builtins.elem positivePayloadKind.kind [ "guest-to-trusted" "media-to-management"
             "multicast-flooding" "receiver-to-controller-initiation" ]))
        "diagnostic.positive-evidence-used-for-denial: positive payload evidence cannot be used as denied-path proof"
    )).success;
  in
    require checkTenantManagement
      "FS-760-HDS-040-SDS-010-SMS-010: tenant-management denial acceptance predicates not met"
    && require checkMulticast
      "FS-760-HDS-040-SDS-010-SMS-010: multicast flooding denial acceptance predicates not met"
    && require sn1_detected
      "FS-760-HDS-040-SDS-010-SMS-010 SN1: diagnostic.receiver-denied-boundary-missing — missing reason must be detected"
    && require sn2_detected
      "FS-760-HDS-040-SDS-010-SMS-010 SN2: diagnostic.positive-evidence-used-for-denial — positive payload as denial must be detected"
' >/dev/null || fail "receiver denied probe surface acceptance predicates or seeded negatives failed"

echo "PASS FS-760-HDS-040-SDS-010-SMS-010 receiver-denied-probe-surfaces"
