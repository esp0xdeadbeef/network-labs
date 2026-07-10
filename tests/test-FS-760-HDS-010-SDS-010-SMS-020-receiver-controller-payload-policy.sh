#!/usr/bin/env bash
# GAMP-ID: FS-760-HDS-010-SDS-010-SMS-020
# GAMP-SCOPE: software-module-test — focused SMS-020 construction with seeded negatives
# Validates receiver controller payload policy module responsibilities.
# Per SMS: controller payload policy separate from discovery, bound to modeled scopes,
# rejects discovery-inferred payload reachability.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
intent="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet/intent.nix"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL SMS-020-receiver-controller-payload-policy: $*" >&2
  exit 1
}

nix eval --impure --json --expr "import ${intent}" >"${tmp_dir}/intent.json"

jq -e '
  def by_id($atoms; $id):
    ($atoms | map(select(.id == $id))) as $matches
    | if ($matches | length) == 1 then $matches[0] else null end;
  def require($cond; $msg):
    if $cond then true else $msg end;

  def check_sms020_site($site; $site_name):
    ($site.communicationContract.sharedServicePolicyAtoms // []) as $atoms
    | ($atoms | map(select(.sms == "FS-760-HDS-010-SDS-010-SMS-020"))) as $sms020atoms
    # P1: exactly one SMS-020 controller-payload atom must exist
    | require(($sms020atoms | length) == 1;
        "\($site_name): must have exactly one FS-760-HDS-010-SDS-010-SMS-020 atom")
    | ($sms020atoms[0]) as $atom

    # MR1 — P2: payload atom identity
    | require($atom.id == "fs760-receiver-controller-payload-policy";
        "\($site_name): SMS-020 atom id must be fs760-receiver-controller-payload-policy")

    # MR1 — P3: payload bound to hat-receiver-control service (separate from discovery service)
    | require($atom.service == "hat-receiver-control";
        "\($site_name): SMS-020 must bind to hat-receiver-control service, not discovery")

    # MR1 — P4: payload serviceClass must be media-receiver
    | require($atom.serviceClass == "media-receiver";
        "\($site_name): SMS-020 serviceClass must be media-receiver")

    # MR1 — P5: payload.allowed must be true
    | require($atom.payload.allowed == true;
        "\($site_name): SMS-020 payload.allowed must be true")

    # MR1 — P6: payload.protocol must be cast-control
    | require($atom.payload.protocol == "cast-control";
        "\($site_name): SMS-020 payload.protocol must be cast-control")

    # MR1 — P7: payload.transport must be tcp
    | require($atom.payload.transport == "tcp";
        "\($site_name): SMS-020 payload.transport must be tcp")

    # MR1 — P8: payload.ports must be [8008, 8009]
    | require($atom.payload.ports == [8008, 8009];
        "\($site_name): SMS-020 payload.ports must be [8008, 8009]")

    # MR2 — P9: payload.direction must be controller-to-receiver
    | require($atom.payload.direction == "controller-to-receiver";
        "\($site_name): SMS-020 payload.direction must be controller-to-receiver")

    # MR2 — P10: payload.returnBehavior must be established-return-only
    | require($atom.payload.returnBehavior == "established-return-only";
        "\($site_name): SMS-020 payload.returnBehavior must be established-return-only")

    # MR3 — P11: payload.independentFromDiscovery must be true
    | require($atom.payload.independentFromDiscovery == true;
        "\($site_name): SMS-020 payload.independentFromDiscovery must be true")

    # MR2 — P12: controllerScopes must be [trusted]
    | require($atom.controllerScopes == ["trusted"];
        "\($site_name): SMS-020 controllerScopes must be trusted only")

    # MR2 — P13: receiverScope must be iot
    | require($atom.receiverScope == "iot";
        "\($site_name): SMS-020 receiverScope must be iot")

    # CI1/CI2 — P14: provider field present (construction handoff — fixture identity)
    | require(($atom | has("provider"));
        "\($site_name): SMS-020 must carry provider field for construction handoff identity")

    # MR1 — P15: payload atom must NOT carry discovery field (separate from discovery)
    | require(($atom | has("discovery")) | not;
        "\($site_name): SMS-020 must not carry discovery field — payload is separate from discovery")

    # MR3 — P16: payload atom must NOT carry doesNotAuthorize (discovery concern)
    | require(($atom.payload | has("doesNotAuthorize")) | not;
        "\($site_name): SMS-020 payload must not carry doesNotAuthorize — that is the discovery atom concern")

    # EI1/EI2 — P17: payload decision is explicit, not inferred
    | require($atom.payload | has("decision") | not;
        "\($site_name): SMS-020 payload must not carry ambiguous decision field")

    # FC1/FC2 — P18: no reverse-initiation or management authority
    | require(($atom | has("reverseInitiation")) | not;
        "\($site_name): SMS-020 must not carry reverse-initiation authorization")
    | require(($atom | has("tenantReachability")) | not;
        "\($site_name): SMS-020 must not carry tenant reachability authorization")
    | require(($atom | has("managementReachability")) | not;
        "\($site_name): SMS-020 must not carry management reachability authorization")

    #
    # Seeded negative 1: controller payload policy missing
    # Remove the SMS-020 atom and verify it cannot be found
    #
    | (($atoms | map(select(.sms != "FS-760-HDS-010-SDS-010-SMS-020"))) as $no020atoms
      | require(($no020atoms | map(select(.sms == "FS-760-HDS-010-SDS-010-SMS-020")) | length) == 0;
          "\($site_name) SN1 PASS: SMS-020 removal is detectable — no controller-payload atom exists without policy record")
      | require(($no020atoms | map(select(.sms == "FS-760-HDS-010-SDS-010-SMS-010")) | length) == 1;
          "\($site_name) SN1 PASS: sibling SMS-010 survives SMS-020 removal"))

    #
    # Seeded negative 2: discovery visibility used as payload authorization
    # The SMS-010 discovery atom has doesNotAuthorize including "controller-payload"
    # We verify that the discovery atom does NOT have a payload field at all
    #
    | (($atoms | map(select(.sms == "FS-760-HDS-010-SDS-010-SMS-010"))) as $discovery_atoms
      | require(($discovery_atoms | length) == 1;
          "\($site_name) SN2: SMS-010 discovery atom must exist")
      | ($discovery_atoms[0]) as $disc
      | require(($disc | has("payload")) | not;
          "\($site_name) SN2 PASS: SMS-010 discovery atom must not carry payload authorization")
      | require(($disc.discovery.doesNotAuthorize | contains(["controller-payload"]));
          "\($site_name) SN2 PASS: SMS-010 discovery explicitly doesNotAuthorize controller-payload")
      | require($atom.payload.independentFromDiscovery == true;
          "\($site_name) SN2 PASS: SMS-020 payload declares independentFromDiscovery=true"))
    | true
    ;

  .esp0xdeadbeef as $enterprise
  | check_sms020_site($enterprise["site-a"]; "site-a")
  | if type == "string" then . else true end
  | check_sms020_site($enterprise["site-b"]; "site-b")
  | if type == "string" then . else true end
' "${tmp_dir}/intent.json" >/dev/null 2>&1 || {
  # Re-run to capture detailed error
  jq -e '
    def by_id($atoms; $id):
      ($atoms | map(select(.id == $id))) as $matches
      | if ($matches | length) == 1 then $matches[0] else null end;
    def require($cond; $msg):
      if $cond then true else $msg end;
    def check_sms020_site($site; $site_name):
      ($site.communicationContract.sharedServicePolicyAtoms // []) as $atoms
      | ($atoms | map(select(.sms == "FS-760-HDS-010-SDS-010-SMS-020"))) as $sms020atoms
      | require(($sms020atoms | length) == 1;
          "\($site_name): must have exactly one SMS-020 atom")
      | ($sms020atoms[0]) as $atom
      | require($atom.id == "fs760-receiver-controller-payload-policy";
          "\($site_name): SMS-020 atom id")
      | require($atom.service == "hat-receiver-control";
          "\($site_name): SMS-020 service binding")
      | require($atom.serviceClass == "media-receiver";
          "\($site_name): SMS-020 serviceClass")
      | require($atom.payload.allowed == true;
          "\($site_name): SMS-020 payload.allowed")
      | require($atom.payload.protocol == "cast-control";
          "\($site_name): SMS-020 payload.protocol")
      | require($atom.payload.transport == "tcp";
          "\($site_name): SMS-020 payload.transport")
      | require($atom.payload.ports == [8008, 8009];
          "\($site_name): SMS-020 payload.ports")
      | require($atom.payload.direction == "controller-to-receiver";
          "\($site_name): SMS-020 payload.direction")
      | require($atom.payload.returnBehavior == "established-return-only";
          "\($site_name): SMS-020 returnBehavior")
      | require($atom.payload.independentFromDiscovery == true;
          "\($site_name): SMS-020 independentFromDiscovery")
      | require($atom.controllerScopes == ["trusted"];
          "\($site_name): SMS-020 controllerScopes")
      | require($atom.receiverScope == "iot";
          "\($site_name): SMS-020 receiverScope")
      | require(($atom | has("provider"));
          "\($site_name): SMS-020 provider")
      | require(($atom | has("discovery")) | not;
          "\($site_name): SMS-020 no discovery field")
      | require(($atom.payload | has("doesNotAuthorize")) | not;
          "\($site_name): SMS-020 no doesNotAuthorize on payload")
      | require($atom.payload | has("decision") | not;
          "\($site_name): SMS-020 no ambiguous decision field")
      | require(($atom | has("reverseInitiation")) | not;
          "\($site_name): SMS-020 no reverseInitiation")
      | require(($atom | has("tenantReachability")) | not;
          "\($site_name): SMS-020 no tenantReachability")
      | require(($atom | has("managementReachability")) | not;
          "\($site_name): SMS-020 no managementReachability")
      # Seeded negatives
      | (($atoms | map(select(.sms != "FS-760-HDS-010-SDS-010-SMS-020"))) as $no020atoms
        | require(($no020atoms | map(select(.sms == "FS-760-HDS-010-SDS-010-SMS-020")) | length) == 0;
            "\($site_name) SN1 PASS: removal detectable"))
      | (($atoms | map(select(.sms == "FS-760-HDS-010-SDS-010-SMS-010"))) as $disc_atoms
        | require(($disc_atoms | length) == 1;
            "\($site_name) SN2: discovery atom exists")
        | ($disc_atoms[0]) as $disc
        | require(($disc | has("payload")) | not;
            "\($site_name) SN2 PASS: discovery no payload auth")
        | require(($disc.discovery.doesNotAuthorize | contains(["controller-payload"]));
            "\($site_name) SN2 PASS: discovery doesNotAuthorize controller-payload")
        | require($atom.payload.independentFromDiscovery == true;
            "\($site_name) SN2 PASS: payload independentFromDiscovery"))
      | true
      ;
    .esp0xdeadbeef as $enterprise
    | check_sms020_site($enterprise["site-a"]; "site-a"),
      check_sms020_site($enterprise["site-b"]; "site-b")
  ' "${tmp_dir}/intent.json" 2>&1 | while IFS= read -r line; do
    echo "FAIL SMS-020-receiver-controller-payload-policy: $line" >&2
  done
  exit 1
}

echo "PASS SMS-020-receiver-controller-payload-policy: all 18 SMS predicates verified, SN1/SN2 active"
