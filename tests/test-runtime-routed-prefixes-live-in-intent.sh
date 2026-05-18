#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bad_inventory="$(mktemp)"
bad_intent="$(mktemp)"
trap 'rm -f "${bad_inventory}" "${bad_intent}"' EXIT

while IFS= read -r inventory; do
  nix-instantiate --eval --strict --json --expr "
    let
      root = import ${inventory};
      lib = import <nixpkgs/lib>;
      collect = path: value:
        if builtins.isAttrs value then
          let
            own =
              if value ? routedPrefixes && builtins.isAttrs value.routedPrefixes then
                lib.concatMap
                  (name:
                    let routed = value.routedPrefixes.\${name}; in
                    if builtins.isAttrs routed
                      && (
                        routed ? delegatedPrefixLength
                        || routed ? perTenantPrefixLength
                        || routed ? slot
                        || routed ? sourceFile
                      )
                    then [ { inherit path name routed; } ]
                    else [ ])
                  (builtins.attrNames value.routedPrefixes)
              else
                [ ];
          in
          own ++ lib.concatMap
            (name: collect (path ++ [ name ]) value.\${name})
            (builtins.attrNames value)
        else if builtins.isList value then
          lib.concatLists (builtins.genList
            (idx: collect (path ++ [ (toString idx) ]) (builtins.elemAt value idx))
            (builtins.length value))
        else
          [ ];
    in
    collect [ ] root
  " | jq -e 'length == 0' >/dev/null || {
    echo "${inventory}" >>"${bad_inventory}"
  }
done < <(find "${repo_root}/examples" "${repo_root}/labs" -name 'inventory*.nix' -type f | sort)

while IFS= read -r intent; do
  [[ -n "${intent}" ]] || continue
  nix-instantiate --eval --strict --json --expr "
    let
      root = import ${intent};
      lib = import <nixpkgs/lib>;
      isRuntime = value:
        builtins.isAttrs value
        && (value.allocation or null) == \"runtime\";
      collect = path: value:
        if isRuntime value then
          [ { inherit path value; } ]
        else if builtins.isAttrs value then
          lib.concatMap
            (name: collect (path ++ [ name ]) value.\${name})
            (builtins.attrNames value)
        else if builtins.isList value then
          lib.concatLists (builtins.genList
            (idx: collect (path ++ [ (toString idx) ]) (builtins.elemAt value idx))
            (builtins.length value))
        else
          [ ];
      runtimePrefixes = collect [ ] root;
      missing = builtins.filter
        (entry:
          let value = entry.value;
          in
          !(builtins.isInt (value.delegatedPrefixLength or null))
          || !(builtins.isInt (value.perTenantPrefixLength or null))
          || !(builtins.isInt (value.slot or null))
          || !(builtins.isString (value.sourceFile or null))
          || (value.sourceFile or \"\") == \"\")
        runtimePrefixes;
    in
    missing
  " | jq -e 'length == 0' >/dev/null || {
    echo "${intent}" >>"${bad_intent}"
  }
done < <(find "${repo_root}/examples" "${repo_root}/labs" -name intent.nix -type f | sort)

if [[ -s "${bad_inventory}" || -s "${bad_intent}" ]]; then
  echo "FAIL runtime-routed-prefixes-live-in-intent" >&2
  if [[ -s "${bad_inventory}" ]]; then
    echo "inventory still carries runtime routed-prefix semantics:" >&2
    cat "${bad_inventory}" >&2
  fi
  if [[ -s "${bad_intent}" ]]; then
    echo "intent runtime routed-prefix entries missing delegated/per-tenant/sourceFile/slot fields:" >&2
    cat "${bad_intent}" >&2
  fi
  exit 1
fi

echo "PASS runtime-routed-prefixes-live-in-intent"
