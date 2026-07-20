#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-030-SDS-030-SMS-010
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
trace_id="FS-800-HDS-030-SDS-030-SMS-010"

fail() {
  echo "FAIL ${trace_id}: $*" >&2
  exit 1
}

nix eval --impure --expr "
let
  mini = import ${repo_root}/GAMP/SMT/mini-smt/default.nix;
  table = import ${repo_root}/GAMP/SAT/provider-access-fixture-table.nix;
  lab = mini.labs.\"${trace_id}\";
  validator = mini.validators.pppoePair;
  require = cond: msg: if cond then true else throw msg;
  expectOk = label: pair:
    let result = validator pair;
    in require (result.ok && result.diagnostic == null)
      (label + \" should be accepted by mini.validators.pppoePair, got \" + builtins.toJSON result);
  expectReject = label: diagnostic: pair:
    let result = validator pair;
    in require (!result.ok && result.diagnostic == diagnostic)
      (label + \" should reject with \" + diagnostic + \", got \" + builtins.toJSON result);
  fixturePair = row: {
    inherit (row) provider customer;
    fallback = false;
    transportClassification = \"pppoe\";
  };
  pair = lab.pppoePairs.primary;
in
  require (lab.traceId == \"${trace_id}\")
    \"mini PPPoE pairing lab must carry the exact trace id\"
  && require (lab.testsOnly == [
    \"provider-customer-pairing\"
    \"fallback-rejection\"
    \"transport-classification\"
  ])
    \"mini PPPoE pairing lab must enumerate the pairing/fallback/transport predicates\"
  && expectOk \"happy path mini-lab primary pair\" pair
  && expectOk \"happy path SAT pppoeNixos fixture pair\" (fixturePair table.pppoeNixos)
  && expectOk \"happy path SAT pppoeClab fixture pair\" (fixturePair table.pppoeClab)
  && expectReject \"SN1 provider-only row\" \"missing-customer-surface\" (removeAttrs pair [ \"customer\" ])
  && expectOk \"SN1 recovery row\" (pair // {
    customer = {
      target = \"recovered-client\";
      coreInterface = \"wan0\";
      runtimeInterface = \"ppp0\";
      routeAuthority = \"connected\";
    };
  })
  && expectReject \"SN2 customer-only row\" \"missing-provider-surface\" (removeAttrs pair [ \"provider\" ])
  && expectOk \"SN2 recovery row\" (pair // {
    provider = {
      target = \"recovered-provider\";
      handoff = \"pppoe\";
      routeDeliveryClass = \"connected\";
    };
  })
  && expectReject \"SN3 fallback row\" \"fallback-enabled\" (pair // { fallback = true; })
  && expectOk \"SN3 recovery row\" (pair // { fallback = false; })
  && expectReject \"SN4 opaque transport row\" \"opaque-transport-classification\" (pair // { transportClassification = \"opaque\"; })
  && expectOk \"SN4 recovery row\" (pair // { transportClassification = \"pppoe\"; })
  && expectReject \"SN5 unpaired row\" \"unpaired-pppoe-row\" { }
" >/dev/null || fail "PPPoE pairing validator contract failed"

echo "PASS ${trace_id}"
