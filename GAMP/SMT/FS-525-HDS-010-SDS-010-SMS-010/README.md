# SMT Source Specification: FS-525-HDS-010-SDS-010-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-525-HDS-010-SDS-010-SMS-010-named-core-resolver-binding.md`

Status: NOT OK - validation specification only.

This row specifies the future isolated NixOS/CLAB validation boundary for a
named access-to-core resolver binding. The valid profile uses topology-derived
dual-stack service endpoints, an explicit multi-egress provider decision, and
emits no DNS reproducibility warnings.

Seeded profiles shall cover every FS-525 warning code, including the permitted
warning for an explicitly static provider-bound core upstream. Missing,
literal, invalid, ambiguous, family-incomplete, or substrate-divergent binding
must remain fail-closed. Warning records may contain modeled identities but no
addresses or protected client identity.

No construction command or live result is registered yet. Implementation and
execution begin only after this source specification is accepted.

Title slug: `named-core-resolver-binding`
