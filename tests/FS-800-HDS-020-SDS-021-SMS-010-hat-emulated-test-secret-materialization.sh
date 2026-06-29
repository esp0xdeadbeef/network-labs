#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-020-SDS-021-SMS-010
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/network-labs-fs800-sds021.XXXXXX")"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL FS-800-HDS-020-SDS-021-SMS-010: $*" >&2
  exit 1
}

materialization_filter='
  def file_records: (.files // []);
  def selected_credentials: (.credentials // {});
  def bad_files:
    [file_records[]
    | select(
        (.path == "/run/secrets/hat-pppoe-username" or .path == "/run/secrets/hat-pppoe-password")
        and (((.owner // "root") != "root") or ((.group // "root") != "root") or ((.mode | tostring) != "0400"))
      )];
  if selected_credentials.labOnly != true
     or (selected_credentials.productionSecretHandling? // false) == true
  then error("diagnostic.missing-non-production-source-declaration secret=hat-pppoe provider-access=emulated-pppoe")
  elif (bad_files | length) > 0
  then (bad_files[0] | error("diagnostic.bad-secret-file-boundary path=\(.path) owner=\(.owner // "root") group=\(.group // "root") mode=\(.mode)"))
  elif (.protectedInventoryPromotion? // false) == true
  then error("diagnostic.emulated-secret-promoted-to-protected-inventory")
  else {
    accepted: true,
    materializedPaths: [file_records[].path],
    protectedInventoryPromotion: false
  }
  end
'

validate_materialization() {
  local input="$1"
  jq -e "${materialization_filter}" "${input}"
}

must_fail_materialization() {
  local name="$1"
  local expected="$2"
  local input="$3"

  if validate_materialization "${input}" >"${tmp_dir}/${name}.out" 2>"${tmp_dir}/${name}.err"; then
    fail "${name} unexpectedly passed"
  fi
  grep -F "${expected}" "${tmp_dir}/${name}.err" >/dev/null \
    || fail "${name} missing diagnostic ${expected}"
  if [[ -s "${tmp_dir}/${name}.out" ]]; then
    fail "${name} emitted materialization output despite rejection"
  fi
}

nix eval --impure --json --expr "
  let
    sopsModule = import ${repo_root}/GAMP/HAT/sops.nix { config = {}; lib = {}; pkgs = {}; };
    sopsRoutingNixos = import ${repo_root}/GAMP/HAT/emulated-isp-residential-testnet/sops-routing-s-router-nixos.nix;
    sopsRoutingClab = import ${repo_root}/GAMP/HAT/emulated-isp-residential-testnet/sops-routing-s-router-clab.nix;
    sopsRoutingTest = import ${repo_root}/GAMP/HAT/emulated-isp-residential-testnet/sops-routing-s-router-test-clients.nix;
    inventoryNixos = import ${repo_root}/GAMP/HAT/emulated-isp-residential-testnet/inventory-nixos.nix;
    inventoryClab = import ${repo_root}/GAMP/HAT/emulated-isp-residential-testnet/inventory-clab.nix;
    protectedBindings = import ${repo_root}/GAMP/HAT/emulated-isp-residential-testnet/protected-pppoe-credential-bindings.nix;
  in {
    sops = sopsModule;
    hostRouting = {
      nixos = sopsRoutingNixos;
      clab = sopsRoutingClab;
      test = sopsRoutingTest;
    };
    inventories = {
      nixos = inventoryNixos;
      clab = inventoryClab;
    };
    protected = {
      nixos = protectedBindings {
        consumerNode = \"esp-nixos-router-core-isp-a\";
        harness = \"s-router-nixos\";
        site = \"nixos\";
      };
      clab = protectedBindings {
        consumerNode = \"esp-clab-router-core-simulated-isp\";
        harness = \"s-router-clab\";
        site = \"clab\";
      };
    };
  }
" | jq -e '
  def secret_ok($module; $name; $key; $file):
    $module.sops.secrets[$name] as $secret
    | $secret.key == $key
      and $secret.mode == "0400"
      and (($secret.owner // "root") == "root")
      and (($secret.group // "root") == "root")
      and ($secret.sopsFile | test($file + "$"));
  def host_secret_pair_ok($module; $file):
    secret_ok($module; "hat-pppoe-username"; "pppoe-username"; $file)
    and secret_ok($module; "hat-pppoe-password"; "pppoe-password"; $file);
  def pppoe_client_credentials($inventory):
    [
      $inventory.realization.nodes
      | to_entries[]
      | .value.services.pppoe.client.credentials? // empty
    ];
  def runtime_credentials_ok($inventory):
    (pppoe_client_credentials($inventory) | length) > 0
    and all(pppoe_client_credentials($inventory)[];
      .labOnly == true
      and .usernameFile == "/run/secrets/hat-pppoe-username"
      and .passwordFile == "/run/secrets/hat-pppoe-password"
      and (has("username") | not)
      and (has("password") | not));
  def no_authority($policy):
    $policy.createsRouteAuthority == false
    and $policy.createsFirewallPolicy == false
    and $policy.createsDnsPolicy == false
    and $policy.createsPublicIngress == false
    and $policy.createsTenantReachability == false
    and $policy.createsTrustBoundary == false
    and $policy.createsNetworkBehavior == false;
  def protected_ok($records):
    ($records.secretDeclarations | length) == 2
    and all($records.secretDeclarations[];
      .material == "reference-only"
      and .plaintextMaterial == false
      and .sourceSelected == false
      and no_authority(.policyAuthority))
    and all($records.secretSources[];
      .sourceClass == "deployment-platform-secret-reference"
      and .materialAccess == "not-supplied-by-source-record"
      and .plaintextMaterial == false
      and .providerNeutral == true)
    and all($records.sourceBindings[];
      .bindingKind == "declaration-source"
      and .sourceClass == "deployment-platform-secret-reference"
      and no_authority(.policyAuthority));
  host_secret_pair_ok(.sops; "active-lab/secrets/sops-s-router-clab.yaml")
  and host_secret_pair_ok(.hostRouting.nixos; "active-lab/secrets/sops-s-router-nixos.yaml")
  and host_secret_pair_ok(.hostRouting.clab; "active-lab/secrets/sops-s-router-clab.yaml")
  and host_secret_pair_ok(.hostRouting.test; "active-lab/secrets/sops-s-router-test.yaml")
  and runtime_credentials_ok(.inventories.nixos)
  and runtime_credentials_ok(.inventories.clab)
  and protected_ok(.protected.nixos)
  and protected_ok(.protected.clab)
' >/dev/null || fail "current HAT source does not satisfy emulated test-secret materialization contract"

cat >"${tmp_dir}/positive.json" <<'JSON'
{
  "credentials": {
    "labOnly": true,
    "productionSecretHandling": false
  },
  "files": [
    {"path": "/run/secrets/hat-pppoe-username", "owner": "root", "group": "root", "mode": "0400"},
    {"path": "/run/secrets/hat-pppoe-password", "owner": "root", "group": "root", "mode": "0400"}
  ],
  "protectedInventoryPromotion": false
}
JSON
validate_materialization "${tmp_dir}/positive.json" >"${tmp_dir}/positive.out"
jq -e '.accepted == true and (.materializedPaths | length) == 2 and .protectedInventoryPromotion == false' \
  "${tmp_dir}/positive.out" >/dev/null \
  || fail "positive materialization did not emit bounded runtime credential files"

cat >"${tmp_dir}/missing-non-production.json" <<'JSON'
{
  "credentials": {
    "productionSecretHandling": false
  },
  "files": [
    {"path": "/run/secrets/hat-pppoe-username", "owner": "root", "group": "root", "mode": "0400"}
  ]
}
JSON
must_fail_materialization missing-non-production diagnostic.missing-non-production-source-declaration "${tmp_dir}/missing-non-production.json"

cat >"${tmp_dir}/bad-file-boundary.json" <<'JSON'
{
  "credentials": {
    "labOnly": true,
    "productionSecretHandling": false
  },
  "files": [
    {"path": "/run/secrets/hat-pppoe-username", "owner": "nobody", "group": "users", "mode": "0644"}
  ]
}
JSON
must_fail_materialization bad-file-boundary diagnostic.bad-secret-file-boundary "${tmp_dir}/bad-file-boundary.json"
grep -F '/run/secrets/hat-pppoe-username' "${tmp_dir}/bad-file-boundary.err" >/dev/null \
  || fail "bad file diagnostic did not name hat-pppoe-username"

cat >"${tmp_dir}/protected-promotion.json" <<'JSON'
{
  "credentials": {
    "labOnly": true,
    "productionSecretHandling": false
  },
  "files": [
    {"path": "/run/secrets/hat-pppoe-username", "owner": "root", "group": "root", "mode": "0400"}
  ],
  "protectedInventoryPromotion": true
}
JSON
must_fail_materialization protected-promotion diagnostic.emulated-secret-promoted-to-protected-inventory "${tmp_dir}/protected-promotion.json"

echo "PASS FS-800-HDS-020-SDS-021-SMS-010 hat emulated test-secret materialization"
