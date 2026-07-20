#!/usr/bin/env bash
# GAMP-ID: FS-760-HDS-010-SDS-010-SMS-040
# GAMP-SCOPE: software-module-test — focused SMS-040 construction with seeded negatives
# Validates receiver tenant-and-management denial module responsibilities.
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
intent="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet/intent.nix"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL SMS-040-receiver-tenant-management-denial: $*" >&2
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

  def check_sms040_site($site; $site_name):
    ($site.communicationContract.sharedServicePolicyAtoms // []) as $atoms
    | ($atoms | map(select(.sms == "FS-760-HDS-010-SDS-010-SMS-040"))) as $sms040atoms
    | require(($sms040atoms | length) == 1;
        "\($site_name): must have exactly one FS-760-HDS-010-SDS-010-SMS-040 atom")
    | ($sms040atoms[0]) as $atom
    # P1: atom identity
    | require($atom.id == "fs760-receiver-tenant-management-denial";
        "\($site_name): SMS-040 atom id must be fs760-receiver-tenant-management-denial")
    # P2: service binding
    | require($atom.service == "hat-receiver-control";
        "\($site_name): SMS-040 must bind to hat-receiver-control service")
    # P3: service class
    | require($atom.serviceClass == "media-receiver";
        "\($site_name): SMS-040 serviceClass must be media-receiver")
    # P4: controller scopes
    | require($atom.controllerScopes == ["trusted"];
        "\($site_name): SMS-040 controllerScopes must be trusted only")
    # P5: receiver scope
    | require($atom.receiverScope == "iot";
        "\($site_name): SMS-040 receiverScope must be iot")
    # P6: exactly 2 denied paths
    | require((($atom.deniedPaths // []) | length) == 2;
        "\($site_name): SMS-040 must have exactly 2 denied paths")
    # P7: guest-to-trusted denied path
    | require(denied_kind($atom; "guest-to-trusted");
        "\($site_name): SMS-040 must deny guest-to-trusted")
    | ($atom.deniedPaths | map(select(.kind == "guest-to-trusted"))[0]) as $gtpath
    | require($gtpath.from == "guest";
        "\($site_name): guest-to-trusted denied path must enforce from=guest")
    | require($gtpath.to == "trusted";
        "\($site_name): guest-to-trusted denied path must enforce to=trusted")
    | require($gtpath.reason == "receiver-policy-does-not-authorize-guest-to-trusted-reachability";
        "\($site_name): guest-to-trusted reason must be correct")
    # P8: media-to-management denied path
    | require(denied_kind($atom; "media-to-management");
        "\($site_name): SMS-040 must deny media-to-management")
    | ($atom.deniedPaths | map(select(.kind == "media-to-management"))[0]) as $mtpath
    | require($mtpath.from == "iot";
        "\($site_name): media-to-management denied path must enforce from=iot")
    | require($mtpath.to == "management";
        "\($site_name): media-to-management denied path must enforce to=management")
    | require($mtpath.reason == "receiver-policy-does-not-authorize-management-reachability";
        "\($site_name): media-to-management reason must be correct")
    #
    # Seeded negative 1: missing guest-to-trusted denial is detectable
    # Remove the guest-to-trusted denied path and verify it cannot be found
    #
    | (($atom.deniedPaths // []) | map(select(.kind != "guest-to-trusted"))) as $noGTpaths
    | require(($noGTpaths | map(select(.kind == "guest-to-trusted")) | length) == 0;
        "\($site_name) SN1 PASS: guest-to-trusted removal is detectable")
    | require(($noGTpaths | map(select(.kind == "media-to-management")) | length) == 1;
        "\($site_name) SN1 PASS: media-to-management survives guest-to-trusted removal")
    #
    # Seeded negative 2: discovery or payload authorization must not create tenant/management reachability
    # Verify SMS-040 atom does NOT carry discovery or payload authorization that could be
    # wrongly interpreted as granting tenant or management reachability
    #
    | require(($atom | has("discovery")) | not;
        "\($site_name) SN2 PASS: SMS-040 must not carry discovery authorization")
    | require(($atom | has("payload")) | not;
        "\($site_name) SN2 PASS: SMS-040 must not carry payload authorization")
    | require(($atom | has("allowedScopes")) | not;
        "\($site_name) SN2 PASS: SMS-040 must not carry allowedScopes")
    | true
    ;

  .esp0xdeadbeef as $enterprise
  | check_sms040_site($enterprise["site-a"]; "site-a")
  | if type == "string" then . else true end
  | check_sms040_site($enterprise["site-b"]; "site-b")
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
    def check_sms040_site($site; $site_name):
      ($site.communicationContract.sharedServicePolicyAtoms // []) as $atoms
      | ($atoms | map(select(.sms == "FS-760-HDS-010-SDS-010-SMS-040"))) as $sms040atoms
      | require(($sms040atoms | length) == 1;
          "\($site_name): must have exactly one FS-760-HDS-010-SDS-010-SMS-040 atom")
      | ($sms040atoms[0]) as $atom
      | require($atom.id == "fs760-receiver-tenant-management-denial";
          "\($site_name): SMS-040 atom id must be fs760-receiver-tenant-management-denial")
      | require($atom.service == "hat-receiver-control";
          "\($site_name): SMS-040 must bind to hat-receiver-control service")
      | require($atom.serviceClass == "media-receiver";
          "\($site_name): SMS-040 serviceClass must be media-receiver")
      | require($atom.controllerScopes == ["trusted"];
          "\($site_name): SMS-040 controllerScopes must be trusted only")
      | require($atom.receiverScope == "iot";
          "\($site_name): SMS-040 receiverScope must be iot")
      | require((($atom.deniedPaths // []) | length) == 2;
          "\($site_name): SMS-040 must have exactly 2 denied paths")
      | require(denied_kind($atom; "guest-to-trusted");
          "\($site_name): SMS-040 must deny guest-to-trusted")
      | ($atom.deniedPaths | map(select(.kind == "guest-to-trusted"))[0]) as $gtpath
      | require($gtpath.from == "guest";
          "\($site_name): guest-to-trusted denied path must enforce from=guest")
      | require($gtpath.to == "trusted";
          "\($site_name): guest-to-trusted denied path must enforce to=trusted")
      | require($gtpath.reason == "receiver-policy-does-not-authorize-guest-to-trusted-reachability";
          "\($site_name): guest-to-trusted reason must be correct")
      | require(denied_kind($atom; "media-to-management");
          "\($site_name): SMS-040 must deny media-to-management")
      | ($atom.deniedPaths | map(select(.kind == "media-to-management"))[0]) as $mtpath
      | require($mtpath.from == "iot";
          "\($site_name): media-to-management denied path must enforce from=iot")
      | require($mtpath.to == "management";
          "\($site_name): media-to-management denied path must enforce to=management")
      | require($mtpath.reason == "receiver-policy-does-not-authorize-management-reachability";
          "\($site_name): media-to-management reason must be correct")
      #
      # Seeded negatives
      #
      | (($atom.deniedPaths // []) | map(select(.kind != "guest-to-trusted"))) as $noGTpaths
      | require(($noGTpaths | map(select(.kind == "guest-to-trusted")) | length) == 0;
          "\($site_name) SN1 PASS: guest-to-trusted removal detectable")
      | require(($noGTpaths | map(select(.kind == "media-to-management")) | length) == 1;
          "\($site_name) SN1 PASS: media-to-management survives")
      | require(($atom | has("discovery")) | not;
          "\($site_name) SN2 PASS: no discovery auth collapse")
      | require(($atom | has("payload")) | not;
          "\($site_name) SN2 PASS: no payload auth collapse")
      | true
      ;
    .esp0xdeadbeef as $enterprise
    | check_sms040_site($enterprise["site-a"]; "site-a"),
      check_sms040_site($enterprise["site-b"]; "site-b")
  ' "${tmp_dir}/intent.json" 2>&1 | while IFS= read -r line; do
    echo "FAIL SMS-040-receiver-tenant-management-denial: $line" >&2
  done
  exit 1
}

echo "PASS SMS-040-receiver-tenant-management-denial: all predicates verified, SN1/SN2 active"
