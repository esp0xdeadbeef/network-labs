# FS-270-HDS-010-SDS-010-SMS-020

Layer: SMT

The focused source shall model two isolated access scopes, a downstream
selector and one policy-state owner. It shall allow one bounded service from
the first access scope to the second with symmetric return while denying new
flows in the reverse direction.

Acceptance requires the forward request and return to traverse the same policy
owner on both NixOS and CLAB. Seeded negatives are a direct forward shortcut
with a policy-routed return, a missing post-policy service handoff, and a broad
stateless reverse allow. This row remains NOT OK until the focused construction
predicate and the cold-staged isolated client protocol pass.
