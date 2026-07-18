# FS-540-HDS-010-SDS-010-SMS-030 SMT

Isolated dual-stack source for recursive-authority separation. It models a
recursive access resolver, a local-only access resolver, a named iterative core
resolver, and two eligible-looking egress surfaces with one explicit selection.

The local-only resolver may query only the modeled `lab.` and reverse
namespaces through the recursive access resolver. It has no direct or
transitive core/public recursion authority. NixOS uses VLANs 403/404 and CLAB
uses VLANs 405/406; production VLANs and provider networks are out of scope.

Both reachable lateral resolver directions must classify the opposite source
as local-only, and the requesting resolver must not mask `lab.` forwarding with
a static negative zone.

The row remains `NOT OK` until CPM and both renderers pass their focused
construction predicates and a cold-staged live protocol uses the real isolated
test clients.
