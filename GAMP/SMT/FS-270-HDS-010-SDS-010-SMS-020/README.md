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
networks are outside this evidence boundary. This row remains NOT OK until the
focused construction predicate and that cold-staged client protocol pass.
