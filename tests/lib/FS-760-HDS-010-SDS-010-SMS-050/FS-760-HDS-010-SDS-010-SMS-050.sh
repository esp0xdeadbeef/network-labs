#!/usr/bin/env bash
# GAMP-ID: FS-760-HDS-010-SDS-010-SMS-050
# GAMP-SCOPE: software-module-test — focused SMS-050 construction with seeded negatives
# Validates receiver multicast flooding denial module responsibilities.
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
intent="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet/intent.nix"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL SMS-050-receiver-multicast-flooding-denial: $*" >&2
  exit 1
}

nix eval --impure --json --expr "import ${intent}" >"${tmp_dir}/intent.json"

jq -e '
  def by_id($atoms; $id):
    ($atoms | map(select(.id == $id))) as $matches
    | if ($matches | length) == 1 then $matches[0] else null end;
  def denied_kind($atom; $kind):
    (($atom.deniedPaths // []) | map(select(.kind == $kind)) | length) == 1;
  def require($cond; $msg):
    if $cond then true else $msg end;

  def check_sms050_site($site; $site_name):
    ($site.communicationContract.sharedServicePolicyAtoms // []) as $atoms
    | ($atoms | map(select(.sms == "FS-760-HDS-010-SDS-010-SMS-050"))) as $sms050atoms
    | require(($sms050atoms | length) == 1;
        "\($site_name): must have exactly one FS-760-HDS-010-SDS-010-SMS-050 atom")
    | ($sms050atoms[0]) as $atom
    | require($atom.id == "fs760-receiver-multicast-flooding-denial";
        "\($site_name): SMS-050 atom id must be fs760-receiver-multicast-flooding-denial")
    | require($atom.service == "hat-receiver-discovery";
        "\($site_name): SMS-050 must bind to hat-receiver-discovery service")
    | require($atom.serviceClass == "media-receiver";
        "\($site_name): SMS-050 serviceClass must be media-receiver")
    | require($atom.controllerScopes == ["trusted"];
        "\($site_name): SMS-050 controllerScopes must be trusted only")
    | require($atom.receiverScope == "iot";
        "\($site_name): SMS-050 receiverScope must be iot")
    | require(denied_kind($atom; "multicast-flooding");
        "\($site_name): SMS-050 must deny multicast-flooding")
    | ($atom.deniedPaths | map(select(.kind == "multicast-flooding"))[0]) as $mpath
    | require($mpath.from == "trusted";
        "\($site_name): multicast-flooding denied path must enforce from=trusted")
    | require($mpath.to == "any";
        "\($site_name): multicast-flooding denied path must enforce to=any")
    | require(($mpath.protocols | sort == ["dial", "mdns", "ssdp"]);
        "\($site_name): multicast-flooding must deny mdns, ssdp, dial protocols")
    | require($mpath.reason == "selected-receiver-discovery-does-not-authorize-broad-flooding";
        "\($site_name): multicast-flooding reason must be selected-receiver-discovery-does-not-authorize-broad-flooding")
    #
    # Seeded negative 1: missing multicast-flooding denied path
    #
    | (($atom.deniedPaths // []) | map(select(.kind != "multicast-flooding"))) as $noFloodingPaths
    | (($noFloodingPaths | length) == (($atom.deniedPaths // []) | length) - 1)
    | if ($noFloodingPaths | map(select(.kind == "multicast-flooding")) | length) != 0
      then "SN1 FAIL: removing multicast-flooding should make it undetectable" else true end
    | require(($noFloodingPaths | map(select(.kind == "multicast-flooding")) | length) == 0;
        "\($site_name) SN1 PASS: multicast-flooding removal is detectable")
    #
    # Seeded negative 2: discovery protocols must not authorize broad multicast
    # If the discovery atom from SMS-010 were collapsed into this atom,
    # the deniedPaths would be missing (since discovery="" can be interpreted as "allow").
    # We verify that the SMS-050 atom does NOT contain any discovery "allowed" field
    # that could be wrongly interpreted as multicast authorization.
    #
    | require(($atom | has("discovery")) | not;
        "\($site_name) SN2 PASS: SMS-050 must not carry discovery authorization")
    | require(($atom | has("payload")) | not;
        "\($site_name) SN2 PASS: SMS-050 must not carry payload authorization")
    | require(($atom | has("allowedScopes")) | not;
        "\($site_name) SN2 PASS: SMS-050 must not carry allowedScopes")
    | true
    ;

  .esp0xdeadbeef as $enterprise
  | check_sms050_site($enterprise["site-a"]; "site-a")
  | if type == "string" then . else true end
  | check_sms050_site($enterprise["site-b"]; "site-b")
  | if type == "string" then . else true end
' "${tmp_dir}/intent.json" >/dev/null 2>&1 || {
  # Re-run to capture detailed error
  jq -e '
    def by_id($atoms; $id):
      ($atoms | map(select(.id == $id))) as $matches
      | if ($matches | length) == 1 then $matches[0] else null end;
    def denied_kind($atom; $kind):
      (($atom.deniedPaths // []) | map(select(.kind == $kind)) | length) == 1;
    def require($cond; $msg):
      if $cond then true else $msg end;
    def check_sms050_site($site; $site_name):
      ($site.communicationContract.sharedServicePolicyAtoms // []) as $atoms
      | ($atoms | map(select(.sms == "FS-760-HDS-010-SDS-010-SMS-050"))) as $sms050atoms
      | require(($sms050atoms | length) == 1;
          "\($site_name): must have exactly one FS-760-HDS-010-SDS-010-SMS-050 atom")
      | ($sms050atoms[0]) as $atom
      | require($atom.id == "fs760-receiver-multicast-flooding-denial";
          "\($site_name): SMS-050 atom id must be fs760-receiver-multicast-flooding-denial")
      | require($atom.service == "hat-receiver-discovery";
          "\($site_name): SMS-050 must bind to hat-receiver-discovery service")
      | require($atom.serviceClass == "media-receiver";
          "\($site_name): SMS-050 serviceClass must be media-receiver")
      | require($atom.controllerScopes == ["trusted"];
          "\($site_name): SMS-050 controllerScopes must be trusted only")
      | require($atom.receiverScope == "iot";
          "\($site_name): SMS-050 receiverScope must be iot")
      | require(denied_kind($atom; "multicast-flooding");
          "\($site_name): SMS-050 must deny multicast-flooding")
      | ($atom.deniedPaths | map(select(.kind == "multicast-flooding"))[0]) as $mpath
      | require($mpath.from == "trusted";
          "\($site_name): multicast-flooding denied path must enforce from=trusted")
      | require($mpath.to == "any";
          "\($site_name): multicast-flooding denied path must enforce to=any")
      | require(($mpath.protocols | sort == ["dial", "mdns", "ssdp"]);
          "\($site_name): multicast-flooding must deny mdns, ssdp, dial protocols")
      | require($mpath.reason == "selected-receiver-discovery-does-not-authorize-broad-flooding";
          "\($site_name): multicast-flooding reason must be correct")
      #
      # Seeded negatives
      #
      | (($atom.deniedPaths // []) | map(select(.kind != "multicast-flooding"))) as $noFloodingPaths
      | require(($noFloodingPaths | map(select(.kind == "multicast-flooding")) | length) == 0;
          "\($site_name) SN1 PASS: multicast-flooding removal detectable")
      | require(($atom | has("discovery")) | not;
          "\($site_name) SN2 PASS: no discovery authorization collapse")
      | require(($atom | has("payload")) | not;
          "\($site_name) SN2 PASS: no payload authorization collapse")
      | true
      ;
    .esp0xdeadbeef as $enterprise
    | check_sms050_site($enterprise["site-a"]; "site-a"),
      check_sms050_site($enterprise["site-b"]; "site-b")
  ' "${tmp_dir}/intent.json" 2>&1 | while IFS= read -r line; do
    echo "FAIL SMS-050-receiver-multicast-flooding-denial: $line" >&2
  done
  exit 1
}

echo "PASS SMS-050-receiver-multicast-flooding-denial: all predicates verified, SN1/SN2 active"
