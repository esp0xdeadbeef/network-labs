# FS-270-HDS-010-SDS-010-SMS-020

Layer: SMT

The focused source shall model two isolated access scopes, a downstream
selector and one policy-state owner. It shall allow one bounded service from
the first access scope to the second with symmetric return while denying new
flows in the reverse direction.

Acceptance requires IPv4 and IPv6 requests from the source endpoint to reach
only the modeled service and return through the same policy owner on both NixOS
and CLAB. Independently initiated reverse flows and attempts to borrow an
unrelated public-egress capability through the destination scope shall fail.
Seeded negatives are a direct forward shortcut with a policy-routed return, a
missing post-policy service handoff, a broad stateless reverse allow, and
transitive egress inherited from the destination scope.

The protocol shall run only on cold-staged `s-router-nixos`, `s-router-clab`,
and `s-router-test-clients` using isolated test VLANs; VLAN 2 and production
networks are outside this evidence boundary.

## Validation evidence

Status: OK.

On 2026-07-19 all three guests were shut down together, observed offline, and
started with new boot IDs, exact source hashes, and exact pushed network pins.
The final restage selected `network-labs` revision `c7b47da3bb63` and common
`network-renderer-nebula` revision `0e6ee9367b40`.
The focused construction checks and live client protocol passed on both NixOS
and CLAB for IPv4 and IPv6: the forward flow crossed the same policy-state
owner, the allowed return was stateful, independently initiated reverse flows
were denied, no direct shortcut existed, and the destination access scope did
not confer unrelated public-egress rights. The validator made no route,
firewall, or service mutations. Full evidence is recorded by
`FS-270-HDS-010-SDS-010-SMS-020-online-eval.txt` in network-codex-agent.
