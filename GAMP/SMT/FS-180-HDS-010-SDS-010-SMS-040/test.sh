#!/usr/bin/env bash
# GAMP-ID: FS-180-HDS-010-SDS-010-SMS-040
# GAMP-SCOPE: row-local mini-SMT focused test; not HAT/SAT evidence
# Predicate: absent returnBehavior — forward-only nft accept rules
#   (bidirectional returnBehavior=symmetric case tested at CPM construction level)
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
intent_file="${repo_root}/GAMP/SMT/FS-180-HDS-010-SDS-010-SMS-040/intent.nix"

fail() {
  echo "FAIL FS-180-HDS-010-SDS-010-SMS-040: $*" >&2
  exit 1
}

[[ -f "${intent_file}" ]] || fail "missing ${intent_file}"

# Write Nix expression to temp file to avoid shell quoting issues
nix_expr=$(mktemp)
trap 'rm -f "$nix_expr"' EXIT
cat > "$nix_expr" <<'NIXEOF'
  let
    intentFile = builtins.toPath INTENT_FILE_PLACEHOLDER;
    intent = import intentFile;
    lab = intent.mini-smt."FS-180-HDS-010-SDS-010-SMS-040";
    require = cond: msg: if cond then true else throw msg;
    relations = lab.communicationContract.relations or [];
    trafficTypes = lab.communicationContract.trafficTypes or [];
    topology = lab.topology or {};
    nodes = topology.nodes or {};
    links = topology.links or [];
    ownership = lab.ownership or {};
    prefixes = ownership.prefixes or [];
    pools = lab.pools or {};
    rel = builtins.head relations;
  in
    require (builtins.length relations == 1)
      "FS-180-040: must have exactly one relation"
    && require (builtins.elem rel.action [ "allow" "deny" ])
      "FS-180-040: relation must have explicit allow or deny action"
    && require (rel.action == "allow")
      "FS-180-040: relation must be allow"
    && require (rel.id == "FS-180-HDS-010-SDS-010-SMS-040__mini-verify")
      "FS-180-040: relation id must match SMS trace"
    && require (rel.from.kind == "tenant")
      "FS-180-040: relation from must be a tenant scope"
    && require (rel.to.kind == "external")
      "FS-180-040: relation to must be external"
    && require (rel.trafficType == "any")
      "FS-180-040: relation must specify trafficType=any"
    && require (! (builtins.hasAttr "returnBehavior" rel))
      "FS-180-040: relation must NOT have returnBehavior (absent case = forward-only)"
    && require (builtins.length trafficTypes >= 1)
      "FS-180-040: must declare at least one trafficType"
    && require ((builtins.head trafficTypes).name == "any")
      "FS-180-040: trafficType name must match relation"
    && require (builtins.length links == 4)
      "FS-180-040: must have exactly 4 fabric links"
    && require (builtins.elem "client-edge" (builtins.attrNames nodes))
      "FS-180-040: missing client-edge node"
    && require (builtins.elem "policy" (builtins.attrNames nodes))
      "FS-180-040: missing policy node"
    && require (nodes."client-edge".role == "access")
      "FS-180-040: client-edge must be access role"
    && require (nodes.policy.role == "policy")
      "FS-180-040: policy must be policy role"
    && require (builtins.length prefixes == 1)
      "FS-180-040: must declare exactly one tenant prefix"
    && require (pools ? p2p)
      "FS-180-040: must declare p2p address pool"
    && require (pools ? loopback)
      "FS-180-040: must declare loopback address pool"
    && require (! (builtins.hasAttr "returnBehavior" rel))
      "FS-180-040 SN1: absent returnBehavior confirmed - forward-only expected"
    && require (rel.returnBehavior or "absent" == "absent")
      "FS-180-040 SN2: no unrecognized returnBehavior value present"
NIXEOF

sed -i "s|INTENT_FILE_PLACEHOLDER|$intent_file|g" "$nix_expr"
nix eval --impure --expr "$(<"$nix_expr")" >/dev/null \
  || fail "mini SMT forward-only nft contract failed"

echo "PASS FS-180-HDS-010-SDS-010-SMS-040"
