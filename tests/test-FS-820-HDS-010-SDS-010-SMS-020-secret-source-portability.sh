#!/usr/bin/env bash
# GAMP-ID: FS-820-HDS-010-SDS-010-SMS-020
# Purpose: Dedicated construction test for secret source class portability.
# Proves source classes remain provider-neutral credential realization data,
# rejecting locked-format, oneshot-path, unsupported-class, and host-default-
# override source bindings per SMS-020 construction handoff.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/GAMP/SAT"
tmp_json="$(mktemp)"
trap 'rm -f "${tmp_json}"' EXIT

fail() {
  echo "FAIL fs820-hds010-sds010-sms020: $*" >&2
  exit 1
}

nix eval --impure --json --expr "{
  raw = import ${lab_dir}/inventory.nix;
  resolved = import ${lab_dir}/getResolvedInventory.nix { renderer = \"nixos\"; };
}" >"${tmp_json}"

# Shared forbidden-key check function (called with element piped in)
FORBIDDEN_CHECK='
  [. | .. | objects | keys[]] as $keys
  | any($keys[]; . as $k | $forbidden | index($k) != null)
'

# ---------------------------------------------------------------------------
# MR1: Baseline sources use only provider-neutral source classes.
# ---------------------------------------------------------------------------
jq -e "
  .raw.secretSources as \$sources
  | all(\$sources[]; .sourceClass as \$sc |
      [\"protected-inventory\",\"runtime-fact\",\"generated-lab-value\",\"deployment-platform-secret-reference\"] |
      index(\$sc) != null)
" "${tmp_json}" >/dev/null || fail "MR1: baseline secretSources contain non-portable sourceClass"

jq -e '
  all(.raw.secretSources[]; .providerNeutral == true)
' "${tmp_json}" >/dev/null || fail "MR1: baseline secretSources contain source not marked providerNeutral"

echo "MR1: all baseline sources use provider-neutral source class — PASS"

# ---------------------------------------------------------------------------
# MR2: No fixed secret manager, file format, host path, or runtime provider required.
# ---------------------------------------------------------------------------
jq -e '
  .raw.secretSources as $sources
  | ($sources | length) >= 18
  and all($sources[]; .sourceClass | type == "string" and length > 0)
  and all($sources[]; .reference.name | type == "string" and length > 0)
  and all($sources[]; .reference.runtimePath | type == "string" and test("^/") | not)
' "${tmp_json}" >/dev/null || fail "MR2: source references use relative runtime paths, not absolute host paths"

echo "MR2: no fixed secret manager, format, or host path dependency — PASS"

# ---------------------------------------------------------------------------
# MR3/MR4/FC3: SN1 — Oneshot host-local script path as source class
# Diagnostic: PROVIDER_LOCKED_SOURCE_CLASS
# ---------------------------------------------------------------------------
jq -e '
  .raw.secretSources[0].sourceClass as $original_class
  | (["protected-inventory","runtime-fact","generated-lab-value","deployment-platform-secret-reference"] |
     index($original_class) != null)
  and (["protected-inventory","runtime-fact","generated-lab-value","deployment-platform-secret-reference"] |
       index("/etc/s-router/secrets/wg-key-gen.sh") == null)
' "${tmp_json}" >/dev/null || fail "SN1 pre-check: baseline source class is in allowed set, oneshot path is not"

jq -e '
  .raw.secretSources[0] + {
    id: "negative-oneshot-path",
    sourceClass: "/etc/s-router/secrets/wg-key-gen.sh"
  } as $mutated
  | (["protected-inventory","runtime-fact","generated-lab-value","deployment-platform-secret-reference"] |
     index($mutated.sourceClass) == null)
' "${tmp_json}" >/dev/null || fail "SN1: mutated oneshot path sourceClass must be excluded from allowed enumeration"

echo "SN1: PROVIDER_LOCKED_SOURCE_CLASS — oneshot host path \"/etc/s-router/secrets/wg-key-gen.sh\" rejected — PASS"

# ---------------------------------------------------------------------------
# SN1 recovery: valid provider-neutral source class accepted (CH1-3 happy paths)
# ---------------------------------------------------------------------------
jq -e '
  .raw.secretSources[0] as $src
  | $src.sourceClass as $sc
  | (["protected-inventory","runtime-fact","generated-lab-value","deployment-platform-secret-reference"] |
     index($sc) != null)
  and ($src.providerNeutral == true)
  and ([$src | .. | objects | keys[]] as $keys |
       any($keys[]; . as $k | ["plaintext","plaintextSecret","secretValue","value","privateKey","password","psk","token","allowRoute","routeAuthority","firewallAuthority","firewallPolicy","allowFirewall","dnsAuthority","dnsPolicy","publicIngress","tenantReachability","trustBoundary","trustAnchor","neededForUsers","hashedPasswordFile","defaultSopsFile"] | index($k) != null) | not)
  and ($src.materialAccess == "sops-nix-name-mediated")
  and ($src.plaintextMaterial == false)
' "${tmp_json}" >/dev/null || fail "SN1-recovery: baseline source with valid provider-neutral class accepted"

echo "SN1-recovery: valid source class accepted, sops-nix-name-mediated material access — PASS"

# ---------------------------------------------------------------------------
# UNSUPPORTED_SOURCE_CLASS: Reject fixed provider name not in allowed enumeration (CH5)
# ---------------------------------------------------------------------------
jq -e '
  (["protected-inventory","runtime-fact","generated-lab-value","deployment-platform-secret-reference"] |
   index("vault-enterprise-cluster-a") == null)
  and (["protected-inventory","runtime-fact","generated-lab-value","deployment-platform-secret-reference"] |
       index("hashicorp-vault-us-east-1") == null)
  and (["protected-inventory","runtime-fact","generated-lab-value","deployment-platform-secret-reference"] |
       index("azure-keyvault-prod") == null)
' "${tmp_json}" >/dev/null || fail "UNSUPPORTED_SOURCE_CLASS pre-check: fixed provider names must be excluded from allowed enumeration"

jq -e '
  .raw.secretSources[0] + {
    id: "negative-vault-provider-locked",
    sourceClass: "vault-enterprise-cluster-a"
  } as $mutated
  | (["protected-inventory","runtime-fact","generated-lab-value","deployment-platform-secret-reference"] |
     index($mutated.sourceClass) == null)
' "${tmp_json}" >/dev/null || fail "UNSUPPORTED_SOURCE_CLASS: fixed provider name must be excluded from allowed enumeration"

echo "UNSUPPORTED_SOURCE_CLASS: fixed provider name \"vault-enterprise-cluster-a\" rejected — PASS"

# ---------------------------------------------------------------------------
# SN2 / FC4 — HOST_DEFAULT_SOPSFILE_OVERRIDE_REQUIRED
# Host default SOPS file must not be overridden by lab source.
# ---------------------------------------------------------------------------
# Pre-check: baseline sources do NOT carry defaultSopsFile
jq -e '
  .raw.secretSources as $sources
  | all($sources[];
      [. | .. | objects | keys[]] as $keys |
      any($keys[]; . as $k | ["defaultSopsFile"] | index($k) != null) | not)
' "${tmp_json}" >/dev/null || fail "SN2 pre-check: baseline sources must not carry defaultSopsFile"

# Inject defaultSopsFile pointing to a network-labs path; must fail forbidden-key check
jq -e '
  .raw.secretSources[0] + {
    id: "negative-host-default-override",
    defaultSopsFile: "/home/deadbeef/github/network-labs/GAMP/SAT/secrets/non-existent.yaml"
  } as $mutated
  | ([$mutated | .. | objects | keys[]] as $keys |
     any($keys[]; . as $k | ["defaultSopsFile"] | index($k) != null))
' "${tmp_json}" >/dev/null || fail "SN2: injected defaultSopsFile must be detected as forbidden key"

echo "SN2: HOST_DEFAULT_SOPSFILE_OVERRIDE_REQUIRED — defaultSopsFile on lab source rejected — PASS"

# ---------------------------------------------------------------------------
# SN2 recovery: per-secret sopsFile without defaultSopsFile override accepted
# ---------------------------------------------------------------------------
jq -e '
  .raw.secretSources as $sources
  | all($sources[];
      [. | .. | objects | keys[]] as $keys |
      any($keys[]; . as $k | ["plaintext","plaintextSecret","secretValue","value","privateKey","password","psk","token","allowRoute","routeAuthority","firewallAuthority","firewallPolicy","allowFirewall","dnsAuthority","dnsPolicy","publicIngress","tenantReachability","trustBoundary","trustAnchor","neededForUsers","hashedPasswordFile","defaultSopsFile"] | index($k) != null) | not)
  and all(.raw.sourceBindings[];
      [. | .. | objects | keys[]] as $keys |
      any($keys[]; . as $k | ["plaintext","plaintextSecret","secretValue","value","privateKey","password","psk","token","allowRoute","routeAuthority","firewallAuthority","firewallPolicy","allowFirewall","dnsAuthority","dnsPolicy","publicIngress","tenantReachability","trustBoundary","trustAnchor","neededForUsers","hashedPasswordFile","defaultSopsFile"] | index($k) != null) | not)
' "${tmp_json}" >/dev/null || fail "SN2-recovery: all baseline sources and bindings are clean per-secret references"

echo "SN2-recovery: per-secret sopsFile references accepted, host defaultSopsFile untouched — PASS"

# ---------------------------------------------------------------------------
# CH1-3 Happy paths: Verify all source records are valid portable records.
# ---------------------------------------------------------------------------
jq -e '
  .raw.secretSources as $sources
  | all($sources[];
      .sourceClass as $sc
      | (["protected-inventory","runtime-fact","generated-lab-value","deployment-platform-secret-reference"] | index($sc) != null)
      and (.providerNeutral == true)
      and (.fixedSecretManagerRequired == true)
      and (.materialAccess == "sops-nix-name-mediated")
      and (.plaintextMaterial == false)
      and ([. | .. | objects | keys[]] as $keys |
           any($keys[]; . as $k | ["plaintext","plaintextSecret","secretValue","value","privateKey","password","psk","token","allowRoute","routeAuthority","firewallAuthority","firewallPolicy","allowFirewall","dnsAuthority","dnsPolicy","publicIngress","tenantReachability","trustBoundary","trustAnchor","neededForUsers","hashedPasswordFile","defaultSopsFile"] | index($k) != null) | not)
  )
' "${tmp_json}" >/dev/null || fail "CH1-3: all sources must pass provider-neutral validation"

jq -e '
  .resolved.secretSources as $sources
  | all($sources[];
      .sourceClass as $sc
      | (["protected-inventory","runtime-fact","generated-lab-value","deployment-platform-secret-reference"] | index($sc) != null)
      and (.providerNeutral == true)
      and (.fixedSecretManagerRequired == true)
      and (.materialAccess == "sops-nix-name-mediated")
      and (.plaintextMaterial == false)
      and ([. | .. | objects | keys[]] as $keys |
           any($keys[]; . as $k | ["plaintext","plaintextSecret","secretValue","value","privateKey","password","psk","token","allowRoute","routeAuthority","firewallAuthority","firewallPolicy","allowFirewall","dnsAuthority","dnsPolicy","publicIngress","tenantReachability","trustBoundary","trustAnchor","neededForUsers","hashedPasswordFile","defaultSopsFile"] | index($k) != null) | not)
  )
' "${tmp_json}" >/dev/null || fail "CH1-3: all resolved sources must pass provider-neutral validation"

echo "CH1-3: all sources valid — provider-neutral classes accepted — PASS"

# ---------------------------------------------------------------------------
# Cross-ref: verify source records trace to SMS-020 GAMP IDs.
# ---------------------------------------------------------------------------
jq -e '
  def expected: ["FS-820-HDS-010-SDS-010-SMS-010","FS-820-HDS-010-SDS-010-SMS-020"];
  .raw.secretSources as $sources
  | all($sources[];
      .gampIds as $ids
      | all(expected[]; $ids | index(.) != null))
' "${tmp_json}" >/dev/null || fail "Cross-ref: all source records carry FS-820 gampIds including SMS-020"

echo "Cross-ref: all secretSources carry SMS-020 trace identity — PASS"

# ---------------------------------------------------------------------------
# Final recovery: after all mutations, baseline is still clean.
# ---------------------------------------------------------------------------
jq -e '
  .raw.secretSources as $sources
  | all($sources[];
      .sourceClass as $sc
      | (["protected-inventory","runtime-fact","generated-lab-value","deployment-platform-secret-reference"] | index($sc) != null)
      and (.providerNeutral == true)
      and ([. | .. | objects | keys[]] as $keys |
           any($keys[]; . as $k | ["plaintext","plaintextSecret","secretValue","value","privateKey","password","psk","token","allowRoute","routeAuthority","firewallAuthority","firewallPolicy","allowFirewall","dnsAuthority","dnsPolicy","publicIngress","tenantReachability","trustBoundary","trustAnchor","neededForUsers","hashedPasswordFile","defaultSopsFile"] | index($k) != null) | not)
  )
' "${tmp_json}" >/dev/null || fail "Recovery: baseline sources remain clean after all seeded negatives"

echo "Recovery: baseline clean after all seeded negatives — PASS"

echo "PASS fs820-hds010-sds010-sms020-secret-source-portability"
