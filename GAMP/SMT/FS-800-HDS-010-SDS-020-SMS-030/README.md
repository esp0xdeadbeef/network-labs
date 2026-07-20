# SMT Source: FS-800-HDS-010-SDS-020-SMS-030

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-800-HDS-010-SDS-020-SMS-030-pppoe-pairing-and-fallback-rejection.md`

Title slug: `pppoe-pairing-and-fallback-rejection`

This row provides the mini-SMT intent source for PPPoE pairing and fallback
rejection module testing. The intent uses `pppoe-client`/`pppoe-provider` roles
with a `pppoePairs` section to exercise the CPM-level pairing validation.

Focused CPM construction test:
`network-control-plane-model/tests/FS-800-HDS-010-SDS-020-SMS-030.sh`
(4 seeded negatives + positive control: SN1 missing-handoff, SN2 wrong-address,
SN3 missing-credentials, SN4 killswitch-bypass).

Focused CPM contract test:
`network-control-plane-model/tests/FS-800-HDS-010-SDS-020-SMS-030.sh`

Lab-side test:
`network-labs/tests/test-s-sigma-pppoe-pairing-fallback-rejection.sh`
