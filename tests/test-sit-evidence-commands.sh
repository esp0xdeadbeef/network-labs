#!/usr/bin/env bash
# GAMP-SCOPE: SIT-to-SMS catalog derivation; not runtime evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

count="$({
  REPO_ROOT="${repo_root}" nix eval --impure --raw --expr '
    let
      repoRoot = builtins.getEnv "REPO_ROOT";
      sitRoot = repoRoot + "/GAMP/SIT";
      manifest = import (repoRoot + "/GAMP/SMT/mini-smt/tests.nix");
      names = builtins.filter
        (name:
          (builtins.readDir sitRoot).${name} == "directory"
          && builtins.match "FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+" name != null
          && builtins.pathExists (sitRoot + "/${name}/default.nix"))
        (builtins.attrNames (builtins.readDir sitRoot));
      validRow = name:
        let
          row = import (sitRoot + "/${name}/default.nix");
          smsIds = builtins.attrNames (row.smsInputs or { });
        in
          (row.layer or null) == "SIT"
          && (row.traceId or null) == name
          && builtins.all
            (traceId:
              builtins.match "${name}-SMS-[0-9]+" traceId != null
              && builtins.hasAttr traceId manifest.tests)
            smsIds;
    in
      if builtins.all validRow names
      then builtins.toString (builtins.length names)
      else throw "SIT rows do not derive their SMS catalog from full trace IDs"
  '
} 2>&1)" || {
  printf 'FAIL SIT catalog derivation: %s\n' "${count}" >&2
  exit 1
}

printf 'PASS SIT catalog derivation: %s SDS rows use full SMS trace IDs without runner mappings\n' "${count}"
