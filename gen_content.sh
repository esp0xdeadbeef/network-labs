#!/bin/bash
# Generate SMT and SMS content files for SMS-040 traces
set -e
cd /home/deadbeef/github/network-labs

# All SMS-040 traces (excluding the 5 that already have full fixtures)
# Existing: FS-180, FS-270, FS-350, FS-500, FS-800-HDS-010-SDS-020
generate() {
  local trace="$1"
  local fs=$(echo "$trace" | grep -oP '^FS-\d+')
  local sds_chain=$(echo "$trace" | sed 's/-SMS-040//')
  local sms_file=$(ls ../network-codex-agent/GAMP/SMS/${trace}-*.md 2>/dev/null | head -1)
  local title=""
  local scope_line=""
  
  if [ -n "$sms_file" ]; then
    title=$(head -1 "$sms_file" | sed 's/^# //' | sed 's/Software Module Specification: //' | sed 's/SMS: //')
    scope_line=$(grep -A1 '^## Scope' "$sms_file" | tail -1 | sed 's/^This SMS //;s/^This software module specification //;s/^This SMS item //' | tr -d '\n' | head -c 200)
  fi
  [ -z "$title" ] && title="$trace"
  [ -z "$scope_line" ] && scope_line="See SMS spec in network-codex-agent/GAMP/SMS/${trace}-*.md"

  # SMT default.nix
  cat > "GAMP/SMT/$trace/default.nix" <<NIXEOF
{
  layer = "SMT";
  traceId = "$trace";
  evidenceBoundary = "construction-only";
  source = null;
  evidence = {
    owningRepo = "network-codex-agent";
    focusedTest = "tests/${trace}.sh";
    smtRow = "GAMP/SMT/README.md";
    status = "NOT OK";
    verifiedAt = "network-codex-agent HEAD (pending verification)";
    scope = "$scope_line";
  };
}
NIXEOF

  # SMT README.md
  cat > "GAMP/SMT/$trace/README.md" <<MDEOF
# $trace SMT

Row-local source for $title.

**Validation Evidence Boundary:** construction-only — all predicates are provable with construction tests against compile-time output. No live host/runtime surface required.

Construction test: \`network-codex-agent/tests/${trace}.sh\`

$scope_line
MDEOF

  # SMS default.nix
  cat > "GAMP/SMS/$trace/default.nix" <<NIXEOF
{
  layer = "SMS";
  traceId = "$trace";
  parentSds = ../../SDS/$sds_chain;
  purpose = "$title (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {};
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
NIXEOF

  # SMS README.md
  cat > "GAMP/SMS/$trace/README.md" <<MDEOF
# $trace SMS Template

Template row for $title.

**Evidence Boundary:** construction-only.

SMS spec: \`network-codex-agent/GAMP/SMS/${trace}-*.md\`

$scope_line
MDEOF

  echo "  $trace OK"
}

# Process all traces
for t in "$@"; do
  if [ -d "GAMP/SMT/$t" ] && [ ! -f "GAMP/SMT/$t/default.nix" ]; then
    generate "$t"
  elif [ -f "GAMP/SMT/$t/default.nix" ]; then
    echo "  $t SKIP (already exists)"
  fi
done
echo "DONE"
