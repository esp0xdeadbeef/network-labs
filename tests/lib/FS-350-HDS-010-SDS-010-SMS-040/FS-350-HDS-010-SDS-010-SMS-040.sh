#!/usr/bin/env bash
# GAMP-ID: FS-350-HDS-010-SDS-010-SMS-040
# GAMP-SCOPE: row-local SMT construction test for prefix authority class separation
# VEB: construction-only — no runtime targets
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
fixture="${repo_root}/GAMP/SMT/FS-350-HDS-010-SDS-010-SMS-040/intent.nix"
nfm_repo="${NFM_REPO_ROOT:-/home/deadbeef/github/network-forwarding-model}"

fail() {
  echo "FAIL FS-350-HDS-010-SDS-010-SMS-040: $*" >&2
  exit 1
}

[[ -f "${fixture}" ]] || fail "missing fixture: ${fixture}"
[[ -d "${nfm_repo}" ]] || fail "missing network-forwarding-model repo: ${nfm_repo}"

# Evaluate NFM prefix-authority classification functions against the row-local fixture.
# We use `nix eval` with the network-forwarding-model flake to test:
#   1. Authority class assignment (records.build)
#   2. Consumer eligibility classification (requests.classify)
#   3. Seeded negatives: reserved-space denial, unassigned-space rejection,
#      invalid-consumer-for-authority-class

