#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# FS-164 requires English for every controlled document. This word-level gate
# catches common Dutch prose deterministically; review remains responsible for
# non-English text that cannot be identified from this bounded token set.
dutch_token_pattern='(^|[[:space:][:punct:]])(de|het|een|geen|moet|wordt|worden|zijn|deze|dit|daarom|hiervoor|daarmee|alleen|zonder|eerst|daarna|opnieuw|werkt|bewijst|migratie|configuratie|gebruikt|verwijder|toevoegen|hoort|blijft|bestaat|wanneer|waarom|omdat|zodat|namelijk|gewoon|fout|geheim|adres|adressen|bestand|bestanden|oplossing|synthetische|niet-productie|mogen|toegestaan|binnen|gelezen|gekopieerd|opgenomen|ongemoeid|geldige|voegt|autoriteit|ongewijzigd)[[:space:]]'

scan_controlled_tree() {
  local source_root="$1"
  local hits
  local status

  set +e
  hits="$(
    rg -n -i \
      --glob '*.md' \
      --glob '*.txt' \
      "${dutch_token_pattern}" \
      "${source_root}/GAMP" 2>&1
  )"
  status=$?
  set -e

  case "${status}" in
    0)
      printf '%s\n' "${hits}" >&2
      printf 'FAIL FS-164 controlled document language: Dutch-language token detected\n' >&2
      return 1
      ;;
    1)
      return 0
      ;;
    *)
      printf '%s\n' "${hits}" >&2
      printf 'FAIL FS-164 controlled document language: scan failed with status %s\n' "${status}" >&2
      return "${status}"
      ;;
  esac
}

scan_controlled_tree "${repo_root}"

negative_root="$(mktemp -d)"
trap 'rm -rf "${negative_root}"' EXIT
mkdir -p "${negative_root}/GAMP/FS"
printf '%s\n' 'This is de controlled baseline.' >"${negative_root}/GAMP/FS/README.md"

if negative_output="$(scan_controlled_tree "${negative_root}" 2>&1)"; then
  printf 'FAIL FS-164 controlled document language: seeded Dutch negative was accepted\n' >&2
  exit 1
fi

if ! grep -F 'de controlled baseline' <<<"${negative_output}" >/dev/null; then
  printf 'FAIL FS-164 controlled document language: seeded negative lacked the matching line\n' >&2
  exit 1
fi

printf 'PASS FS-164 controlled document language: controlled baseline is English and seeded Dutch prose is rejected\n'
