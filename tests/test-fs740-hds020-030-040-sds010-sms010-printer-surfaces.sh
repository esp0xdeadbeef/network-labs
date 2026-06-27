#!/usr/bin/env bash
# GAMP-ID: FS-740-HDS-020-SDS-010-SMS-010
# GAMP-ID: FS-740-HDS-030-SDS-010-SMS-010
# GAMP-ID: FS-740-HDS-040-SDS-010-SMS-010
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
intent="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet/intent.nix"
inventory_nixos="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet/inventory-nixos.nix"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL fs740-hds020-030-040-sds010-sms010-printer-surfaces: $*" >&2
  exit 1
}

# Parse and evaluate both Nix files
nix-instantiate --parse "${intent}" >/dev/null || fail "intent.nix parse failed"
nix-instantiate --parse "${inventory_nixos}" >/dev/null || fail "inventory-nixos.nix parse failed"

nix eval --impure --json -f "${intent}" >"${tmp_dir}/intent.json" || fail "intent eval failed"

jq -e '
  def by_id($atoms; $id):
    ($atoms | map(select(.id == $id))) as $matches
    | if ($matches | length) == 1 then $matches[0] else null end;
  def contains_all($expected): . as $actual | ($expected - $actual | length) == 0;

  def site_surfaces_ok($site; $provider):
    ($site.communicationContract.sharedServicePolicyAtoms // []) as $atoms

    # ═══════════════════════════════════════════════════════════════
    # SMS FS-740-HDS-020-SDS-010-SMS-010 — Printer Discovery Surface
    # ═══════════════════════════════════════════════════════════════
    | (by_id($atoms; "fs740-printer-discovery-policy") as $disc
      | $disc != null
      and $disc.sms == "FS-740-HDS-010-SDS-010-SMS-010"
      and $disc.service == "hat-printer-ipp"
      and $disc.serviceClass == "printer"
      and $disc.provider == $provider
      and $disc.requesterScopes == [ "trusted" ]
      and $disc.responderScope == "trusted"

      # Discovery surface field validation
      and $disc.discovery.allowed == true
      and ($disc.discovery.protocols | sort == [ "dns-sd", "mdns" ])
      and $disc.discovery.transport.proto == "udp"
      and $disc.discovery.transport.port == 5353
      and $disc.discovery.transport.scope == "link-local-multicast"

      # Bonjour DNS-SD record
      and ($disc.discovery.records | length) >= 1
      and $disc.discovery.records[0].kind == "bonjour-dns-sd"
      and $disc.discovery.records[0].serviceType == "_ipp._tcp"
      and $disc.discovery.records[0].targetService == "hat-printer-ipp"
      and $disc.discovery.records[0].payloadPort == 631

      # Decision and non-authorization (seeded negative guard)
      and $disc.discovery.decision == "discovery-only"
      and ($disc.discovery.doesNotAuthorize | contains_all([
        "print-payload",
        "printer-admin",
        "reverse-discovery",
        "multicast-flooding",
        "client-lateral"
      ]))

      # Seeded negative: discovery-is-not-payload-authority
      # Verified by doesNotAuthorize containing print-payload above.
    )

    # ═══════════════════════════════════════════════════════════════
    # SMS FS-740-HDS-030-SDS-010-SMS-010 — Printer Payload And Admin Surfaces
    # ═══════════════════════════════════════════════════════════════
    and (by_id($atoms; "fs740-printer-print-payload-policy") as $payload
      | $payload != null
      and $payload.sms == "FS-740-HDS-010-SDS-010-SMS-020"
      and $payload.service == "hat-printer-ipp"
      and $payload.serviceClass == "printer"
      and $payload.requesterScopes == [ "trusted" ]
      and $payload.responderScope == "trusted"

      # Payload surface field validation
      and $payload.payload.allowed == true
      and $payload.payload.protocol == "ipp"
      and $payload.payload.transport == "tcp"
      and $payload.payload.ports == [ 631 ]
      and $payload.payload.direction == "requester-to-printer"
      and $payload.payload.returnBehavior == "established-return-only"
      and $payload.payload.independentFromDiscovery == true
    )

    and (by_id($atoms; "fs740-printer-admin-denial-policy") as $admin
      | $admin != null
      and $admin.sms == "FS-740-HDS-010-SDS-010-SMS-030"
      and $admin.service == "hat-printer-admin"
      and $admin.serviceClass == "printer"
      and $admin.requesterScopes == [ "trusted" ]
      and $admin.responderScope == "trusted"

      # Administration surface field validation
      and $admin.administration.ports == [ 80 ]
      and $admin.administration.independentFromDiscovery == true
      and $admin.administration.independentFromPayload == true

      # Seeded negative: payload-is-not-admin-authority
      # Payload and admin must be separate atoms; admin must have
      # independentFromPayload == true.
    )

    # ═══════════════════════════════════════════════════════════════
    # SMS FS-740-HDS-040-SDS-010-SMS-010 — Printer Denied Probe Surfaces
    # ═══════════════════════════════════════════════════════════════
    and (by_id($atoms; "fs740-printer-reverse-multicast-lateral-denial") as $denied
      | $denied != null
      and $denied.sms == "FS-740-HDS-010-SDS-010-SMS-040"
      and $denied.service == "hat-printer-ipp"
      and $denied.serviceClass == "printer"
      and $denied.requesterScopes == [ "trusted" ]
      and $denied.responderScope == "trusted"
      and ($denied.deniedPaths | length) == 3

      # Reverse-discovery denied probe
      and ($denied.deniedPaths | map(select(.kind == "reverse-discovery")) | length) == 1
      and ($denied.deniedPaths[] | select(.kind == "reverse-discovery") |
        .from == "trusted"
        and .to == "trusted"
        and .direction == "printer-to-requester"
        and (.reason | length) > 0
      )

      # Multicast-flooding denied probe
      and ($denied.deniedPaths | map(select(.kind == "multicast-flooding")) | length) == 1
      and ($denied.deniedPaths[] | select(.kind == "multicast-flooding") |
        .from == "trusted"
        and .to == "any"
        and (.protocols | sort == [ "dns-sd", "mdns" ])
        and (.reason | length) > 0
      )

      # Unrelated-client-lateral denied probe
      and ($denied.deniedPaths | map(select(.kind == "unrelated-client-lateral")) | length) == 1
      and ($denied.deniedPaths[] | select(.kind == "unrelated-client-lateral") |
        .from == "guest"
        and .to == "trusted"
        and (.reason | length) > 0
      )

      # Seeded negative cases:
      #   - printer-denied-boundary-missing: each denied path has from/to/reason
      #   - positive-evidence-used-for-denial: denied paths are explicit
      #     kind/from/to predicates, not service-presence checks
    );

  # Validate both sites
  .esp0xdeadbeef as $enterprise
  | site_surfaces_ok($enterprise["site-a"]; "nixos-printer01")
  and site_surfaces_ok($enterprise["site-b"]; "clab-printer01")
' "${tmp_dir}/intent.json" >/dev/null \
  || fail "printer discovery/payload/denied surface records are incomplete"

echo "PASS fs740-hds020-030-040-sds010-sms010-printer-surfaces"
