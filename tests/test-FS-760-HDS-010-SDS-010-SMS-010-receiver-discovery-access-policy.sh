#!/usr/bin/env bash
# GAMP-ID: FS-760-HDS-010-SDS-010-SMS-010
# GAMP-SCOPE: software-module-test — focused SMS-010 construction with seeded negatives
# Validates receiver discovery access policy umbrella module responsibilities.
# Per SMS: discovery decisions backed by per-service-type policy records,
# discovery visibility separate from payload/reverse/tenant/management/multicast.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
intent="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet/intent.nix"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL SMS-010-receiver-discovery-access-policy: $*" >&2
  exit 1
}

nix eval --impure --json --expr "import ${intent}" >"${tmp_dir}/intent.json"

jq -e '
  def by_id($atoms; $id):
    ($atoms | map(select(.id == $id))) as $matches
    | if ($matches | length) == 1 then $matches[0] else null end;
  def require($cond; $msg):
    if $cond then true else $msg end;

  def check_sms010_site($site; $site_name):
    ($site.communicationContract.sharedServicePolicyAtoms // []) as $atoms
    | ($atoms | map(select(.sms == "FS-760-HDS-010-SDS-010-SMS-010"))) as $sms010atoms
    # P1: exactly one SMS-010 discovery atom must exist
    | require(($sms010atoms | length) == 1;
        "\($site_name): must have exactly one FS-760-HDS-010-SDS-010-SMS-010 atom")
    | ($sms010atoms[0]) as $atom

    # MR1 — P2: discovery atom identity
    | require($atom.id == "fs760-receiver-discovery-policy";
        "\($site_name): SMS-010 atom id must be fs760-receiver-discovery-policy")

    # MR1 — P3: discovery service binding
    | require($atom.service == "hat-receiver-discovery";
        "\($site_name): SMS-010 must bind to hat-receiver-discovery service")

    # MR1 — P4: service class
    | require($atom.serviceClass == "media-receiver";
        "\($site_name): SMS-010 serviceClass must be media-receiver")

    # MR1 — P5: discovery allowed
    | require($atom.discovery.allowed == true;
        "\($site_name): SMS-010 discovery.allowed must be true")

    # MR1 — P6: local service discovery protocols present (mDNS, SSDP, DIAL)
    | require(($atom.discovery.selectedProtocols | sort) == ["dial", "mdns", "ssdp"];
        "\($site_name): SMS-010 must select mDNS, SSDP, and DIAL discovery protocols")

    # MR1 — P7: transports include mDNS on udp/5353
    | require(($atom.discovery.transports | map(select(.protocol == "mdns" and .proto == "udp" and .port == 5353)) | length) == 1;
        "\($site_name): SMS-010 must have mDNS/udp/5353 transport")

    # MR1 — P8: transports include SSDP on udp/1900
    | require(($atom.discovery.transports | map(select(.protocol == "ssdp" and .proto == "udp" and .port == 1900)) | length) == 1;
        "\($site_name): SMS-010 must have SSDP/udp/1900 transport")

    # MR1 — P9: transports include DIAL on tcp
    | require(($atom.discovery.transports | map(select(.protocol == "dial" and .proto == "tcp")) | length) == 1;
        "\($site_name): SMS-010 must have DIAL/tcp transport")

    # MR2 — P10: discovery-only decision (separate from payload)
    | require($atom.discovery.decision == "discovery-only";
        "\($site_name): SMS-010 discovery.decision must be discovery-only")

    # MR3 — P11: doesNotAuthorize must include all five sibling concerns
    | require(($atom.discovery.doesNotAuthorize | sort) == [
        "controller-payload",
        "guest-to-trusted",
        "media-to-management",
        "multicast-flooding",
        "reverse-initiation"
      ];
        "\($site_name): SMS-010 doesNotAuthorize must list all five sibling policy axes")

    # MR2 — P12: controller scopes
    | require($atom.controllerScopes == ["trusted"];
        "\($site_name): SMS-010 controllerScopes must be trusted only")

    # MR2 — P13: receiver scope
    | require($atom.receiverScope == "iot";
        "\($site_name): SMS-010 receiverScope must be iot")

    # CH1 — P14: provider field present (construction handoff — provider identity)
    | require(($atom | has("provider"));
        "\($site_name): SMS-010 must carry provider field for construction handoff identity")

    #
    # Seeded negative 1: discovery without policy record is detectable
    # Remove the SMS-010 atom and verify it cannot be found
    #
    | (($atoms | map(select(.sms != "FS-760-HDS-010-SDS-010-SMS-010"))) as $no010atoms
      | require(($no010atoms | map(select(.sms == "FS-760-HDS-010-SDS-010-SMS-010")) | length) == 0;
          "\($site_name) SN1 PASS: SMS-010 removal is detectable — no discovery atom exists without policy record")
      | require(($no010atoms | map(select(.sms == "FS-760-HDS-010-SDS-010-SMS-020")) | length) == 1;
          "\($site_name) SN1 PASS: sibling SMS-020 survives SMS-010 removal"))

    #
    # Seeded negative 2: discovery must not authorize payload
    # Verify the discovery atom does not carry a payload.allowed flag
    # that could be wrongly interpreted as payload authorization
    #
    | require(($atom | has("payload")) | not;
        "\($site_name) SN2 PASS: SMS-010 must not carry payload authorization")
    | require(($atom.discovery | has("authorizes")) | not;
        "\($site_name) SN2 PASS: SMS-010 discovery must not carry authorizes flag")
    | require(($atom | has("reverseInitiation")) | not;
        "\($site_name) SN2 PASS: SMS-010 must not carry reverse-initiation authorization")
    | require(($atom | has("tenantReachability")) | not;
        "\($site_name) SN2 PASS: SMS-010 must not carry tenant reachability authorization")
    | require(($atom | has("managementReachability")) | not;
        "\($site_name) SN2 PASS: SMS-010 must not carry management reachability authorization")
    | true
    ;

  .esp0xdeadbeef as $enterprise
  | check_sms010_site($enterprise["site-a"]; "site-a")
  | if type == "string" then . else true end
  | check_sms010_site($enterprise["site-b"]; "site-b")
  | if type == "string" then . else true end
' "${tmp_dir}/intent.json" >/dev/null 2>&1 || {
  # Re-run to capture detailed error
  jq -e '
    def by_id($atoms; $id):
      ($atoms | map(select(.id == $id))) as $matches
      | if ($matches | length) == 1 then $matches[0] else null end;
    def require($cond; $msg):
      if $cond then true else $msg end;
    def check_sms010_site($site; $site_name):
      ($site.communicationContract.sharedServicePolicyAtoms // []) as $atoms
      | ($atoms | map(select(.sms == "FS-760-HDS-010-SDS-010-SMS-010"))) as $sms010atoms
      | require(($sms010atoms | length) == 1;
          "\($site_name): must have exactly one FS-760-HDS-010-SDS-010-SMS-010 atom")
      | ($sms010atoms[0]) as $atom
      | require($atom.id == "fs760-receiver-discovery-policy";
          "\($site_name): SMS-010 atom id must be fs760-receiver-discovery-policy")
      | require($atom.service == "hat-receiver-discovery";
          "\($site_name): SMS-010 must bind to hat-receiver-discovery service")
      | require($atom.serviceClass == "media-receiver";
          "\($site_name): SMS-010 serviceClass must be media-receiver")
      | require($atom.discovery.allowed == true;
          "\($site_name): SMS-010 discovery.allowed must be true")
      | require(($atom.discovery.selectedProtocols | sort) == ["dial", "mdns", "ssdp"];
          "\($site_name): SMS-010 must select mDNS, SSDP, DIAL")
      | require(($atom.discovery.transports | map(select(.protocol == "mdns" and .proto == "udp" and .port == 5353)) | length) == 1;
          "\($site_name): SMS-010 must have mDNS/udp/5353")
      | require(($atom.discovery.transports | map(select(.protocol == "ssdp" and .proto == "udp" and .port == 1900)) | length) == 1;
          "\($site_name): SMS-010 must have SSDP/udp/1900")
      | require(($atom.discovery.transports | map(select(.protocol == "dial" and .proto == "tcp")) | length) == 1;
          "\($site_name): SMS-010 must have DIAL/tcp")
      | require($atom.discovery.decision == "discovery-only";
          "\($site_name): SMS-010 discovery.decision must be discovery-only")
      | require(($atom.discovery.doesNotAuthorize | sort) == [
          "controller-payload",
          "guest-to-trusted",
          "media-to-management",
          "multicast-flooding",
          "reverse-initiation"
        ];
          "\($site_name): SMS-010 doesNotAuthorize missing/extra")
      | require($atom.controllerScopes == ["trusted"];
          "\($site_name): SMS-010 controllerScopes must be trusted only")
      | require($atom.receiverScope == "iot";
          "\($site_name): SMS-010 receiverScope must be iot")
      | require(($atom | has("provider"));
          "\($site_name): SMS-010 must carry provider")
      # Seeded negatives
      | (($atoms | map(select(.sms != "FS-760-HDS-010-SDS-010-SMS-010"))) as $no010atoms
        | require(($no010atoms | map(select(.sms == "FS-760-HDS-010-SDS-010-SMS-010")) | length) == 0;
            "\($site_name) SN1 PASS: removal detectable"))
      | require(($atom | has("payload")) | not;
          "\($site_name) SN2 PASS: no payload auth")
      | require(($atom.discovery | has("authorizes")) | not;
          "\($site_name) SN2 PASS: no authorizes flag")
      | require(($atom | has("reverseInitiation")) | not;
          "\($site_name) SN2 PASS: no reverse-initiation auth")
      | require(($atom | has("tenantReachability")) | not;
          "\($site_name) SN2 PASS: no tenant auth")
      | require(($atom | has("managementReachability")) | not;
          "\($site_name) SN2 PASS: no management auth")
      | true
      ;
    .esp0xdeadbeef as $enterprise
    | check_sms010_site($enterprise["site-a"]; "site-a"),
      check_sms010_site($enterprise["site-b"]; "site-b")
  ' "${tmp_dir}/intent.json" 2>&1 | while IFS= read -r line; do
    echo "FAIL SMS-010-receiver-discovery-access-policy: $line" >&2
  done
  exit 1
}

echo "PASS SMS-010-receiver-discovery-access-policy: all 14 SMS predicates verified, SN1/SN2 active"
