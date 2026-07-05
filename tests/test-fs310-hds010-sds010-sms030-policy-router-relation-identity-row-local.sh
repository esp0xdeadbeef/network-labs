#!/usr/bin/env bash
# GAMP-ID: FS-310-HDS-010-SDS-010-SMS-030
# GAMP-SCOPE: active-lab mini SMT row-local; not HAT/SAT evidence
# Row-local focused test for policy-router relation identity intent fixture.
# Does NOT depend on mini-smt/default.nix or mini-smt/tests.nix.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
intent_file="${repo_root}/GAMP/SMT/FS-310-HDS-010-SDS-010-SMS-030/intent.nix"

fail() {
  echo "FAIL FS-310-HDS-010-SDS-010-SMS-030 row-local: $*" >&2
  exit 1
}

[[ -f "${intent_file}" ]] || fail "missing ${intent_file}"

nix eval --impure --expr '
  let
    intent = import '"${intent_file}"';
    lab = intent."mini-smt"."policy-router-relation-identity";
    cc = lab.communicationContract;
    rels = cc.relations;
    rel = builtins.head rels;
    topo = lab.topology;
    require = cond: msg: if cond then true else throw msg;
  in
    require (builtins.length rels == 1)
      "FS-310-HDS-010-SDS-010-SMS-030: must test exactly one relation atom"
    && require (rel ? id && builtins.isString rel.id && rel.id != "")
      "FS-310-HDS-010-SDS-010-SMS-030: relation must carry a non-empty string id"
    && require (rel.id == "FS-310-HDS-010-SDS-010-SMS-030__mini-allow-client-to-testnet")
      "FS-310-HDS-010-SDS-010-SMS-030: relation id must match expected trace-scoped identifier"
    && require (rel ? action && builtins.isString rel.action && rel.action != "")
      "FS-310-HDS-010-SDS-010-SMS-030: relation must carry an action"
    && require (rel.action == "allow")
      "FS-310-HDS-010-SDS-010-SMS-030: relation action must be allow"
    && require (rel ? from && rel.from ? kind && rel.from ? name)
      "FS-310-HDS-010-SDS-010-SMS-030: relation must carry source scope"
    && require (rel.from.kind == "tenant")
      "FS-310-HDS-010-SDS-010-SMS-030: source scope kind must be tenant"
    && require (rel ? to && rel.to ? kind && rel.to ? name)
      "FS-310-HDS-010-SDS-010-SMS-030: relation must carry destination scope"
    && require (rel.to.kind == "external")
      "FS-310-HDS-010-SDS-010-SMS-030: destination scope must be external"
    && require (rel ? trafficType && builtins.isString rel.trafficType && rel.trafficType != "")
      "FS-310-HDS-010-SDS-010-SMS-030: relation must carry traffic class"
    && require (rel.trafficType == "any")
      "FS-310-HDS-010-SDS-010-SMS-030: trafficType must be any"
    && require (rel ? priority && builtins.isInt rel.priority)
      "FS-310-HDS-010-SDS-010-SMS-030: relation must carry priority"
    && require (cc ? interfaceTags && cc.interfaceTags ? "external-testnet" && cc.interfaceTags ? "tenant-client")
      "FS-310-HDS-010-SDS-010-SMS-030: interface tags must define testnet and client"
    && require (cc ? trafficTypes && builtins.length cc.trafficTypes >= 1)
      "FS-310-HDS-010-SDS-010-SMS-030: must define at least one traffic type"
    && require (builtins.length cc.services == 0)
      "FS-310-HDS-010-SDS-010-SMS-030: must have zero services"

    # Topology checks
    && require (topo ? links && builtins.length topo.links == 1)
      "FS-310-HDS-010-SDS-010-SMS-030: must define exactly one link"
    && require (builtins.elemAt topo.links 0 == [ "client-edge" "core-vlan4-client-dhcp-slaac" ])
      "FS-310-HDS-010-SDS-010-SMS-030: link must connect client-edge and core-vlan4-client-dhcp-slaac"
    && require (topo ? nodes && builtins.length (builtins.attrNames topo.nodes) == 2)
      "FS-310-HDS-010-SDS-010-SMS-030: must define exactly two nodes"
    && require (topo.nodes ? "client-edge" && topo.nodes."client-edge".role == "access")
      "FS-310-HDS-010-SDS-010-SMS-030: client-edge must be an access node"
    && require (topo.nodes."client-edge" ? attachments && builtins.length topo.nodes."client-edge".attachments == 1)
      "FS-310-HDS-010-SDS-010-SMS-030: client-edge must have exactly one tenant attachment"
    && require (builtins.elemAt topo.nodes."client-edge".attachments 0 == { kind = "tenant"; name = "client"; })
      "FS-310-HDS-010-SDS-010-SMS-030: client-edge attachment must be tenant client"
    && require (topo.nodes ? "core-vlan4-client-dhcp-slaac" && topo.nodes."core-vlan4-client-dhcp-slaac".role == "external")
      "FS-310-HDS-010-SDS-010-SMS-030: core-vlan4-client-dhcp-slaac must be an external node"
    && require (topo.nodes."core-vlan4-client-dhcp-slaac" ? external && topo.nodes."core-vlan4-client-dhcp-slaac".external == "testnet")
      "FS-310-HDS-010-SDS-010-SMS-030: core-vlan4-client-dhcp-slaac must declare external=testnet"

    # Seeded negative: relation without id
    && require (let relNoId = builtins.removeAttrs rel [ "id" ]; in !(relNoId ? id))
      "FS-310-HDS-010-SDS-010-SMS-030 SN1: relation-without-id detectable"

    # Seeded negative: relation without action
    && require (let relNoAction = builtins.removeAttrs rel [ "action" ]; in !(relNoAction ? action))
      "FS-310-HDS-010-SDS-010-SMS-030 SN2: relation-without-action detectable"
  ' || fail "nix eval predicates failed"

echo "PASS FS-310-HDS-010-SDS-010-SMS-030 row-local: all predicates verified"
