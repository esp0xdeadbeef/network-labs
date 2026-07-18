# SMT Source Specification: FS-525-HDS-010-SDS-010-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-525-HDS-010-SDS-010-SMS-010-named-core-resolver-binding.md`

Status: NOT OK - compiler construction source implemented; downstream and live evidence remain open.

This row supplies the isolated shared input for a named access-to-core resolver
binding. The valid profile names `core-dns` and `core-primary`, requests
dual-stack model-allocated service endpoints, and explicitly selects
`isp-primary` while another modeled egress exists. No resolver address is part
of the intent binding.

Seeded profiles shall cover every FS-525 warning code, including the permitted
warning for an explicitly static provider-bound core upstream. Missing,
literal, invalid, ambiguous, family-incomplete, or substrate-divergent binding
must remain fail-closed. Warning records may contain modeled identities but no
addresses or protected client identity.

The focused compiler test covers the positive profile plus missing, literal,
invalid, ambiguous, and provider-bound static-upstream warnings. NFM, CPM,
renderer equivalence, and cold-stage NixOS/CLAB execution are not yet evidence;
the row remains `NOT OK` until those boundaries pass.

Title slug: `named-core-resolver-binding`
