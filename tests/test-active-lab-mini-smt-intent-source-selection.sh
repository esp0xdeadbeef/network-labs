#!/usr/bin/env bash
# GAMP-SCOPE: active-lab mini SMT/SIT intent source selection; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
manifest_file="${repo_root}/GAMP/SMT/mini-smt/tests.nix"
runner="${repo_root}/tests/run-active-lab-mini-smt.sh"

fail() {
  echo "FAIL active-lab-mini-smt-intent-source-selection: $*" >&2
  exit 1
}

nix-instantiate --parse "${repo_root}/GAMP/SMT/FS-800-HDS-030-SDS-030-SMS-010/intent.nix" >/dev/null
nix-instantiate --parse "${repo_root}/GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-010/intent.nix" >/dev/null
nix-instantiate --parse "${repo_root}/GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-040/intent.nix" >/dev/null

REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  active = import (repoRoot + "/active-lab");
  current = import (repoRoot + "/current-lab");
  manifest = import '"${manifest_file}"';
  pppoe = manifest.tests.pppoe-pairing;
  reachability = manifest.tests.reachability-decision;
  p2p = manifest.tests.p2p-next-hop;
  pppoeSource = active.mkSource { intent = pppoe.source.intent; };
  reachabilitySource = active.mkSource { intent = reachability.source.intent; };
  p2pSource = active.mkSource { intent = p2p.source.intent; };
  require = cond: msg: if cond then true else throw msg;
  collectIds =
    value:
    if builtins.isAttrs value then
      (if value ? id then [ value.id ] else [ ])
      ++ builtins.concatLists (map collectIds (builtins.attrValues value))
    else if builtins.isList value then
      builtins.concatLists (map collectIds value)
    else
      [ ];
  pppoeIds = collectIds pppoeSource.intent;
  reachabilityIds = collectIds reachabilitySource.intent;
  p2pIds = collectIds p2pSource.intent;
  activeDefaultIntentPath = repoRoot + "/active-lab/intent.nix";
  globalTrace = active.intent.control_plane_model.meta.traceId or null;
  selectedDefaultMini =
    current.selection.layer == "SMT"
    && current.selection.selector == "FS-166-HDS-010-SDS-010-SMS-900__active-lab-mini-runtime";
  selectedSourceExplicit =
    builtins.isString (current.selection.sourceRoot or null)
    && builtins.isString (current.selection.sourcePath or null)
    && current.selection.sourceRoot != ""
    && current.selection.sourcePath != "";
  pppoeRelation = builtins.head pppoe.source.expectedRelationIds;
  reachabilityRelation = builtins.head reachability.source.expectedRelationIds;
  p2pRelation = builtins.head p2p.source.expectedRelationIds;
in
  require (builtins.isFunction active.mkSource) "active-lab must expose mkSource for alternate intent files"
  && require (pppoe.source.kind == "intent-source") "pppoe mini SMT must declare intent-source"
  && require (reachability.source.kind == "intent-source") "reachability mini SMT must declare intent-source"
  && require (p2p.source.kind == "intent-source") "p2p mini SMT must declare intent-source"
  && require (toString pppoe.source.intent != toString p2p.source.intent) "mini SMT intent files must be distinct"
  && require (toString reachability.source.intent != toString pppoe.source.intent) "reachability and pppoe intent files must be distinct"
  && require (toString reachability.source.intent != toString p2p.source.intent) "reachability and p2p intent files must be distinct"
  && require (toString pppoeSource.sourcePaths.intent == toString pppoe.source.intent) "pppoe mkSource must preserve the selected intent path"
  && require (toString reachabilitySource.sourcePaths.intent == toString reachability.source.intent) "reachability mkSource must preserve the selected intent path"
  && require (toString p2pSource.sourcePaths.intent == toString p2p.source.intent) "p2p mkSource must preserve the selected intent path"
  && require (builtins.elem pppoeRelation pppoeIds) "pppoe selected intent must expose the PPPoE relation"
  && require (!(builtins.elem reachabilityRelation pppoeIds)) "pppoe selected intent must not expose the reachability relation"
  && require (!(builtins.elem p2pRelation pppoeIds)) "pppoe selected intent must not expose the p2p relation"
  && require (builtins.elem reachabilityRelation reachabilityIds) "reachability selected intent must expose the reachability relation"
  && require (!(builtins.elem pppoeRelation reachabilityIds)) "reachability selected intent must not expose the PPPoE relation"
  && require (!(builtins.elem p2pRelation reachabilityIds)) "reachability selected intent must not expose the p2p relation"
  && require (builtins.elem p2pRelation p2pIds) "p2p selected intent must expose the p2p relation"
  && require (!(builtins.elem reachabilityRelation p2pIds)) "p2p selected intent must not expose the reachability relation"
  && require (!(builtins.elem pppoeRelation p2pIds)) "p2p selected intent must not expose the PPPoE relation"
  && require (toString active.sourcePaths.intent == activeDefaultIntentPath) "global active-lab source path must remain active-lab/intent.nix"
  && require (
    if selectedDefaultMini then
      globalTrace == "FS-166-HDS-010-SDS-010-SMS-900__active-lab-mini-runtime"
    else
      selectedSourceExplicit
  ) "global active-lab selection must be explicit and may be HAT/SAT/non-default SMT"
  && require (toString pppoeSource.sourcePaths.intent != toString active.sourcePaths.intent) "pppoe mini intent must be separate from global active-lab intent"
  && require (toString reachabilitySource.sourcePaths.intent != toString active.sourcePaths.intent) "reachability mini intent must be separate from global active-lab intent"
  && require (toString p2pSource.sourcePaths.intent != toString active.sourcePaths.intent) "p2p mini intent must be separate from global active-lab intent"
' >/dev/null || fail "alternate intent source selection failed"

pppoe_source="$("${runner}" --source FS-800-HDS-030-SDS-030-SMS-010)"
reachability_source="$("${runner}" --source FS-500-HDS-010-SDS-010-SMS-010)"
p2p_source="$("${runner}" --source FS-500-HDS-010-SDS-010-SMS-040)"

grep -Fq "kind=intent-source" <<<"${pppoe_source}" \
  || fail "runner must report pppoe-pairing as intent-source"
grep -Fq "GAMP/SMT/FS-800-HDS-030-SDS-030-SMS-010/intent.nix" <<<"${pppoe_source}" \
  || fail "runner must report the pppoe-pairing intent path"
grep -Fq "kind=intent-source" <<<"${reachability_source}" \
  || fail "runner must report reachability-decision as intent-source"
grep -Fq "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-010/intent.nix" <<<"${reachability_source}" \
  || fail "runner must report the reachability-decision intent path"
grep -Fq "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-040/intent.nix" <<<"${p2p_source}" \
  || fail "runner must report the p2p-next-hop intent path"

echo "PASS active-lab-mini-smt-intent-source-selection"
