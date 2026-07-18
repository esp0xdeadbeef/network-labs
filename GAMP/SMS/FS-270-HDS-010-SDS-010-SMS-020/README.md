# FS-270-HDS-010-SDS-010-SMS-020

Layer: SMS

This row mirrors the client/tenant policy-transit contract for a dual-stack
lateral service on another access scope. A symmetric or stateful-return
relation shall send both the IPv4 and IPv6 forward requests and their return
packets through the same policy state owner. Relation-specific route selection
shall take effect before a directly connected access route can shortcut that
owner. A direct access-to-access forward shortcut paired with a policy-routed
return is invalid because the policy node cannot classify the reply as
established.

The row shall also require relation-scoped new-flow authority on the
post-policy selector and destination-access handoffs, keep an explicit reverse
deny effective for independently initiated traffic, and reject broad stateless
reverse allowances. A lateral allow shall not confer unrelated or transitive
egress through the destination access scope. NixOS and CLAB shall consume the
same path contract.

Status: specification source only. Construction and cold-staged validation
status belong to the matching SMT/SIT records.
