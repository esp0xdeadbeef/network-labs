#!/usr/bin/env bash
# GAMP-ID: FS-740-HDS-010-SDS-010-SMS-010
# GAMP-ID: FS-740-HDS-010-SDS-010-SMS-020
# GAMP-ID: FS-740-HDS-010-SDS-010-SMS-030
# GAMP-ID: FS-740-HDS-010-SDS-010-SMS-040
# GAMP-ID: FS-760-HDS-010-SDS-010-SMS-010
# GAMP-ID: FS-760-HDS-010-SDS-010-SMS-020
# GAMP-ID: FS-760-HDS-010-SDS-010-SMS-030
# GAMP-ID: FS-760-HDS-010-SDS-010-SMS-040
# GAMP-ID: FS-760-HDS-010-SDS-010-SMS-050
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
intent="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet/intent.nix"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL hat-printer-receiver-policy-source: $*" >&2
  exit 1
}

nix-instantiate --parse "${intent}" >/dev/null
nix eval --impure --json --expr "import ${intent}" >"${tmp_dir}/intent.json"

jq -e '
  def by_id($atoms; $id):
    ($atoms | map(select(.id == $id))) as $matches
    | if ($matches | length) == 1 then $matches[0] else null end;
  def contains_all($expected): . as $actual | ($expected - $actual | length) == 0;
  def denied_kind($atom; $kind):
    (($atom.deniedPaths // []) | map(select(.kind == $kind)) | length) == 1;

  def site_policy_ok($site; $printer_provider; $receiver_provider):
    ($site.communicationContract.sharedServicePolicyAtoms // []) as $atoms
    | ($atoms | length) == 9
    and (($atoms | map(.sms) | sort) == [
      "FS-740-HDS-010-SDS-010-SMS-010",
      "FS-740-HDS-010-SDS-010-SMS-020",
      "FS-740-HDS-010-SDS-010-SMS-030",
      "FS-740-HDS-010-SDS-010-SMS-040",
      "FS-760-HDS-010-SDS-010-SMS-010",
      "FS-760-HDS-010-SDS-010-SMS-020",
      "FS-760-HDS-010-SDS-010-SMS-030",
      "FS-760-HDS-010-SDS-010-SMS-040",
      "FS-760-HDS-010-SDS-010-SMS-050"
    ])
    and (by_id($atoms; "fs740-printer-discovery-policy") as $printer_discovery
      | $printer_discovery.service == "hat-printer-ipp"
      and $printer_discovery.serviceClass == "printer"
      and $printer_discovery.provider == $printer_provider
      and $printer_discovery.requesterScopes == [ "trusted" ]
      and $printer_discovery.responderScope == "trusted"
      and $printer_discovery.discovery.allowed == true
      and ($printer_discovery.discovery.protocols | sort == [ "dns-sd", "mdns" ])
      and $printer_discovery.discovery.transport.proto == "udp"
      and $printer_discovery.discovery.transport.port == 5353
      and $printer_discovery.discovery.records[0].kind == "bonjour-dns-sd"
      and $printer_discovery.discovery.records[0].serviceType == "_ipp._tcp"
      and $printer_discovery.discovery.records[0].targetService == "hat-printer-ipp"
      and $printer_discovery.discovery.records[0].payloadPort == 631
      and $printer_discovery.discovery.decision == "discovery-only"
      and ($printer_discovery.discovery.doesNotAuthorize | contains_all([
        "print-payload",
        "printer-admin",
        "reverse-discovery",
        "multicast-flooding",
        "client-lateral"
      ])))
    and (by_id($atoms; "fs740-printer-print-payload-policy") as $printer_payload
      | $printer_payload.service == "hat-printer-ipp"
      and $printer_payload.payload.allowed == true
      and $printer_payload.payload.protocol == "ipp"
      and $printer_payload.payload.transport == "tcp"
      and $printer_payload.payload.ports == [ 631 ]
      and $printer_payload.payload.direction == "requester-to-printer"
      and $printer_payload.payload.returnBehavior == "established-return-only"
      and $printer_payload.payload.independentFromDiscovery == true)
    and (by_id($atoms; "fs740-printer-admin-denial-policy") as $printer_admin
      | $printer_admin.service == "hat-printer-admin"
      and $printer_admin.administration.ports == [ 80 ]
      and $printer_admin.administration.allowedScopes == []
      and ($printer_admin.administration.deniedScopes | contains_all([
        "guest",
        "iot",
        "work",
        "client",
        "management"
      ]))
      and $printer_admin.administration.independentFromDiscovery == true
      and $printer_admin.administration.independentFromPayload == true)
    and (by_id($atoms; "fs740-printer-reverse-multicast-lateral-denial") as $printer_denied
      | denied_kind($printer_denied; "reverse-discovery")
      and denied_kind($printer_denied; "multicast-flooding")
      and denied_kind($printer_denied; "unrelated-client-lateral"))
    and (by_id($atoms; "fs760-receiver-discovery-policy") as $receiver_discovery
      | $receiver_discovery.service == "hat-receiver-discovery"
      and $receiver_discovery.serviceClass == "media-receiver"
      and $receiver_discovery.provider == $receiver_provider
      and $receiver_discovery.controllerScopes == [ "trusted" ]
      and $receiver_discovery.receiverScope == "iot"
      and $receiver_discovery.discovery.allowed == true
      and ($receiver_discovery.discovery.selectedProtocols | sort == [ "dial", "mdns", "ssdp" ])
      and ($receiver_discovery.discovery.transports | map(.protocol) | sort == [ "dial", "mdns", "ssdp" ])
      and ($receiver_discovery.discovery.transports | map(select(.protocol == "mdns" and .proto == "udp" and .port == 5353 and .record == "_googlecast._tcp")) | length) == 1
      and ($receiver_discovery.discovery.transports | map(select(.protocol == "ssdp" and .proto == "udp" and .port == 1900 and .record == "urn:dial-multiscreen-org:service:dial:1")) | length) == 1
      and ($receiver_discovery.discovery.transports | map(select(.protocol == "dial" and .proto == "tcp" and .service == "hat-receiver-control")) | length) == 1
      and $receiver_discovery.discovery.decision == "discovery-only"
      and ($receiver_discovery.discovery.doesNotAuthorize | contains_all([
        "controller-payload",
        "reverse-initiation",
        "guest-to-trusted",
        "media-to-management",
        "multicast-flooding"
      ])))
    and (by_id($atoms; "fs760-receiver-controller-payload-policy") as $receiver_payload
      | $receiver_payload.service == "hat-receiver-control"
      and $receiver_payload.payload.allowed == true
      and $receiver_payload.payload.protocol == "cast-control"
      and $receiver_payload.payload.transport == "tcp"
      and $receiver_payload.payload.ports == [ 8008, 8009 ]
      and $receiver_payload.payload.direction == "controller-to-receiver"
      and $receiver_payload.payload.returnBehavior == "established-return-only"
      and $receiver_payload.payload.independentFromDiscovery == true)
    and (by_id($atoms; "fs760-receiver-reverse-initiation-denial") as $receiver_reverse
      | denied_kind($receiver_reverse; "receiver-to-controller-initiation"))
    and (by_id($atoms; "fs760-receiver-tenant-management-denial") as $receiver_tenant
      | denied_kind($receiver_tenant; "guest-to-trusted")
      and denied_kind($receiver_tenant; "media-to-management"))
    and (by_id($atoms; "fs760-receiver-multicast-flooding-denial") as $receiver_multicast
      | denied_kind($receiver_multicast; "multicast-flooding")
      and (($receiver_multicast.deniedPaths[0].protocols // []) | sort == [ "dial", "mdns", "ssdp" ]));

  .esp0xdeadbeef as $enterprise
  | site_policy_ok($enterprise["site-a"]; "nixos-printer01"; "nixos-receiver01")
  and site_policy_ok($enterprise["site-b"]; "clab-printer01"; "clab-receiver01")
' "${tmp_dir}/intent.json" >/dev/null \
  || fail "HAT intent does not model split FS-740/FS-760 printer and receiver policy atoms one-to-one"

echo "PASS hat-printer-receiver-policy-source"
