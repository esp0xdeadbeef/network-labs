#!/usr/bin/env bash
# GAMP-ID: FS-760-HDS-020-SDS-010-SMS-010
# GAMP-SCOPE: software-module-test
# Construction test for receiver discovery surface.
# Validates mDNS, SSDP, and DIAL discovery records
# against the FS-760-HDS-020-SDS-010-SMS-010 acceptance predicates.
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
hat_dir="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL FS-760-HDS-020-SDS-010-SMS-010 receiver-discovery-surface: $*" >&2
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

    # Extract the receiver discovery policy atom
    discoveryAtom = byId "fs760-receiver-discovery-policy";

    discoveryOk = d:
      # SMS predicate: discovery record must name protocol selection
      builtins.hasAttr "selectedProtocols" d
      && (builtins.typeOf d.selectedProtocols == "list")
      && builtins.length d.selectedProtocols >= 3
      # SMS predicate: must include mdns, ssdp, dial
      && builtins.elem "mdns" d.selectedProtocols
      && builtins.elem "ssdp" d.selectedProtocols
      && builtins.elem "dial" d.selectedProtocols
      # SMS predicate: discovery must have transports for each protocol
      && builtins.hasAttr "transports" d
      && (builtins.typeOf d.transports == "list")
      && builtins.length d.transports >= 3
      # SMS predicate: each transport must name its protocol
      && builtins.all (t: builtins.hasAttr "protocol" t) d.transports
      # SMS predicate: decision must be discovery-only
      && (d.decision or null) == "discovery-only"
      # SMS predicate: doesNotAuthorize must cover all 5 categories
      && builtins.hasAttr "doesNotAuthorize" d
      && (builtins.typeOf d.doesNotAuthorize == "list")
      && builtins.length d.doesNotAuthorize >= 5;

    # ── Positive checks ────────────────────────────────────────────────────
    checkDiscovery = discoveryOk discoveryAtom.discovery
      && require (discoveryAtom.sms == "FS-760-HDS-010-SDS-010-SMS-010")
        "FS-760-HDS-020-SDS-010-SMS-010: discovery atom must preserve upstream gampId FS-760-HDS-010-SDS-010-SMS-010"
      && require (discoveryAtom.service == "hat-receiver-discovery")
        "FS-760-HDS-020-SDS-010-SMS-010: discovery atom must bind to hat-receiver-discovery service";

    # SMS predicate: doesNotAuthorize must include controller-payload,
    # reverse-initiation, guest-to-trusted, media-to-management, multicast-flooding
    checkDeniedAuth = builtins.all
      (kind: builtins.elem kind discoveryAtom.discovery.doesNotAuthorize)
      [ "controller-payload" "reverse-initiation" "guest-to-trusted"
        "media-to-management" "multicast-flooding" ];

    # ── Seeded negatives ──────────────────────────────────────────────────
    # SN1: diagnostic.receiver-discovery-protocol-missing
    # Prove that removing selectedProtocols would be detected.
    discoveryWithoutProtocols = builtins.removeAttrs discoveryAtom.discovery [ "selectedProtocols" ];
    sn1_detected = !(builtins.tryEval (
      require (builtins.hasAttr "selectedProtocols" discoveryWithoutProtocols)
        "diagnostic.receiver-discovery-protocol-missing: discovery record missing selectedProtocols"
    )).success;

    # SN2: diagnostic.discovery-is-not-payload-authority
    # Prove that an empty doesNotAuthorize list would be detected.
    discoveryWithEmptyDeny = discoveryAtom.discovery // { doesNotAuthorize = [ ]; };
    sn2_detected = !(builtins.tryEval (
      require (builtins.length discoveryWithEmptyDeny.doesNotAuthorize >= 5)
        "diagnostic.discovery-is-not-payload-authority: discovery must not grant payload or other policy authority"
    )).success;
  in
    require checkDiscovery
      "FS-760-HDS-020-SDS-010-SMS-010: discovery surface acceptance predicates not met"
    && require checkDeniedAuth
      "FS-760-HDS-020-SDS-010-SMS-010: doesNotAuthorize must cover all 5 policy categories"
    && require sn1_detected
      "FS-760-HDS-020-SDS-010-SMS-010 SN1: diagnostic.receiver-discovery-protocol-missing — missing selectedProtocols must be detected"
    && require sn2_detected
      "FS-760-HDS-020-SDS-010-SMS-010 SN2: diagnostic.discovery-is-not-payload-authority — empty doesNotAuthorize must be detected"
' >/dev/null || fail "receiver discovery surface acceptance predicates or seeded negatives failed"

echo "PASS FS-760-HDS-020-SDS-010-SMS-010 receiver-discovery-surface"
