#!/usr/bin/env bash
# GAMP-ID: FS-830-HDS-010-SDS-010-SMS-010
# CMC: Controlled Secret Preparation Context Validation
# Lane: CMC-FS830-SMS010-PREP-CTX
# Owning repo: network-labs
#
# 4 seeded negatives with active injection + diagnostic verification:
#   SN1: Missing preparation context → "no controlled preparation context"
#   SN2: Missing source binding → "no selected source binding"
#   SN3: Lifecycle mismatch → "lifecycle stage mismatch"
#   SN4: Out-of-boundary path → "source binding outside preparation boundary"
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
lab_dir="${repo_root}/GAMP/SAT"
tmp_dir="$(mktemp -d)"
tmp_json="${tmp_dir}/inventory.json"
jq_lib="${tmp_dir}/validator.jq"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL fs830-hds010-sds010-sms010-controlled-secret-preparation: $*" >&2
  exit 1
}

# Write jq validation function to a module file.
# jq's "include" directive searches paths given by -L.
cat >"${jq_lib}" <<'JQEOF'
def validate_preparation_context($config):
  . as $inv
  | ($inv.secretDeclarations // []) as $decls
  | ($inv.secretSources // []) as $sources
  | ($inv.sourceBindings // []) as $bindings
  | [ $decls[]
    | . as $decl
    | .preparationContext as $ctx
    | select($ctx != null)
    | $config[$ctx] as $ctxConfig
    | ([$bindings[] | select(.declarationId == $decl.id)] | .[0]) as $binding
    | ([$sources[] | select(.declarationId == $decl.id)] | .[0]) as $source
    | {
        secret_id: $decl.id,
        ok: (
          ($ctxConfig != null)
          and ($binding != null)
          and (($ctxConfig.allowedLifecycles // []) == [] or
            ($decl.lifecycle as $lc | $ctxConfig.allowedLifecycles | index($lc) != null))
          and (($ctxConfig.allowedRoots // []) == [] or
            ($source.reference.sourceFieldPath as $path
            | [($ctxConfig.allowedRoots[] | . as $root | $path | startswith($root))] | any))
        ),
        preparation_context: $ctx,
        lifecycle: $decl.lifecycle,
        diagnostics: (
          [(if $ctxConfig == null then "no controlled preparation context" else empty end),
           (if $ctxConfig != null and $binding == null then "no selected source binding" else empty end),
           (if $ctxConfig != null and $binding != null
               and (($ctxConfig.allowedLifecycles // []) != [])
               and ($decl.lifecycle as $lc | $ctxConfig.allowedLifecycles | index($lc) == null)
            then "lifecycle stage mismatch"
            else empty end),
           (if $ctxConfig != null and $source != null
               and (($ctxConfig.allowedRoots // []) != [])
               and ($source.reference.sourceFieldPath as $path
                    | [($ctxConfig.allowedRoots[] | . as $root | $path | startswith($root))] | any | not)
            then "source binding outside preparation boundary"
            else empty end)]
        )
      }
  ];
JQEOF

# Evaluate the inventory + validatePreparationContext nix module
nix eval --impure --json --expr "{
  raw = import ${lab_dir}/inventory.nix;
  resolved = import ${lab_dir}/getResolvedInventory.nix { renderer = \"nixos\"; };
  prepValidation = import ${lab_dir}/validatePreparationContext.nix {
    inventory = import ${lab_dir}/inventory.nix;
    preparationConfig = {
      controlled = {
        allowedLifecycles = [ \"production\" \"deployment-runtime\" \"lab-runtime\" ];
        allowedRoots = [ \"controlPlane.\" ];
      };
    };
  };
}" >"${tmp_json}"

# --------------------------------------------------------------------
# Baseline: No declarations have preparationContext → vacuously OK
# --------------------------------------------------------------------
jq -e '
  .prepValidation.allOk == true
  and (.prepValidation.validationRecords | length) == 0
  and .prepValidation.declarationsChecked == 0
  and .prepValidation.gampId == "FS-830-HDS-010-SDS-010-SMS-010"
' "${tmp_json}" >/dev/null || fail "baseline: preparation context validation should pass vacuously (no declarations have preparationContext)"

# --------------------------------------------------------------------
# Shared configs for test scenarios
# --------------------------------------------------------------------
CONTROLLED_CONFIG='{"controlled":{"allowedLifecycles":["production","deployment-runtime","lab-runtime"],"allowedRoots":["controlPlane."]}}'
EMPTY_CONFIG='{}'

# --------------------------------------------------------------------
# Shared jq preamble: include the validator module and set up data
# We define a $JQ_PREAMBLE that loads the function and sets $r = .raw
# --------------------------------------------------------------------
JQ_PREAMBLE="include \"validator\"; .raw as \$r |"

# --------------------------------------------------------------------
# SN1 happy-path baseline: Inject preparationContext with valid config
# Expected: ok == true, diagnostics == []
# --------------------------------------------------------------------
jq -L "${tmp_dir}" -e "
${JQ_PREAMBLE}
(\$r | .secretDeclarations |= map(
  if .id == \"sat-secret-wireguard-host128-private-key\" then
    . + { preparationContext: \"controlled\" }
  else . end
)) as \$mutated
| \$mutated | validate_preparation_context(${CONTROLLED_CONFIG}) as \$records
| \$records[]
| select(.secret_id == \"sat-secret-wireguard-host128-private-key\")
| .ok == true and (.diagnostics | length) == 0
" "${tmp_json}" >/dev/null || fail "SN1 happy-path baseline: valid preparation context should pass"

# --------------------------------------------------------------------
# SN1: Missing preparation context config
# Inject preparationContext: "controlled" but use empty config
# Expected: ok == false, diagnostics[0] == "no controlled preparation context"
# --------------------------------------------------------------------
jq -L "${tmp_dir}" -e "
${JQ_PREAMBLE}
(\$r | .secretDeclarations |= map(
  if .id == \"sat-secret-wireguard-host128-private-key\" then
    . + { preparationContext: \"controlled\" }
  else . end
)) as \$mutated
| \$mutated | validate_preparation_context(${EMPTY_CONFIG}) as \$records
| \$records[]
| select(.secret_id == \"sat-secret-wireguard-host128-private-key\")
| .ok == false
  and (.diagnostics | length) == 1
  and .diagnostics[0] == \"no controlled preparation context\"
" "${tmp_json}" >/dev/null || fail "SN1: missing preparation context — should REJECT with \"no controlled preparation context\""

echo "SN1 PASS: missing preparation context → \"no controlled preparation context\""

# --------------------------------------------------------------------
# SN2: Missing source binding
# Inject preparationContext: "controlled" but remove source binding
# Expected: ok == false, diagnostics[0] == "no selected source binding"
# --------------------------------------------------------------------
jq -L "${tmp_dir}" -e "
${JQ_PREAMBLE}
(\$r
  | .secretDeclarations |= map(
      if .id == \"sat-secret-wireguard-host128-private-key\" then
        . + { preparationContext: \"controlled\" }
      else . end
    )
  | .sourceBindings |= map(
      select(.declarationId != \"sat-secret-wireguard-host128-private-key\")
    )
) as \$mutated
| \$mutated | validate_preparation_context(${CONTROLLED_CONFIG}) as \$records
| \$records[]
| select(.secret_id == \"sat-secret-wireguard-host128-private-key\")
| .ok == false
  and (.diagnostics | length) == 1
  and .diagnostics[0] == \"no selected source binding\"
" "${tmp_json}" >/dev/null || fail "SN2: missing source binding — should REJECT with \"no selected source binding\""

echo "SN2 PASS: missing source binding → \"no selected source binding\""

# --------------------------------------------------------------------
# SN3: Lifecycle mismatch
# Inject preparationContext: "controlled" but change lifecycle to "development"
# (not in allowedLifecycles: [production, deployment-runtime, lab-runtime])
# Expected: ok == false, diagnostics[0] == "lifecycle stage mismatch"
# --------------------------------------------------------------------
jq -L "${tmp_dir}" -e "
${JQ_PREAMBLE}
(\$r | .secretDeclarations |= map(
  if .id == \"sat-secret-wireguard-host128-private-key\" then
    . + { preparationContext: \"controlled\", lifecycle: \"development\" }
  else . end
)) as \$mutated
| \$mutated | validate_preparation_context(${CONTROLLED_CONFIG}) as \$records
| \$records[]
| select(.secret_id == \"sat-secret-wireguard-host128-private-key\")
| .ok == false
  and (.diagnostics | length) == 1
  and .diagnostics[0] == \"lifecycle stage mismatch\"
" "${tmp_json}" >/dev/null || fail "SN3: lifecycle mismatch — should REJECT with \"lifecycle stage mismatch\""

echo "SN3 PASS: lifecycle mismatch → \"lifecycle stage mismatch\""

# --------------------------------------------------------------------
# SN4: Out-of-boundary path
# Inject preparationContext: "controlled" but change source path to
# host-local/uncontrolled/secrets/wg-key.enc (outside controlPlane. root)
# Expected: ok == false, diagnostics[0] == "source binding outside preparation boundary"
# --------------------------------------------------------------------
jq -L "${tmp_dir}" -e "
${JQ_PREAMBLE}
(\$r
  | .secretDeclarations |= map(
      if .id == \"sat-secret-wireguard-host128-private-key\" then
        . + { preparationContext: \"controlled\" }
      else . end
    )
  | .secretSources |= map(
      if .declarationId == \"sat-secret-wireguard-host128-private-key\" then
        . + {
          reference: {
            name: .reference.name,
            runtimePath: .reference.runtimePath,
            sourceFieldPath: \"host-local/uncontrolled/secrets/wg-key.enc\"
          }
        }
      else . end
    )
) as \$mutated
| \$mutated | validate_preparation_context(${CONTROLLED_CONFIG}) as \$records
| \$records[]
| select(.secret_id == \"sat-secret-wireguard-host128-private-key\")
| .ok == false
  and (.diagnostics | length) == 1
  and .diagnostics[0] == \"source binding outside preparation boundary\"
" "${tmp_json}" >/dev/null || fail "SN4: out-of-boundary path — should REJECT with \"source binding outside preparation boundary\""

echo "SN4 PASS: out-of-boundary path → \"source binding outside preparation boundary\""

echo "PASS fs830-hds010-sds010-sms010-controlled-secret-preparation"
