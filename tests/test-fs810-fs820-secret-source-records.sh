#!/usr/bin/env bash
# GAMP-ID: FS-810-HDS-010-SDS-010-SMS-010
# GAMP-ID: FS-810-HDS-010-SDS-010-SMS-020
# GAMP-ID: FS-810-HDS-010-SDS-010-SMS-030
# GAMP-ID: FS-820-HDS-010-SDS-010-SMS-010
# GAMP-ID: FS-820-HDS-010-SDS-010-SMS-020
# GAMP-ID: FS-820-HDS-010-SDS-010-SMS-030
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/sat"
tmp_json="$(mktemp)"
trap 'rm -f "${tmp_json}"' EXIT

fail() {
  echo "FAIL fs810-fs820-secret-source-records: $*" >&2
  exit 1
}

nix eval --impure --json --expr "{
  raw = import ${lab_dir}/inventory.nix;
  resolved = import ${lab_dir}/getResolvedInventory.nix { renderer = \"nixos\"; };
}" >"${tmp_json}"

jq -e '
  def expected810:
    [
      "FS-810-HDS-010-SDS-010-SMS-010",
      "FS-810-HDS-010-SDS-010-SMS-020",
      "FS-810-HDS-010-SDS-010-SMS-030"
    ];
  def expected820:
    [
      "FS-820-HDS-010-SDS-010-SMS-010",
      "FS-820-HDS-010-SDS-010-SMS-020",
      "FS-820-HDS-010-SDS-010-SMS-030"
    ];
  def allowed_source_classes:
    [
      "protected-inventory",
      "runtime-fact",
      "generated-lab-value",
      "deployment-platform-secret-reference"
    ];
  def has_forbidden_key:
    any(
      [.. | objects | keys[]][];
      IN(
        "plaintext",
        "plaintextSecret",
        "secretValue",
        "value",
        "privateKey",
        "password",
        "token",
        "routeAuthority",
        "firewallAuthority",
        "firewallPolicy",
        "dnsAuthority",
        "dnsPolicy",
        "publicIngress",
        "tenantReachability",
        "trustBoundary"
      )
    );
  def policy_neutral:
    (.policyAuthority // {}) as $policy
    | all(
        [
          "createsRouteAuthority",
          "createsFirewallPolicy",
          "createsDnsPolicy",
          "createsPublicIngress",
          "createsTenantReachability",
          "createsTrustBoundary",
          "createsNetworkBehavior"
        ][];
        $policy[.] == false
      );
  def declaration_key:
    [
      .credentialClass,
      .site,
      (.tenant // ""),
      .host,
      .consumer.kind,
      .consumer.node,
      .consumer.name,
      .purpose
    ] | @json;
  def has_all_ids($expected):
    . as $ids | all($expected[]; $ids | index(.) != null);
  def valid_declarations($declarations):
    ($declarations | type == "array")
    and ($declarations | length) >= 18
    and all(
      $declarations[];
      (.id | type == "string" and length > 0)
      and (.credentialClass | type == "string" and length > 0)
      and (.site | type == "string" and length > 0)
      and has("tenant")
      and (.host | type == "string" and length > 0)
      and (.consumer.kind | type == "string" and length > 0)
      and (.consumer.node | type == "string" and length > 0)
      and (.consumer.name | type == "string" and length > 0)
      and (.purpose | type == "string" and length > 0)
      and (.lifecycle | type == "string" and length > 0)
      and (.required | type == "boolean")
      and (.requiredness == "mandatory" or .requiredness == "optional")
      and (.material == "reference-only")
      and (.plaintextMaterial == false)
      and (.sourceSelected == false)
      and policy_neutral
      and ((.gampIds // []) | has_all_ids(expected810))
      and (has_forbidden_key | not)
    )
    and ([$declarations[] | declaration_key] | length == (unique | length));
  def valid_sources($sources):
    ($sources | type == "array")
    and ($sources | length) >= 18
    and all(
      $sources[];
      (.id | type == "string" and length > 0)
      and (.declarationId | type == "string" and length > 0)
      and (.sourceClass as $source_class | allowed_source_classes | index($source_class) != null)
      and (.reference.name | type == "string" and length > 0)
      and (.reference.runtimePath | test("^/run/secrets/"))
      and (.reference.sourceFieldPath | type == "string" and length > 0)
      and (.materialAccess == "not-supplied-by-source-record")
      and (.plaintextMaterial == false)
      and (.providerNeutral == true)
      and (.fixedSecretManagerRequired == false)
      and ((.gampIds // []) | has_all_ids(expected820[0:2]))
      and (has_forbidden_key | not)
    );
  def valid_bindings($declarations; $sources; $bindings):
    ($bindings | type == "array")
    and ($bindings | length == ($declarations | length))
    and all(
      $declarations[];
      .id as $declaration_id
      | ([$bindings[] | select(.declarationId == $declaration_id)] | length) == 1
    )
    and all(
      $bindings[];
      . as $binding
      | ([$declarations[] | select(.id == $binding.declarationId)] | length) == 1
      and ([$sources[] | select(.id == $binding.sourceId and .sourceClass == $binding.sourceClass)] | length) == 1
      and (.bindingKind == "declaration-source")
      and (.sourceFieldPath | type == "string" and length > 0)
      and policy_neutral
      and ((.gampIds // []) | has_all_ids(expected820))
      and (has_forbidden_key | not)
    );
  def valid_inventory:
    (.secretDeclarations // null) as $declarations
    | (.secretSources // null) as $sources
    | (.sourceBindings // null) as $bindings
    | valid_declarations($declarations)
      and valid_sources($sources)
      and valid_bindings($declarations; $sources; $bindings);
  .raw as $raw
  | .resolved as $resolved
  | ($raw | valid_inventory)
  and ($resolved | valid_inventory)
  and ($raw.secretDeclarations | any(.credentialClass == "provider-credential" and .purpose == "pppoe-password"))
  and ($raw.secretDeclarations | any(.credentialClass == "wireguard-credential" and .purpose == "wireguard-private-key"))
  and ($raw.secretDeclarations | any(.credentialClass == "overlay-runtime-fact" and .purpose == "nebula-lighthouse-endpoint-ipv4"))
  and ($raw.secretDeclarations | any(.credentialClass == "deployment-runtime-fact" and .purpose == "tenant-routed-prefix"))
  and ($raw.secretSources | any(.sourceClass == "protected-inventory"))
  and ($raw.secretSources | any(.sourceClass == "runtime-fact"))
  and ($raw.secretSources | any(.sourceClass == "deployment-platform-secret-reference"))
  and (($raw | .secretDeclarations[0] |= del(.lifecycle) | valid_inventory) | not)
  and (($raw | .secretDeclarations[0].plaintext = "not-allowed" | valid_inventory) | not)
  and (($raw | .sourceBindings += [(.sourceBindings[0] + { id: "negative-duplicate-binding" })] | valid_inventory) | not)
  and (($raw | .sourceBindings = .sourceBindings[1:] | valid_inventory) | not)
  and (($raw | .secretSources[0].reference = { runtimePath: .secretSources[0].reference.runtimePath } | valid_inventory) | not)
  and (($raw | .sourceBindings[0].policyAuthority.createsDnsPolicy = true | valid_inventory) | not)
  # FS-810-HDS-010-SDS-010-SMS-010 SN1: Remove required WG secret declaration → MISSING_SECRET_DECLARATION
  and (($raw | .secretDeclarations = (.secretDeclarations | map(select(.id != "sat-secret-wireguard-host128-private-key"))) | valid_inventory) | not)
  # FS-820-HDS-010-SDS-010-SMS-020 SN1: Oneshot script path as source class → PROVIDER_LOCKED_SOURCE_CLASS
  and (($raw | .secretSources[0].sourceClass = "/etc/s-router/secrets/wg-key-gen.sh" | valid_inventory) | not)
' "${tmp_json}" >/dev/null || fail "secret declaration/source binding records failed FS-810/FS-820 source validation"

# --- FS-810-HDS-010-SDS-010-SMS-010 SN1 targeted diagnostic: MISSING_SECRET_DECLARATION ---
# Verify that removing the WG declaration orphans its binding (the orphan binding is the MISSING_SECRET_DECLARATION condition)
jq -e '
  .raw as $r
  | ($r.secretDeclarations | map(select(.id != "sat-secret-wireguard-host128-private-key"))) as $mutated_decls
  | ([$r.sourceBindings[] | select(.declarationId == "sat-secret-wireguard-host128-private-key")] | length) > 0
' "${tmp_json}" >/dev/null || fail "FS-810-SMS-010 SN1: MISSING_SECRET_DECLARATION — no source binding found referencing removed WG declaration sat-secret-wireguard-host128-private-key"

# --- FS-820-HDS-010-SDS-010-SMS-020 SN1 recovery: valid source class accepted ---
# The main pipeline proves: (a) oneshot path mutation → valid_inventory fails, (b) baseline valid_inventory passes.
# This targeted check proves the sourceClass enumeration specifically excludes the oneshot path
# and includes the existing valid class.
jq -e '
  def allowed: ["protected-inventory","runtime-fact","generated-lab-value","deployment-platform-secret-reference"];
  (.raw.secretSources[0].sourceClass) as $sc
  | (allowed | index("/etc/s-router/secrets/wg-key-gen.sh") == null)
  and (allowed | index($sc) != null)
' "${tmp_json}" >/dev/null || fail "FS-820-SMS-020 SN1: recovery - oneshot path excluded from allowed_source_classes, valid class included"

echo "PASS fs810-fs820-secret-source-records"
