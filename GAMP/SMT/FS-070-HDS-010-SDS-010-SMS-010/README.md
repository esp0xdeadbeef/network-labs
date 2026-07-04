# FS-070-HDS-010-SDS-010-SMS-010 SMT

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-070-HDS-010-SDS-010-SMS-010-validation-context-boundary.md`

Status: OK live on 2026-07-04.

This row proves the validation-context boundary as an active-lab mini path.
Validation context may select evidence surfaces, but it shall not mutate
compiled model meaning or rendered behavior.

Title slug: `validation-context-boundary`

Current evidence:

- Full-loop command:
  `S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-070-HDS-010-SDS-010-SMS-010 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 REBOOT_S_ROUTER_TEST_CLIENTS=1 RUN_S_ROUTER_CLAB_REBUILD_LOOP=1 NETWORK_REPO_DIRECT_TEST_OK=1 MINI_SMT_OFFLINE_VERIFY=0 bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos`
- Locked source: `/nix/store/3mxrnfjhys741zavf161hs64wyd5nbza-source`
- Active-lab runner: `/tmp/active-lab-mini-smt-runs/20260704T080616Z-3029439/FS-070-HDS-010-SDS-010-SMS-010`
- Live evidence:
  `/tmp/s-router-live-smoke/FS-070-HDS-010-SDS-010-SMS-010/20260704T080618Z`
  and
  `/tmp/s-router-live-smoke/FS-070-HDS-010-SDS-010-SMS-010/20260704T080720Z`
- Manual enumeration confirmed `s-router-nixos` and `s-router-clab` each have
  the five full-trace runtime targets and `relationHits=38`,
  `s-router-test-clients` has zero router runtime targets, and all three have
  `validationContextMutationRecords=0`.

The evidence is active-lab SMT/SIT proof only. It is not HAT, SAT, or production
readiness evidence.
