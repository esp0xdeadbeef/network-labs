# FS-500-HDS-010-SDS-010 SIT

Focused SIT row for the mini reachability decision and point-to-point next-hop
integration path.

SIT rows are SDS-scoped, but the inputs are explicit SMS atoms. This row
currently consumes:

- `FS-500-HDS-010-SDS-010-SMS-010`
- `FS-500-HDS-010-SDS-010-SMS-040`

Run the small row inputs independently:

```sh
tests/run-active-lab-mini-smt.sh FS-500-HDS-010-SDS-010-SMS-010 FS-500-HDS-010-SDS-010-SMS-040
```

After selecting the reachability row into `current-lab`, run the live verifier
against the active-lab hosts:

```sh
NETWORK_REPO_DIRECT_TEST_OK=1 \
  S_ROUTER_NIXOS=192.168.1.17 \
  S_ROUTER_CLAB=192.168.1.19 \
  S_ROUTER_TEST_CLIENTS=192.168.1.18 \
  ../network-codex-agent/scripts/fs500-active-lab-reachability-runtime-check.sh --live
```

For the decision-reason diagnostic row:

```sh
NETWORK_REPO_DIRECT_TEST_OK=1 \
  S_ROUTER_NIXOS=192.168.1.17 \
  S_ROUTER_CLAB=192.168.1.19 \
  S_ROUTER_TEST_CLIENTS=192.168.1.18 \
  ../network-codex-agent/scripts/fs500-decision-reason-active-lab-runtime-check.sh --live
```

For the point-to-point next-hop row:

```sh
NETWORK_REPO_DIRECT_TEST_OK=1 \
  S_ROUTER_NIXOS=192.168.1.17 \
  S_ROUTER_CLAB=192.168.1.19 \
  S_ROUTER_TEST_CLIENTS=192.168.1.18 \
  ../network-codex-agent/scripts/fs500-p2p-next-hop-active-lab-runtime-check.sh --live
```
