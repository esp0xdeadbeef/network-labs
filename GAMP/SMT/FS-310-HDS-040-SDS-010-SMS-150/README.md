# SMT Source: FS-310-HDS-040-SDS-010-SMS-150

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-310-HDS-040-SDS-010-SMS-150-cpm-platform-abstention.md`

Status: ACTIVE MINI-SMT - registered runtime wrapper.

This row is registered in `GAMP/SMT/mini-smt/tests.nix` and is selected through
`scripts/select-current-lab.sh SMT FS-310-HDS-040-SDS-010-SMS-150`.

The canonical SMS is construction/RaTM-scoped CPM platform abstention. The
active-lab wrapper is therefore a runtime evidence guard for the selected mini
profile: it must fail when the live `s-router-*` hosts do not carry this trace,
relation, and target shape. It is not by itself HAT/SAT acceptance.

Title slug: `cpm-platform-abstention`
