#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
canonical_sms_dir="${CANONICAL_SMS_DIR:-/home/deadbeef/github/network-codex-agent/GAMP/SMS}"

if [[ ! -d "${canonical_sms_dir}" ]]; then
  echo "canonical SMS directory not found: ${canonical_sms_dir}" >&2
  exit 2
fi

trace_for_file() {
  local file="$1"
  local stem="${file%.md}"
  if [[ "${stem}" =~ ^(FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+-SMS-[0-9]+) ]]; then
    printf '%s\n' "${BASH_REMATCH[1]}"
    return 0
  fi
  return 1
}

sds_for_trace() {
  printf '%s\n' "$1" | sed -E 's/-SMS-[0-9]+$//'
}

slug_for_file() {
  local file="$1"
  local trace="$2"
  local stem="${file%.md}"
  local slug="${stem#"${trace}"}"
  slug="${slug#-}"
  if [[ -z "${slug}" ]]; then
    slug="canonical-sms"
  fi
  printf '%s\n' "${slug}"
}

relative_canonical_path() {
  printf 'network-codex-agent/GAMP/SMS/%s\n' "$1"
}

write_if_missing() {
  local path="$1"
  local tmp_path
  shift
  if [[ -e "${path}" ]]; then
    if [[ "${OVERWRITE_SOURCE_STUBS:-0}" == "1" ]] \
      && [[ -f "${path}" ]] \
      && grep -Eq 'canonical-sms-source-stub|canonical-source-stub|source-stub-only|Source stub only|canonical SMS inputs mirrored|Canonical SMS mirror source-stub' "${path}" \
      && ! grep -Eq 'status = "OK"|Status: OK' "${path}"; then
      :
    else
      return 0
    fi
  fi
  mkdir -p "$(dirname "${path}")"
  tmp_path="$(mktemp "${path}.tmp.XXXXXX")"
  "$@" >"${tmp_path}"
  mv "${tmp_path}" "${path}"
}

write_sds_readme() {
  local sds_trace="$1"
  cat <<EOF
# SDS Source Stub: ${sds_trace}

Status: NOT OK - source stub only.

This row exists so the network-labs GAMP tree can mirror canonical SMS children
from network-codex-agent. Add real design detail and focused evidence before
marking any child SMS input OK.
EOF
}