nix eval --impure --expr "
  let
    fixture = import ${fixture};
    nfmFlake = builtins.getFlake \"path:${nfm_repo}\";
    lib = nfmFlake.inputs.nixpkgs.lib;

    # Build prefix authority records from the fixture
    recordsMod = import \"\${nfmFlake}/implementation/lib/model/prefix-authority/records.nix\" {
      inherit lib;
      self = { outPath = \"\${nfmFlake}\"; };
    };
    records = recordsMod.build {
      tenantPrefixOwners = builtins.listToAttrs (
        map (name: { inherit name; value = fixture.tenantPrefixOwners.\"\${name}\"; })
          (builtins.attrNames fixture.tenantPrefixOwners)
      );
      reservations = fixture.reservations;
    };

    recordsById = builtins.listToAttrs (
      map (r: { name = r.id; value = r; }) records
    );

    # Classify consumer requests
    requestsMod = import \"\${nfmFlake}/implementation/lib/model/prefix-authority/requests.nix\" {
      inherit lib;
      self = { outPath = \"\${nfmFlake}\"; };
    };
    classified = requestsMod.classify recordsById (
      builtins.listToAttrs (
        map (r: { name = r.id; value = r; }) fixture.consumerRequests
      )
    );
    classifiedById = builtins.listToAttrs (
      map (c: { name = c.id; value = c; }) classified
    );

    require = cond: msg: if cond then true else throw msg;

    authClass = id: (recordsById.\"\${id}\".authorityClass or null);
    childPurpose = id: (recordsById.\"\${id}\".childPurpose or null);
    consumerElig = id: consumer: (recordsById.\"\${id}\".consumerEligibility.\"\${consumer}\" or false);

    classifyOk = id: (classifiedById.\"\${id}\".allowed or false);
    classifyReason = id: (classifiedById.\"\${id}\".reason or null);

    result = rec {
      # ---- Authority class assignment checks ----
      check1 = require
        (authClass \"prefix-authority::access-client::4|10.10.0.0/24\" == \"access-subnet-pool\")
        \"access-client IPv4 must be access-subnet-pool\";
      check2 = require
        (authClass \"prefix-authority::access-client::6|fd42:10:a::/64\" == \"access-subnet-pool\")
        \"access-client IPv6 ULA must be access-subnet-pool\";
      check3 = require
        (authClass \"prefix-authority::access-client::6|source:/run/pd/client.prefix\" == \"routed-client-prefix\")
        \"runtime-routed GUA must be routed-client-prefix\";
      check4 = require
        (authClass \"prefix-authority::access-client::4|203.0.113.0/28\" == \"routed-public-ipv4\")
        \"routed-public-ipv4 kind must yield routed-public-ipv4 class\";
      check5 = require
        (authClass \"prefix-authority::provider-a::4|198.51.100.1/32\" == \"host-only-provider-prefix\")
        \"host-only provider IPv4 must be host-only-provider-prefix\";
      check6 = require
        (authClass \"prefix-authority::provider-a::6|fd42:egress::/48\" == \"nat66-egress-prefix\")
        \"NAT66 egress prefix must be nat66-egress-prefix\";
      check7 = require
        (authClass \"prefix-authority::provider-a::4|10.255.0.0/24\" == \"private-ipv4-egress-prefix\")
        \"private IPv4 egress must be private-ipv4-egress-prefix\";

      # ---- childPurpose checks ----
      check8 = require
        (childPurpose \"prefix-authority::access-client::4|10.10.0.0/24\" == \"tenant-or-access-assignment\")
        \"access-subnet-pool child purpose must be tenant-or-access-assignment\";
      check9 = require
        (childPurpose \"prefix-authority::access-client::6|source:/run/pd/client.prefix\" == \"downstream-client-routing\")
        \"routed-client-prefix child purpose must be downstream-client-routing\";
      check10 = require
        (childPurpose \"prefix-authority::provider-a::4|198.51.100.1/32\" == \"provider-endpoint-host-address\")
        \"host-only provider child purpose must be provider-endpoint-host-address\";
      check11 = require
        (childPurpose \"prefix-authority::provider-a::6|fd42:egress::/48\" == \"translation-egress-source\")
        \"NAT66 egress child purpose must be translation-egress-source\";
      check12 = require
        (childPurpose \"prefix-authority::provider-a::4|10.255.0.0/24\" == \"ipv4-translation-egress-source\")
        \"private IPv4 egress child purpose must be ipv4-translation-egress-source\";

      # ---- Consumer eligibility: allowed cases ----
      check13 = require
        (consumerElig \"prefix-authority::access-client::4|10.10.0.0/24\" \"assignment\" == true)
        \"access-subnet-pool must allow assignment\";
      check14 = require
        (consumerElig \"prefix-authority::access-client::4|10.10.0.0/24\" \"route\" == true)
        \"access-subnet-pool must allow route\";
      check15 = require
        (consumerElig \"prefix-authority::provider-a::4|198.51.100.1/32\" \"route\" == true)
        \"host-only-provider-prefix must allow route\";
      check16 = require
        (consumerElig \"prefix-authority::provider-a::4|198.51.100.1/32\" \"assignment\" == false)
        \"host-only-provider-prefix must deny assignment\";

      # ---- Consumer eligibility: denied cases (authority class separation) ----
      check17 = require
        (consumerElig \"prefix-authority::access-client::4|10.10.0.0/24\" \"translation\" == false)
        \"access-subnet-pool must deny translation — authority class separation\";
      check18 = require
        (consumerElig \"prefix-authority::access-client::4|10.10.0.0/24\" \"advertisement\" == false)
        \"access-subnet-pool must deny advertisement — authority class separation\";

      # ---- Consumer request classification: PASS cases ----
      check19 = require
        (classifyOk \"assign-access-v4\" && classifyReason \"assign-access-v4\" == \"allowed\")
        \"assign-access-v4 must be allowed\";
      check20 = require
        (classifyOk \"route-access-v4\" && classifyReason \"route-access-v4\" == \"allowed\")
        \"route-access-v4 must be allowed\";
      check21 = require
        (classifyOk \"route-runtime-gua\" && classifyReason \"route-runtime-gua\" == \"allowed\")
        \"route-runtime-gua must be allowed\";
      check22 = require
        (classifyOk \"route-host-only\" && classifyReason \"route-host-only\" == \"allowed\")
        \"route-host-only must be allowed\";
      check23 = require
        (classifyOk \"translate-nat66-egress\" && classifyReason \"translate-nat66-egress\" == \"allowed\")
        \"translate-nat66-egress must be allowed\";
      check24 = require
        (classifyOk \"translate-private-ipv4-egress\" && classifyReason \"translate-private-ipv4-egress\" == \"allowed\")
        \"translate-private-ipv4-egress must be allowed\";

      # ---- Seeded negative: invalid consumer for authority class ----
      check25 = require
        (!classifyOk \"translate-access-v4-illegal\" && classifyReason \"translate-access-v4-illegal\" == \"invalid-consumer-for-authority-class\")
        \"SN1: access-subnet-pool must reject translation — invalid-consumer-for-authority-class\";
      check26 = require
        (!classifyOk \"advertise-access-v4-illegal\" && classifyReason \"advertise-access-v4-illegal\" == \"invalid-consumer-for-authority-class\")
        \"SN1: access-subnet-pool must reject advertisement — invalid-consumer-for-authority-class\";
      check27 = require
        (!classifyOk \"assign-host-only-illegal\" && classifyReason \"assign-host-only-illegal\" == \"invalid-consumer-for-authority-class\")
        \"SN1: host-only-provider-prefix must reject assignment — invalid-consumer-for-authority-class\";

      # ---- Seeded negative: reserved space denial ----
      check28 = require
        (!classifyOk \"consume-reserved\" && classifyReason \"consume-reserved\" == \"reserved-prefix-authority\")
        \"SN2: reserved space must be denied — reserved-prefix-authority\";

      # ---- Seeded negative: unassigned prefix (missing authority class) ----
      check29 = require
        (!classifyOk \"consume-unassigned\" && classifyReason \"consume-unassigned\" == \"unassigned-prefix-authority\")
        \"SN3: unassigned prefix must be rejected — unassigned-prefix-authority\";

      # ---- Seeded negative: public IPv4 route allowed ----
      check30 = require
        (classifyOk \"route-public-v4\" && classifyReason \"route-public-v4\" == \"allowed\")
        \"routed-public-ipv4 must allow route\";
      check31 = require
        (classifyOk \"expose-public-v4\" && classifyReason \"expose-public-v4\" == \"allowed\")
        \"routed-public-ipv4 must allow exposure\";

      ok = true;
    };
  in
    result.ok
" >/dev/null || fail "prefix authority class separation contract failed"

echo "PASS FS-350-HDS-010-SDS-010-SMS-040-prefix-authority-class-separation"
