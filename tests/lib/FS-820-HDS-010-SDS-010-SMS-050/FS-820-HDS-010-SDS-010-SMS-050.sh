#!/usr/bin/env bash
# GAMP-ID: FS-820-HDS-010-SDS-010-SMS-050
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/network-labs-fs820-sms050.XXXXXX")"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL FS-820-HDS-010-SDS-010-SMS-050: $*" >&2
  exit 1
}

append_diag() {
  local diag_file="$1"
  shift
  printf '%s\n' "$*" >>"${diag_file}"
}

find_source_dirs() {
  local root="$1"
  for dir in active-lab current-lab GAMP; do
    [[ -d "${root}/${dir}" ]] && printf '%s\n' "${root}/${dir}"
  done
}

find_source_nix_files() {
  local root="$1"
  while IFS= read -r dir || [[ -n "${dir}" ]]; do
    find "${dir}" \
      \( -path "${root}/GAMP/SMT/*/default.nix" \
      -o -path "${root}/GAMP/SIT/*/default.nix" \
      -o -path "${root}/GAMP/SDS/*/default.nix" \
      -o -path "${root}/GAMP/SMS/*/default.nix" \
      -o -path "${root}/GAMP/HDS/*/default.nix" \) -prune -o \
      -type f -name '*.nix' -print
  done < <(find_source_dirs "${root}")
}

validate_tree() {
  local root="$1"
  local diag_file="$2"
  : >"${diag_file}"

  if [[ -d "${root}/active-lab/secrets" ]]; then
    while IFS= read -r file || [[ -n "${file}" ]]; do
      append_diag "${diag_file}" "active-lab-secret-payload-owner file=${file#"${root}/"}"
    done < <(find "${root}/active-lab/secrets" -type f \( -name '*.yaml' -o -name '*.yml' \) -print)
  fi

  while IFS= read -r file || [[ -n "${file}" ]]; do
    while IFS= read -r key || [[ -n "${key}" ]]; do
      case "${key}" in
        deadbeef-passwd|qqqqabc)
          append_diag "${diag_file}" "host-owned-secret-in-lab-sops file=${file#"${root}/"} key=${key}"
          ;;
      esac
    done < <(rg --no-line-number '^[A-Za-z0-9_.-]+:' "${file}" | sed 's/:.*//')
  done < <(find "${root}" \
    \( -path "${root}/.git" -o -path "${root}/.direnv" -o -path "${root}/result" \) -prune -o \
    -path '*/secrets/*.yaml' -type f -print)

  mapfile -t source_files < <(find_source_nix_files "${root}")
  if ((${#source_files[@]} > 0)); then
    while IFS= read -r match || [[ -n "${match}" ]]; do
      append_diag "${diag_file}" "lab-default-sopsfile-override ${match#"${root}/"}"
    done < <(rg -n 'sops[.]defaultSopsFile' "${source_files[@]}" 2>/dev/null || true)

    while IFS= read -r match || [[ -n "${match}" ]]; do
      append_diag "${diag_file}" "HOST_OWNED_SECRET_BOUND_IN_LAB_SOURCE ${match#"${root}/"}"
    done < <(rg -n 'sops[.]secrets[.]"?(deadbeef-passwd|qqqqabc)"?|"(deadbeef-passwd|qqqqabc)"[[:space:]]*=|neededForUsers|hashedPasswordFile' "${source_files[@]}" 2>/dev/null || true)
  fi

  [[ ! -s "${diag_file}" ]]
}

must_fail_tree() {
  local name="$1"
  local root="$2"
  local expected="$3"
  local diag="${tmp_dir}/${name}.diag"

  if validate_tree "${root}" "${diag}"; then
    fail "${name} unexpectedly passed"
  fi
  rg -q "${expected}" "${diag}" \
    || fail "${name} missing diagnostic ${expected}; got $(tr '\n' ';' <"${diag}")"
}

validate_tree "${repo_root}" "${tmp_dir}/repo.diag" \
  || fail "current network-labs SOPS boundary failed: $(tr '\n' ';' <"${tmp_dir}/repo.diag")"

positive_root="${tmp_dir}/positive"
mkdir -p "${positive_root}/GAMP/HAT/example/secrets" "${positive_root}/GAMP/HAT/example"
cat >"${positive_root}/GAMP/HAT/example/secrets/lab.yaml" <<'YAML'
pppoe-password: ENC[AES256_GCM,data:example,iv:example,tag:example,type:str]
YAML
cat >"${positive_root}/GAMP/HAT/example/sops.nix" <<'NIX'
{
  sops.secrets."hat-pppoe-password" = {
    key = "pppoe-password";
    sopsFile = ./secrets/lab.yaml;
  };
}
NIX
validate_tree "${positive_root}" "${tmp_dir}/positive.diag" \
  || fail "positive per-secret sopsFile fixture failed: $(tr '\n' ';' <"${tmp_dir}/positive.diag")"

active_payload_root="${tmp_dir}/active-payload"
mkdir -p "${active_payload_root}/active-lab/secrets"
cat >"${active_payload_root}/active-lab/secrets/bad.yaml" <<'YAML'
pppoe-password: ENC[AES256_GCM,data:example,iv:example,tag:example,type:str]
YAML
must_fail_tree active-payload "${active_payload_root}" 'active-lab-secret-payload-owner'

host_key_root="${tmp_dir}/host-key"
mkdir -p "${host_key_root}/GAMP/HAT/example/secrets"
cat >"${host_key_root}/GAMP/HAT/example/secrets/bad.yaml" <<'YAML'
deadbeef-passwd: ENC[AES256_GCM,data:example,iv:example,tag:example,type:str]
YAML
must_fail_tree host-key "${host_key_root}" 'host-owned-secret-in-lab-sops'

unmodeled_key_root="${tmp_dir}/unmodeled-key"
mkdir -p "${unmodeled_key_root}/GAMP/SMT/example/secrets"
cat >"${unmodeled_key_root}/GAMP/SMT/example/secrets/bad.yaml" <<'YAML'
qqqqabc: ENC[AES256_GCM,data:example,iv:example,tag:example,type:str]
YAML
must_fail_tree unmodeled-key "${unmodeled_key_root}" 'host-owned-secret-in-lab-sops'

default_override_root="${tmp_dir}/default-override"
mkdir -p "${default_override_root}/GAMP/HAT/example"
cat >"${default_override_root}/GAMP/HAT/example/sops.nix" <<'NIX'
{
  sops.defaultSopsFile = ./secrets/lab.yaml;
  sops.secrets."hat-pppoe-password".key = "pppoe-password";
}
NIX
must_fail_tree default-override "${default_override_root}" 'lab-default-sopsfile-override'

source_binding_root="${tmp_dir}/source-binding"
mkdir -p "${source_binding_root}/GAMP/SMT/example"
cat >"${source_binding_root}/GAMP/SMT/example/bad.nix" <<'NIX'
{
  sops.secrets."qqqqabc" = {
    key = "qqqqabc";
    sopsFile = ./secrets/lab.yaml;
  };
}
NIX
must_fail_tree source-binding "${source_binding_root}" 'HOST_OWNED_SECRET_BOUND_IN_LAB_SOURCE'

echo "PASS FS-820-HDS-010-SDS-010-SMS-050"
