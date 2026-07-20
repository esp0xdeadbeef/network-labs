#!/usr/bin/env bash
# GAMP-SCOPE: SDS/SMS/SIT source mapping guard; not HAT/SAT evidence
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"

result="$({
  REPO_ROOT="${repo_root}" nix eval --impure --raw --expr '
    let
      repoRoot = builtins.getEnv "REPO_ROOT";
      manifest = import (repoRoot + "/GAMP/SMT/mini-smt/tests.nix");
      pathExistsRel = rel:
        builtins.pathExists (repoRoot + "/" + rel)
        || builtins.pathExists (repoRoot + "/../" + rel);
      rowsFor = layer: pattern:
        let
          root = repoRoot + "/GAMP/${layer}";
          names = builtins.filter
            (name:
              (builtins.readDir root).${name} == "directory"
              && builtins.match pattern name != null
              && builtins.pathExists (root + "/${name}/default.nix"))
            (builtins.attrNames (builtins.readDir root));
        in map (name: import (root + "/${name}/default.nix")) names;
      referencedPathsExist = row:
        let
          sources = builtins.attrValues (row.sourceInputs or { });
          inputs = builtins.attrValues (row.smsInputs or { });
          evidencePaths = row.evidence.sourcePaths or [ ];
        in
          builtins.all (source: !(source ? sourcePath) || pathExistsRel source.sourcePath) sources
          && builtins.all
            (input:
              (!(input ? smsRow) || builtins.pathExists input.smsRow)
              && (!(input ? smtRow) || builtins.pathExists input.smtRow)
              && (!(input ? sourcePath) || pathExistsRel input.sourcePath))
            inputs
          && builtins.all pathExistsRel evidencePaths;
      layerRowsValid = layer: rows:
        builtins.all
          (row: (row.layer or null) == layer && referencedPathsExist row)
          rows;

      sdsRows = rowsFor "SDS" "FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+";
      smsRows = rowsFor "SMS" "FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+-SMS-[0-9]+";
      sitRows = rowsFor "SIT" "FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+";

      fsSds = import (repoRoot + "/GAMP/SDS/FS-166-HDS-010-SDS-010/default.nix");
      fsSms = import (repoRoot + "/GAMP/SMS/FS-166-HDS-010-SDS-010-SMS-900/default.nix");
      ids = builtins.attrNames fsSms.sourceInputs;
      sourceValid = id:
        let
          source = fsSms.sourceInputs.${id};
          entry = manifest.tests.${id};
        in
          builtins.hasAttr id fsSds.smsInputs
          && source.traceId == entry.traceId
          && source.kind == "replacement-cpm-artifact"
          && source.replacementContract == "network-control-plane-artifact/v1"
          && source.declaredFirstActiveBoundary == "network-realization-model"
          && pathExistsRel source.sourcePath
          && toString entry.source.cpm == repoRoot + "/" + source.sourcePath;
      valid =
        sdsRows != [ ]
        && smsRows != [ ]
        && sitRows != [ ]
        && layerRowsValid "SDS" sdsRows
        && layerRowsValid "SMS" smsRows
        && layerRowsValid "SIT" sitRows
        && builtins.all sourceValid ids;
    in
      if valid
      then "SDS=${builtins.toString (builtins.length sdsRows)} SMS=${builtins.toString (builtins.length smsRows)} SIT=${builtins.toString (builtins.length sitRows)}"
      else throw "SDS/SMS/SIT source mapping mismatch"
  '
} 2>&1)" || {
  printf 'FAIL gamp-sds-sms-template-mapping: %s\n' "${result}" >&2
  exit 1
}

printf 'PASS gamp-sds-sms-template-mapping: %s\n' "${result}"
