# SIT Mini Source: FS-030-HDS-010-SDS-020

SIT integration source for FS-030-HDS-010-SDS-020 stage-topology enforcement.

**Evidence Boundary:** active-lab mini-SMT runtime for
`FS-030-HDS-010-SDS-020-SMS-010`.

This row integrates the row-local intent source with the compiler construction
test and the locked active-lab runtime on `s-router-nixos`, `s-router-clab`,
and `s-router-test-clients`.

Current validation evidence must include:

- `NETWORK_REPO_DIRECT_TEST_OK=1 bash ../network-compiler/tests/test-FS-030-HDS-010-SDS-020-SMS-010.sh`.
- `NETWORK_LABS_PATH=/home/deadbeef/github/network-labs S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash ../network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-020-SMS-010.sh`.
- `MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-020-SMS-010`.

This is SIT active-lab child-row evidence only and does not promote HAT/SAT or
production readiness.
