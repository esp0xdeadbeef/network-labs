# FS-540-HDS-010-SDS-010-SMS-010 SMT

Row-local source stub for recursive DNS policy binding.

Construction-only — no active-lab mini-SMT runtime targets.
Governing SMS: CPM-level recursive DNS binding module. Verifies DNS-specific relations in communicationContract.allowedRelations with trafficType=dns, resolver node assignments from forwardingSemantics.dns, and fail-closed on missing DNS relations.

Renderer materialization and live runtime DNS behavior are delegated to SMS-035.
Sibling SMS-020 (dns-resolver-config) has its own mini-SMT runtime fixture.
