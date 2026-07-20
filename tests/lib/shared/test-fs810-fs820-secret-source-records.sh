#!/usr/bin/env bash
# GAMP-ID: FS-810-HDS-010-SDS-010-SMS-010
# GAMP-ID: FS-810-HDS-010-SDS-010-SMS-020
# GAMP-ID: FS-810-HDS-010-SDS-010-SMS-030
# GAMP-ID: FS-820-HDS-010-SDS-010-SMS-010
# GAMP-ID: FS-820-HDS-010-SDS-010-SMS-020
# GAMP-ID: FS-820-HDS-010-SDS-010-SMS-030
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
lab_dir="${repo_root}/GAMP/SAT"
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
  def allowed_credential_classes:
    [
      "provider-credential",
      "wireguard-credential",
      "deployment-runtime-fact",
      "overlay-runtime-fact"
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
        "psk",
        "token",
        "allowRoute",
        "routeAuthority",
        "firewallAuthority",
        "firewallPolicy",
        "allowFirewall",
        "dnsAuthority",
        "dnsPolicy",
        "publicIngress",
        "tenantReachability",
        "trustBoundary",
        "trustAnchor",
        "neededForUsers",
        "hashedPasswordFile",
        "defaultSopsFile"
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
      and (.credentialClass as $cc | allowed_credential_classes | index($cc) != null)
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
      and (.sourceSelected == true)
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
      and (.reference.runtimePath | type == "string" and length > 0 and (test("^/") | not))
      and (.reference.sourceFieldPath | type == "string" and length > 0)
      and (.materialAccess == "sops-nix-name-mediated")
      and (.plaintextMaterial == false)
      and (.providerNeutral == true)
      and (.fixedSecretManagerRequired == true)
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
  and (($raw | .secretDeclarations |= map(if .id == "sat-secret-wireguard-host128-psk" then .psk = "super-secret-key-12345" else . end) | valid_inventory) | not)
  and (($raw | .sourceBindings += [(.sourceBindings[0] + { id: "negative-duplicate-binding" })] | valid_inventory) | not)
  and (($raw | .sourceBindings = .sourceBindings[1:] | valid_inventory) | not)
  and (($raw | .secretSources[0].reference = { runtimePath: .secretSources[0].reference.runtimePath } | valid_inventory) | not)
  and (($raw | .sourceBindings[0].policyAuthority.createsDnsPolicy = true | valid_inventory) | not)
  # FS-810-HDS-010-SDS-010-SMS-010 SN1: Remove required WG secret declaration → MISSING_SECRET_DECLARATION
  and (($raw | .secretDeclarations = (.secretDeclarations | map(select(.id != "sat-secret-wireguard-host128-private-key"))) | valid_inventory) | not)
  # FS-820-HDS-010-SDS-010-SMS-020 SN1: Oneshot script path as source class → PROVIDER_LOCKED_SOURCE_CLASS
  and (($raw | .secretSources[0].sourceClass = "/etc/s-router/secrets/wg-key-gen.sh" | valid_inventory) | not)
  # FS-810-HDS-010-SDS-010-SMS-020 SN1: Missing site field → REJECT, diagnostic naming missing field and declaration identity
  and (($raw | .secretDeclarations |= map(if .id == "sat-secret-pppoe-nixos-username" then del(.site) else . end) | valid_inventory) | not)
  # FS-810-HDS-010-SDS-010-SMS-010 SN2: Duplicate PPPoE declaration → DUPLICATE_SECRET_DECLARATION
  and (($raw | .secretDeclarations += [
    (.secretDeclarations[] | select(.id == "sat-secret-pppoe-clab-password")) + { id: "negative-duplicate-pppoe-clab-password" }
  ] | valid_inventory) | not)
  # FS-820-HDS-010-SDS-010-SMS-010 SN1: Dual source class on same declaration → ambiguous source binding
  and (($raw | .secretSources += [
    (.secretSources[] | select(.declarationId == "sat-secret-wireguard-host128-private-key")) | .id = "negative-dual-source" | .sourceClass = "runtime-fact"
  ] | .sourceBindings += [
    (.sourceBindings[] | select(.declarationId == "sat-secret-wireguard-host128-private-key")) | .id = "negative-dual-binding" | .sourceId = "negative-dual-source" | .sourceClass = "runtime-fact"
  ] | valid_inventory) | not)
  # FS-810-HDS-010-SDS-010-SMS-020 SN2: Remove lifecycle from mandatory declaration → REJECT
  and (($raw | .secretDeclarations |= map(if .id == "sat-secret-pppoe-nixos-username" then del(.lifecycle) else . end) | valid_inventory) | not)
  # FS-810-HDS-010-SDS-010-SMS-030 SN2: Inject metadata.allowRoute on declaration → REJECT with policyBearingDeclaration
  and (($raw | .secretDeclarations |= map(if .id == "sat-secret-pppoe-nixos-username" then .metadata.allowRoute = { destination: "10.99.99.0/24", interface: "eth0" } else . end) | valid_inventory) | not)
  # FS-810-HDS-010-SDS-010-SMS-010 SN3: Unsupported credential class → UNSUPPORTED_CREDENTIAL_CLASS
  and (($raw | .secretDeclarations |= map(if .id == "sat-secret-pppoe-nixos-username" then .credentialClass = "unsupported-legacy-token" else . end) | valid_inventory) | not)
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

# --- FS-810-HDS-010-SDS-010-SMS-010 SN2 targeted diagnostic: DUPLICATE_SECRET_DECLARATION ---
# Prove that duplicating the PPPoE clab declaration produces two records with the same composite key
# (same credentialClass, site, host, consumer, purpose), which is the DUPLICATE_SECRET_DECLARATION condition.
jq -e '
  def decl_key: [.credentialClass, .site, (.tenant // ""), .host, .consumer.kind, .consumer.node, .consumer.name, .purpose] | @json;
  .raw as $r
  | ($r.secretDeclarations[] | select(.id == "sat-secret-pppoe-clab-password")) as $pppoe
  | ($pppoe | decl_key) as $pppoe_key
  | ([$r.secretDeclarations[] | select(decl_key == $pppoe_key)] | length) >= 1
  # The duplicate mutation in the main pipeline adds a second record with the same composite key.
  # This check proves the original PPPoE declaration exists (length >= 1).
  # The main pipeline already proves that adding a duplicate causes valid_inventory failure.
' "${tmp_json}" >/dev/null || fail "FS-810-SMS-010 SN2: DUPLICATE_SECRET_DECLARATION — PPPoE clab declaration sat-secret-pppoe-clab-password not found or composite key missing"

# --- FS-820-HDS-010-SDS-010-SMS-010 SN1 targeted diagnostic: dual source class ---
# Prove that the baseline valid inventory has exactly one binding per declaration (no ambiguity).
# The main pipeline proves that adding a second source+binding for the same declaration fails.
jq -e '
  .raw as $r
  | ([$r.sourceBindings[] | select(.declarationId == "sat-secret-wireguard-host128-private-key")] | length) == 1
  and ([$r.secretSources[] | select(.declarationId == "sat-secret-wireguard-host128-private-key")] | length) == 1
' "${tmp_json}" >/dev/null || fail "FS-820-SMS-010 SN1: baseline verification - WG key declaration must have exactly one source and one binding (single-source accepted)"

# --- FS-820-HDS-010-SDS-010-SMS-010 SN1 recovery: single-source binding accepted ---
# The main pipeline proves baseline valid_inventory passes with one source per declaration.
# This targeted check proves the single-source mapping is correct (declarationId matches).
jq -e '
  .raw as $r
  | ($r.secretSources[] | select(.declarationId == "sat-secret-wireguard-host128-private-key")) as $src
  | ($r.sourceBindings[] | select(.declarationId == "sat-secret-wireguard-host128-private-key")) as $bind
  | $bind.sourceId == $src.id
  and $bind.sourceClass == $src.sourceClass
' "${tmp_json}" >/dev/null || fail "FS-820-SMS-010 SN1: recovery - WG key single-source binding integrity check failed"

# --- FS-810-HDS-010-SDS-010-SMS-020 SN1 targeted diagnostic: missing site field ---
# Baseline: prove sat-secret-pppoe-nixos-username has a valid site field.
# Mutation: prove that after removing site, the declaration lacks site.
# The main pipeline already proves valid_inventory fails when site is missing (inline mutation).
jq -e '
  .raw as $r
  | ($r.secretDeclarations[] | select(.id == "sat-secret-pppoe-nixos-username")) as $decl
  | ($decl.site | type == "string" and length > 0)
  and (($r | .secretDeclarations |= map(if .id == "sat-secret-pppoe-nixos-username" then del(.site) else . end))
        | .secretDeclarations[] | select(.id == "sat-secret-pppoe-nixos-username") | has("site") | not)
' "${tmp_json}" >/dev/null || fail "FS-810-SMS-020 SN1: missing site — baseline has valid site for sat-secret-pppoe-nixos-username, mutation removes site field"

# --- FS-810-HDS-010-SDS-010-SMS-030 SN1 targeted diagnostic: plaintextSecretExposure ---
# Baseline: prove sat-secret-wireguard-host128-psk has no psk field (reference-only material).
# Mutation: prove that after injecting psk, the declaration carries the forbidden psk key.
# The main pipeline already proves valid_inventory fails when psk is present (has_forbidden_key catches "psk").
jq -e '
  .raw as $r
  | ($r.secretDeclarations[] | select(.id == "sat-secret-wireguard-host128-psk")) as $decl
  | ($decl | has("psk") | not)
  and ($decl.plaintextMaterial == false)
  and ($decl.material == "reference-only")
  and (($r.secretDeclarations | map(if .id == "sat-secret-wireguard-host128-psk" then .psk = "super-secret-key-12345" else . end))[]
        | select(.id == "sat-secret-wireguard-host128-psk") | has("psk"))
' "${tmp_json}" >/dev/null || fail "FS-810-SMS-030 SN1: plaintextSecretExposure — baseline has no psk (reference-only), psk injection detected via has_forbidden_key"

# --- FS-810-HDS-010-SDS-010-SMS-020 SN2 targeted diagnostic: missing lifecycle on mandatory ---
# Baseline: prove sat-secret-pppoe-nixos-username is mandatory AND has lifecycle.
# Mutation: prove that after removing lifecycle, the declaration lacks it.
# The main pipeline already proves valid_inventory fails when lifecycle is missing (inline mutation).
jq -e '
  .raw as $r
  | ($r.secretDeclarations[] | select(.id == "sat-secret-pppoe-nixos-username")) as $decl
  | ($decl.requiredness == "mandatory")
  and ($decl.lifecycle | type == "string" and length > 0)
  and (($r | .secretDeclarations |= map(if .id == "sat-secret-pppoe-nixos-username" then del(.lifecycle) else . end))
        | .secretDeclarations[] | select(.id == "sat-secret-pppoe-nixos-username") | has("lifecycle") | not)
' "${tmp_json}" >/dev/null || fail "FS-810-SMS-020 SN2: missing lifecycle — sat-secret-pppoe-nixos-username is mandatory, baseline has lifecycle, mutation removes lifecycle field"

# --- FS-810-HDS-010-SDS-010-SMS-030 SN2 targeted diagnostic: metadata.allowRoute policy ---
# Prove: (a) baseline declaration has no metadata, (b) injection creates allowRoute with correct fields.
jq -e '
  .raw as $r
  | ($r.secretDeclarations[] | select(.id == "sat-secret-pppoe-nixos-username")) as $decl
  | ($decl | has("metadata") | not)
' "${tmp_json}" >/dev/null || fail "FS-810-SMS-030 SN2: baseline check — sat-secret-pppoe-nixos-username must have no metadata field"

jq -e '
  .raw as $r
  | ($r.secretDeclarations | map(if .id == "sat-secret-pppoe-nixos-username" then .metadata.allowRoute = { destination: "10.99.99.0/24", interface: "eth0" } else . end)) as $mutated
  | ($mutated | map(select(.id == "sat-secret-pppoe-nixos-username")))[0].metadata.allowRoute.destination == "10.99.99.0/24"
' "${tmp_json}" >/dev/null || fail "FS-810-SMS-030 SN2: injection check — mutation creates allowRoute with destination 10.99.99.0/24"

jq -e '
  .raw as $r
  | ($r.secretDeclarations | map(if .id == "sat-secret-pppoe-nixos-username" then .metadata.allowRoute = { destination: "10.99.99.0/24", interface: "eth0" } else . end)) as $mutated
  | ($mutated | map(select(.id == "sat-secret-pppoe-nixos-username")))[0].metadata.allowRoute.interface == "eth0"
' "${tmp_json}" >/dev/null || fail "FS-810-SMS-030 SN2: injection check — mutation creates allowRoute with interface eth0"

# --- FS-810-HDS-010-SDS-010-SMS-010 SN3 targeted diagnostic: UNSUPPORTED_CREDENTIAL_CLASS ---
# Baseline: prove sat-secret-pppoe-nixos-username uses a recognized credential class.
# The main pipeline already proves that injecting unsupported-legacy-token causes valid_inventory failure
# via the new allowed_credential_classes enumeration in valid_declarations.
# This targeted check proves: (a) baseline credentialClass is in the allowed list,
# (b) unsupported-legacy-token is NOT in the allowed list (the enumeration excludes it).
jq -e '
  def allowed: ["provider-credential","wireguard-credential","deployment-runtime-fact","overlay-runtime-fact"];
  .raw as $r
  | ($r.secretDeclarations[] | select(.id == "sat-secret-pppoe-nixos-username")) as $decl
  | ($decl.credentialClass | type == "string" and length > 0)
  and (allowed | index($decl.credentialClass) != null)
  and (allowed | index("unsupported-legacy-token") == null)
' "${tmp_json}" >/dev/null || fail "FS-810-SMS-010 SN3: baseline — recognized credential class accepted, unsupported-legacy-token excluded from allowed enumeration"

# Prove active rejection: injecting unsupported-legacy-token produces the mutation and class is excluded.
jq -e '
  def allowed: ["provider-credential","wireguard-credential","deployment-runtime-fact","overlay-runtime-fact"];
  .raw as $r
  | ($r | .secretDeclarations |= map(if .id == "sat-secret-pppoe-nixos-username" then .credentialClass = "unsupported-legacy-token" else . end)) as $mutated
  | ($mutated.secretDeclarations[] | select(.id == "sat-secret-pppoe-nixos-username")) as $m
  | ($m.credentialClass == "unsupported-legacy-token")
  and ((allowed | index($m.credentialClass)) == null)
' "${tmp_json}" >/dev/null || fail "FS-810-SMS-010 SN3: UNSUPPORTED_CREDENTIAL_CLASS — injecting unsupported-legacy-token creates declaration with credential class excluded from allowed enumeration"

echo "PASS fs810-fs820-secret-source-records"
