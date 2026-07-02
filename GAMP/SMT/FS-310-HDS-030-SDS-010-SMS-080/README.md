# SMT Source Stub: FS-310-HDS-030-SDS-010-SMS-080

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-310-HDS-030-SDS-010-SMS-080-renderer-shell-fallback-error-propagation.md`

Status: ACTIVE MINI-SMT - registered runtime wrapper.

This row is registered in `GAMP/SMT/mini-smt/tests.nix` and is selected through
`scripts/select-current-lab.sh SMT FS-310-HDS-030-SDS-010-SMS-080`.

The canonical SMS is construction/RaTM-scoped shell fallback propagation in the
CLAB renderer. The active-lab wrapper is therefore a runtime evidence guard for
the selected mini profile: it must fail when the live `s-router-*` hosts do not
carry this trace, relation, and target shape. It is not by itself HAT/SAT
acceptance.

Title slug: `renderer-shell-fallback-error-propagation`
