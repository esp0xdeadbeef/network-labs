#!/usr/bin/env bash
# GAMP-SCOPE: SDS/SMS/SIT source-template mapping guard; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  echo "FAIL gamp-sds-sms-template-mapping: $*" >&2
  exit 1
}

check_row() {
  local expected_layer="$1"
  local row_path="$2"

  EXPECTED_LAYER="${expected_layer}" \
  REPO_ROOT="${repo_root}" \
  ROW_PATH="${row_path}" \
  nix eval --impure --expr '
    let
      expectedLayer = builtins.getEnv "EXPECTED_LAYER";
      repoRoot = builtins.getEnv "REPO_ROOT";
      rowPath = builtins.getEnv "ROW_PATH";
      row = import rowPath;
      require = cond: msg: if cond then true else throw msg;
      pathExistsRel = rel:
        builtins.pathExists (repoRoot + "/" + rel)
        || builtins.pathExists (repoRoot + "/../" + rel);

      sourceInputs = row.sourceInputs or { };
      sourceInputsOk =
        expectedLayer != "SMS"
        || builtins.all
          (name:
            let input = sourceInputs.${name}; in
              (!(input ? sourcePath) || pathExistsRel input.sourcePath))
          (builtins.attrNames sourceInputs);

      smsInputs = row.smsInputs or { };
      smsInputsOk =
        expectedLayer != "SMS"
        || builtins.all
          (name:
            let input = smsInputs.${name}; in
              (!(input ? smsRow) || builtins.pathExists input.smsRow)
              && (!(input ? sourcePath) || pathExistsRel input.sourcePath))
          (builtins.attrNames smsInputs);

      templateTestsOk =
        builtins.all pathExistsRel (row.templateTests or [ ]);

      evidenceSourcePathsOk =
        expectedLayer != "SMS"
        || builtins.all pathExistsRel (row.evidence.sourcePaths or [ ]);
    in
      require ((row.layer or null) == expectedLayer) "row layer mismatch"
      && require sourceInputsOk "row sourceInputs contain a missing sourcePath"
      && require smsInputsOk "row smsInputs contain a missing smsRow or sourcePath"
      && require templateTestsOk "row templateTests contain a missing test"
      && require evidenceSourcePathsOk "row evidence.sourcePaths contain a missing source path"
  ' >/dev/null || fail "${expected_layer} row failed template mapping checks: ${row_path}"
}

mapfile -t sds_rows < <(find "${repo_root}/GAMP/SDS" -mindepth 2 -maxdepth 2 -name default.nix -print | sort)
mapfile -t sms_rows < <(find "${repo_root}/GAMP/SMS" -mindepth 2 -maxdepth 2 -name default.nix -print | sort)
mapfile -t sit_rows < <(find "${repo_root}/GAMP/SIT" -mindepth 2 -maxdepth 2 -name default.nix -print | sort)

((${#sds_rows[@]} > 0)) || fail "no SDS rows found"
((${#sms_rows[@]} > 0)) || fail "no SMS rows found"
((${#sit_rows[@]} > 0)) || fail "no SIT rows found"

for row in "${sds_rows[@]}"; do
  check_row "SDS" "${row}"
done

for row in "${sms_rows[@]}"; do
  check_row "SMS" "${row}"
done

for row in "${sit_rows[@]}"; do
  check_row "SIT" "${row}"
done

REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  sds = import (repoRoot + "/GAMP/SDS/FS-166-HDS-010-SDS-010/default.nix");
  sms = import (repoRoot + "/GAMP/SMS/FS-166-HDS-010-SDS-010-SMS-900/default.nix");
  sit = import (repoRoot + "/GAMP/SIT/FS-166-HDS-010-SDS-010/default.nix");
  manifest = import (repoRoot + "/GAMP/SMT/mini-smt/tests.nix");
  require = cond: msg: if cond then true else throw msg;
  pathExistsRel = rel:
    builtins.pathExists (repoRoot + "/" + rel)
    || builtins.pathExists (repoRoot + "/../" + rel);
  manifestIds = builtins.attrNames manifest.tests;
  sourceNames = builtins.attrNames sms.sourceInputs;
  ids = map (name: sms.sourceInputs.${name}.traceId) sourceNames;
  activeMiniSmtSmsKeysMatchTrace =
    builtins.all
      (id:
        let row = import (repoRoot + "/GAMP/SMS/" + id + "/default.nix");
            sourceInputs = row.sourceInputs or { };
        in
	          builtins.any
	            (name: (sourceInputs.${name}.traceId or null) == id)
	            (builtins.attrNames sourceInputs))
	      ids;
  sourceNameForTrace = trace:
    builtins.head (builtins.filter (name: sms.sourceInputs.${name}.traceId == trace) sourceNames);
  sitSourcePaths = sit.evidence.sourcePaths or [ ];
  sourceMatches = id:
    let
      source = sms.sourceInputs.${sourceNameForTrace id};
      entry = builtins.getAttr id manifest.tests;
    in
      source.traceId == entry.traceId
      && source.test == entry.script
      && pathExistsRel source.sourcePath
      && pathExistsRel source.test
      && builtins.elem source.sourcePath sitSourcePaths;
in
  require (builtins.all (id: builtins.hasAttr id sds.smsInputs) ids) "FS-166 SMS sourceInputs reference an SDS mini SMT trace missing from SDS smsInputs"
  && require (builtins.all (id: builtins.hasAttr id manifest.tests) ids) "FS-166 SDS references an SMS mini SMT missing from manifest"
  && require activeMiniSmtSmsKeysMatchTrace "active mini SMT SMS sourceInputs must contain the full trace ID"
  && require (builtins.length ids == builtins.length sourceNames) "FS-166 SMS sourceInputs and SDS mini SMT count differ"
  && require (builtins.all sourceMatches ids) "FS-166 SDS/SMS/SIT/manifest source mapping mismatch"
' >/dev/null || fail "FS-166 SDS/SMS/SIT source mapping failed"

echo "PASS gamp-sds-sms-template-mapping"