write_sds_default() {
  local sds_trace="$1"
  local records_file="$2"
  cat <<EOF
{
  layer = "SDS";
  traceId = "${sds_trace}";
  purpose = "Canonical SMS mirror source-stub grouping.";
  smsInputs = {
EOF
  awk -F '\t' -v sds="${sds_trace}" '
    function parent(trace) {
      sub(/-SMS-[0-9]+$/, "", trace);
      return trace;
    }
    parent($1) == sds { print $1 }
  ' "${records_file}" | sort | while IFS= read -r trace; do
    cat <<EOF
    "${trace}" = {
      smsRow = ../../SMS/${trace};
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
EOF
  done
  cat <<EOF
  };
}
EOF
}

write_sms_readme() {
  local trace="$1"
  local canonical_file="$2"
  local slug="$3"
  cat <<EOF
# SMS Mirror: ${trace}

Canonical SMS: \`$(relative_canonical_path "${canonical_file}")\`

This network-labs row mirrors the canonical GAMP SMS trace so lab-source
coverage cannot silently omit it.

Status: Source stub only - not validation evidence.

The canonical SMS title slug is \`${slug}\`. Add row-specific lab source and
focused validation evidence in the SMT/SIT row before marking this trace OK.
EOF
}

write_sms_default() {
  local trace="$1"
  local canonical_file="$2"
  local slug="$3"
  local parent_sds
  parent_sds="$(sds_for_trace "${trace}")"
  cat <<EOF
{
  layer = "SMS";
  traceId = "${trace}";
  parentSds = ../../SDS/${parent_sds};
  canonicalSms = "$(relative_canonical_path "${canonical_file}")";
  titleSlug = "${slug}";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "${trace}";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/${trace}/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
EOF
}

write_smt_readme() {
  local trace="$1"
  local canonical_file="$2"
  local slug="$3"
  cat <<EOF
# SMT Source Stub: ${trace}

Canonical SMS: \`$(relative_canonical_path "${canonical_file}")\`

Status: NOT OK - source stub only.

This row exists so the network-labs GAMP tree mirrors every canonical SMS trace.
It is not a runnable mini-SMT until \`GAMP/SMT/mini-smt/tests.nix\` registers a
focused runner or the owning repository records construction evidence for this
trace.

Title slug: \`${slug}\`
EOF
}

write_smt_default() {
  local trace="$1"
  local canonical_file="$2"
  local slug="$3"
  cat <<EOF
{
  layer = "SMT";
  traceId = "${trace}";
  canonicalSms = "$(relative_canonical_path "${canonical_file}")";
  titleSlug = "${slug}";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/${trace}/intent.nix";
    inventories = {
      clab = "GAMP/SMT/${trace}/inventory-clab.nix";
      nixos = "GAMP/SMT/${trace}/inventory-nixos.nix";
      testClients = "GAMP/SMT/${trace}/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
EOF
}

write_intent_stub() {
  local trace="$1"
  local canonical_file="$2"
  local slug="$3"
  cat <<EOF
{
  canonicalSmsStub = {
    traceId = "${trace}";
    canonicalSms = "$(relative_canonical_path "${canonical_file}")";
    titleSlug = "${slug}";
    evidenceBoundary = "source-stub-only";
    runnable = false;
    notRunnableReason = "No focused mini-SMT runner is registered for this canonical SMS trace.";
  };
}
EOF
}

write_inventory_stub() {
  local trace="$1"
  local canonical_file="$2"
  local renderer="$3"
  cat <<EOF
{
  meta = {
    traceId = "${trace}";
    canonicalSms = "$(relative_canonical_path "${canonical_file}")";
    renderer = "${renderer}";
    scope = "canonical-sms-source-stub";
    evidenceBoundary = "source-stub-only";
  };
  hosts = { };
  deploymentHosts = { };
}
EOF
}

write_test_clients_inventory_stub() {
  local trace="$1"
  local canonical_file="$2"
  cat <<EOF
{
  meta = {
    traceId = "${trace}";
    canonicalSms = "$(relative_canonical_path "${canonical_file}")";
    renderer = "test-clients";
    scope = "canonical-sms-source-stub";
    evidenceBoundary = "source-stub-only";
  };
  clients = { };
  deploymentHosts = {
    s-router-test-clients = {
      hat.endpointClients = { };
    };
  };
}
EOF
}

records_file="$(mktemp)"
trap 'rm -f "${records_file}"' EXIT

while IFS= read -r canonical_file; do
  trace="$(trace_for_file "${canonical_file}")"
  slug="$(slug_for_file "${canonical_file}" "${trace}")"
  printf '%s\t%s\t%s\n' "${trace}" "${canonical_file}" "${slug}" >>"${records_file}"
done < <(find "${canonical_sms_dir}" -mindepth 1 -maxdepth 1 -type f -name 'FS-*.md' -printf '%f\n' | sort)

duplicates="$(cut -f1 "${records_file}" | sort | uniq -d)"
if [[ -n "${duplicates}" ]]; then
  echo "canonical SMS trace IDs are not unique:" >&2
  printf '%s\n' "${duplicates}" >&2
  exit 1
fi

count=0
while IFS=$'\t' read -r trace canonical_file slug; do
  count=$((count + 1))
  if [[ "${SYNC_GAMP_PROGRESS:-0}" == "1" ]] && (( count % 50 == 0 )); then
    printf 'synced SMS/SMT stubs: %s\n' "${count}" >&2
  fi
  sms_dir="${repo_root}/GAMP/SMS/${trace}"
  smt_dir="${repo_root}/GAMP/SMT/${trace}"

  mkdir -p "${sms_dir}" "${smt_dir}"
  write_if_missing "${sms_dir}/README.md" write_sms_readme "${trace}" "${canonical_file}" "${slug}"
  write_if_missing "${sms_dir}/default.nix" write_sms_default "${trace}" "${canonical_file}" "${slug}"

  write_if_missing "${smt_dir}/README.md" write_smt_readme "${trace}" "${canonical_file}" "${slug}"
  write_if_missing "${smt_dir}/default.nix" write_smt_default "${trace}" "${canonical_file}" "${slug}"
  write_if_missing "${smt_dir}/intent.nix" write_intent_stub "${trace}" "${canonical_file}" "${slug}"
  write_if_missing "${smt_dir}/inventory-clab.nix" write_inventory_stub "${trace}" "${canonical_file}" "clab"
  write_if_missing "${smt_dir}/inventory-nixos.nix" write_inventory_stub "${trace}" "${canonical_file}" "nixos"
  write_if_missing "${smt_dir}/inventory-test-clients.nix" write_test_clients_inventory_stub "${trace}" "${canonical_file}"
done <"${records_file}"

sds_count=0
while IFS= read -r sds_trace; do
  sds_count=$((sds_count + 1))
  if [[ "${SYNC_GAMP_PROGRESS:-0}" == "1" ]] && (( sds_count % 25 == 0 )); then
    printf 'synced SDS/SIT stubs: %s\n' "${sds_count}" >&2
  fi
  sds_dir="${repo_root}/GAMP/SDS/${sds_trace}"
  mkdir -p "${sds_dir}"
  write_if_missing "${sds_dir}/README.md" write_sds_readme "${sds_trace}"
  write_if_missing "${sds_dir}/default.nix" write_sds_default "${sds_trace}" "${records_file}"

  sit_dir="${repo_root}/GAMP/SIT/${sds_trace}"
  if [[ -e "${sit_dir}" ]]; then
    continue
  fi

  mkdir -p "${sit_dir}"
  {
    cat <<EOF
# SIT Source Stub: ${sds_trace}

Status: NOT OK - source stub only.

This SDS-scoped SIT row was created to keep the network-labs GAMP tree aligned
with the canonical SMS trace set. Add integrated artifact evidence before
marking any child SMS input OK.
EOF
  } >"${sit_dir}/README.md"

  {
    cat <<EOF
{
  layer = "SIT";
  traceId = "${sds_trace}";
  smsInputs = {
EOF
    awk -F '\t' -v sds="${sds_trace}" '
      function parent(trace) {
        sub(/-SMS-[0-9]+$/, "", trace);
        return trace;
      }
      parent($1) == sds { print $1 "\t" $2 }
    ' "${records_file}" | sort | while IFS=$'\t' read -r trace canonical_file; do
      cat <<EOF
    "${trace}" = {
      smtRow = ../../SMT/${trace};
      sourcePath = "GAMP/SMT/${trace}/intent.nix";
      canonicalSms = "$(relative_canonical_path "${canonical_file}")";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
EOF
    done
    cat <<EOF
  };
  evidence = {
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
EOF
  } >"${sit_dir}/default.nix"
done < <(cut -f1 "${records_file}" | sed -E 's/-SMS-[0-9]+$//' | sort -u)

printf 'synced %s canonical SMS traces into network-labs GAMP mirrors\n' "$(wc -l <"${records_file}")"
