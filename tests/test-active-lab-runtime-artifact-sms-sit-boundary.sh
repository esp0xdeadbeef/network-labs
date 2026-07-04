#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
runner="${repo_root}/tests/run-active-lab-mini-smt.sh"

fail() {
  echo "FAIL active-lab-runtime-artifact-sms-sit-boundary: $*" >&2
  exit 1
}

traces=(
  FS-820-HDS-010-SDS-010-SMS-050
  FS-830-HDS-010-SDS-010-SMS-040
  FS-840-HDS-010-SDS-010-SMS-040
  FS-860-HDS-010-SDS-010-SMS-030
  FS-880-HDS-010-SDS-010-SMS-010
  FS-970-HDS-010-SDS-010-SMS-040
)

for trace in "${traces[@]}"; do
  source_info="$("${runner}" --source "${trace}")"
  grep -Fxq "traceId=${trace}" <<<"${source_info}" \
    || fail "${trace} --source did not return the full trace"
  grep -Fxq "kind=intent-source" <<<"${source_info}" \
    || fail "${trace} must remain an intent-source row"
  grep -Fxq "evidenceBoundary=active-lab-mini-smt-runtime-artifact" <<<"${source_info}" \
    || fail "${trace} must be runtime artifact applicable"
  grep -Fxq "maxRuntimeTargets=5" <<<"${source_info}" \
    || fail "${trace} must keep five router runtime targets on router hosts"
done

REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  boundary = "active-lab-mini-smt-runtime-artifact";
  rows = [
    { trace = "FS-820-HDS-010-SDS-010-SMS-050"; sds = "FS-820-HDS-010-SDS-010"; }
    { trace = "FS-830-HDS-010-SDS-010-SMS-040"; sds = "FS-830-HDS-010-SDS-010"; }
    { trace = "FS-840-HDS-010-SDS-010-SMS-040"; sds = "FS-840-HDS-010-SDS-010"; }
    { trace = "FS-860-HDS-010-SDS-010-SMS-030"; sds = "FS-860-HDS-010-SDS-010"; }
    { trace = "FS-880-HDS-010-SDS-010-SMS-010"; sds = "FS-880-HDS-010-SDS-010"; }
    { trace = "FS-970-HDS-010-SDS-010-SMS-040"; sds = "FS-970-HDS-010-SDS-010"; }
  ];
  require = cond: msg: if cond then true else throw msg;
  contains = haystack: needle:
    builtins.stringLength (builtins.replaceStrings [ needle ] [ "" ] haystack)
    < builtins.stringLength haystack;
  rowOk = row:
    let
      smt = import (repoRoot + "/GAMP/SMT/" + row.trace + "/default.nix");
      sms = import (repoRoot + "/GAMP/SMS/" + row.trace + "/default.nix");
      sds = import (repoRoot + "/GAMP/SDS/" + row.sds + "/default.nix");
      sit = import (repoRoot + "/GAMP/SIT/" + row.sds + "/default.nix");
      smsSource = sms.sourceInputs.${row.trace};
      sdsInput = sds.smsInputs.${row.trace};
      sitInput = sit.smsInputs.${row.trace};
    in
      require (smt.evidenceBoundary == boundary) (row.trace + " SMT boundary mismatch")
      && require (smt.source.kind == "intent-source") (row.trace + " SMT source kind mismatch")
      && require (smt.source.expectedRuntimeTargets."s-router-nixos" == 5) (row.trace + " SMT NixOS target count mismatch")
      && require (smt.source.expectedRuntimeTargets."s-router-clab" == 5) (row.trace + " SMT CLAB target count mismatch")
      && require (smt.source.expectedRuntimeTargets."s-router-test-clients" == 0) (row.trace + " SMT test-client target count mismatch")
      && require (sms.evidenceBoundary == boundary) (row.trace + " SMS boundary mismatch")
      && require (smsSource.kind == "intent-source") (row.trace + " SMS source kind mismatch")
      && require (smsSource.expectedRuntimeTargets."s-router-test-clients" == 0) (row.trace + " SMS test-client target count mismatch")
      && require (sdsInput.evidenceBoundary == boundary) (row.trace + " SDS input boundary mismatch")
      && require (sdsInput.expectedRuntimeTargets."s-router-test-clients" == 0) (row.trace + " SDS test-client target count mismatch")
      && require (sitInput.evidenceBoundary == boundary) (row.trace + " SIT input boundary mismatch")
      && require (sitInput.expectedRuntimeTargets."s-router-test-clients" == 0) (row.trace + " SIT test-client target count mismatch")
      && require (contains sit.evidence.liveCommand "S_ROUTER_TEST_CLIENTS=s-router-test-clients") (row.trace + " SIT live command must name s-router-test-clients")
      && require (contains sit.evidence.liveCommand row.trace) (row.trace + " SIT live command must name full trace")
      && require (contains (smt.evidence.liveScript or "") row.trace) (row.trace + " SMT live script must name full trace");
in
  builtins.all rowOk rows
' >/dev/null || fail "metadata boundary evaluation failed"

echo "PASS active-lab runtime artifact boundary is wired through SMS/SDS/SMT/SIT for related rows"
