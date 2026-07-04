# SIT Runtime Path: FS-060-HDS-010-SDS-010

Status: OK live on 2026-07-04.

This SDS-scoped SIT row selects the child
`FS-060-HDS-010-SDS-010-SMS-010` active-lab mini path and validates the full
SMS trace on `s-router-nixos`, `s-router-clab`, and `s-router-test-clients`.

Current evidence:

- Command: `S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-060-HDS-010-SDS-010-SMS-010 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 REBOOT_S_ROUTER_TEST_CLIENTS=1 RUN_S_ROUTER_CLAB_REBUILD_LOOP=1 NETWORK_REPO_DIRECT_TEST_OK=1 MINI_SMT_OFFLINE_VERIFY=0 bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos`
- Locked source: `/nix/store/8m09agpz5bbqdcfyf1gvpayg7v1sl3lx-source`
- Evidence:
  `/tmp/s-router-live-smoke/FS-060-HDS-010-SDS-010-SMS-010/20260704T072157Z`
  and
  `/tmp/s-router-live-smoke/FS-060-HDS-010-SDS-010-SMS-010/20260704T072252Z`
- Result: live runtime checks passed on `s-router-nixos`, `s-router-clab`, and
  `s-router-test-clients`.
